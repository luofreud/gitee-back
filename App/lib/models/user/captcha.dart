import 'package:json_annotation/json_annotation.dart';

part 'captcha.g.dart';

@JsonSerializable()
class Captcha {
  final int? id;
  final String? img;

  const Captcha({
    this.id,
    this.img,
  });

  factory Captcha.fromJson(Map<String, dynamic> json) =>
      _$CaptchaFromJson(json);

  Map<String, dynamic> toJson() => _$CaptchaToJson(this);
}
