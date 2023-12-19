part of 'course_chapters_cubit.dart';

abstract class CourseChaptersState {}

class CourseChaptersInitial extends CourseChaptersState {}

class CourseChaptersLoading extends CourseChaptersState {}

class CourseChaptersLoaded extends CourseChaptersState {}

class CourseChaptersFailure extends CourseChaptersState {
  final String message;
  CourseChaptersFailure({required this.message});
}
