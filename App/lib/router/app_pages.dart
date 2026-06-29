import 'package:freud/pages/counselor/comment/comment_complaint_view.dart';
import 'package:freud/pages/counselor/comment/counselor_comment_view.dart';
import 'package:freud/pages/counselor/counselor_index_view.dart';
import 'package:freud/pages/counselor/creation/creation_content_view.dart';
import 'package:freud/pages/counselor/creation/creation_index_view.dart';
import 'package:freud/pages/counselor/creation/creation_list_view.dart';
import 'package:freud/pages/counselor/live/counselor_live_create_view.dart';
import 'package:freud/pages/counselor/live/counselor_live_index_view.dart';
import 'package:freud/pages/counselor/live/counselor_live_room_view.dart';
import 'package:freud/pages/counselor/notice/notice_detail_view.dart';
import 'package:freud/pages/counselor/notice/notice_list_view.dart';
import 'package:freud/pages/counselor/register/counselor_guide_view.dart';
import 'package:freud/pages/counselor/register/counselor_reg_view.dart';
import 'package:freud/pages/counselor/report/counselor_report_view.dart';
import 'package:freud/pages/counselor/revenue/revenue_income_view.dart';
import 'package:freud/pages/counselor/revenue/revenue_index_view.dart';
import 'package:freud/pages/counselor/revenue/revenue_record_view.dart';
import 'package:freud/pages/counselor/revenue/revenue_withdraw_view.dart';
import 'package:freud/pages/discover/draft/draft_list_view.dart';
import 'package:freud/pages/discover/post/post_detail_view.dart';
import 'package:freud/pages/discover/post/post_publish_view.dart';
import 'package:freud/pages/discover/topic/topic_detail_view.dart';
import 'package:freud/pages/discover/topic/topic_list_view.dart';
import 'package:freud/pages/discover/topic/topic_select_view.dart';
import 'package:freud/pages/home/archive/archive_select_view.dart';
import 'package:freud/pages/live/live_room_view.dart';
import 'package:freud/pages/login/login_view.dart';
import 'package:freud/pages/login/protocol/protocol_view.dart';
import 'package:freud/pages/main/astrolabe/astrolabe_analysis_view.dart';
import 'package:freud/pages/main/astrolabe/astrolabe_detail_view.dart';
import 'package:freud/pages/main/astrolabe/astrolabe_parameter_view.dart';
import 'package:freud/pages/main/astrolabe/astrolabe_setting_view.dart';
import 'package:freud/pages/main/fortune/constellation_view.dart';
import 'package:freud/pages/main/fortune/dice_detail_view.dart';
import 'package:freud/pages/main/fortune/dice_index_view.dart';
import 'package:freud/pages/main/fortune/dice_resolve_view.dart';
import 'package:freud/pages/main/fortune/fortune_human_view.dart';
import 'package:freud/pages/main/fortune/synastry_index_view.dart';
import 'package:freud/pages/main/fortune/tarot_detail_view.dart';
import 'package:freud/pages/main/fortune/tarot_draw_view.dart';
import 'package:freud/pages/main/fortune/tarot_index_view.dart';
import 'package:freud/pages/main/fortune/tarot_question_view.dart';
import 'package:freud/pages/main/main_view.dart';
import 'package:freud/pages/message/chat/chat_view.dart';
import 'package:freud/pages/message/chat/voice_call_view.dart';
import 'package:freud/pages/message/msglist/msg_activity_view.dart';
import 'package:freud/pages/message/msglist/msg_comment_view.dart';
import 'package:freud/pages/message/msglist/msg_like_view.dart';
import 'package:freud/pages/message/msglist/msg_service_view.dart';
import 'package:freud/pages/mine/order/mytips_order_view.dart';
import 'package:freud/pages/mine/order/qa_order_view.dart';
import 'package:freud/pages/mine/order/test_order_view.dart';
import 'package:freud/pages/mine/order/voice_order_view.dart';
import 'package:freud/pages/mine/profile/bind_mobile_view.dart';
import 'package:freud/pages/mine/profile/delete_account_view.dart';
import 'package:freud/pages/mine/profile/edit_name_view.dart';
import 'package:freud/pages/mine/profile/edit_sign_view.dart';
import 'package:freud/pages/mine/profile/profile_view.dart';
import 'package:freud/pages/mine/setting/complaint_view.dart';
import 'package:freud/pages/mine/setting/setting_view.dart';
import 'package:freud/pages/mine/tool/address_manage_view.dart';
import 'package:freud/pages/mine/tool/archive_add_view.dart';
import 'package:freud/pages/mine/tool/calendar_view.dart';
import 'package:freud/pages/mine/tool/evaluation_detail_view.dart';
import 'package:freud/pages/mine/tool/evaluation_publish_view.dart';
import 'package:freud/pages/mine/tool/follow_list_view.dart';
import 'package:freud/pages/mine/tool/my_archive_view.dart';
import 'package:freud/pages/mine/tool/my_evaluation_view.dart';
import 'package:freud/pages/mine/tool/my_gift_view.dart';
import 'package:freud/pages/mine/tool/my_publish_view.dart';
import 'package:freud/pages/mine/tool/sales_service_detail_view.dart';
import 'package:freud/pages/mine/tool/sales_service_view.dart';
import 'package:freud/pages/mine/wealth/coupon_list_view.dart';
import 'package:freud/pages/mine/wealth/mall_change_view.dart';
import 'package:freud/pages/mine/wealth/task_center_view.dart';
import 'package:freud/pages/online/liverank/liverank_view.dart';
import 'package:freud/pages/online/online_qa/qa_astrolabe_view.dart';
import 'package:freud/pages/online/online_qa/qa_dice_view.dart';
import 'package:freud/pages/online/online_qa/qa_square_view.dart';
import 'package:freud/pages/online/online_qa/qa_synastry_view.dart';
import 'package:freud/pages/online/online_qa/qa_tarot_detail_view.dart';
import 'package:freud/pages/online/online_qa/qa_tarot_order_view.dart';
import 'package:freud/pages/splash/splash_view.dart';
import 'package:get/get.dart';

