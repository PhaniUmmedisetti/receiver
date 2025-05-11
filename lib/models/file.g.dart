// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadedFile _$UploadedFileFromJson(Map<String, dynamic> json) => UploadedFile(
      name: json['name'] as String,
      url: json['url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      latitude: (json['lat'] as num?)?.toDouble(),
      longitude: (json['long'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UploadedFileToJson(UploadedFile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'created_at': instance.createdAt.toIso8601String(),
      'lat': instance.latitude,
      'long': instance.longitude,
    };
