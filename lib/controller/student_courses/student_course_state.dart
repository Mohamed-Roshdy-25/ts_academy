part of 'student_course_cubit.dart';

abstract class StudentCourseState {}

class StudentCourseInitial extends StudentCourseState {}

class StudentCourseLoading extends StudentCourseState {}

class StudentCourseLoaded extends StudentCourseState {}

class StudentCourseFailure extends StudentCourseState {
  final String message;
  StudentCourseFailure(this.message);
}
