import 'package:flutter/material.dart';

class LiveingAnimationWidget extends StatefulWidget {
  const LiveingAnimationWidget({super.key});

  @override
  State<LiveingAnimationWidget> createState() => _LiveingAnimationWidgetState();
}

class _LiveingAnimationWidgetState extends State<LiveingAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    // 1. 定义动画时长和Tween
    final Duration animDuration = Duration(milliseconds: 500);
    final Tween<double> heightTween = Tween<double>(begin: 2.0, end: 8.0);

    // 2. 初始化第一个柱子的动画（无延迟）
    _controller1 = AnimationController(vsync: this, duration: animDuration);
    _animation1 = heightTween.animate(
      CurvedAnimation(
        parent: _controller1,
        curve: const Interval(0, 1.0, curve: Curves.easeInOut),
      ),
    );
    _controller1.repeat(reverse: true);
    // 3. 初始化第二个柱子的动画（延迟0.2秒）
    _controller2 = AnimationController(vsync: this, duration: animDuration);
    _animation2 = heightTween.animate(
      CurvedAnimation(
        parent: _controller2,
        curve: const Interval(0, 1.0, curve: Curves.easeInOut),
      ),
    );
    Future.delayed(
      Duration(milliseconds: 200),
      () => _controller2.repeat(reverse: true),
    );

    // 4. 初始化第三个柱子的动画（延迟0.4秒）
    _controller3 = AnimationController(vsync: this, duration: animDuration);
    _animation3 = heightTween.animate(
      CurvedAnimation(
        parent: _controller3,
        curve: const Interval(0, 1.0, curve: Curves.easeInOut),
      ),
    );
    Future.delayed(
      Duration(milliseconds: 400),
      () => _controller3.repeat(reverse: true),
    );
  }

  @override
  void dispose() {
    // 释放所有控制器
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 使用 AnimatedBuilder 来构建动画 widget
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 使用 AnimatedBuilder 来构建每根柱子
        // AnimatedBuilder 是一个高效的 Widget，它只会在动画值变化时重建自身
        _buildBar(_animation1),
        const SizedBox(width: 2),
        _buildBar(_animation2),
        const SizedBox(width: 2),
        _buildBar(_animation3),
      ],
    );
  }

  Widget _buildBar(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: 2,
          // 动画值直接控制高度
          height: animation.value,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      },
    );
  }
}
