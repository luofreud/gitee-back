import 'package:flutter/material.dart';
import 'package:freud/api/api.dart';
import 'package:freud/models/article/article_plate.dart';
import 'package:freud/models/article/post.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:get/get.dart';

/// appbar默认扩展高度
const double _kExpandedHeightDefault = 200.0;

const double _kAppbarStartAlphaHeight = 60.0;

class TopicDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final offsetHeight = _kExpandedHeightDefault.obs;

  late AnimationController animationController;
  late Animation<double> heightAnimation;
  final animationStatus = AnimationStatus.dismissed.obs;

  /// 动画开始时保存的offsetHeight
  double _animationStartOffsetHeight = _kExpandedHeightDefault;

  /// appbar透明度
  final appBarColor = Colors.white.withAlpha(0).obs;
  final appBarTextColor = Colors.white.obs;

  final isLoading = false.obs;
  final listNoMore = false.obs;
  final listData = <Post>[].obs;
  int _page = 1;
  late int topicId;
  final topicInfo = Rx<ArticlePlate?>(null);
  final isSubscribed = 0.obs;
  final subscribeCount = 0.obs;
  final isSubscribing = false.obs;
  int? subscribeId;

  @override
  void onInit() {
    super.onInit();
    _initAnimation();
    topicId = Get.arguments as int;
    PostApi().plateDetail(topicId).then((data) {
      topicInfo.value = data;
      _fetchSubscribeStatus();
    });
    listRefresh();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void _initAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    // 监听动画状态，当动画完成时将高度重置为默认高度
    animationController.addStatusListener((status) {
      animationStatus.value = status;
      if (status == AnimationStatus.completed) {
        offsetHeight.value = _kExpandedHeightDefault;
      }
    });
    heightAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut, // 缓动曲线，让过渡更自然
        reverseCurve: Curves.easeInOut,
      ),
    );
    //监听动画值改变，更新offsetHeight
    heightAnimation.addListener(() {
      offsetHeight.value =
          _animationStartOffsetHeight -
          (_animationStartOffsetHeight - _kExpandedHeightDefault) *
              heightAnimation.value;
    });
  }

  /// 下拉过程中实时更新offsetHeight
  void updateOffsetHeight(double value) {
    offsetHeight.value = (_kExpandedHeightDefault + 50 * value).clamp(
      _kExpandedHeightDefault,
      400,
    );
  }

  /// 下拉结束后动画执行恢复到默认高度
  void pullDownEnd() {
    _animationStartOffsetHeight = offsetHeight.value;
    animationController.reset();
    animationController.forward();
  }

  /// 根据滚动条到顶部的距离更新appbar的颜色
  void updateAppBarColor(double distanceToTop) {
    if (distanceToTop < _kAppbarStartAlphaHeight) {
      appBarColor.value = Colors.black.withAlpha(0);
      appBarTextColor.value = Colors.white;
    } else if (distanceToTop >= _kAppbarStartAlphaHeight) {
      int alpha = (255 * ((distanceToTop - _kAppbarStartAlphaHeight) / 20))
          .toInt();
      appBarColor.value = Colors.white.withAlpha(alpha.clamp(0, 255));
      appBarTextColor.value = Color(0xff383838);
    }
  }

  _fetchSubscribeStatus() async {
    var data = await UserApi().userSubPage(
      PageRequest(page: 1, pageSize: 1),
      corrid: topicId,
      stype: 2,
    );
    if (data?.items != null && data!.items!.isNotEmpty) {
      isSubscribed.value = 1;
      subscribeId = data.items!.first.id;
    }
    // subscribeCount.value = topicInfo.value?.count ?? 0;
  }

  toggleSubscribe() async {
    if (isSubscribing.value) return;
    isSubscribing.value = true;
    if (isSubscribed.value == 1) {
      if (subscribeId == null) {
        await _fetchSubscribeStatus();
      }
      if (subscribeId == null) {
        isSubscribing.value = false;
        return;
      }
      var success = await UserApi().userSubDel(subscribeId!);
      if (success) {
        isSubscribed.value = 0;
        subscribeCount.value = (subscribeCount.value > 0
            ? subscribeCount.value - 1
            : 0);
        subscribeId = null;
      }
    } else {
      var success = await UserApi().userSubAdd({"corrid": topicId, "stype": 2});
      if (success) {
        isSubscribed.value = 1;
        subscribeCount.value = subscribeCount.value + 1;
        _fetchSubscribeStatus();
      }
    }
    isSubscribing.value = false;
  }

  listRefresh() {
    _page = 1;
    listNoMore.value = false;
    return loadMore();
  }

  loadMore() {
    if (isLoading.value || listNoMore.value) return;
    isLoading.value = true;
    PostApi()
        .postPage(
          PageRequest(page: _page, pageSize: 10),
          filters: {'topicid': topicId},
        )
        .then((data) {
          if (data != null && data.items != null) {
            if (_page == 1) {
              listData.clear();
            }
            listData.addAll(data.items!);
            _page++;
            if (data.hasNextPage == false) {
              listNoMore.value = true;
            }
          }
        })
        .whenComplete(() {
          isLoading.value = false;
        });
  }
}
