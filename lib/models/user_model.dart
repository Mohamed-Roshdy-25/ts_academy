import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String studentId;
  final String studentName;
  final String studentPhone;
  final String studentSerial;
  final String studentToken;
  final String universityId;
  final String universityName;
  final dynamic studentGender;
  final String studentPhoto;
  final String simCard;
  final int appVersion;
  // "earphone_permission": "false",
  // "all_permission": "live",
  // "phone_jack": "0",

  final String earphone_permission;
  final String all_permission;
  final String phone_jack;

  const UserModel(
      {required this.universityName,
      required this.studentPhoto,
      required this.studentId,
      required this.studentName,
      required this.studentPhone,
      required this.studentSerial,
      required this.studentToken,
      required this.universityId,
      required this.studentGender,
      required this.simCard,
      required this.appVersion,
      required this.all_permission,
      required this.earphone_permission,
      required this.phone_jack});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        all_permission: json["all_permission"],
        earphone_permission: json["earphone_permission"],
        phone_jack: json["phone_jack"],
        simCard: json["sim_card"],
        appVersion: json["app_version"]??0,
        studentId: json['student_id'],
        studentName: json['student_name'],
        studentPhone: json['student_phone'],
        studentSerial: json['student_serial'],
        studentToken: json['student_token'],
        universityId: json['university_id'],
        studentGender: json['student_gender'],
        universityName: json['university_id'],
        studentPhoto: json['student_photo'] ?? "",
      );

  @override
  List<Object?> get props => [
        universityName,
        studentPhoto,
        studentId,
        studentName,
        studentPhone,
        studentSerial,
        studentToken,
        universityId,
        studentGender,
        simCard,
        appVersion,
        all_permission,
        earphone_permission,
        phone_jack
      ];
}
