class ReplyModel {
  String? status;
  List<Massage>? massage;

  ReplyModel({this.status, this.massage});

  ReplyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['massage'] != null && json['massage'] is List) {
      massage = <Massage>[];
      json['massage'].forEach((v) {
        massage!.add(new Massage.fromJson(v));
      });
    }
  }
}

class Massage {
  String? replyId;
  String? commentId;
  String? studentId;
  String? replyText;
  String? date;
  OwnerReplyData? ownerReplyData;
  bool? reported;

  Massage(
      {this.replyId,
        this.commentId,
        this.studentId,
        this.replyText,
        this.date,
        this.ownerReplyData,
        this.reported,
      });

  Massage.fromJson(Map<String, dynamic> json) {
    replyId = json['reply_id'];
    commentId = json['comment_id'];
    studentId = json['student_id'];
    replyText = json['reply_text'];
    date = json['date'];
    ownerReplyData = json['owner_reply_data'] != null
        ? new OwnerReplyData.fromJson(json['owner_reply_data'])
        : null;
    reported = json['reported'];
  }
}

class OwnerReplyData {
  String? studentName;
  String? studentId;
  String? studentPhoto;

  OwnerReplyData({this.studentName, this.studentId, this.studentPhoto});

  OwnerReplyData.fromJson(Map<String, dynamic> json) {
    studentName = json['student_name'];
    studentId = json['student_id'];
    studentPhoto = json['student_photo'];
  }
}
