// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'astrocalendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XzAstrocalendar _$XzAstrocalendarFromJson(Map<String, dynamic> json) =>
    XzAstrocalendar(
      id: (json['id'] as num?)?.toInt(),
      year: (json['year'] as num?)?.toInt(),
      month: (json['month'] as num?)?.toInt(),
      day: (json['day'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
      timestamp: (json['timestamp'] as num?)?.toInt(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      time: json['time'] as String?,
      date: json['date'] as String?,
      endDate: json['endDate'] as String?,
      titleShort: json['titleShort'] as String?,
      title: json['title'] as String?,
      planetCode1: json['planetCode1'] as String?,
      planetCode2: json['planetCode2'] as String?,
      allow: (json['allow'] as num?)?.toInt(),
      allowCha: (json['allowCha'] as num?)?.toDouble(),
      planetChinese1: json['planetChinese1'] as String?,
      planetEnglish1: json['planetEnglish1'] as String?,
      planetFont1: json['planetFont1'] as String?,
      planetChinese2: json['planetChinese2'] as String?,
      planetEnglish2: json['planetEnglish2'] as String?,
      planetFont2: json['planetFont2'] as String?,
      planetCode: json['planetCode'] as String?,
      sign: json['sign'] as String?,
      signChinese: json['signChinese'] as String?,
      signEnglish: json['signEnglish'] as String?,
      signFont: json['signFont'] as String?,
    );

Map<String, dynamic> _$XzAstrocalendarToJson(XzAstrocalendar instance) =>
    <String, dynamic>{
      'id': instance.id,
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'type': instance.type,
      'timestamp': instance.timestamp,
      'longitude': instance.longitude,
      'time': instance.time,
      'date': instance.date,
      'endDate': instance.endDate,
      'titleShort': instance.titleShort,
      'title': instance.title,
      'planetCode1': instance.planetCode1,
      'planetCode2': instance.planetCode2,
      'allow': instance.allow,
      'allowCha': instance.allowCha,
      'planetChinese1': instance.planetChinese1,
      'planetEnglish1': instance.planetEnglish1,
      'planetFont1': instance.planetFont1,
      'planetChinese2': instance.planetChinese2,
      'planetEnglish2': instance.planetEnglish2,
      'planetFont2': instance.planetFont2,
      'planetCode': instance.planetCode,
      'sign': instance.sign,
      'signChinese': instance.signChinese,
      'signEnglish': instance.signEnglish,
      'signFont': instance.signFont,
    };
