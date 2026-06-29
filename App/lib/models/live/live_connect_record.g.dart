// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_connect_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveConnectRecord _$LiveConnectRecordFromJson(Map<String, dynamic> json) =>
    LiveConnectRecord(
      id: (json['id'] as num?)?.toInt(),
      uid: (json['uid'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      itype: (json['itype'] as num?)?.toInt(),
      roomid: (json['roomid'] as num?)?.toInt(),
      xzmoney: (json['xzmoney'] as num?)?.toDouble(),
      orderno: json['orderno'] as String?,
      isdel: (json['isdel'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      state: (json['state'] as num?)?.toInt(),
      imtime: (json['imtime'] as num?)?.toInt(),
      starttime: json['starttime'] as String?,
      overtime: json['overtime'] as String?,
      paytime: (json['paytime'] as num?)?.toInt(),
      freetime: (json['freetime'] as num?)?.toInt(),
      createtime: json['createtime'] as String?,
      userxzmoney: (json['userxzmoney'] as num?)?.toDouble(),
      user: json['user'] == null
          ? null
          : Userinfo.fromJson(json['user'] as Map<String, dynamic>),
      teacher: json['teacher'] == null
          ? null
          : Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
      appid: json['appid'] as String?,
      roomtoken: json['roomtoken'] as String?,
    );

Map<String, dynamic> _$LiveConnectRecordToJson(LiveConnectRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'tid': instance.tid,
      'itype': instance.itype,
      'roomid': instance.roomid,
      'xzmoney': instance.xzmoney,
      'orderno': instance.orderno,
      'isdel': instance.isdel,
      'price': instance.price,
      'state': instance.state,
      'imtime': instance.imtime,
      'starttime': instance.starttime,
      'overtime': instance.overtime,
      'paytime': instance.paytime,
      'freetime': instance.freetime,
      'createtime': instance.createtime,
      'userxzmoney': instance.userxzmoney,
      'user': instance.user,
      'teacher': instance.teacher,
      'appid': instance.appid,
      'roomtoken': instance.roomtoken,
    };
