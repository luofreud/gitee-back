import 'package:freud/models/user/userinfo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final int? id;
  final int? uid;
  final int? aid;
  final String? content;
  final int? likecount;
  final int? islike;
  final int? parentid;
  final int? replycount;
  final int? state;
  final String? createtime;
  final Userinfo? xzuser;
  final List<Comment>? replay;

  Comment({
    this.id,
    this.uid,
    this.aid,
    this.content,
    this.likecount,
    this.islike,
    this.parentid,
    this.replycount,
    this.state,
    this.createtime,
    this.xzuser,
    this.replay,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
