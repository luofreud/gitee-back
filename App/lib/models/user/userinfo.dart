import 'package:json_annotation/json_annotation.dart';

part 'userinfo.g.dart';

@JsonSerializable()
class Userinfo {
  final int? id;
  final String? nickname;
  final String? phone;
  final String? openid;
  final int? sex;
  final int? level;
  final int? roomid;
  final String? address;
  final String? headimg;
  final String? nowaddress;
  final int? xbmoney;
  final int? xzmoney;
  final int? lmtime;
  final int? iscz;
  final String? sign;
  final int? state;
  final String? tgcode;
  final String? xzname;
  final String? xzimg;
  final String? birthday;
  final String? createtime;
  final int? couponcount;
  final int? utype;

  const Userinfo({
    this.id,
    this.nickname,
    this.phone,
    this.openid,
    this.sex,
    this.level,
    this.roomid,
    this.address,
    this.headimg,
    this.nowaddress,
    this.xbmoney,
    this.xzmoney,
    this.lmtime,
    this.iscz,
    this.sign,
    this.state,
    this.tgcode,
    this.xzname,
    this.xzimg,
    this.birthday,
    this.createtime,
    this.couponcount,
    this.utype,
  });

  factory Userinfo.fromJson(Map<String, dynamic> json) =>
      _$UserinfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserinfoToJson(this);
}
