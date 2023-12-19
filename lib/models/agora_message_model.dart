class AgoraMessageModel {
  final List<AgoraMessageType> types = [
    AgoraMessageType.comment,
    AgoraMessageType.raiseHand
  ];


  late AgoraMessageType type;
  late int userId;
  late String message;

  AgoraMessageModel({
    required this.message,
    required this.type,
    required this.userId,
  });

  AgoraMessageModel.fromJson(dynamic json){
    type = types.firstWhere((element) => element.name==json['type']);
    message = json['message']??'';
    userId = json['userId']??0;
  }
  Map toJson(){
    return {
      'type':type.name,
      'message':message,
      'userId':userId,
    };
  }
}

enum AgoraMessageType{
  comment,
  raiseHand,
}