import 'app_routes.dart';
import 'auth_middleware.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH; // 初始路由为启动页

  static final routes = [
    GetPage(name: AppRoutes.SPLASH, page: () => const SplashPage()),
    GetPage(name: AppRoutes.LOGIN, page: () => const LoginPage()),
    GetPage(name: AppRoutes.PROTOCOL, page: () => const ProtocolPage()),
    GetPage(name: AppRoutes.MAIN, page: () => const MainPage()),
    GetPage(name: AppRoutes.CHAT, page: () => const ChatPage()),
    GetPage(name: AppRoutes.VOICE_CALL, page: () => const VoiceCallPage()),

    GetPage(
      name: AppRoutes.CONSTELLATION,
      page: () => const ConstellationPage(),
    ),
    GetPage(name: AppRoutes.FORTUNEHUMAN, page: () => const FortuneHumanPage()),
    GetPage(
      name: AppRoutes.ASTROLABE_ANALYSIS,
      page: () => const AstrolabeAnalysisPage(),
    ),
    GetPage(
      name: AppRoutes.ASTROLABE_DETAIL,
      page: () => const AstrolabeDetailPage(),
    ),
    GetPage(
      name: AppRoutes.ASTROLABE_SETTING,
      page: () => const AstrolabeSettingPage(),
    ),
    GetPage(
      name: AppRoutes.ASTROLABE_PARAMETER,
      page: () => const AstrolabeParameterPage(),
    ),
    GetPage(name: AppRoutes.TAROT, page: () => const TarotIndexPage()),
    GetPage(name: AppRoutes.TAROT_DRAW, page: () => const TarotDrawPage()),
    GetPage(
      name: AppRoutes.TAROT_QUESTION,
      page: () => const TarotQuestionPage(),
    ),
    GetPage(name: AppRoutes.TAROT_DETAIL, page: () => const TarotDetailPage()),
    GetPage(name: AppRoutes.DICE, page: () => const DiceIndexPage()),
    GetPage(name: AppRoutes.DICE_DETAIL, page: () => const DiceDetailPage()),
    GetPage(name: AppRoutes.DICE_RESOLVE, page: () => const DiceResolvePage()),
    GetPage(name: AppRoutes.SYNASTRY, page: () => const SynastryIndexPage()),

    GetPage(name: AppRoutes.POST_PUBLISH, page: () => const PostPublishPage()),
    GetPage(name: AppRoutes.POST_DETAIL, page: () => const PostDetailPage()),
    GetPage(name: AppRoutes.TOPIC_SELECT, page: () => const TopicSelectPage()),
    GetPage(name: AppRoutes.TOPIC_LIST, page: () => const TopicListPage()),
    GetPage(name: AppRoutes.TOPIC_DETAIL, page: () => const TopicDetailPage()),
    GetPage(name: AppRoutes.DRAFT_LIST, page: () => const DraftListPage()),

    GetPage(name: AppRoutes.LIVE_ROOM, page: () => const LiveRoomPage()),
    GetPage(name: AppRoutes.LIVERANK, page: () => const LiverankPage()),
    GetPage(name: AppRoutes.QA_ASTROLABE, page: () => const QaAstrolabePage()),
    GetPage(name: AppRoutes.QA_DICE, page: () => const QaDicePage()),
    GetPage(name: AppRoutes.QA_SYNASTRY, page: () => const QaSynastryPage()),
    GetPage(
      name: AppRoutes.QA_TAROT_DETAIL,
      page: () => const QaTarotDetailPage(),
    ),
    GetPage(
      name: AppRoutes.QA_TAROT_ORDER,
      page: () => const QaTarotOrderPage(),
    ),
    GetPage(name: AppRoutes.QA_SQUARE, page: () => const QaSquarePage()),

    GetPage(name: AppRoutes.MSG_LIKE, page: () => const MsgLikePage()),
    GetPage(name: AppRoutes.MSG_COMMENT, page: () => const MsgCommentPage()),
    GetPage(name: AppRoutes.MSG_ACTIVITY, page: () => const MsgActivityPage()),
    GetPage(name: AppRoutes.MSG_SERVICE, page: () => const MsgServicePage()),

    GetPage(name: AppRoutes.MINE_PROFILE, page: () => const ProfilePage()),
    GetPage(name: AppRoutes.MINE_SETTING, page: () => const SettingPage()),
    GetPage(name: AppRoutes.MINE_EDITNAME, page: () => const EditNamePage()),
    GetPage(name: AppRoutes.MINE_EDITSIGN, page: () => const EditSignPage()),
    GetPage(
      name: AppRoutes.MINE_BINDMOBILE,
      page: () => const BindMobilePage(),
    ),
    GetPage(
      name: AppRoutes.MINE_DELETEACCOUNT,
      page: () => const DeleteAccountPage(),
    ),
    GetPage(name: AppRoutes.MINE_COMPLAINT, page: () => const ComplaintPage()),

    GetPage(name: AppRoutes.WEALTH_COUPON, page: () => const CouponListPage()),
    GetPage(name: AppRoutes.ORDER_QALIST, page: () => const QaOrderPage()),
    GetPage(name: AppRoutes.ORDER_TESTLIST, page: () => const TestOrderPage()),
    GetPage(
      name: AppRoutes.ORDER_VOICELIST,
      page: () => const VoiceOrderPage(),
    ),
    GetPage(
      name: AppRoutes.ORDER_MYTIPSlIST,
      page: () => const MytipsOrderPage(),
    ),

    GetPage(name: AppRoutes.TASK_CENTER, page: () => const TaskCenterPage()),
    GetPage(name: AppRoutes.MALL_CHANGE, page: () => const MallChangePage()),

    GetPage(name: AppRoutes.TOOL_CALENDAR, page: () => const CalendarPage()),
    GetPage(
      name: AppRoutes.TOOL_FOLLOWLIST,
      page: () => const FollowListPage(),
    ),
    GetPage(name: AppRoutes.TOOL_MYPUBLISH, page: () => const MyPublishPage()),
    GetPage(
      name: AppRoutes.TOOL_MYEVALUATION,
      page: () => const MyEvaluationPage(),
    ),
    GetPage(
      name: AppRoutes.TOOL_EVALUATIONDETAIL,
      page: () => const EvaluationDetailPage(),
    ),
    GetPage(
      name: AppRoutes.TOOL_EVALUATIONPUBLISH,
      page: () => const EvaluationPublishPage(),
    ),
    GetPage(name: AppRoutes.TOOL_MYARCHIVE, page: () => const MyArchivePage()),
    GetPage(
      name: AppRoutes.TOOL_ARCHIVEADD,
      page: () => const ArchiveAddPage(),
    ),
    GetPage(
      name: AppRoutes.ARCHIVE_SELECT,
      page: () => const ArchiveSelectPage(),
    ),
    GetPage(name: AppRoutes.TOOL_MYGIFT, page: () => const MyGiftPage()),
    GetPage(
      name: AppRoutes.TOOL_ADDRESSMANAGE,
      page: () => const AddressManagePage(),
    ),
    GetPage(
      name: AppRoutes.TOOL_SALESSERVICE,
      page: () => const SalesServicePage(),
    ),
    GetPage(
      name: AppRoutes.TOOL_SALESSERVICE_DETAIL,
      page: () => const SalesServiceDetailPage(),
    ),

    GetPage(
      name: AppRoutes.COUNSELOR_GUIDE,
      page: () => const CounselorGuidePage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_REG,
      page: () => const CounselorRegPage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_INDEX,
      page: () => const CounselorIndexPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_NOTICE,
      page: () => const NoticeListPage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_NOTICE_DETAIL,
      page: () => const NoticeDetailPage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_COMMENT,
      page: () => const CounselorCommentPage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_COMMENT_COMPLAINT,
      page: () => const CommentComplaintPage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_REVENUE_INDEX,
      page: () => const RevenueIndexPage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_REVENUE_INCOME,
      page: () => const RevenueIncomePage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_REVENUE_WITHDRAW,
      page: () => const RevenueWithdrawPage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_REVENUE_RECORD,
      page: () => const RevenueRecordPage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_REPORT,
      page: () => const CounselorReportPage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_CREATION_INDEX,
      page: () => const CreationIndexPage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_CREATION_LIST,
      page: () => const CreationListPage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_CREATION_CONTENT,
      page: () => const CreationContentPage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_LIVE_INDEX,
      page: () => const CounselorLiveIndexPage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_LIVE_CREATE,
      page: () => const CounselorLiveCreatePage(),
    ),
    GetPage(
      name: AppRoutes.COUNSELOR_LIVE_ROOM,
      page: () => const CounselorLiveRoomPage(),
    ),
  ];
}
