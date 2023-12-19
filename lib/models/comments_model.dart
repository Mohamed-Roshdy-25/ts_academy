class CommentsModel {
  final String? message;
  final String? roomId;
  final DateTime? date;
  final String? userName;
  final String? userId;
  final String? userImage;

  CommentsModel({
    this.message,
    this.roomId,
    this.date,
    this.userName,
    this.userId,
    this.userImage,
  });
}