import 'package:json_annotation/json_annotation.dart';

part 'upload_response.g.dart';

@JsonSerializable()
class UploadResponse {
  final String? provider;
  final String? bucketName;
  final String? fileName;
  final String? suffix;
  final String? filePath;
  final int? sizeKb;
  final dynamic sizeInfo;
  final String? url;
  final String? fileMd5;
  final dynamic fileType;
  final dynamic fileAlias;
  final bool? isPublic;
  final dynamic dataId;
  final dynamic tenantId;
  final int? orgId;
  final String? createTime;
  final dynamic updateTime;
  final int? createUserId;
  final dynamic createUserName;
  final dynamic updateUserId;
  final dynamic updateUserName;
  final int? id;

  const UploadResponse({
    this.provider,
    this.bucketName,
    this.fileName,
    this.suffix,
    this.filePath,
    this.sizeKb,
    this.sizeInfo,
    this.url,
    this.fileMd5,
    this.fileType,
    this.fileAlias,
    this.isPublic,
    this.dataId,
    this.tenantId,
    this.orgId,
    this.createTime,
    this.updateTime,
    this.createUserId,
    this.createUserName,
    this.updateUserId,
    this.updateUserName,
    this.id,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadResponseToJson(this);
}
