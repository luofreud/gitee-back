import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freud/utils/theme_util.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// 图片视图组件
class ImageView extends StatefulWidget {
  final ImageProvider? image;
  final List<ImageProvider>? images;
  final Widget? placeholder; // 占位图
  final Widget? errorWidget; // 错误图标
  final double? width; // 宽度
  final double? height; // 高度

  final BoxFit? fit;
  final BorderRadius? borderRadius; // 圆角

  final bool? isPreview; //是否允许点击进行预览
  final bool? showOperate;
  final bool? showIndicator;
  final bool? showProgress;
  final String? heroTag;
  final List<String>? heroTags;
  final bool? cached; //是否开启图片缓存

  const ImageView({
    super.key,
    this.image,
    this.images,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.isPreview,
    this.showOperate,
    this.showIndicator,
    this.showProgress,
    this.heroTag,
    this.heroTags,
    this.cached,
  });

  @override
  State<ImageView> createState() => _ImageViewState();

  ImageView.network(
    String url, {
    super.key,
    List<String>? urls,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.isPreview,
    this.showOperate,
    this.showIndicator,
    this.showProgress,
    this.heroTag,
    this.heroTags,
    this.cached,
  }) : image = CachedNetworkImageProvider(url),
       images = urls?.map((e) => CachedNetworkImageProvider(e)).toList();

  ImageView.file(
    String path, {
    super.key,
    List<String>? paths,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.isPreview,
    this.showOperate,
    this.showIndicator,
    this.showProgress,
    this.heroTag,
    this.heroTags,
  }) : image = FileImage(File(path)),
       images = paths?.map((e) => FileImage(File(e))).toList(),
       cached = false;

  static ImageProvider<Object> provider(
    String url, {
    int? maxWidth,
    int? maxHeight,
    double scale = 1.0,
  }) {
    if (url == null || url.isEmpty) {
      return const AssetImage("assets/images/ic_launcher.png");
    }
    return CachedNetworkImageProvider(
      url,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      scale: scale,
    );
  }
}

class _ImageViewState extends State<ImageView> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildPlaceholder({double? progress}) {
    if (widget.placeholder != null) return widget.placeholder!;
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = min(widget.width ?? 80, 80);
        size = min(widget.height ?? 80, size);
        size = min(size, constraints.maxWidth);
        size = min(size, constraints.maxHeight);
        double circularSize = min(size * 0.5, 40);
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            color: Theme.of(context).colorScheme.surface,
          ),
          constraints: BoxConstraints(
            minHeight: size * 0.8,
            minWidth: size * 0.8,
          ),
          width: widget.width ?? double.infinity,
          height: widget.height,
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: circularSize,
                height: circularSize,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                ),
              ),
              progress != null && widget.showProgress == true
                  ? Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 12),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = min(widget.width ?? 80, 80);
        size = min(widget.height ?? 80, size);
        size = min(size, constraints.maxWidth);
        size = min(size, constraints.maxHeight);

        return widget.errorWidget ??
            Container(
              width: widget.width ?? double.infinity,
              height: widget.height,
              constraints: BoxConstraints(minHeight: size, minWidth: size),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: widget.borderRadius ?? BorderRadius.zero,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/image_error.png',
                      width: size,
                      fit: BoxFit.fitWidth,
                      height: size,
                    ),
                  ],
                ),
              ),
            );
      },
    );
  }

  Widget _buildImage(BuildContext context) {
    late ImageProvider image;
    if (widget.image != null) {
      image = widget.image!;
    } else {
      /// 显示默认图片
      image = const AssetImage("");
    }
    var imageWidget = Image(
      image: image,
      width: widget.width,
      height: widget.height,
      fit: widget.fit ?? BoxFit.cover,
      // 加载过程展示
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame == null) return _buildPlaceholder();
        return child;
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        int total = loadingProgress.expectedTotalBytes ?? 0;
        int current = loadingProgress.cumulativeBytesLoaded;
        double? progress;
        if (total > 0) {
          progress = current / total;
        }
        return _buildPlaceholder(progress: progress);
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget();
      },
    );
    String heroTag = widget.heroTag ?? '${widget.image.hashCode}';
    return GestureDetector(
      onTap: widget.isPreview == true
          ? () {
              ImagePreview.push(
                context,
                image,
                images: widget.images,
                heroTag: heroTag,
                heroTags: widget.heroTags,
                showIndicator: widget.showIndicator,
                showOperate: widget.showOperate,
              );
            }
          : null,
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: widget.isPreview == false
            ? imageWidget
            : Hero(tag: heroTag, child: imageWidget),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.image == null) {
      return Container();
    }
    return _buildImage(context);
  }
}

/// 图片预览
class ImagePreview extends StatefulWidget {
  final ImageProvider image;
  final List<ImageProvider>? images;
  final String? heroTag;
  final List<String>? heroTags;
  final bool? showOperate;
  final bool? showIndicator;

