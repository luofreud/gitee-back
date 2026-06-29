// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Userinfo _$UserinfoFromJson(Map<String, dynamic> json) => Userinfo(
  id: (json['id'] as num?)?.toInt(),
  nickname: json['nickname'] as String?,
  phone: json['phone'] as String?,
  openid: json['openid'] as String?,
  sex: (json['sex'] as num?)?.toInt(),
  level: (json['level'] as num?)?.toInt(),
  roomid: (json['roomid'] as num?)?.toInt(),
  address: json['address'] as String?,
  headimg: json['headimg'] as String?,
  nowaddress: json['nowaddress'] as String?,
  xbmoney: (json['xbmoney'] as num?)?.toInt(),
  xzmoney: (json['xzmoney'] as num?)?.toInt(),
  lmtime: (json['lmtime'] as num?)?.toInt(),
  iscz: (json['iscz'] as num?)?.toInt(),
  sign: json['sign'] as String?,
  state: (json['state'] as num?)?.toInt(),
  tgcode: json['tgcode'] as String?,
  xzname: json['xzname'] as String?,
  xzimg: json['xzimg'] as String?,
  birthday: json['birthday'] as String?,
  createtime: json['createtime'] as String?,
  couponcount: (json['couponcount'] as num?)?.toInt(),
  utype: (json['utype'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserinfoToJson(Userinfo instance) => <String, dynamic>{
  'id': instance.id,
  'nickname': instance.nickname,
  'phone': instance.phone,
  'openid': instance.openid,
  'sex': instance.sex,
  'level': instance.level,
  'roomid': instance.roomid,
  'address': instance.address,
  'headimg': instance.headimg,
  'nowaddress': instance.nowaddress,
  'xbmoney': instance.xbmoney,
  'xzmoney': instance.xzmoney,
  'lmtime': instance.lmtime,
  'iscz': instance.iscz,
  'sign': instance.sign,
  'state': instance.state,
  'tgcode': instance.tgcode,
  'xzname': instance.xzname,
  'xzimg': instance.xzimg,
  'birthday': instance.birthday,
  'createtime': instance.createtime,
  'couponcount': instance.couponcount,
  'utype': instance.utype,
};
