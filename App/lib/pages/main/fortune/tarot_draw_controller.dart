import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:get/get.dart';

class TarotDrawController extends GetxController
    with GetTickerProviderStateMixin {
  // 飞行牌动画控制器，驱动牌从牌堆移动到卡槽
  late AnimationController flyAnimController;
  late Animation<double> flyAnimation;

  final remainingCards = 20.obs;
  final drawnCards = <int?>[null, null, null].obs;
  final isAnimating = false.obs;
  final flyOffset = Offset.zero.obs;

  // 三个 GlobalKey 用于在运行时获取牌堆/卡槽/Stack 的坐标
  final deckKey = GlobalKey();
  final List<GlobalKey> slotKeys = [GlobalKey(), GlobalKey(), GlobalKey()];
  final stackKey = GlobalKey();

  int _animatingSlotIndex = -1;
  int _pickedCardIndex = 0;
  Offset _flyStart = Offset.zero;
  Offset _flyEnd = Offset.zero;

  @override
  void onInit() {
    super.onInit();
    flyAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    flyAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: flyAnimController, curve: Curves.easeInOut),
    );

    // 每帧更新飞行牌的位置，实现从牌堆到卡槽的移动
    flyAnimController.addListener(() {
      flyOffset.value = Offset.lerp(_flyStart, _flyEnd, flyAnimation.value)!;
    });

    // 动画完成 → 牌落地到卡槽
    flyAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onAnimationComplete();
      }
    });
  }

  @override
  void onClose() {
    flyAnimController.dispose();
    super.onClose();
  }

  /// 将牌从牌堆最上方飞入指定卡槽
  /// [slotIndex] 卡槽索引 (0=过去, 1=现在, 2=未来)
  /// [deckOffsetWidth] 牌堆中每张牌的偏移宽度，用于定位最右牌坐标
  void drawCard(int slotIndex, double deckOffsetWidth) {
    // 动画中/卡槽已填/牌堆空 → 不处理
    if (isAnimating.value ||
        drawnCards[slotIndex] != null ||
        remainingCards.value <= 0) {
      return;
    }

    // 获取三个关键节点的 RenderBox，用于坐标转换
    final stackRenderBox =
        stackKey.currentContext?.findRenderObject() as RenderBox?;
    final deckRenderBox =
        deckKey.currentContext?.findRenderObject() as RenderBox?;
    final slotRenderBox =
        slotKeys[slotIndex].currentContext?.findRenderObject() as RenderBox?;
    if (stackRenderBox == null ||
        deckRenderBox == null ||
        slotRenderBox == null) {
      return;
    }

    // 计算牌堆最右（最上方）那张牌在 Stack 中的坐标
    final rightmostIndex = remainingCards.value - 1;
    final cardLocalOffset = Offset(rightmostIndex * deckOffsetWidth, 0);

    // 坐标链路：牌堆内坐标 → 屏幕全局坐标 → Stack 本地坐标
    final deckCardGlobal = deckRenderBox.localToGlobal(cardLocalOffset);
    final slotGlobal = slotRenderBox.localToGlobal(Offset.zero);

    _flyStart = stackRenderBox.globalToLocal(deckCardGlobal);
    _flyEnd = stackRenderBox.globalToLocal(slotGlobal);
    _animatingSlotIndex = slotIndex;

    // 从剩余牌中随机选一张，等动画结束才填入卡槽
    _pickedCardIndex = Random().nextInt(remainingCards.value);

    isAnimating.value = true;
    flyAnimController.forward(from: 0);
  }

  // 飞行动画完成 → 牌落槽、牌堆减一、三张满后跳转解读页
  void _onAnimationComplete() {
    drawnCards[_animatingSlotIndex] = _pickedCardIndex;
    remainingCards.value--;
    isAnimating.value = false;

    // 三张牌都发满后 1 秒跳转到塔罗解读页
    if (drawnCards.every((c) => c != null)) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offNamed(AppRoutes.TAROT_DETAIL);
      });
    }
  }
}
