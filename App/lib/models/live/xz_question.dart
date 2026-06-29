import 'package:json_annotation/json_annotation.dart';

import 'xz_question_astrology.dart';

part 'xz_question.g.dart';

/// 用户问答
@JsonSerializable()
class XzQuestion {
  /// 主键Id（雪花Id）
  final int? id;

  /// 用户id
  final int? uid;

  /// 导师id
  final int? tid;

  /// 用户档案1
  final int? aid1;

  /// 用户档案2
  final int? aid2;

  /// 名称
  final String? name;

  /// 解读内容
  final String? content;

  /// 0:骰子,1:星盘,2:智慧牌,3:合盘
  final int? ordertype;

  /// 0：待完成，1：已完成，2：投诉
  final int? orderstate;

  /// 完成时间
  final String? ftime;

  /// 星钻
  final double? money;

  /// 创建时间
  final String? createtime;

  /// 图片
  final String? img;

  /// 订单编号
  final String? orderno;

  /// 开始时间
  final String? stime;

  /// 结束时间
  final String? etime;

  /// 付费时间
  final int? paytime;

  /// 免费时间
  final int? freetime;

  /// 单价
  final double? price;

  /// 占星结果
  XzQuestionAstrology? astrology;

  XzQuestion({
    this.id,
    this.uid,
    this.tid,
    this.aid1,
    this.aid2,
    this.name,
    this.content,
    this.ordertype,
    this.orderstate,
    this.ftime,
    this.money,
    this.createtime,
    this.img,
    this.orderno,
    this.stime,
    this.etime,
    this.paytime,
    this.freetime,
    this.price,
    this.astrology,
  });

  factory XzQuestion.fromJson(Map<String, dynamic> json) =>
      _$XzQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$XzQuestionToJson(this);
}
