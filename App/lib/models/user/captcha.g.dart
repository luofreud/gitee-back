// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captcha.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Captcha _$CaptchaFromJson(Map<String, dynamic> json) =>
    Captcha(id: (json['id'] as num?)?.toInt(), img: json['img'] as String?);

Map<String, dynamic> _$CaptchaToJson(Captcha instance) => <String, dynamic>{
  'id': instance.id,
  'img': instance.img,
};
