import 'package:json_annotation/json_annotation.dart';

part 'astrocalendar.g.dart';

@JsonSerializable()
class XzAstrocalendar {
  int? id;
  int? year;
  int? month;
  int? day;
  int? type;
  int? timestamp;
  double? longitude;
  String? time;
  String? date;
  String? endDate;
  String? titleShort;
  String? title;
  String? planetCode1;
  String? planetCode2;
  int? allow;
  double? allowCha;
  String? planetChinese1;
  String? planetEnglish1;
  String? planetFont1;
  String? planetChinese2;
  String? planetEnglish2;
  String? planetFont2;
  String? planetCode;
  String? sign;
  String? signChinese;
  String? signEnglish;
  String? signFont;

  XzAstrocalendar({
    this.id,
    this.year,
    this.month,
    this.day,
    this.type,
    this.timestamp,
    this.longitude,
    this.time,
    this.date,
    this.endDate,
    this.titleShort,
    this.title,
    this.planetCode1,
    this.planetCode2,
    this.allow,
    this.allowCha,
    this.planetChinese1,
    this.planetEnglish1,
    this.planetFont1,
    this.planetChinese2,
    this.planetEnglish2,
    this.planetFont2,
    this.planetCode,
    this.sign,
    this.signChinese,
    this.signEnglish,
    this.signFont,
  });

  factory XzAstrocalendar.fromJson(Map<String, dynamic> json) =>
      _$XzAstrocalendarFromJson(json);

  Map<String, dynamic> toJson() => _$XzAstrocalendarToJson(this);
}
