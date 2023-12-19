import 'package:equatable/equatable.dart';

class PostComments extends Equatable {
   String? commentId;
  final String commentDetails;
   String ? date;
  final String studentName;
  final String studentPhoto;
  final String studentId;

  // {
  // "comment_id": "93",
  // "comment_details": "i need help",
  // "student_id": "51",
  // "course_id": "0",
  // "date": "2023-07-04 22:56:52",
  // "post_id": "1",
  // "owner_data": {
  // "student_name": "Mahmoud Matar",
  // "student_id": "51",
  // "student_photo": null
  // }
  // }

   PostComments(
      { this.commentId,
      required this.studentId,
      required this.commentDetails,
       this.date,
      required this.studentName,
      required this.studentPhoto});

  @override
  List<Object?> get props =>
      [commentId, studentId, commentDetails, date, studentName, studentPhoto];

  factory PostComments.fromjson(Map<String, dynamic> json) => PostComments(
      commentId: json['comment_id'],
      commentDetails: json['comment_details'],
      date: json['date'],
      studentName: json['owner_data']['student_name'],
      studentPhoto: json['owner_data']['student_photo'] ?? "",
      studentId: json['owner_data']['student_id']);
}
