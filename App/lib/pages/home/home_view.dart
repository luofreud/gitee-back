import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:get/get.dart';

import '../../widgets/carousel_widget.dart';
import '../../widgets/component/tutor_item.dart';
import '../main/main_controller.dart';
import '../online/online_controller.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: GetBuilder<HomeController>(
          builder: (HomeController home) {
            return Obx(
              () => AppBar(
                title: Image.asset('assets/images/logo_text.png', height: 24),
                backgroundColor: Color(
                  0xffDEE6FF,
                ).withAlpha(home.appBarAlpha.value),
                centerTitle: false,
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.TASK_CENTER);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withAlpha(150),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      minimumSize: Size(0, 0),
                      fixedSize: Size(double.infinity, 30),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/icons/icon_signin.png', height: 20),
                        SizedBox(width: 5),
                        Text('签到', style: TextStyle(color: Color(0xffFF8F40))),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    // 禁用水波纹效果
                    splashColor: Colors.transparent,
                    // 水波纹颜色透明
                    highlightColor: Colors.transparent,
                    icon: Icon(Icons.add_circle_outline, size: 30),
                    color: Color(0xff4D1FAE),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffF5F7F9),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        padding: EdgeInsets.only(bottom: AppConst.PAGE_PADDING),
        child: Column(
          spacing: AppConst.PAGE_PADDING,
          children: [
            _TodayFortuneWidget(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConst.PAGE_PADDING),
              child: CarouselWidget(
                height: 75,
                children: List<Widget>.generate(5, (int index) {
                  return Container(
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        // image: AssetImage('assets/images/home_ad1.png'),
                        // image: NetworkImage(
                        //   'https://iph.href.lu/500x200?text=$index&fg=666666&bg=cccccc',
                        // ),
                        image: NetworkImage(
                          'https://api.elaina.cat/random/?t=$index',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                }),
              ),
            ),
            _HomeNavWidget(),
            _HomeCardRecommendWidget(),
            _HomeCardCounsellingWidget(),
            _HomeCardInteractWidget(),
            Text('宝瓶占星', style: TextStyle(color: Color(0xffE5E5E5))),
          ],
        ),
      ),
    );
  }
}

