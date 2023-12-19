import 'package:ts_academy/models/get_room_details.dart';
import 'package:ts_academy/models/select_rooms.dart';

abstract class ZegoCloudStates{}
class ZegoCloudInitialState extends ZegoCloudStates{}

class CreateRoomInBackendLoadingState extends ZegoCloudStates {}
class CreateRoomInBackendSuccessState extends ZegoCloudStates {
  final String roomId;
  CreateRoomInBackendSuccessState(this.roomId);
}
class CreateRoomInBackendErrorState extends ZegoCloudStates {
  final String error;
  CreateRoomInBackendErrorState(this.error);
}

class GetRoomsLoadingState extends ZegoCloudStates{}
class GetRoomsSuccessState extends ZegoCloudStates{
  final SelectRooms selectRooms;
  GetRoomsSuccessState(this.selectRooms);
}
class GetRoomsErrorState extends ZegoCloudStates{
  final String error;
  GetRoomsErrorState(this.error);
}

class GetRoomDetailsLoadingState extends ZegoCloudStates{}
class GetRoomDetailsSuccessState extends ZegoCloudStates{
  final RoomDetails roomDetails;
  GetRoomDetailsSuccessState(this.roomDetails);
}
class GetRoomDetailsErrorState extends ZegoCloudStates{
  final String error;
  GetRoomDetailsErrorState(this.error);
}

class JoinRoomInBackendLoadingState extends ZegoCloudStates {}
class JoinRoomInBackendSuccessState extends ZegoCloudStates {}
class JoinRoomInBackendErrorState extends ZegoCloudStates {
  final String error;
  JoinRoomInBackendErrorState(this.error);
}

class LeaveRoomInBackendLoadingState extends ZegoCloudStates {}
class LeaveRoomInBackendSuccessState extends ZegoCloudStates {}
class LeaveRoomInBackendErrorState extends ZegoCloudStates {
  final String error;
  LeaveRoomInBackendErrorState(this.error);
}

class EndRoomInBackendLoadingState extends ZegoCloudStates {}
class EndRoomInBackendSuccessState extends ZegoCloudStates {
  final String msg;
  EndRoomInBackendSuccessState(this.msg);
}
class EndRoomInBackendErrorState extends ZegoCloudStates {
  final String error;
  EndRoomInBackendErrorState(this.error);
}

class MakeCommentInRoomLoadingState extends ZegoCloudStates {}

class MakeCommentInRoomSuccessState extends ZegoCloudStates {
  final String msg;
  MakeCommentInRoomSuccessState(this.msg);
}
class MakeCommentInRoomErrorState extends ZegoCloudStates {
  final String error;
  MakeCommentInRoomErrorState(this.error);
}