import 'package:flutter/material.dart';

///幻灯片组件
class CarouselWidget extends StatefulWidget {
  // 广告图片列表
  final List<Widget> children;

  // 自动滚动间隔时间(秒)
  final int autoScrollInterval;

  // 点击事件回调
  final Function(int index)? onTap;

  // 轮播图高度
  final double height;

  // 指示器颜色
  final Color indicatorColor;

  // 指示器选中颜色
  final Color indicatorSelectedColor;

  // 是否自动滚动
  final bool autoScroll;

  // 是否循环
  final bool loop;

  const CarouselWidget({
    super.key,
    required this.children,
    this.autoScrollInterval = 5,
    this.onTap,
    this.height = 200,
    this.indicatorColor = Colors.white,
    this.indicatorSelectedColor = Colors.green,
    this.autoScroll = true,
    this.loop = true,
  });

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  late PageController _pageController;

  //当前索引
  int _currentIndex = 1;

  // 实际展示的索引（处理无限滚动）
  int _realCurrentIndex = 0;
  late bool _isAutoScroll;

  late List<Widget> _childrenList;

  late bool _isLoop;

  @override
  void initState() {
    super.initState();
    _isAutoScroll = widget.autoScroll;

    if (widget.loop && widget.children.length > 1) {
      _isLoop = true;
      _childrenList = [
        widget.children.last,
        ...widget.children,
        widget.children.first,
      ];
      _pageController = PageController(initialPage: 1);
    } else {
      _isLoop = false;
      _childrenList = widget.children;
      _pageController = PageController(initialPage: 0);
    }

    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 更新当前索引
  void _updateCurrentIndex(int index) {
    _currentIndex = index;
    _realCurrentIndex = index - 1;
    if (_isLoop) {
      if (_currentIndex == _childrenList.length - 1) {
        _currentIndex = 1;
        _realCurrentIndex = 0;
        Future.delayed(Duration(milliseconds: 500), () {
          _pageController.jumpToPage(_currentIndex);
        });
      } else if (_currentIndex == 0) {
        _currentIndex = _childrenList.length - 2;
        _realCurrentIndex = widget.children.length - 1;
        Future.delayed(Duration(milliseconds: 500), () {
          _pageController.jumpToPage(_currentIndex);
        });
      }
    } else {}
    setState(() {});
  }

  // 启动自动滚动
  void _startAutoScroll() {
    if (widget.autoScroll && widget.children.length > 1) {
      Future.delayed(Duration(seconds: widget.autoScrollInterval), () {
        if (_isAutoScroll && mounted) {
          _nextPage();
          _startAutoScroll();
        }
      });
    }
  }

  void _nextPage() {
    if (_isLoop) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      if (_currentIndex < widget.children.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  // 切换到上一页
  void _prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(),
      child: Stack(
        children: [
          NotificationListener(
            onNotification: (notification) {
              return true;
            },
            child: PageView.builder(
              itemCount: _childrenList.length,
              controller: _pageController,
              physics: const ClampingScrollPhysics(),
              onPageChanged: (index) {
                _updateCurrentIndex(index);
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (widget.onTap != null) {
                      widget.onTap!(index);
                    }
                  },
                  child: _childrenList[index],
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.children.length, (index) {
                return Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _realCurrentIndex
                        ? widget.indicatorSelectedColor
                        : widget.indicatorColor,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
