class RoomDetails {
  String? status;
  Message? message;

  RoomDetails({this.status, this.message});

  RoomDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
  }
}

class Message {
  String? roomId;
  String? roomName;
  String? channalId;
  String? userCreated;
  String? title;
  String? description;
  String? roomEnded;
  UserData? userData;
  List<Comments>? comments;
  List<UsersInRooms>? usersInRooms;

  Message(
      {this.roomId,
        this.roomName,
        this.channalId,
        this.userCreated,
        this.title,
        this.description,
        this.roomEnded,
        this.userData,
        this.comments,
        this.usersInRooms});

  Message.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    roomName = json['room_name'];
    channalId = json['channal_id'];
    userCreated = json['user_created'];
    title = json['title'];
    description = json['description'];
    roomEnded = json['room_ended'];
    userData = json['user_data'] != null
        ? new UserData.fromJson(json['user_data'])
        : null;
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
    if (json['users_in_rooms'] != null) {
      usersInRooms = <UsersInRooms>[];
      json['users_in_rooms'].forEach((v) {
        usersInRooms!.add(new UsersInRooms.fromJson(v));
      });
    }
  }
}

class UserData {
  String? studentId;
  String? studentName;
  String? studentPhone;
  String? studentSerial;
  String? studentToken;
  String? studentGrade;
  String? universityId;
  String? studentGender;
  String? studentPhoto;
  String? earphonePermission;
  String? allPermission;
  String? phoneJack;
  String? simCard;
  String? role;
  String? muted;
  String? deafen;
  String? remoteId;
  String? roomUserDetils;

  UserData(
      {this.studentId,
        this.studentName,
        this.studentPhone,
        this.studentSerial,
        this.studentToken,
        this.studentGrade,
        this.universityId,
        this.studentGender,
        this.studentPhoto,
        this.earphonePermission,
        this.allPermission,
        this.phoneJack,
        this.simCard,
        this.role,
        this.muted,
        this.deafen,
        this.remoteId,
        this.roomUserDetils});

  UserData.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    studentName = json['student_name'];
    studentPhone = json['student_phone'];
    studentSerial = json['student_serial'];
    studentToken = json['student_token'];
    studentGrade = json['student_grade'];
    universityId = json['university_id'];
    studentGender = json['student_gender'];
    studentPhoto = json['student_photo'];
    earphonePermission = json['earphone_permission'];
    allPermission = json['all_permission'];
    phoneJack = json['phone_jack'];
    simCard = json['sim_card'];
    role = json['role'];
    muted = json['muted'];
    deafen = json['deafen'];
    remoteId = json['remote_id'];
    roomUserDetils = json['room_user_detils'];
  }
}

class Comments {
  String? userId;
  String? comment;
  String? date;
  String? userName;
  String? gender;
  String? userImage;

  Comments(
      {this.userId,
        this.comment,
        this.date,
        this.userName,
        this.gender,
        this.userImage});

  Comments.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    comment = json['comment'];
    date = json['date'];
    userName = json['user_name'];
    gender = json['gender'];
    userImage = json['user_image'];
  }
}

class UsersInRooms {
  String? channelId;
  String? roomId;
  String? userId;
  String? role;
  String? muted;
  String? deafen;
  String? userName;
  String? gender;
  String? userImage;

  UsersInRooms(
      {this.channelId,
        this.roomId,
        this.userId,
        this.role,
        this.muted,
        this.deafen,
        this.userName,
        this.gender,
        this.userImage});

  UsersInRooms.fromJson(Map<String, dynamic> json) {
    channelId = json['channel_id'];
    roomId = json['room_id'];
    userId = json['user_id'];
    role = json['role'];
    muted = json['muted'];
    deafen = json['deafen'];
    userName = json['user_name'];
    gender = json['gender'];
    userImage = json['user_image'];
  }
}
