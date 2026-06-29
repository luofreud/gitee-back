// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xz_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XzQuestion _$XzQuestionFromJson(Map<String, dynamic> json) => XzQuestion(
  id: (json['id'] as num?)?.toInt(),
  uid: (json['uid'] as num?)?.toInt(),
  tid: (json['tid'] as num?)?.toInt(),
  aid1: (json['aid1'] as num?)?.toInt(),
  aid2: (json['aid2'] as num?)?.toInt(),
  name: json['name'] as String?,
  content: json['content'] as String?,
  ordertype: (json['ordertype'] as num?)?.toInt(),
  orderstate: (json['orderstate'] as num?)?.toInt(),
  ftime: json['ftime'] as String?,
  money: (json['money'] as num?)?.toDouble(),
  createtime: json['createtime'] as String?,
  img: json['img'] as String?,
  orderno: json['orderno'] as String?,
  stime: json['stime'] as String?,
  etime: json['etime'] as String?,
  paytime: (json['paytime'] as num?)?.toInt(),
  freetime: (json['freetime'] as num?)?.toInt(),
  price: (json['price'] as num?)?.toDouble(),
  astrology: json['astrology'] == null
      ? null
      : XzQuestionAstrology.fromJson(json['astrology'] as Map<String, dynamic>),
);

Map<String, dynamic> _$XzQuestionToJson(XzQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'tid': instance.tid,
      'aid1': instance.aid1,
      'aid2': instance.aid2,
      'name': instance.name,
      'content': instance.content,
      'ordertype': instance.ordertype,
      'orderstate': instance.orderstate,
      'ftime': instance.ftime,
      'money': instance.money,
      'createtime': instance.createtime,
      'img': instance.img,
      'orderno': instance.orderno,
      'stime': instance.stime,
      'etime': instance.etime,
      'paytime': instance.paytime,
      'freetime': instance.freetime,
      'price': instance.price,
      'astrology': instance.astrology,
    };
