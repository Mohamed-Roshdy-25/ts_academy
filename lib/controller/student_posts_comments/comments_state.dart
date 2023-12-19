part of 'comments.dart';

abstract class CommentsState {}

class GetCommentsInitial extends CommentsState {}

class GetCommentsLoading extends CommentsState {}

class GetCommentsLoaded extends CommentsState {}
class AddCommentToListState extends CommentsState {}

class GetCommentsFailure extends CommentsState {
  final String message;
  GetCommentsFailure({required this.message});
}

class InsertPostCommentsInitial extends CommentsState {}

class InsertPostCommentsLoading extends CommentsState {}

class InsertPostCommentsFailure extends CommentsState {
  final String message;
  InsertPostCommentsFailure({required this.message});
}

class InsertPostCommentsLoaded extends CommentsState {
  final String message;
  InsertPostCommentsLoaded({required this.message});
}

class GetCommentsLoadingState extends CommentsState{}
class GetCommentsSuccessState extends CommentsState{
  final NewCommentsModel newCommentsModel;
  GetCommentsSuccessState(this.newCommentsModel);
}
class GetCommentsErrorState extends CommentsState{
  final String error;
  GetCommentsErrorState(this.error);
}

class GetRepliesLoadingState extends CommentsState{}
class GetRepliesSuccessState extends CommentsState{
  final ReplyModel replyModel;
  GetRepliesSuccessState(this.replyModel);
}
class GetRepliesErrorState extends CommentsState{
  final String error;
  GetRepliesErrorState(this.error);
}

class MakeReplyLoadingState extends CommentsState{}
class MakeReplySuccessState extends CommentsState{
  final String msg;
  MakeReplySuccessState(this.msg);
}
class MakeReplyErrorState extends CommentsState{
  final String error;
  MakeReplyErrorState(this.error);
}

class DeleteCommentLoadingState extends CommentsState{}
class DeleteCommentSuccessState extends CommentsState{
  final String msg;
  DeleteCommentSuccessState(this.msg);
}
class DeleteCommentErrorState extends CommentsState{
  final String error;
  DeleteCommentErrorState(this.error);
}

class DeleteReplyLoadingState extends CommentsState{}
class DeleteReplySuccessState extends CommentsState{
  final String msg;
  DeleteReplySuccessState(this.msg);
}
class DeleteReplyErrorState extends CommentsState{
  final String error;
  DeleteReplyErrorState(this.error);
}

class ReportReplyLoadingState extends CommentsState{}
class ReportReplySuccessState extends CommentsState{
  final String msg;
  ReportReplySuccessState(this.msg);
}
class ReportReplyErrorState extends CommentsState{
  final String error;
  ReportReplyErrorState(this.error);
}

class ReportCommentLoadingState extends CommentsState{}
class ReportCommentSuccessState extends CommentsState{
  final String msg;
  ReportCommentSuccessState(this.msg);
}
class ReportCommentErrorState extends CommentsState{
  final String error;
  ReportCommentErrorState(this.error);
}

class EditCommentLoadingState extends CommentsState{}
class EditCommentSuccessState extends CommentsState{
  final String msg;
  EditCommentSuccessState(this.msg);
}
class EditCommentErrorState extends CommentsState{
  final String error;
  EditCommentErrorState(this.error);
}

class EditReplyLoadingState extends CommentsState{}
class EditReplySuccessState extends CommentsState{
  final String msg;
  EditReplySuccessState(this.msg);
}
class EditReplyErrorState extends CommentsState{
  final String error;
  EditReplyErrorState(this.error);
}