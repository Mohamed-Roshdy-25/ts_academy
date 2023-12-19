part of 'courses_video_cubit.dart';

abstract class CoursesVideoState {}

class GetCoursesVideoInitial extends CoursesVideoState {}
class ChangeIndexOfVideoState extends CoursesVideoState {}

class GetCoursesVideoLoading extends CoursesVideoState {

}

class GetCoursesVideoLoaded extends CoursesVideoState {}

class ChangeLinksSuccess extends CoursesVideoState {}

class ChangeLinksLoading extends CoursesVideoState {}
class VideoLoadedInWebView extends CoursesVideoState {}

class ChangeLinksFailure extends CoursesVideoState {}

class GetCoursesVideoFailure extends CoursesVideoState {
  final String message;
  GetCoursesVideoFailure({required this.message});
}
