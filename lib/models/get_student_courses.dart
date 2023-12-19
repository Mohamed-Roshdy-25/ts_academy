class Courses {
  List<Massage>? massage;

  Courses({this.massage});

  Courses.fromJson(Map<String, dynamic> json) {
    if (json['massage'] != null && json['massage'] is List) {
      massage = <Massage>[];
      json['massage'].forEach((v) {
        massage!.add(new Massage.fromJson(v));
      });
    }
  }
}

class Massage {
  String? courseId;
  String? universityId;
  String? courseName;
  String? coursePhoto;
  String? courseDescription;
  String? free;
  bool? own;

  Massage({
    this.courseId,
    this.universityId,
    this.courseName,
    this.coursePhoto,
    this.courseDescription,
    this.free,
    this.own,
  });

  Massage.fromJson(Map<String, dynamic> json) {
    courseId = json['course_id'];
    universityId = json['university_id'];
    courseName = json['course_name'];
    coursePhoto = json['course_photo'];
    courseDescription = json['course_description'];
    free = json['free'];
    own = json['own'];
  }
}