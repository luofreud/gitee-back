// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xz_question_astrology.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XzQuestionAstrology _$XzQuestionAstrologyFromJson(Map<String, dynamic> json) =>
    XzQuestionAstrology(
      qid: (json['qid'] as num?)?.toInt(),
      ordertype: (json['ordertype'] as num?)?.toInt(),
      content: json['content'] as String?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$XzQuestionAstrologyToJson(
  XzQuestionAstrology instance,
) => <String, dynamic>{
  'qid': instance.qid,
  'ordertype': instance.ordertype,
  'content': instance.content,
  'id': instance.id,
};
