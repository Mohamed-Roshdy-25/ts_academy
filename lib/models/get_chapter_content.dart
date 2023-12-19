class ChapterContent {
  List<Massage>? massage;

  ChapterContent({this.massage});

  ChapterContent.fromJson(Map<String, dynamic> json) {
    if (json['massage'] != null && json['massage'] is List) {
      massage = <Massage>[];
      json['massage'].forEach((v) {
        massage!.add(new Massage.fromJson(v));
      });
    }
  }
}

class Massage {
  String? videoId;
  String? videoUrl;
  String? videoDescription;
  String? videoTitle;
  String? chapterId;
  String? type;
  String? videoNumber;
  String? free;

  Massage(
      {this.videoId,
        this.videoUrl,
        this.videoDescription,
        this.videoTitle,
        this.chapterId,
        this.type,
        this.videoNumber,
        this.free});

  Massage.fromJson(Map<String, dynamic> json) {
    videoId = json['video_id'];
    videoUrl = json['video_url'];
    videoDescription = json['video_description'];
    videoTitle = json['video_title'];
    chapterId = json['chapter_id'];
    type = json['type'];
    videoNumber = json['video_number'];
    free = json['free'];
  }
}
