// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Archive _$ArchiveFromJson(Map<String, dynamic> json) => Archive(
  id: (json['id'] as num?)?.toInt(),
  uid: (json['uid'] as num?)?.toInt(),
  name: json['name'] as String?,
  relation: json['relation'] as String?,
  sex: (json['sex'] as num?)?.toInt(),
  birthday: json['birthday'] as String?,
  address: json['address'] as String?,
  nowaddress: json['nowaddress'] as String?,
  createtime: json['createtime'] as String?,
  addresslat: json['addresslat'] as String?,
  addresslong: json['addresslong'] as String?,
  nowaddresslat: json['nowaddresslat'] as String?,
  nowaddresslong: json['nowaddresslong'] as String?,
  isdst: (json['isdst'] as num?)?.toInt(),
  timezone: json['timezone'] as String?,
);

Map<String, dynamic> _$ArchiveToJson(Archive instance) => <String, dynamic>{
  'id': instance.id,
  'uid': instance.uid,
  'name': instance.name,
  'relation': instance.relation,
  'sex': instance.sex,
  'birthday': instance.birthday,
  'address': instance.address,
  'nowaddress': instance.nowaddress,
  'createtime': instance.createtime,
  'addresslat': instance.addresslat,
  'addresslong': instance.addresslong,
  'nowaddresslat': instance.nowaddresslat,
  'nowaddresslong': instance.nowaddresslong,
  'isdst': instance.isdst,
  'timezone': instance.timezone,
};
