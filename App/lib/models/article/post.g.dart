// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
  id: (json['id'] as num?)?.toInt(),
  plateid: (json['plateid'] as num?)?.toInt(),
  uid: (json['uid'] as num?)?.toInt(),
  title: json['title'] as String?,
  content: json['content'] as String?,
  imgs: json['imgs'] as String?,
  videos: json['videos'] as String?,
  tags: json['tags'] as String?,
  atype: (json['atype'] as num?)?.toInt(),
  isanonymous: (json['isanonymous'] as num?)?.toInt(),
  likecount: (json['likecount'] as num?)?.toInt(),
  topicid: (json['topicid'] as num?)?.toInt(),
  islike: (json['islike'] as num?)?.toInt(),
  commentcount: (json['commentcount'] as num?)?.toInt(),
  collectioncount: (json['collectioncount'] as num?)?.toInt(),
  iscollection: (json['iscollection'] as num?)?.toInt(),
  istop: (json['istop'] as num?)?.toInt(),
  createtime: json['createtime'] as String?,
  state: (json['state'] as num?)?.toInt(),
  user: json['user'] == null
      ? null
      : Userinfo.fromJson(json['user'] as Map<String, dynamic>),
  teachroom: json['teachroom'] == null
      ? null
      : LiveRoom.fromJson(json['teachroom'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
  'id': instance.id,
  'plateid': instance.plateid,
  'uid': instance.uid,
  'title': instance.title,
  'content': instance.content,
  'imgs': instance.imgs,
  'videos': instance.videos,
  'tags': instance.tags,
  'atype': instance.atype,
  'isanonymous': instance.isanonymous,
  'likecount': instance.likecount,
  'topicid': instance.topicid,
  'islike': instance.islike,
  'commentcount': instance.commentcount,
  'collectioncount': instance.collectioncount,
  'iscollection': instance.iscollection,
  'istop': instance.istop,
  'createtime': instance.createtime,
  'state': instance.state,
  'user': instance.user,
  'teachroom': instance.teachroom,
};
