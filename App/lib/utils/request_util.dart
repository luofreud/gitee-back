import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'common_util.dart';
import 'sp_util.dart';

/// 网络请求管理类 (单例)
class RequestUtil {
  static const String GET = "GET";
  static const String POST = "POST";
  static const String PUT = "PUT";
  static const String PATCH = "PATCH";
  static const String DELETE = "DELETE";

  static const CONNECT_TIMEOUT = 15000; // 连接超时时间
  static const RECEIVE_TIMEOUT = 15000; // 接收超时时间
  static const SEND_TIMEOUT = 15000; // 发送超时时间

  static bool showLogger = true; //输出调试信息

  static CancelToken _cancelToken = CancelToken(); // 取消网络请求 token，默认所有请求都可取消。

  final Map<String, CancelToken> _pendingRequests = {}; // 正在请求列表

  static final RequestUtil _instance = RequestUtil._internal();

  factory RequestUtil() => _instance;
  static Dio _dio = Dio();
  BaseOptions options = BaseOptions(
    baseUrl: TokenUtil.getServer(),
    // 替换为你的 BaseUrl
    connectTimeout: const Duration(milliseconds: CONNECT_TIMEOUT),
    receiveTimeout: const Duration(milliseconds: RECEIVE_TIMEOUT),
    sendTimeout: const Duration(milliseconds: SEND_TIMEOUT),
    // headers: {'Content-Type': 'application/json', 'TenantId': ''},
    extra: {'cancelDuplicatedRequest': true}, // 是否取消重复请求
  );

  RequestUtil._internal() {
    _dio = Dio(options);
    // 添加日志拦截器 (开发环境使用)
    if (kDebugMode || showLogger) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }

