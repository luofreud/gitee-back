import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freud/api/api.dart';
import 'package:freud/utils/common_util.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'image_view.dart';

class AppSelectMedia extends StatefulWidget {
  final List<String>? urls;
  final int maxCount;
  final AppSelectMediaController? controller;
  final Widget? child;
  final Function(List<String>? urls)? onUploadSuccess;
  final Function(String? error)? onUploadError;
  final bool autoUpload;

  const AppSelectMedia({
    super.key,
    this.urls,
    this.maxCount = 9,
    this.controller,
    this.autoUpload = false,
    this.child,
    this.onUploadSuccess,
    this.onUploadError,
  });

  @override
  State<AppSelectMedia> createState() => _AppSelectMediaState();
}

class _AppSelectMediaState extends State<AppSelectMedia> {
  bool _autoUpload = false;

  /// 图片
  List<_SelectMediaItem> urlsOrFiles = [];

  List<String> get selectFileHerTags => urlsOrFiles
      .asMap()
      .entries
      .map((e) => '${e.value.hashCode}_${e.key}')
      .toList();

  @override
  void initState() {
    super.initState();
    _autoUpload = widget.autoUpload;
    urlsOrFiles =
        widget.urls?.map((item) => _SelectMediaItem(url: item)).toList() ?? [];
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (widget.controller?._isUploading == true) {
      //开始上传
      startUpload();
    }
  }

  startUpload() async {
    final selectAssets = urlsOrFiles.where((item) => item.entity != null);
    if (selectAssets.isNotEmpty) {
      for (var item in selectAssets) {
        final file = await item.entity?.file;
        if (file == null) continue;
        final filePath = file.path;
        String fileName = filePath.split('/').last; // 获取文件名
        item.isUploading = true;
        try {
          SystemApi()
              .upload(
                filePath,
                filename: fileName,
                onSendProgress: (count, total) {},
              )
              .then((uploadRes) {
                if (uploadRes != null) {
                  final fileUrl = uploadRes.url;
                  item.url = fileUrl;
                  item.entity = null;
                  //判断是否全部上传完成
                  if (selectAssets.every((item) => item.url != null)) {
                    uploadSuccessCallback();
                  }
                } else {
                  widget.onUploadError?.call(null);
                }
                item.isUploading = false;
                setState(() {});
              });
          setState(() {});
        } catch (e) {
          widget.onUploadError?.call(e.toString());
          item.isUploading = false;
          setState(() {});
        }
      }
    } else {
      uploadSuccessCallback();
    }
  }

  uploadSuccessCallback() {
    widget.onUploadSuccess?.call(
      urlsOrFiles.map<String>((item) => item.url!).toList(),
    );
  }

  _buildAddImage(context) {
    return GestureDetector(
      onTap: () async {
        CommonUtil.hideKeyShowUnfocus();
        var result = await CommonUtil.selectImage(
          context,
          maxCount: widget.maxCount - urlsOrFiles.length,
          requestType: RequestType.image,
        );
        if (result != null && result.isNotEmpty) {
          for (var i = 0; i < result.length; i++) {
            var path = (await result[i].file)!.path;
            urlsOrFiles.add(
              _SelectMediaItem(filePath: path, entity: result[i]),
            );
            setState(() {});
          }
          if (_autoUpload) {
            startUpload();
          }
        }
      },
      child:
          widget.child ??
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffF5F7F9),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 32,
                  color: Color(0xffcccccc),
                ),
              ],
            ),
          ),
    );
  }

  _buildImageItem(int index, List<ImageProvider<Object>> images) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageView(
          image: images[index],
          images: images,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          heroTag: selectFileHerTags[index],
          heroTags: selectFileHerTags,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              urlsOrFiles.removeAt(index);
              if (_autoUpload) {
                uploadSuccessCallback();
              }
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Color(0xff262626).withAlpha(100),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Icon(Icons.close, size: 18, color: Colors.white),
            ),
          ),
        ),
        if (urlsOrFiles[index].isUploading)
          Positioned(
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var count = urlsOrFiles.length;
    List<ImageProvider<Object>> images = urlsOrFiles.map<ImageProvider<Object>>(
      (item) {
        if (item.url != null && item.url!.isNotEmpty) {
          return CachedNetworkImageProvider(item.url!);
        } else {
          return FileImage(File(item.filePath!));
        }
      },
    ).toList();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count == widget.maxCount ? widget.maxCount : (count + 1),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (_, index) {
        Widget child;
        if (index <= count - 1) {
          child = _buildImageItem(index, images);
        } else {
          child = _buildAddImage(context);
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Container(alignment: Alignment.center, child: child),
        );
      },
    );
  }
}

class AppSelectMediaController extends ChangeNotifier {
  AppSelectMediaController();

  bool _isUploading = false;

  void upload() {
    _isUploading = true;
    notifyListeners();
  }
}

class _SelectMediaItem {
  String? url;
  String? filePath;
  AssetEntity? entity;
  bool isUploading = false;

  _SelectMediaItem({this.url, this.filePath, this.entity});
}
