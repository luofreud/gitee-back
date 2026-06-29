class AppRoutes {
  static const String SPLASH = '/splash'; // 启动页
  static const String LOGIN = '/login'; // 登录页
  static const String PROTOCOL = '/protocol'; // 用户协议
  static const String MAIN = '/main'; // 主框架页
  static const String CHAT = '/chat'; // 聊天页面
  static const String VOICE_CALL = '/chat/voice_call'; // 语音通话

  static const String ARCHIVE_SELECT = '/archiveselect'; // 选择档案

  static const String CONSTELLATION = '/constellation'; //星座
  static const String FORTUNEHUMAN = '/fortunehuman'; //个人运势
  static const String ASTROLABE_ANALYSIS = '/astrolabe/analysis'; //星盘解析
  static const String ASTROLABE_DETAIL = '/astrolabe/detail'; //星盘解析详情
  static const String ASTROLABE_SETTING = '/astrolabe/setting'; //星盘解析设置
  static const String ASTROLABE_PARAMETER = '/astrolabe/parameter'; //星盘参数
  static const String TAROT = '/tarot'; //塔罗
  static const String TAROT_DRAW = '/tarot/draw'; //塔罗取牌
  static const String TAROT_QUESTION = '/tarot/question'; //塔罗提问
  static const String TAROT_DETAIL = '/tarot/detail'; //塔罗解读
  static const String DICE = '/dice'; //骰子
  static const String DICE_DETAIL = '/dice/detail'; //骰子详情页面
  static const String DICE_RESOLVE = '/dice/resolve'; //骰子咨询师解读
  static const String SYNASTRY = '/synastry'; //合盘

  static const String POST_PUBLISH = '/post/publish'; // 发帖
  static const String POST_DETAIL = '/post/detail'; // 帖子详情
  static const String TOPIC_SELECT = '/topic/select'; // 选择话题
  static const String TOPIC_LIST = '/topic/list'; // 话题列表
  static const String TOPIC_DETAIL = '/topic/detail'; // 话题详情
  static const String DRAFT_LIST = '/draft/list'; // 草稿箱

  static const String LIVE_ROOM = '/live/room'; //直播间

  ///直播榜单
  static const String LIVERANK = '/liverank';

  static const String QA_ASTROLABE = '/qa/astrolabe'; // 星盘解读
  static const String QA_DICE = '/qa/dice'; // 骰子解读
  static const String QA_SYNASTRY = '/qa/synastry'; // 合盘解读
  static const String QA_TAROT_DETAIL = '/qa/tarot/detail'; // 塔罗解读
  static const String QA_TAROT_ORDER = '/qa/tarot/order'; // 塔罗解读下单
  static const String QA_SQUARE = '/qa/square'; // 问题广场

  static const String MSG_LIKE = '/message/like'; // 点赞列表
  static const String MSG_COMMENT = '/message/comment'; // 评论回复列表
  static const String MSG_ACTIVITY = '/message/activity'; // 活动通知
  static const String MSG_SERVICE = '/message/service'; // 服务消息

  static const String MINE_PROFILE = '/mine/profile'; // 个人资料
  static const String MINE_SETTING = '/mine/setting'; // 设置界面
  static const String MINE_EDITNAME = '/mine/editname'; // 修改昵称
  static const String MINE_EDITSIGN = '/mine/editsign'; // 修改个性签名
  static const String MINE_BINDMOBILE = '/mine/bindmobile'; // 绑定手机号码
  static const String MINE_DELETEACCOUNT = '/mine/deleteaccount'; // 注销账户
  static const String MINE_COMPLAINT = '/mine/complaint'; // 投诉

  static const String WEALTH_COUPON = '/wealth/coupon'; // 我的优惠券列表

  static const String ORDER_QALIST = '/order/qalist'; // 问答
  static const String ORDER_TESTLIST = '/order/testlist'; // 测评
  static const String ORDER_VOICELIST = '/order/voicelist'; // 连麦
  static const String ORDER_MYTIPSlIST = '/order/mytipslist'; // 我的赞赏

  static const String TASK_CENTER = '/taskcenter'; // 任务中心
  static const String MALL_CHANGE = '/mallchange'; // 兑换商城

  static const String TOOL_CALENDAR = '/tool/calendar'; // 星象日历
  static const String TOOL_FOLLOWLIST = '/tool/followlist'; // 关注收藏
  static const String TOOL_MYPUBLISH = '/tool/mypublish'; // 我的发布
  static const String TOOL_MYEVALUATION = '/tool/myevaluation'; // 我的评价
  static const String TOOL_EVALUATIONDETAIL = '/tool/evaluationdetail'; // 评价详情
  static const String TOOL_EVALUATIONPUBLISH =
      '/tool/evaluationpublish'; // 评价发布

  static const String TOOL_MYARCHIVE = '/tool/myarchive'; // 我的档案
  static const String TOOL_ARCHIVEADD = '/tool/archiveadd'; // 添加档案
  static const String TOOL_MYGIFT = '/tool/mygift'; // 我的礼物
  static const String TOOL_ADDRESSMANAGE = '/tool/addressmanage'; // 地址管理
  static const String TOOL_SALESSERVICE = '/tool/salesservice'; // 售后
  static const String TOOL_SALESSERVICE_DETAIL =
      '/tool/salesservice/detail'; // 售后详情

  /// ====================
  /// 咨询师管理页面
  /// ====================
  static const String COUNSELOR_GUIDE = '/counselor/guide'; // 咨询师注册引导页
  static const String COUNSELOR_REG = '/counselor/reg'; // 咨询师注册页
  static const String COUNSELOR_INDEX = '/counselor/index'; // 咨询师首页
  static const String COUNSELOR_NOTICE = '/counselor/notice'; // 咨询师通知
  static const String COUNSELOR_NOTICE_DETAIL =
      '/counselor/notice/detail'; // 咨询师通知详情
  static const String COUNSELOR_COMMENT = '/counselor/comment'; // 咨询师互动管理
  static const String COUNSELOR_COMMENT_COMPLAINT =
      '/counselor/comment/complaint'; // 互动举报

  static const String COUNSELOR_REVENUE_INDEX =
      '/counselor/revenue/index'; // 收益中心
  static const String COUNSELOR_REVENUE_INCOME =
      '/counselor/revenue/income'; // 个人收益
  static const String COUNSELOR_REVENUE_WITHDRAW =
      '/counselor/revenue/withdraw'; //收益提现
  static const String COUNSELOR_REVENUE_RECORD =
      '/counselor/revenue/record'; //提现记录
  static const String COUNSELOR_REPORT = '/counselor/report'; //数据中心
  static const String COUNSELOR_CREATION_INDEX =
      '/counselor/creation/index'; //创作中心
  static const String COUNSELOR_CREATION_LIST =
      '/counselor/creation/list'; //创作管理
  static const String COUNSELOR_CREATION_CONTENT =
      '/counselor/creation/content'; //创作内容
  static const String COUNSELOR_LIVE_INDEX = '/counselor/live/index'; //直播中心
  static const String COUNSELOR_LIVE_CREATE = '/counselor/live/create'; //直播创建
  static const String COUNSELOR_LIVE_ROOM = '/counselor/live/room'; //直播间
}
