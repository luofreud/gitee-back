import 'package:freud/models/article/article_plate.dart';
import 'package:freud/models/article/post.dart';
import 'package:freud/models/base/base_response.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:freud/models/base/page_response.dart';
import 'package:freud/utils/request_util.dart';

class PostApi {
  /// 分页查询帖子列表
  Future<PageData<Post>?> postPage(
    PageRequest req, {
    Map<String, dynamic>? filters,
  }) async {
    var data = req.toJson();
    if (filters != null) data.addAll(filters);
    var res = await RequestUtil.getInstance().post(
      "/appXzArticle/page",
      data: data,
    );

    if (res?.code != 200) return null;

    var resJson = PageResponse<Post>.fromJson(
      res?.data,
      (data) => Post.fromJson(data),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  /// 获取帖子详情
  Future<Post?> postDetail(int id) async {
    var res = await RequestUtil.getInstance().get(
      "/appXzArticle/detail",
      params: {"id": id},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => Post.fromJson(data),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  /// 新增帖子
  Future<bool> postAdd(Post post) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzArticle/add",
      data: post.toJson(),
    );
    if (res?.code != 200) return false;
    return true;
  }

  /// 更新帖子
  Future<bool> postUpdate(Post post) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzArticle/update",
      data: post.toJson(),
    );
    if (res?.code != 200) return false;
    return true;
  }

  /// 删除帖子
  Future<bool> postDelete(int id) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzArticle/delete",
      data: {"id": id},
    );
    if (res?.code != 200) return false;
    return true;
  }

  /// 帖子点赞或者取消点赞
  Future<bool> postLike(int id) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzArticle/like",
      data: {"id": id},
    );
    if (res?.code != 200) return false;
    return true;
  }

  /// 获取板块列表
  Future<List<ArticlePlate>?> getPlate(int? type) async {
    var res = await RequestUtil.getInstance().get(
      "/appXzArticle/getPlate",
      params: {"type": type},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => (data as List).map((e) => ArticlePlate.fromJson(e)).toList(),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  /// 分页查询板块
  Future<PageData<ArticlePlate>?> pagePlate(
    PageRequest req, {
    Map<String, dynamic>? filters,
  }) async {
    var data = req.toJson();
    if (filters != null) data.addAll(filters);
    var res = await RequestUtil.getInstance().post(
      "/appXzArticle/platePage",
      data: data,
    );
    if (res?.code != 200) return null;
    var resJson = PageResponse<ArticlePlate>.fromJson(
      res?.data,
      (data) => ArticlePlate.fromJson(data),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  /// 获取板块详情
  Future<ArticlePlate?> plateDetail(int id) async {
    var res = await RequestUtil.getInstance().get(
      "/appXzArticle/plateDetail",
      params: {"id": id},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => ArticlePlate.fromJson(data),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }
}
