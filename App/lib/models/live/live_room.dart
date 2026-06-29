import 'package:freud/models/user/teacher.dart';
import 'package:json_annotation/json_annotation.dart';

part 'live_room.g.dart';

@JsonSerializable()
class LiveRoom {
  final int? id;
  final int? tid;
  final int? roomid;
  final int? uroomid;
  final String? img;
  final String? bgimg;
  final int? istop;
  final int? ishot;
  final int? rtype;
  final int? level;
  final String? major;
  final int? lookrum;
  final int? likerum;
  final String? title;
  final int? rnum;
  final int? state;
  final String? createtime;
  final String? tags;
  final String? content;
  final String? overtime;
  final int? livetime;
  final Teacher? teacher;

  const LiveRoom({
    this.id,
    this.tid,
    this.roomid,
    this.uroomid,
    this.img,
    this.bgimg,
    this.istop,
    this.ishot,
    this.rtype,
    this.level,
    this.major,
    this.lookrum,
    this.likerum,
    this.title,
    this.rnum,
    this.state,
    this.createtime,
    this.tags,
    this.content,
    this.overtime,
    this.livetime,
    this.teacher,
  });

  factory LiveRoom.fromJson(Map<String, dynamic> json) =>
      _$LiveRoomFromJson(json);

  Map<String, dynamic> toJson() => _$LiveRoomToJson(this);
}
