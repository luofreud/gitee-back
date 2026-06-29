import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageCrop {
  static Future<String> cropImage(String imagePath) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: '',
          resetButtonHidden: true,
          aspectRatioLockEnabled: true,
          rotateClockwiseButtonHidden: true,
          rotateButtonsHidden: true,
          cancelButtonTitle: '取消',
          doneButtonTitle: '完成',
        ),
      ],
    );
    return croppedFile?.path ?? '';
  }
}
