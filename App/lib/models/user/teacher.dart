import 'package:json_annotation/json_annotation.dart';

part 'teacher.g.dart';

@JsonSerializable()
class Teacher {
  final int? uid;
  final String? name;
  final String? headimg;
  final int? level;
  final String? tgcode;
  final String? introduction;
  final double? score;
  final int? xzmoney;
  final int? year;
  final String? tags;
  final int? livestate;
  final int? state;
  final int? livenum; // 连麦次数
  final int? doubtnum; // 解惑次数
  final String? phone;
  final String? card;
  final int? sortcode;
  final int? istop;
  final String? checktime;
  final String? createtime;
  final int? liveprice;
  final double? oliveprice;
  final int? id;
  final int? isSubscribe; // 1关注 0未关注

  const Teacher({
    this.uid,
    this.name,
    this.headimg,
    this.level,
    this.tgcode,
    this.introduction,
    this.score,
    this.xzmoney,
    this.year,
    this.tags,
    this.livestate,
    this.state,
    this.livenum,
    this.doubtnum,
    this.phone,
    this.card,
    this.sortcode,
    this.istop,
    this.checktime,
    this.createtime,
    this.liveprice,
    this.oliveprice,
    this.id,
    this.isSubscribe,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherToJson(this);
}
