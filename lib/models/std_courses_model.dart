import 'package:equatable/equatable.dart';

class StudentCoursesModel extends Equatable {
  final String courseName;
  final String courseId;
  final String coursePhoto;
  final String courseDescription;
  final bool own;

  const StudentCoursesModel(
      {required this.courseId,
      required this.coursePhoto,
      required this.courseName,
      required this.own,
      required this.courseDescription});

  factory StudentCoursesModel.fromjson(Map<String, dynamic> json) =>
      StudentCoursesModel(
          courseId: json['course_id'],
          coursePhoto: json['course_photo'],
          courseName: json['course_name'],
          courseDescription: json['course_description'],
          own: json["own"]);

  @override
  List<Object?> get props =>
      [courseId, coursePhoto, courseName, own, courseDescription];
}
