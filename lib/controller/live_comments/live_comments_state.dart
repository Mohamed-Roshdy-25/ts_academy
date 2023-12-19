part of 'live_comments_cubit.dart';

abstract class LiveCommentsState {}

class LiveCommentsInitial extends LiveCommentsState {}
class GetLiveCommentsLoading extends LiveCommentsState {}
class GetLiveCommentsLoaded extends LiveCommentsState {}
class AddCommentToListState extends LiveCommentsState {}
class GetLiveCommentsFailure extends LiveCommentsState {
  final String message;

  GetLiveCommentsFailure({required this.message});
}
class InsertLiveCommentsLoading extends LiveCommentsState {}
class InsertLiveCommentsLoaded extends LiveCommentsState {
  final String message;
  InsertLiveCommentsLoaded({required this.message});
}
class InsertLiveCommentsFailure extends LiveCommentsState {
  final String message;

  InsertLiveCommentsFailure({required this.message});
}