  const ImagePreview({
    super.key,
    required this.image,
    this.images,
    this.heroTag,
    this.heroTags,
    this.showOperate,
    this.showIndicator,
  });

  /// push预览页面到当前路由
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    ImageProvider image, {
    List<ImageProvider>? images,
    String? heroTag,
    List<String>? heroTags,
    bool? showOperate,
    bool? showIndicator,
  }) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ImagePreview(
          image: image,
          images: images,
          heroTag: heroTag,
          heroTags: heroTags,
          showIndicator: showIndicator,
          showOperate: showOperate,
        ),
        // 自定义动画（比如渐变 + 缩放）
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Animation<double> fadeAnimation;

          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
            child: child,
          );

          if (animation.status == AnimationStatus.forward) {
            // push 过程：使用 animation
            fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(animation);
          } else {
            print(animation.status);
            // pop 过程：使用 secondaryAnimation（反向：1→0）
            fadeAnimation = Tween<double>(
              begin: 1.0,
              end: 0.0,
            ).animate(secondaryAnimation);
          }
          return FadeTransition(opacity: fadeAnimation, child: child);
        },
        // transitionDuration: const Duration(milliseconds: 1000),
        // reverseTransitionDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late PageController _pageController;

  double rotateAngle = 0;

  int currentIndex = 0;
  int total = 1;
  List<ImageProvider> images = [];

  Future<void> _saveImage() async {}

  Widget _buildOperate() {
    if (widget.showOperate == false) {
      return Container();
    }
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // Expanded(
            //   child: GestureDetector(
            //     onTap: () {
            //       _saveImage();
            //     },
            //     child: Column(
            //       children: [
            //         Icon(Icons.get_app),
            //         Text('下载', style: TextStyle(fontSize: 12)),
            //       ],
            //     ),
            //   ),
            // ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    rotateAngle -= pi / 2;
                  });
                },
                child: Column(
                  children: [
                    Icon(Icons.rotate_90_degrees_ccw),
                    Text('旋转', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    rotateAngle += pi / 2;
                  });
                },
                child: Column(
                  children: [
                    Icon(Icons.rotate_90_degrees_cw_outlined),
                    Text('旋转', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 指示器
  _buildIndicator() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const SizedBox.shrink(),
      title: widget.showIndicator == true
          ? Text('${(currentIndex + 1)}/$total')
          : null,
    );
  }

  /// 图片加载组件
  Widget _buildImage(ImageProvider image) {
    return Transform.rotate(
      angle: rotateAngle,
      child: ImageView(image: image, fit: BoxFit.contain, isPreview: false),
    );
  }

  @override
  void initState() {
    super.initState();
    var index = 0;
    if (widget.images != null && widget.images!.isNotEmpty) {
      images = widget.images!;
      if (widget.heroTags != null && widget.heroTags!.isNotEmpty) {
        int _index = widget.heroTags!.indexWhere(
          (item) => item == widget.heroTag,
        );
        index = _index >= 0 ? _index : index;
      } else {
        int _index = widget.images!.indexWhere(
          (item) => item.hashCode == widget.image.hashCode,
        );
        index = _index >= 0 ? _index : index;
      }
    } else {
      images = [widget.image];
    }
    currentIndex = index;
    total = images.length;
    _pageController = PageController(initialPage: index);
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String heroTag = widget.heroTag ?? widget.image.hashCode.toString();
    if (widget.heroTags != null && widget.heroTags!.isNotEmpty) {
      heroTag = widget.heroTags![currentIndex];
    } else if (widget.images != null && widget.images!.isNotEmpty) {
      heroTag = images[currentIndex].hashCode.toString();
    }
    return Theme(
      data: ThemeUtil.darkThemeData(),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _buildIndicator(),
          backgroundColor: Colors.black,
          body: SizedBox(
            height: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Hero(
                    tag: heroTag,
                    flightShuttleBuilder:
                        (
                          BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext,
                        ) {
                          // 在动画过程中保持固定尺寸
                          return AnimatedBuilder(
                            animation: animation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: Tween<double>(
                                  begin: 1.0,
                                  end: 1.0, // 保持原始尺寸
                                ).evaluate(animation),
                                child: _buildImage(images[currentIndex]),
                              );
                            },
                          );
                        },
                    child: PhotoViewGallery.builder(
                      scrollPhysics: const BouncingScrollPhysics(),
                      pageController: _pageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      builder: (BuildContext context, int index) {
                        var image = images[index]!;
                        return PhotoViewGalleryPageOptions.customChild(
                          child: _buildImage(image),
                          initialScale: PhotoViewComputedScale.contained * 1,
                          minScale: PhotoViewComputedScale.contained * 0.8,
                          maxScale: PhotoViewComputedScale.covered * 3,
                        );
                      },
                    ),
                  ),
                ),
                _buildOperate(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
