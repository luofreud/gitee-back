// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadResponse _$UploadResponseFromJson(Map<String, dynamic> json) =>
    UploadResponse(
      provider: json['provider'] as String?,
      bucketName: json['bucketName'] as String?,
      fileName: json['fileName'] as String?,
      suffix: json['suffix'] as String?,
      filePath: json['filePath'] as String?,
      sizeKb: (json['sizeKb'] as num?)?.toInt(),
      sizeInfo: json['sizeInfo'],
      url: json['url'] as String?,
      fileMd5: json['fileMd5'] as String?,
      fileType: json['fileType'],
      fileAlias: json['fileAlias'],
      isPublic: json['isPublic'] as bool?,
      dataId: json['dataId'],
      tenantId: json['tenantId'],
      orgId: (json['orgId'] as num?)?.toInt(),
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'],
      createUserId: (json['createUserId'] as num?)?.toInt(),
      createUserName: json['createUserName'],
      updateUserId: json['updateUserId'],
      updateUserName: json['updateUserName'],
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UploadResponseToJson(UploadResponse instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'bucketName': instance.bucketName,
      'fileName': instance.fileName,
      'suffix': instance.suffix,
      'filePath': instance.filePath,
      'sizeKb': instance.sizeKb,
      'sizeInfo': instance.sizeInfo,
      'url': instance.url,
      'fileMd5': instance.fileMd5,
      'fileType': instance.fileType,
      'fileAlias': instance.fileAlias,
      'isPublic': instance.isPublic,
      'dataId': instance.dataId,
      'tenantId': instance.tenantId,
      'orgId': instance.orgId,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'createUserId': instance.createUserId,
      'createUserName': instance.createUserName,
      'updateUserId': instance.updateUserId,
      'updateUserName': instance.updateUserName,
      'id': instance.id,
    };
