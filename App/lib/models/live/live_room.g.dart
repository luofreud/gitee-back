// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveRoom _$LiveRoomFromJson(Map<String, dynamic> json) => LiveRoom(
  id: (json['id'] as num?)?.toInt(),
  tid: (json['tid'] as num?)?.toInt(),
  roomid: (json['roomid'] as num?)?.toInt(),
  uroomid: (json['uroomid'] as num?)?.toInt(),
  img: json['img'] as String?,
  bgimg: json['bgimg'] as String?,
  istop: (json['istop'] as num?)?.toInt(),
  ishot: (json['ishot'] as num?)?.toInt(),
  rtype: (json['rtype'] as num?)?.toInt(),
  level: (json['level'] as num?)?.toInt(),
  major: json['major'] as String?,
  lookrum: (json['lookrum'] as num?)?.toInt(),
  likerum: (json['likerum'] as num?)?.toInt(),
  title: json['title'] as String?,
  rnum: (json['rnum'] as num?)?.toInt(),
  state: (json['state'] as num?)?.toInt(),
  createtime: json['createtime'] as String?,
  tags: json['tags'] as String?,
  content: json['content'] as String?,
  overtime: json['overtime'] as String?,
  livetime: (json['livetime'] as num?)?.toInt(),
  teacher: json['teacher'] == null
      ? null
      : Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LiveRoomToJson(LiveRoom instance) => <String, dynamic>{
  'id': instance.id,
  'tid': instance.tid,
  'roomid': instance.roomid,
  'uroomid': instance.uroomid,
  'img': instance.img,
  'bgimg': instance.bgimg,
  'istop': instance.istop,
  'ishot': instance.ishot,
  'rtype': instance.rtype,
  'level': instance.level,
  'major': instance.major,
  'lookrum': instance.lookrum,
  'likerum': instance.likerum,
  'title': instance.title,
  'rnum': instance.rnum,
  'state': instance.state,
  'createtime': instance.createtime,
  'tags': instance.tags,
  'content': instance.content,
  'overtime': instance.overtime,
  'livetime': instance.livetime,
  'teacher': instance.teacher,
};
