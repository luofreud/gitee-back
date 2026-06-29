import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  int? id;
  int? uid;
  String? name;
  String? phone;
  String? area;
  String? address;
  int? isdefault;
  String? createtime;

  Address({
    this.id,
    this.uid,
    this.name,
    this.phone,
    this.area,
    this.address,
    this.isdefault,
    this.createtime,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
