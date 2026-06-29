import 'package:freud/models/user/userinfo.dart';
import 'package:json_annotation/json_annotation.dart';

import '../live/live_room.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  final int? id;
  final int? plateid;
  final int? uid;
  final String? title;
  final String? content;
  final String? imgs;
  final String? videos;
  final String? tags;
  final int? atype;
  final int? isanonymous;
  int? likecount;
  final int? topicid;
  int? islike;
  int? commentcount;
  int? collectioncount;
  int? iscollection;
  final int? istop;
  final String? createtime;
  final int? state;
  final Userinfo? user;
  final LiveRoom? teachroom;

  Post({
    this.id,
    this.plateid,
    this.uid,
    this.title,
    this.content,
    this.imgs,
    this.videos,
    this.tags,
    this.atype,
    this.isanonymous,
    this.likecount,
    this.topicid,
    this.islike,
    this.commentcount,
    this.collectioncount,
    this.iscollection,
    this.istop,
    this.createtime,
    this.state,
    this.user,
    this.teachroom,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
