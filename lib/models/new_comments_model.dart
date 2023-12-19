class NewCommentsModel {
  List<CommentData>? massage;

  NewCommentsModel({this.massage});

  NewCommentsModel.fromJson(Map<String, dynamic> json) {
    if (json['massage'] != null && json['massage'] is List) {
      massage = <CommentData>[];
      json['massage'].forEach((v) {
        massage!.add(new CommentData.fromJson(v));
      });
    }
  }
}

class CommentData {
  String? commentId;
  String? commentDetails;
  String? studentId;
  String? courseId;
  String? date;
  String? postId;
  OwnerData? ownerData;
  int? replysCount;
  List<ReplysData>? replysData;
  bool? reported;

  CommentData(
      {this.commentId,
        this.commentDetails,
        this.studentId,
        this.courseId,
        this.date,
        this.postId,
        this.ownerData,
        this.replysCount,
        this.replysData,
        this.reported
      });

  CommentData.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    commentDetails = json['comment_details'];
    studentId = json['student_id'];
    courseId = json['course_id'];
    date = json['date'];
    postId = json['post_id'];
    ownerData = json['owner_data'] != null
        ? new OwnerData.fromJson(json['owner_data'])
        : null;
    replysCount = json['replys_count'];
    if (json['replys_data'] != null && json['replys_data'] is List) {
      replysData = <ReplysData>[];
      json['replys_data'].forEach((v) {
        replysData!.add(new ReplysData.fromJson(v));
      });
    }
    reported = json['reported'];
  }
}

class OwnerData {
  String? studentName;
  String? studentId;
  String? studentPhoto;

  OwnerData({this.studentName, this.studentId, this.studentPhoto});

  OwnerData.fromJson(Map<String, dynamic> json) {
    studentName = json['student_name'];
    studentId = json['student_id'];
    studentPhoto = json['student_photo'];
  }
}

class ReplysData {
  String? replyId;
  String? commentId;
  String? studentId;
  String? replyText;
  String? date;
  OwnerData? ownerReplyData;

  ReplysData(
      {this.replyId,
        this.commentId,
        this.studentId,
        this.replyText,
        this.date,
        this.ownerReplyData});

  ReplysData.fromJson(Map<String, dynamic> json) {
    replyId = json['reply_id'];
    commentId = json['comment_id'];
    studentId = json['student_id'];
    replyText = json['reply_text'];
    date = json['date'];
    ownerReplyData = json['owner_reply_data'] != null
        ? new OwnerData.fromJson(json['owner_reply_data'])
        : null;
  }
}
