import 'package:equatable/equatable.dart';

class StudentPosts extends Equatable {
  final String postId;
  final String postContent;
  final String likesCount;
  final String commentsCount;
  final bool isLike;
  final String postDate;
  final List<ImagePostModel> postsImage;

  const StudentPosts(
      {required this.postId,
      required this.postContent,
      required this.likesCount,
      required this.commentsCount,
      required this.isLike,
      required this.postDate,
      required this.postsImage});

  @override
  List<Object?> get props => [
        postId,
        postContent,
        likesCount,
        commentsCount,
        isLike,
        postDate,
        postsImage
      ];

  factory StudentPosts.fromjson(Map<String, dynamic> json) => StudentPosts(
      postId: json['post_id'],
      postContent: json['post_content'],
      likesCount: json['likes_count'],
      commentsCount: json['comment_count'],
      isLike: json['is_liked'],
      postDate: json['post_date'],
      postsImage: List<ImagePostModel>.from(
          (json['post_image'] as List).map((e) => ImagePostModel.fromjson(e))));
}

class ImagePostModel extends Equatable {
  final String postImageId;
  final String postId;
  final String imageUrl;

  const ImagePostModel(
      {required this.postImageId,
      required this.postId,
      required this.imageUrl});

  @override
  List<Object?> get props => [postImageId, postId, imageUrl];
  factory ImagePostModel.fromjson(Map<String, dynamic> json) => ImagePostModel(
      postImageId: json['post_image_id'],
      postId: json['post_id'],
      imageUrl: json['image_url']);
}
