import 'package:equatable/equatable.dart';

class QuizzModel extends Equatable {
  @override
  List<Object?> get props => [
        quizId,
        courseId,
        numOfQuestions,
        completedOrNot,
        date,
        studentId,
        quizTitle
      ];

  final String quizId;
  final String quizPhoto;
  final String courseId;
  final String numOfQuestions;
  final String completedOrNot;
  final String date;
  final String studentId;
  final String quizTitle;

  const QuizzModel(
      {required this.quizId,
      required this.quizPhoto,
      required this.courseId,
      required this.numOfQuestions,
      required this.completedOrNot,
      required this.date,
      required this.studentId,
      required this.quizTitle});

  factory QuizzModel.fromjson(Map<String, dynamic> json) => QuizzModel(
      quizId: json['quiz_id'],
      courseId: json['course_id'],
      numOfQuestions: json['num_of_questions'],
      completedOrNot: json['completed_or_not'],
      date: json['date'],
      studentId: json['student_id'],
      quizTitle: json['quiz_title'],
      quizPhoto: json['quiz_photo']);
}
