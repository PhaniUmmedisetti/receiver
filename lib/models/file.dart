import 'package:json_annotation/json_annotation.dart';

part 'file.g.dart';

@JsonSerializable()
class UploadedFile {
  final String name;
  final String url;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final String? latitude;
  final String? longitude;

  UploadedFile({
    required this.name,
    required this.url,
    required this.createdAt,
    this.latitude,
    this.longitude,
  });

  factory UploadedFile.fromJson(Map<String, dynamic> json) =>
      _$UploadedFileFromJson(json);

  Map<String, dynamic> toJson() => _$UploadedFileToJson(this);
}