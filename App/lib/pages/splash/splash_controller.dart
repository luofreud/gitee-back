import 'package:freud/router/app_routes.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/sp_util.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  /// logo透明度
  final logoOpacity = 1.0.obs;

  /// 显示欢迎语
  final welcomeTextShow = false.obs;

  /// 隐藏欢迎语
  final welcomeTextHide = false.obs;

  /// 显示问题调查界面
  final welcomeSurveyShow = false.obs;

  final List<String> textList = [
    'Hello',
    "这里是宝瓶星座，",
    "加入我们，",
    "和同频星友一起",
    "解锁独特自我，探索未来未知可能，",
    "共赴一场属于风象智者的心灵漫游。",
  ];
  final RxList textListIsShow = [].obs;

  final surveyList = [
    {
      "question": "你是否知道自己是哪个星座?\n是否了解星座知识?",
      "options": [
        {"text": "略知一二", "subText": ""},
        {"text": "了如指掌", "subText": ""},
        {"text": "一无所知", "subText": ""},
      ],
      "selected": "",
    },
    {
      "question": "你最喜欢哪类星座？",
      "options": [
        {"text": "水瓶座", "subText": "1.20-2.18"},
        {"text": "双鱼座", "subText": "2.19-3.20"},
        {"text": "白羊座", "subText": "3.21-4.19"},
        {"text": "金牛座", "subText": "4.20-5.20"},
        {"text": "双子座", "subText": "5.21-6.21"},
        {"text": "巨蟹座", "subText": "6.22-7.22"},
        {"text": "狮子座", "subText": "7.23-8.22"},
        {"text": "处女座", "subText": "8.23-9.22"},
        {"text": "天秤座", "subText": "9.23-10.23"},
        {"text": "天蝎座", "subText": "10.24-11.22"},
        {"text": "射手座", "subText": "11.23-12.21"},
        {"text": "摩羯座", "subText": "12.22-1.19"},
      ],
      "selected": "",
    },
    {
      "question": "你还想解析哪些方面的困惑?\n我带你来寻找真相~？",
      "options": [
        {"text": "事业-人际，职业", "subText": ""},
        {"text": "爱情-婚姻，桃花", "subText": ""},
        {"text": "财富-投资，收入", "subText": ""},
        {"text": "健康-心理，身体", "subText": ""},
        {"text": "我来随便看看", "subText": ""},
      ],
      "selected": "",
    },
    {
      "question": "我们为你提供以下方式获取\n还有多种免费工具等你来探索~",
      "options": [
        {"text": "星座运势", "subText": "专业星座解析，更多万千星友互动"},
        {"text": "免费工具", "subText": "塔罗牌，骰子等工具免费试用"},
        {"text": "情感困惑", "subText": "海量咨询师在线服务为你答疑解惑"},
        {"text": "热门测评", "subText": "年运、MBTI等测评助你30s窥探自我"},
      ],
      "selected": "",
    },
  ].obs;
  final surveyIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    textListIsShow.value = List.filled(textList.length, false);
    init();
  }

  /// 启动页初始化逻辑（如检查登录状态、预加载数据等）
  Future<void> init() async {
    // 可添加实际初始化逻辑：如检查Token、加载配置等
    // 获取安装标志，判断是否是首次启动
    final isFirstLaunch = await SpUtil.containsKey('first_launch');
    if (isFirstLaunch == false) {
      // 首次启动，设置标志为true
      await SpUtil.setStorage('first_launch', true);
      setLogoOpacity(0);
    } else {
      // 获取一次用户信息方便用户信息更新同时检测token是否有效
      try {
        final userInfo = await Get.find<UserService>().getUserInfo();
        if (userInfo == null) {
          goLogin();
        } else {
          goHome();
        }
      } catch (e) {}
    }
  }

  goHome() {
    Get.offNamed(AppRoutes.MAIN);
  }

  goLogin() {
    Get.offNamed(AppRoutes.LOGIN);
  }

  /// 设置logo透明度
  setLogoOpacity(double opacity) {
    logoOpacity.value = opacity;
  }

  /// logo显示透明度为0时，显示欢迎语，从第一条开始动画显示
  showWelcomeText() {
    welcomeTextShow.value = true;
    Future.delayed(const Duration(), () {
      textListIsShow[0] = true;
    });
  }

  selectSurveyOption(String text) {
    surveyList[surveyIndex.value]["selected"] = text;
    surveyList.refresh();
    Future.delayed(Duration(milliseconds: 200), () {
      if (surveyIndex.value + 1 < surveyList.length) {
        surveyIndex.value++;
      } else {
        goLogin();
      }
    });
  }
}
