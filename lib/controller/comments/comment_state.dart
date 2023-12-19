part of 'comment_cubit.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}
class AddedSucceffuly extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {}

class CommentFailure extends CommentState {
  final String message;
  CommentFailure({required this.message});
}

class InsertCourseCommentInitial extends CommentState {}

class InsertCourseCommentLoading extends CommentState {}

class InsertCourseCommentLoaded extends CommentState {
  final String message;
  InsertCourseCommentLoaded({required this.message});
}

class InsertCourseCommentFailure extends CommentState {
  final String message;
  InsertCourseCommentFailure({required this.message});
}

class ClearTextFieldState extends CommentState {}
