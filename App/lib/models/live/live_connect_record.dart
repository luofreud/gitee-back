import 'package:json_annotation/json_annotation.dart';
import 'package:freud/models/user/teacher.dart';
import 'package:freud/models/user/userinfo.dart';

part 'live_connect_record.g.dart';

@JsonSerializable()
class LiveConnectRecord {
  final int? id;
  final int? uid;
  final int? tid;
  final int? itype;
  final int? roomid;
  final double? xzmoney;
  final String? orderno;
  final int? isdel;
  final int? price;
  final int? state;
  final int? imtime;
  final String? starttime;
  final String? overtime;
  final int? paytime;
  final int? freetime;
  final String? createtime;
  final double? userxzmoney;
  final Userinfo? user;
  final Teacher? teacher;
  final String? appid;
  final String? roomtoken;

  const LiveConnectRecord({
    this.id,
    this.uid,
    this.tid,
    this.itype,
    this.roomid,
    this.xzmoney,
    this.orderno,
    this.isdel,
    this.price,
    this.state,
    this.imtime,
    this.starttime,
    this.overtime,
    this.paytime,
    this.freetime,
    this.createtime,
    this.userxzmoney,
    this.user,
    this.teacher,
    this.appid,
    this.roomtoken,
  });

  factory LiveConnectRecord.fromJson(Map<String, dynamic> json) =>
      _$LiveConnectRecordFromJson(json);

  Map<String, dynamic> toJson() => _$LiveConnectRecordToJson(this);
}
