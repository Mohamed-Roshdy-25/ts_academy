part of 'student_posts_cubit.dart';

abstract class StudentPostsState {}

class StudentPostsInitial extends StudentPostsState {}

class StudentPostsLoading extends StudentPostsState {}

class StudentPostsFailure extends StudentPostsState {
  final String message;
  StudentPostsFailure({required this.message});
}

class StudentPostsLoaded extends StudentPostsState {}
class ChangeLikesBool extends StudentPostsState {}
class CreatePostsLoading extends StudentPostsState {}

class CreatePostsFailure extends StudentPostsState {
  final String message;
  CreatePostsFailure({required this.message});
}

class CreatePostsLoaded extends StudentPostsState {
  final String message;
  CreatePostsLoaded({required this.message});
}

class ChangeLikeCountLoading extends StudentPostsState {}

class ChangeLikeCountSuccess extends StudentPostsState {}

class ChangeLikeCountFailure extends StudentPostsState {}
class UploadFilesLoading extends StudentPostsState {}
class UploadFilesSuccess extends StudentPostsState {}
class UploadFilesFailure extends StudentPostsState {
  String errorMessage ;
  UploadFilesFailure(this.errorMessage);
}
