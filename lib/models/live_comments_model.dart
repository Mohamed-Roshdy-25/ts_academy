import 'package:equatable/equatable.dart';

class LiveCommentModel extends Equatable{
  final String commentId;
  final String liveId;
  final String comment;
  final String stuID;
  final String date;

  const LiveCommentModel(
      {required this.commentId,required this.liveId,required this.comment,required this.stuID,required this.date});

  factory LiveCommentModel.fromJson(Map<String,dynamic>json){
    return LiveCommentModel(commentId: json['comment_id'], liveId: json['live_id'], comment: json['comment'], stuID: json['student_id'], date: json['date']);
  }
  @override
  List<Object?> get props => [
  commentId,
  liveId,
  comment,
  stuID,
  date,
  ];

}