    _init();
  }

  /// 取消重复的请求
  void _removePendingRequest(String tokenKey) {
    if (_pendingRequests.containsKey(tokenKey)) {
      // 如果在 pending 中存在当前请求标识，需要取消当前请求，并且移除。
      _pendingRequests[tokenKey]?.cancel(tokenKey);
      _pendingRequests.remove(tokenKey);
    }
  }

  void _init() {
    // 添加全局拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (dio.options.extra['cancelDuplicatedRequest'] == true &&
              options.cancelToken == null &&
              (options.contentType?.contains('application/json') ?? false)) {
            String tokenKey = [
              options.method,
              options.baseUrl + options.path,
              jsonEncode(options.data ?? {}),
              jsonEncode(options.queryParameters ?? {}),
            ].join('&');
            _removePendingRequest(tokenKey);
            options.cancelToken = _cancelToken;
            options.extra['tokenKey'] = tokenKey;
            _pendingRequests[tokenKey] = options.cancelToken!;
          }

          // 统一添加 Token
          var token = await TokenUtil.getToken();
          var refreshToken = await TokenUtil.getRefreshToken();
          if (token != null && token!.toString().isNotEmpty) {
            var jwtJson = CommonUtil.decryptJWT(token);
            var expDateTime = DateTime.fromMillisecondsSinceEpoch(
              jwtJson['exp'] * 1000,
            );

            if (token != dio.options.headers['Authorization']) {
              //全局设置
              dio.options.headers['Authorization'] = 'Bearer $token';
              //当前请求设置
              options.headers['Authorization'] = 'Bearer $token';
            }
            //如果token过期，则将刷新token放入header中
            if (DateTime.now().isAfter(expDateTime)) {
              //token已过期
              options.headers['X-Authorization'] = 'Bearer $refreshToken';
            }
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 在这里处理全局的业务状态码
          RequestOptions option = response.requestOptions;
          if (dio.options.extra['cancelDuplicatedRequest'] == true &&
              option.cancelToken == null) {
            _removePendingRequest(option.extra['tokenKey']);
          }

          var accessToken = response.headers.value('access-token');
          var refreshToken = response.headers.value('x-access-token');
          if (accessToken == 'invalid_token') {
            //token无效
            TokenUtil.clear();
          } else if (refreshToken != null &&
              refreshToken.isNotEmpty &&
              accessToken != 'invalid_token') {
            TokenUtil.setToken(
              accessToken: accessToken,
              refreshToken: refreshToken,
            );
          }
          //如果返回类型不是json，则不判断返回值直接返回结果
          if (option.responseType != ResponseType.json) {
            return handler.next(response);
          }

          //如果是json，则直接将json字符串转换成对象赋值给 response.data
          var repMessage = (response.data ?? {})['message'];
          if (repMessage != null && repMessage.toString().isNotEmpty) {
            //将返回的错误信息中的错误代码删除 例如 [D8003] 文件后缀错误，取消[]错误代码
            repMessage = repMessage.toString().replaceAll(
              RegExp(r'^\[.*?\] '),
              "",
            );
          }
          String message = repMessage ?? response.statusMessage;
          // 静态数据 或者 根据后台实际返回结构解析，即 code == '200' 时，data 为有效数据。
          int code = ((response.data ?? {})['code'] ?? response.statusCode);
          bool isSuccess =
              option.contentType != null &&
                  option.contentType!.contains("text") ||
              code == 200;
          response.data = Result(
            response.data,
            isSuccess,
            code,
            message,
            headers: response.headers,
          );

          return handler.next(response);
        },
        onError: (error, handler) {
          // 统一处理网络错误
          return handler.next(error);
        },
      ),
    );
  }

  /// 获取 Dio 实例 (用于高级操作，如文件上传下载)
  Dio get dio => _dio;

  /// 获取单例本身

  ///获取dio
  static RequestUtil getInstance({String? baseUrl}) {
    String targetBaseUrl = baseUrl ?? TokenUtil.getServer();
    if (_dio.options.baseUrl != targetBaseUrl) {
      _dio.options.baseUrl = targetBaseUrl;
    }
    return _instance;
  }

  /// request
  static Future<Result?> request(
    String url, {
    String method = RequestUtil.GET,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    String? loadMsgText,
    String? baseUrl,
    bool? showLoad,
    String? loadText,
    bool? showError,
  }) async {
    //将参数中中为null的数据删除
    queryParameters?.removeWhere((key, value) => value == null);
    data?.removeWhere((key, value) => value == null);

    try {
      if (showLoad == true) {
        ToastUtil.loading(msg: loadText ?? "加载中...");
      }

      final response = await _dio.request<Result>(
        url,
        options:
            options ??
            Options(method: method, contentType: Headers.jsonContentType),
        queryParameters: queryParameters,
        data: data,
        cancelToken: cancelToken ?? _cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      if (response.data?.code != 200) {
        // TODO: 错误处理
        _instance._showError(showError, response.data?.message ?? '数据异常');
      }
      return response.data;
    } on DioException catch (e) {
      final String errMsg = _instance._handleError(e);
      if (showError == true && errMsg.isNotEmpty) {
        _instance._showError(showError, errMsg);
      } else {
        rethrow;
      }
    } catch (e) {
      _instance._showError(showError, e.toString());
    } finally {
      if (showLoad == true) {
        ToastUtil.hide();
      }
    }
  }

  /// GET 请求
  Future<Result?> get(
    String url, {
    Map<String, dynamic>? params,
    bool isCancelWhiteList = false,
    Options? options,
    CancelToken? cancelToken,
    bool? showLoad,
    String? loadText,
    bool? showError = true,
  }) async {
    return request(
      url,
      queryParameters: params,
      options: options,
      cancelToken: cancelToken,
      showLoad: showLoad,
      loadText: loadText,
      showError: showError,
    );
  }

  /// post 请求
  Future<Result?> post(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool? showLoad,
    String? loadText,
    bool? showError = true,
  }) async {
    return request(
      url,
      method: RequestUtil.POST,
      queryParameters: queryParameters,
      data: data,
      options: options,
      cancelToken: cancelToken,
      showLoad: showLoad,
      loadText: loadText,
      showError: showError,
    );
  }

  /// delete 请求
  Future<Result?> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool? showLoad,
    String? loadText,
    bool? showError = true,
  }) async {
    return request(
      url,
      method: RequestUtil.DELETE,
      queryParameters: queryParameters,
      data: data,
      options: options,
      cancelToken: cancelToken,
      showLoad: showLoad,
      loadText: loadText,
      showError: showError,
    );
  }

  /// 文件下载
  Future download(
    String urlPath,
    dynamic savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    final Directory appTempDir = await getTemporaryDirectory();
    final filePath = '${appTempDir.path}/$savePath';

    final File file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }

    try {
      Response response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken ?? _cancelToken,
      );
      if (response.statusCode == 200) {
        final File file = File(filePath);
        if (await file.exists()) {
          return file;
        } else {
          return response.data;
        }
      } else {}
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// 文件上传
  Future<Result?> upload<T>(
    String url,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
    bool? showError = true,
  }) async {
    try {
      final response = await _dio.post<Result>(
        url,
        options: options,
        queryParameters: queryParameters,
        data: formData,
        cancelToken: cancelToken ?? _cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      if (response.data?.code != 200) {
        // TODO: 错误处理
        _instance._showError(showError, response.data?.message ?? '数据异常');
      }
      return response.data;
    } on DioException catch (e) {
      final String errMsg = _instance._handleError(e);
      if (showError == true && errMsg.isNotEmpty) {
        _instance._showError(showError, errMsg);
      } else {
        rethrow;
      }
    } catch (e) {
      if (showError == true) {
        _instance._showError(showError, e.toString());
      } else {
        rethrow;
      }
    }
  }

  /// 错误处理
  String _handleError(DioException error) {
    String message = '';
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = '网络超时';
        break;
      case DioExceptionType.sendTimeout:
        message = '网络超时';
        break;
      case DioExceptionType.receiveTimeout:
        message = '网络超时';
        break;
      case DioExceptionType.badResponse:
        message = '服务器异常，请稍后重试';
        break;
      case DioExceptionType.cancel:
        message = '请求取消';
        break;
      default:
        message = '网络异常';
        break;
    }
    return message;
    // 这里可以统一弹窗提示或者打印日志
    //print('网络错误: $message');
  }

  /// 显示异常
  void _showError(bool? showError, String message) {
    if (showError == true) {
      ToastUtil.info(message);
    }
  }

  /// 取消所有正在进行的请求
  /// 通常在用户退出登录、切换账号时调用
  void cancelAllRequests() {
    for (var cancelToken in _pendingRequests.values) {
      cancelToken.cancel();
    }
    _pendingRequests.clear();
  }

  /// 取消特定页面或场景下的所有请求
  /// 解决方案：利用 CancelToken 的分组特性
  /// 使用时，需要在发起请求时传入一个特定的 token (例如：PageA_CancelToken)
  void cancelRequestsByToken(CancelToken token, [String? cancelMessage]) {
    if (!token.isCancelled) {
      token.cancel(cancelMessage ?? "用户取消请求");
    }
  }
}

