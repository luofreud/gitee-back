// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Teacher _$TeacherFromJson(Map<String, dynamic> json) => Teacher(
  uid: (json['uid'] as num?)?.toInt(),
  name: json['name'] as String?,
  headimg: json['headimg'] as String?,
  level: (json['level'] as num?)?.toInt(),
  tgcode: json['tgcode'] as String?,
  introduction: json['introduction'] as String?,
  score: (json['score'] as num?)?.toDouble(),
  xzmoney: (json['xzmoney'] as num?)?.toInt(),
  year: (json['year'] as num?)?.toInt(),
  tags: json['tags'] as String?,
  livestate: (json['livestate'] as num?)?.toInt(),
  state: (json['state'] as num?)?.toInt(),
  livenum: (json['livenum'] as num?)?.toInt(),
  doubtnum: (json['doubtnum'] as num?)?.toInt(),
  phone: json['phone'] as String?,
  card: json['card'] as String?,
  sortcode: (json['sortcode'] as num?)?.toInt(),
  istop: (json['istop'] as num?)?.toInt(),
  checktime: json['checktime'] as String?,
  createtime: json['createtime'] as String?,
  liveprice: (json['liveprice'] as num?)?.toInt(),
  oliveprice: (json['oliveprice'] as num?)?.toDouble(),
  id: (json['id'] as num?)?.toInt(),
  isSubscribe: (json['isSubscribe'] as num?)?.toInt(),
);

Map<String, dynamic> _$TeacherToJson(Teacher instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
  'headimg': instance.headimg,
  'level': instance.level,
  'tgcode': instance.tgcode,
  'introduction': instance.introduction,
  'score': instance.score,
  'xzmoney': instance.xzmoney,
  'year': instance.year,
  'tags': instance.tags,
  'livestate': instance.livestate,
  'state': instance.state,
  'livenum': instance.livenum,
  'doubtnum': instance.doubtnum,
  'phone': instance.phone,
  'card': instance.card,
  'sortcode': instance.sortcode,
  'istop': instance.istop,
  'checktime': instance.checktime,
  'createtime': instance.createtime,
  'liveprice': instance.liveprice,
  'oliveprice': instance.oliveprice,
  'id': instance.id,
  'isSubscribe': instance.isSubscribe,
};
