// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
  id: (json['id'] as num?)?.toInt(),
  uid: (json['uid'] as num?)?.toInt(),
  aid: (json['aid'] as num?)?.toInt(),
  content: json['content'] as String?,
  likecount: (json['likecount'] as num?)?.toInt(),
  islike: (json['islike'] as num?)?.toInt(),
  parentid: (json['parentid'] as num?)?.toInt(),
  replycount: (json['replycount'] as num?)?.toInt(),
  state: (json['state'] as num?)?.toInt(),
  createtime: json['createtime'] as String?,
  xzuser: json['xzuser'] == null
      ? null
      : Userinfo.fromJson(json['xzuser'] as Map<String, dynamic>),
  replay: (json['replay'] as List<dynamic>?)
      ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
  'id': instance.id,
  'uid': instance.uid,
  'aid': instance.aid,
  'content': instance.content,
  'likecount': instance.likecount,
  'islike': instance.islike,
  'parentid': instance.parentid,
  'replycount': instance.replycount,
  'state': instance.state,
  'createtime': instance.createtime,
  'xzuser': instance.xzuser,
  'replay': instance.replay,
};
