import 'package:json_annotation/json_annotation.dart';

part 'im_message.g.dart';

@JsonSerializable()
class ImMessage {
  final int? id;
  final String? msgId;
  final String? fromUid;
  final String? toUid;
  final String? type;
  final String? content;
  final int? typeu;
  final int? status;
  final String? createdAt;

  ImMessage({
    this.id,
    this.msgId,
    this.fromUid,
    this.toUid,
    this.type,
    this.content,
    this.typeu,
    this.status,
    this.createdAt,
  });

  factory ImMessage.fromJson(Map<String, dynamic> json) =>
      _$ImMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ImMessageToJson(this);
}
