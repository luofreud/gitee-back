import 'package:freud/models/article/article_plate.dart';
import 'package:freud/models/article/post.dart';
import 'package:freud/models/user/teacher.dart';
import 'package:freud/models/user/userinfo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscribe.g.dart';

@JsonSerializable()
class Subscribe {
  final int? id;
  final int? uid;
  final int? corrid;
  final int? stype;
  final String? createtime;
  final Userinfo? gzuser;
  final Teacher? gzteacher;
  final ArticlePlate? gztopic;
  final Post? xzArticle;

  const Subscribe({
    this.id,
    this.uid,
    this.corrid,
    this.stype,
    this.createtime,
    this.gzuser,
    this.gzteacher,
    this.gztopic,
    this.xzArticle,
  });

  factory Subscribe.fromJson(Map<String, dynamic> json) =>
      _$SubscribeFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeToJson(this);
}
