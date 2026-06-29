// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscribe _$SubscribeFromJson(Map<String, dynamic> json) => Subscribe(
  id: (json['id'] as num?)?.toInt(),
  uid: (json['uid'] as num?)?.toInt(),
  corrid: (json['corrid'] as num?)?.toInt(),
  stype: (json['stype'] as num?)?.toInt(),
  createtime: json['createtime'] as String?,
  gzuser: json['gzuser'] == null
      ? null
      : Userinfo.fromJson(json['gzuser'] as Map<String, dynamic>),
  gzteacher: json['gzteacher'] == null
      ? null
      : Teacher.fromJson(json['gzteacher'] as Map<String, dynamic>),
  gztopic: json['gztopic'] == null
      ? null
      : ArticlePlate.fromJson(json['gztopic'] as Map<String, dynamic>),
  xzArticle: json['xzArticle'] == null
      ? null
      : Post.fromJson(json['xzArticle'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SubscribeToJson(Subscribe instance) => <String, dynamic>{
  'id': instance.id,
  'uid': instance.uid,
  'corrid': instance.corrid,
  'stype': instance.stype,
  'createtime': instance.createtime,
  'gzuser': instance.gzuser,
  'gzteacher': instance.gzteacher,
  'gztopic': instance.gztopic,
  'xzArticle': instance.xzArticle,
};