/// 今日运势
class _TodayFortuneWidget extends StatelessWidget {
  const _TodayFortuneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _todayLuckyList = ['幸运字', '幸运花', '幸运石', '幸运色'];
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        top: kToolbarHeight + 22,
        right: AppConst.PAGE_PADDING,
        left: AppConst.PAGE_PADDING,
      ),
      decoration: BoxDecoration(
        color: Colors.orange,
        image: DecorationImage(
          image: AssetImage('assets/images/home_top_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 20,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        spacing: 10,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.FORTUNEHUMAN);
                            },
                            child: CircleAvatar(
                              radius: 16,
                              foregroundImage: AssetImage(
                                'assets/icons/icon_home_avatar.png',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.FORTUNEHUMAN);
                            },
                            child: Obx(() {
                              final name = Get.find<HomeController>()
                                  .currentArchive
                                  .value
                                  ?.name;
                              return Text(
                                name ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.FORTUNEHUMAN);
                            },
                            child: Obx(() {
                              final archive = Get.find<HomeController>()
                                  .currentArchive
                                  .value;
                              String text = '';
                              if (archive?.birthday != null &&
                                  archive!.birthday!.isNotEmpty) {
                                try {
                                  final birthday = DateTime.parse(
                                    archive.birthday!,
                                  );
                                  text =
                                      '${CommonUtil.getConstellationName(birthday)}';
                                } catch (_) {}
                              }
                              return Text(
                                text,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff8198DB),
                                ),
                              );
                            }),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Get.find<HomeController>().onSelectArchive(),
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: Colors.white.withAlpha(150),
                              ),
                              child: Icon(
                                Icons.sync_alt,
                                size: 12,
                                color: Color(0xff8198DB),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      final fortune =
                          Get.find<HomeController>().todayFortune.value;
                      final List<Map<String, dynamic>> scores = [
                        {
                          'title': '爱情',
                          'score': fortune?['love'] ?? 0,
                          'colors': [Color(0xffFC9C96), Color(0xffFF5445)],
                          'image': 'assets/images/today_score_bg1.png',
                        },
                        {
                          'title': '健康',
                          'score': 85,
                          'colors': [Color(0xff6CDEAC), Color(0xff27C87D)],
                          'image': 'assets/images/today_score_bg2.png',
                        },
                        {
                          'title': '财富',
                          'score': fortune?['wealth'] ?? 0,
                          'colors': [Color(0xffEDBD9A), Color(0xffFF9434)],
                          'image': 'assets/images/today_score_bg3.png',
                        },
                      ];
                      return Row(
                        spacing: 12,
                        children: scores
                            .map(
                              (element) => Expanded(
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(element['image']),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      spacing: 0,
                                      children: [
                                        Text(
                                          element['score'].toString(),
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ShaderMask(
                                          shaderCallback: (Rect bounds) {
                                            return LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: element['colors'],
                                              tileMode: TileMode.clamp,
                                            ).createShader(bounds);
                                          },
                                          child: Text(
                                            element['title'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }),
                  ],
                ),
              ),
              Container(
                width: 100,
                height: 110,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/total_score.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Transform.translate(
                  offset: Offset(0, -8),
                  child: Center(
                    child: Obx(() {
                      final average = Get.find<HomeController>()
                          .todayFortune
                          .value?['average'];
                      return Text(
                        average?.toString() ?? '--',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Color(0xffAC34ED),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
          Row(
            spacing: 12,
            children: _todayLuckyList.map((element) {
              Widget _itemWidget = SizedBox.shrink();
              if (element == '幸运字') {
                _itemWidget = Obx(() {
                  final todayFortune =
                      Get.find<HomeController>().todayFortune.value;
                  final luckyNumber = todayFortune?['lucky_number'];
                  return Text(luckyNumber?.toString() ?? '8');
                });
              } else if (element == '幸运花') {
                _itemWidget = ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/images/home_top_bg.png',
                    width: 12,
                    height: 12,
                  ),
                );
              } else if (element == '幸运石') {
                _itemWidget = ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/images/home_top_bg.png',
                    width: 12,
                    height: 12,
                  ),
                );
              } else if (element == '幸运色') {
                _itemWidget = CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.red,
                );
              }
              return Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        element,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffA8A8A8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _itemWidget,
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          Obx(() {
            final todayFortune = Get.find<HomeController>().todayFortune.value;
            final describe = todayFortune?['describe'] ?? '';
            return _TextWithMoreInLine(text: '${describe}');
          }),
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _TextWithMoreInLine extends StatelessWidget {
  final String text; // 原始文本
  final TextStyle textStyle; // 文本样式
  final TextStyle moreStyle; // “更多”按钮样式
  final int maxLines; // 最大行数（这里固定为2）

  const _TextWithMoreInLine({
    super.key,
    required this.text,
    this.textStyle = const TextStyle(fontSize: 14, color: Colors.black),
    this.moreStyle = const TextStyle(fontSize: 14, color: Color(0xff7B80DB)),
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 1. 计算“更多”文本的宽度
        const moreText = "更多>>";
        final TextPainter morePainter = TextPainter(
          text: TextSpan(text: moreText, style: moreStyle),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);
        final moreWidth = morePainter.width;

        // 2. 计算文本在扣除“更多”按钮宽度后的可用空间
        final textMaxWidth =
            constraints.maxWidth - moreWidth - 4; // 4是省略号与“更多”的间距

        // 3. 检查原始文本在可用空间下是否超过maxLines
        final TextPainter fullTextPainter = TextPainter(
          text: TextSpan(text: text, style: textStyle),
          textDirection: TextDirection.ltr,
          maxLines: maxLines,
        )..layout(maxWidth: textMaxWidth);
        final bool isOverFlow = fullTextPainter.didExceedMaxLines;

        if (isOverFlow) {
          // 4. 超过行数：截断文本并拼接省略号+“更多”
          return RichText(
            maxLines: maxLines,
            overflow: TextOverflow.visible, // 允许“更多”按钮超出文本流（但实际会在第二行内）
            text: TextSpan(
              style: textStyle,
              children: [
                // 截断后的文本（通过计算获取近似截断位置）
                TextSpan(text: _getTruncatedText(text, textMaxWidth)),
                // 省略号
                const TextSpan(text: "...  "),
                // “更多”按钮（带点击事件）
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.FORTUNEHUMAN),
                    child: Text(moreText, style: moreStyle),
                  ),
                ),
              ],
            ),
          );
        } else {
          // 未超过行数：直接显示完整文本
          return Text(text, style: textStyle, maxLines: maxLines);
        }
      },
    );
  }

  // 计算截断后的文本（确保在maxLines内且预留省略号+“更多”的空间）
  String _getTruncatedText(String originalText, double maxWidth) {
    final TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    );

    // 二分法寻找最大可显示的文本长度
    int start = 0;
    int end = originalText.length;
    String bestText = originalText;

    while (start <= end) {
      final mid = (start + end) ~/ 2;
      final testText = originalText.substring(0, mid);
      painter.text = TextSpan(text: testText, style: textStyle);
      painter.layout(maxWidth: maxWidth);

      if (painter.didExceedMaxLines) {
        end = mid - 1;
      } else {
        bestText = testText;
        start = mid + 1;
      }
    }

    return bestText;
  }
}

/// 首页快捷导航栏
class _HomeNavWidget extends StatelessWidget {
  const _HomeNavWidget({super.key});

  static final navList = [
    {
      "title": "星盘",
      "icon": "assets/images/home_nav_xp.png",
      "onTap": () {
        Get.find<HomeController>().onNavToAstrolabe();
      },
    },
    {
      "title": "星座",
      "icon": "assets/images/home_nav_xz.png",
      "onTap": () {
        print('星座');
        Get.toNamed(AppRoutes.CONSTELLATION);
      },
    },
    {
      "title": "骰子",
      "icon": "assets/images/home_nav_tz.png",
      "onTap": () {
        Get.toNamed(AppRoutes.DICE);
      },
    },
    {
      "title": "智慧牌",
      "icon": "assets/images/home_nav_tl.png",
      "onTap": () {
        Get.toNamed(AppRoutes.TAROT);
      },
    },
    {
      "title": "合盘",
      "icon": "assets/images/home_nav_hp.png",
      "onTap": () {
        Get.toNamed(AppRoutes.SYNASTRY);
      },
    },
  ];

  _buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: navList.map((element) {
        return GestureDetector(
          onTap: () {
            var onTapCall = element["onTap"] as Function();
            onTapCall();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(element["icon"].toString(), width: 38),
              const SizedBox(height: 3),
              Text(
                element["title"].toString(),
                style: TextStyle(color: Color(0xff383838)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: AppConst.PAGE_PADDING),
      child: Column(
        spacing: 15,
        children: [
          _buildRow(),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.TOOL_CALENDAR);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [Color(0xffE3F1FF), Color(0xffFCFEFF)],
                      ),
                    ),
                    child: Row(
                      spacing: 5,
                      children: [
                        Image.asset(
                          'assets/images/home_nav_xl.png',
                          width: 40,
                          height: 40,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('星历'),
                              Text(
                                '查看今日星象',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff8AB0D1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // todo 测评功能
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [Color(0xffFFF3ED), Color(0xffFFFAF7)],
                      ),
                    ),
                    child: Row(
                      spacing: 5,
                      children: [
                        Image.asset(
                          'assets/images/home_nav_cp.png',
                          width: 40,
                          height: 40,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('测评'),
                              Text(
                                '超多测评等你来',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xffE0B4A2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 首页卡片标题
class _HomeCardTitleWidget extends StatelessWidget {
  final String? title;
  final Function()? onMore;

  const _HomeCardTitleWidget({super.key, this.title, this.onMore});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title ?? '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xff383838),
            ),
          ),
        ),
        onMore != null
            ? GestureDetector(
                onTap: onMore,
                child: Text('更多 >', style: TextStyle(color: Color(0xffA6A6A6))),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

/// 热门推荐
class _HomeCardRecommendWidget extends StatelessWidget {
  const _HomeCardRecommendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [1, 2, 3, 4, 5, 6];
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: AppConst.PAGE_PADDING),
      child: Column(
        children: [
          _HomeCardTitleWidget(title: '热门推荐', onMore: () {}),
          GridView.count(
            crossAxisCount: 2,
            // 列之间的间距
            crossAxisSpacing: AppConst.PAGE_PADDING,
            // 行之间的间距
            mainAxisSpacing: AppConst.PAGE_PADDING,
            // 内边距
            padding: const EdgeInsets.only(
              top: 10,
              left: 0,
              right: 0,
              bottom: 0,
            ),
            // 禁止网格拉伸以适应内容
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // 子元素构建
            children: items.map((item) {
              List<Color> color = [Color(0xffF452C7), Color(0xff9748C5)];
              switch (item) {
                case 1:
                  color = [Color(0xffF55353), Color(0xffC44949)];
                  break;
                case 2:
                  color = [Color(0xffF5A249), Color(0xffFAD550)];
                  break;
                case 3:
                  color = [Color(0xff26C99E), Color(0xff3CB2E8)];
                  break;
              }
              return AspectRatio(
                // 使用定义的宽高比
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/example/home_item_image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: color,
                            ),
                          ),
                          child: Row(
                            spacing: 3,
                            children: [
                              Image.asset(
                                'assets/icons/icon_crown.png',
                                width: 16,
                              ),
                              Text(
                                '热度榜',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                item.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: 5,
                        child: Column(
                          spacing: 2,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '【七七】',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '你的星盘会告诉你这些你的星盘会告诉你这些你的星盘会告诉你这些你的星盘会告诉你这些',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xff7259FF),
                                    Color(0xff927CF9),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified_user,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '认证咨询师',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// 咨询解惑
class _HomeCardCounsellingWidget extends StatelessWidget {
  const _HomeCardCounsellingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: AppConst.PAGE_PADDING),
      child: Column(
        children: [
          _HomeCardTitleWidget(
            title: '咨询解惑',
            onMore: () {
              final mainCtrl = Get.find<MainController>();
              mainCtrl.changeNavIndex(2);
              mainCtrl.pageController.jumpToPage(2);
              Future.delayed(const Duration(milliseconds: 100), () {
                final onlineCtrl = Get.find<OnlineController>();
                onlineCtrl.changeTab(1);
              });
            },
          ),
          Obx(() {
            final teachers = ctrl.teacherList;
            if (teachers.isEmpty) return const SizedBox.shrink();
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10),
              itemBuilder: (context, index) {
                return TutorItem(teacher: teachers[index]);
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppConst.PAGE_PADDING),
              itemCount: teachers.length,
            );
          }),
        ],
      ),
    );
  }
}

/// 星座交流圈
class _HomeCardInteractWidget extends StatelessWidget {
  const _HomeCardInteractWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: AppConst.PAGE_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          _HomeCardTitleWidget(
            title: '星座交流圈',
            onMore: () {
              print('object');
              Get.toNamed(AppRoutes.TOPIC_LIST);
            },
          ),
          Obx(() {
            final plates = ctrl.plateList;
            if (plates.isEmpty) return const SizedBox(height: 150);
            return SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final plate = plates[index];
                  List<Color> colors = [
                    Color(0xffF0F5FF),
                    Color(0xffFFF0F0),
                    Color(0xffFFFCF0),
                  ];
                  var colorIndex = index % colors.length;
                  return GestureDetector(
                    onTap: () => Get.toNamed(
                      AppRoutes.TOPIC_DETAIL,
                      arguments: plate.id,
                    ),
                    child: Container(
                      width: 110,
                      decoration: BoxDecoration(
                        color: colors[colorIndex],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 74,
                              height: 74,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white.withAlpha(50),
                                ),
                              ),
                              padding: EdgeInsets.all(2),
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white.withAlpha(100),
                                  ),
                                ),
                                padding: EdgeInsets.all(4),
                                child: CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.white,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: ImageView.network(
                                      plate.image ?? '',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      isPreview: false,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                plate.title ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '帖子热度 ${plate.count ?? 0}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xffA6A6A6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: plates.length,
              ),
            );
          }),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '大家也关心的事',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff636363),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Row(
                        spacing: 20,
                        children: [
                          Text(
                            '我的婚姻关系好不好',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff383838),
                            ),
                          ),
                          Text('你肯定会中这几条'),
                          Text('这些性格的星座是最好避开的'),
                        ],
                      ),
                      Row(
                        spacing: 20,
                        children: [
                          Text('测测你星盘基础知识'),
                          Text('做这些事情可以让你财运更好哦'),
                          Text('年运测算'),
                        ],
                      ),
                      Row(
                        spacing: 20,
                        children: [
                          Text('这些性格的星座是最好避开的'),
                          Text('测测你的事业'),
                          Text('测测你的事业'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
