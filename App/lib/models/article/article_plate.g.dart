// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_plate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticlePlate _$ArticlePlateFromJson(Map<String, dynamic> json) => ArticlePlate(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  content: json['content'] as String?,
  image: json['image'] as String?,
  ishot: (json['ishot'] as num?)?.toInt(),
  isnew: (json['isnew'] as num?)?.toInt(),
  count: (json['count'] as num?)?.toInt(),
  istop: (json['istop'] as num?)?.toInt(),
  ltype: (json['ltype'] as num?)?.toInt(),
  createtime: json['createtime'] as String?,
);

Map<String, dynamic> _$ArticlePlateToJson(ArticlePlate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'image': instance.image,
      'ishot': instance.ishot,
      'isnew': instance.isnew,
      'count': instance.count,
      'istop': instance.istop,
      'ltype': instance.ltype,
      'createtime': instance.createtime,
    };
