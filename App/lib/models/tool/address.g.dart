// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  id: (json['id'] as num?)?.toInt(),
  uid: (json['uid'] as num?)?.toInt(),
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  area: json['area'] as String?,
  address: json['address'] as String?,
  isdefault: (json['isdefault'] as num?)?.toInt(),
  createtime: json['createtime'] as String?,
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'id': instance.id,
  'uid': instance.uid,
  'name': instance.name,
  'phone': instance.phone,
  'area': instance.area,
  'address': instance.address,
  'isdefault': instance.isdefault,
  'createtime': instance.createtime,
};
