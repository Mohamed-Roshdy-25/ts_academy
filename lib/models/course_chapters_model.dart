import 'package:equatable/equatable.dart';

class CourseChapters extends Equatable {
  final String chapterId;
  final String courseId;
  final String chapterTitle;
  final String chapterPhoto;
  final String hidden;
  final bool own;

  const CourseChapters({
    required this.chapterId,
    required this.courseId,
    required this.chapterPhoto,
    required this.chapterTitle,
    required this.hidden,
    required this.own,
  });

  factory CourseChapters.fromjson(Map<String, dynamic> json) => CourseChapters(
        chapterId: json["chapter_id"],
        courseId: json["course_id"],
        chapterTitle: json["chapter_title"],
        chapterPhoto: json["chapter_photo"],
        hidden: json["hidden"],
        own: json["own"],
      );
  @override
  // TODO: implement props
  List<Object?> get props => [chapterId, courseId, chapterTitle];
}