/// 结果处理
class Result {
  var data;
  bool? success;
  int? code;
  String? message;
  var headers;

  Result(this.data, this.success, this.code, this.message, {this.headers});
}

class TokenUtil {
  static const String _tokenKey = "accessToken";
  static const String _refreshTokenKey = "refreshToken";

  static const String _apiBaseUrlKey = "apiBaseUrl";
  static String? _apiBaseUrl;

  ///当前设置的自定义服务器地址
  static String? get apiBaseUrl => _apiBaseUrl;

  static Future init() async {
    _apiBaseUrl =
        await SpUtil.getStorage(_apiBaseUrlKey) ?? AppConst.API_BASE_URL;
  }

  ///设置token
  static setToken({String? accessToken, String? refreshToken}) {
    if (accessToken != null && accessToken.isNotEmpty) {
      SpUtil.setStorage(_tokenKey, accessToken, encrypt: true);
    }
    if (refreshToken != null && refreshToken.isNotEmpty) {
      SpUtil.setStorage(_refreshTokenKey, refreshToken, encrypt: true);
    }
  }

  ///获取token
  static Future<String> getToken() async {
    return await SpUtil.getStorage(_tokenKey, encrypt: true) ?? '';
  }

  ///获取刷新token
  static Future<String> getRefreshToken() async {
    return await SpUtil.getStorage(_refreshTokenKey, encrypt: true) ?? '';
  }

  ///清除token
  static Future clear() async {
    await SpUtil.removeStorage(_tokenKey);
    await SpUtil.removeStorage(_refreshTokenKey);
  }

  ///设置服务器地址
  static Future setServer(String url) async {
    await SpUtil.setStorage(_apiBaseUrlKey, url);
    _apiBaseUrl = url;
  }

  ///获取服务器地址，如果未自定义设置，则返回系统默认地址
  static String getServer() {
    _apiBaseUrl = _apiBaseUrl == null || _apiBaseUrl!.isEmpty
        ? AppConst.API_BASE_URL
        : _apiBaseUrl!;
    return _apiBaseUrl!;
  }
}
