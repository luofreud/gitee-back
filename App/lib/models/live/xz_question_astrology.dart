import 'package:json_annotation/json_annotation.dart';

part 'xz_question_astrology.g.dart';

@JsonSerializable()
class XzQuestionAstrology {
  final int? qid;
  final int? ordertype;
  String? content;
  final int? id;

  XzQuestionAstrology({this.qid, this.ordertype, this.content, this.id});

  factory XzQuestionAstrology.fromJson(Map<String, dynamic> json) =>
      _$XzQuestionAstrologyFromJson(json);

  Map<String, dynamic> toJson() => _$XzQuestionAstrologyToJson(this);
}
