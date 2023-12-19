import 'package:equatable/equatable.dart';

class CourseVideoModel extends Equatable {
  final String videoNumber;
  final String type;
  final String videoId;
  final String videoUrl;
  final String videoDescription;
  final String videoTitle;
  final String chapterId;
  final String free;

  const CourseVideoModel(
      {required this.videoId,
      required this.videoNumber,
      required this.type,
      required this.free,
      required this.videoUrl,
      required this.videoDescription,
      required this.videoTitle,
      required this.chapterId});
  factory CourseVideoModel.fromjson(Map<String, dynamic> json) =>
      CourseVideoModel(
          videoId: json["video_id"],
          free: json["free"],
          videoUrl: json["video_url"],
          videoDescription: json["video_description"],
          videoTitle: json["video_title"],
          chapterId: json["chapter_id"],
          videoNumber: json['video_number'],
          type: json['type']);

  @override
  List<Object?> get props => [
        videoId,
        videoUrl,
        videoDescription,
        videoTitle,
        chapterId,
        videoNumber,
        type,
    free
      ];
}
