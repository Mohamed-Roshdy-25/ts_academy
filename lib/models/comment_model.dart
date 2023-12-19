import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CommentModel extends Equatable {
   String ? commentId;
  final String commentDetails;
  final String studentId;
   String ? courseId;
   String ? date;
  final String postId;
  final String studentName;
  final String studentPhoto;

   CommentModel(
      {required this.commentId,
      required this.commentDetails,
      required this.studentId,
       this.courseId,
      required this.date,
      required this.postId,
      required this.studentName,
      required this.studentPhoto});

  factory CommentModel.fromjson(Map<String, dynamic> json) => CommentModel(
        commentId: json['comment_id'],
        commentDetails: json['comment_details'],
        studentId: json["student_id"],
        courseId: json['course_id'],
        date: json['date'],
        postId: json['post_id'],
        studentName: json['owner_data']['student_name'] ?? "",
        studentPhoto: json["owner_data"]['student_photo'] ?? "",
      );

  @override
  List<Object?> get props => [
        commentId,
        commentDetails,
        studentId,
        courseId,
        date,
        postId,
        // studentName,
        // studentPhoto
      ];
}
