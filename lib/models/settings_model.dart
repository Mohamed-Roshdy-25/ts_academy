import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  String? id;
  String? tts_interval;
  String? tts_speedd;
  String? watermark_opacity;
  String? max_screenshot_count;
  String? maxl_login_count;
  String? ios_version;
  String? android_version;
  String? force_update_android;
  String? force_update_ios;
  String? force_update_message;
  SettingsModel({
    required this.id,
    required this.android_version,
    required this.force_update_android,
    required this.force_update_ios,
    required this.force_update_message,
    required this.ios_version,
    required this.tts_speedd,
    required this.max_screenshot_count,
    required this.maxl_login_count,
    required this.tts_interval,
    required this.watermark_opacity,
  });
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
        id: json["id"],
        android_version: json["android_version"],
        force_update_android: json["force_update_android"],
        force_update_ios: json["force_update_ios"],
        force_update_message: json["force_update_message"],
        ios_version: json["ios_version"],
        tts_speedd: json["tts_speed"],
        max_screenshot_count: json["max_screenshot_count"],
        maxl_login_count: json["maxl_login_count"],
        tts_interval: json["tts_interval"],
        watermark_opacity: json["watermark_opacity"]);
  }
  @override
  List<Object?> get props => [
        id,
        android_version,
        force_update_android,
        force_update_ios,
        force_update_message,
        ios_version,
        tts_speedd,
        max_screenshot_count,
        maxl_login_count,
        tts_interval,
        watermark_opacity,
      ];
}
