class CourseCommentsModel {
  List<Massage>? massage;

  CourseCommentsModel({this.massage});

  CourseCommentsModel.fromJson(Map<String, dynamic> json) {
    if (json['massage'] != null) {
      massage = <Massage>[];
      json['massage'].forEach((v) {
        massage!.add(new Massage.fromJson(v));
      });
    }
  }
}

class Massage {
  String? commentId;
  String? commentDetails;
  String? studentId;
  String? courseId;
  String? date;
  String? postId;
  OwnerData? ownerData;

  Massage(
      {this.commentId,
        this.commentDetails,
        this.studentId,
        this.courseId,
        this.date,
        this.postId,
        this.ownerData});

  Massage.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    commentDetails = json['comment_details'];
    studentId = json['student_id'];
    courseId = json['course_id'];
    date = json['date'];
    postId = json['post_id'];
    ownerData = json['owner_data'] != null
        ? new OwnerData.fromJson(json['owner_data'])
        : null;
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
