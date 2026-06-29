import 'package:json_annotation/json_annotation.dart';

part 'archive.g.dart';

@JsonSerializable()
class Archive {
  int? id;
  int? uid;
  String? name;
  String? relation;
  int? sex;
  String? birthday;
  String? address;
  String? nowaddress;
  String? createtime;
  String? addresslat;
  String? addresslong;
  String? nowaddresslat;
  String? nowaddresslong;
  int? isdst;
  String? timezone;

  Archive({
    this.id,
    this.uid,
    this.name,
    this.relation,
    this.sex,
    this.birthday,
    this.address,
    this.nowaddress,
    this.createtime,
    this.addresslat,
    this.addresslong,
    this.nowaddresslat,
    this.nowaddresslong,
    this.isdst,
    this.timezone,
  });

  factory Archive.fromJson(Map<String, dynamic> json) =>
      _$ArchiveFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveToJson(this);
}
