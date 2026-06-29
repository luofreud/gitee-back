import 'package:json_annotation/json_annotation.dart';

part 'article_plate.g.dart';

/// 板块
@JsonSerializable()
class ArticlePlate {
  /// 主键Id
  final int? id;

  final String? title;

  /// 内容（板块名称）
  final String? content;

  final String? image;

  /// 热度
  final int? ishot;

  /// 新
  final int? isnew;

  /// 关联数量
  final int? count;

  /// 0：不置顶，1：置顶
  final int? istop;

  final int? ltype;

  /// 创建时间
  final String? createtime;

  const ArticlePlate({
    this.id,
    this.title,
    this.content,
    this.image,
    this.ishot,
    this.isnew,
    this.count,
    this.istop,
    this.ltype,
    this.createtime,
  });

  factory ArticlePlate.fromJson(Map<String, dynamic> json) =>
      _$ArticlePlateFromJson(json);

  Map<String, dynamic> toJson() => _$ArticlePlateToJson(this);
}
