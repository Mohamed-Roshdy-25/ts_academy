import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/models/get_room_details.dart';
import 'package:ts_academy/models/select_rooms.dart';
import 'package:ts_academy/network/dio_helper.dart';
import 'package:ts_academy/network/end_points.dart';
import 'package:ts_academy/screens/new_live_broadcast/cubit/states.dart';
import 'package:uuid/uuid.dart';

class ZegoCloudCubit extends Cubit<ZegoCloudStates> {
  ZegoCloudCubit() : super(ZegoCloudInitialState());

  static ZegoCloudCubit get(context) => BlocProvider.of(context);

  final channelId = const Uuid().v4().replaceAll("-", "");

  Future<void> createRoomInBackend({
    required BuildContext context,
    required String roomName,
    String? description,
    String? roomType,
    String? universityId,
  }) async {
    emit(CreateRoomInBackendLoadingState());
    await DioHelper.postData(
      url: CREATEROOM,
      baseUrl: BASEURL,
      data: {
        "room_name": roomName,
        "user_created": stuId,
        "title": "title",
        "description": description ?? " ",
        "channal_id": channelId,
        "room_type": roomType,
        "university_id": universityId,
      },
    ).then((value) async {
      final resp = json.decode(value.data);
      if (resp['message'] is int) {
        emit(CreateRoomInBackendSuccessState(resp["message"].toString()));
      } else {
        emit(CreateRoomInBackendErrorState('An error occurred. Please try again.'));
      }
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['message'];
          emit(CreateRoomInBackendErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(CreateRoomInBackendErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(CreateRoomInBackendErrorState('An error occurred. Please try again.'));
      }
    });
  }

  SelectRooms? selectRoomsDorAdmin;
  Future<void> getRoomsForAdmin() async {
    emit(GetRoomsLoadingState());
    await DioHelper.getData(
      url: SELECTROOMSFORADMIN,
      baseUrl: BASEURL,
    ).then((value) async {
      selectRoomsDorAdmin = SelectRooms.fromJson(json.decode(value.data));
      emit(GetRoomsSuccessState(selectRoomsDorAdmin!));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['message'];
          emit(GetRoomsErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(GetRoomsErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(GetRoomsErrorState('An error occurred. Please try again.'));
      }
    });
  }

  RoomDetails? roomDetails;
  Future<void> getRoomDetails({
    required String roomId,
  }) async {
    emit(GetRoomDetailsLoadingState());
    await DioHelper.postData(
      url: GETROOMDETAILS,
      baseUrl: BASEURL,
      data: {
        "room_id": roomId,
      },
    ).then((value) async {
      roomDetails = RoomDetails.fromJson(json.decode(value.data));
      emit(GetRoomDetailsSuccessState(roomDetails!));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['message'];
          emit(GetRoomDetailsErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(GetRoomDetailsErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(GetRoomDetailsErrorState('An error occurred. Please try again.'));
      }
    });
  }

  Future<void> joinRoom({
    required String roomId,
  }) async {
    emit(JoinRoomInBackendLoadingState());
    await DioHelper.postData(
      url: JOINROOM,
      baseUrl: BASEURL,
      data: {
        "room_id": roomId,
        "user_id": stuId,
      },
    ).then((value) async {
      final resp = json.decode(value.data);
      if (resp["status"] == "success") {
        emit(JoinRoomInBackendSuccessState());
      } else {
        emit(JoinRoomInBackendErrorState(resp["message"]));
      }
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['message'];
          emit(JoinRoomInBackendErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(JoinRoomInBackendErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(JoinRoomInBackendErrorState('An error occurred. Please try again.'));
      }
    });
  }

  Future<void> leaveRoom({
    required String roomId,
  }) async {
    emit(LeaveRoomInBackendLoadingState());
    await DioHelper.postData(
      url: LEAVEROOM,
      baseUrl: BASEURL,
      data: {
        "room_id": roomId,
        "user_id": stuId,
      },
    ).then((value) async {
      final resp = json.decode(value.data);
      if (resp["status"] == "success") {
        emit(LeaveRoomInBackendSuccessState());
      } else {
        emit(LeaveRoomInBackendErrorState(resp["message"]));
      }
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['message'];
          emit(LeaveRoomInBackendErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(LeaveRoomInBackendErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(LeaveRoomInBackendErrorState('An error occurred. Please try again.'));
      }
    });
  }

  Future<void> endRoomInBackend({
    required String roomId,
  }) async {
    emit(EndRoomInBackendLoadingState());
    await DioHelper.postData(
      url: ENDROOM,
      baseUrl: BASEURL,
      data: {
        "room_id": roomId,
      },
    ).then((value) async {
      final resp = json.decode(value.data);
      if (resp["status"] == "success") {
        emit(EndRoomInBackendSuccessState(resp["message"]));
      } else {
        emit(EndRoomInBackendErrorState(resp["message"]));
      }
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['message'];
          emit(EndRoomInBackendErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(EndRoomInBackendErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(EndRoomInBackendErrorState('An error occurred. Please try again.'));
      }
    });
  }

  SelectRooms? selectRoomsForStudents;
  Future<void> getRoomsForStudents() async {
    emit(GetRoomsLoadingState());
    await DioHelper.postData(
      url: SELECTROOMSFORSTUDENT,
      baseUrl: BASEURL,
      data: {
        "student_id": stuId,
      },
    ).then((value) async {
      selectRoomsForStudents = SelectRooms.fromJson(json.decode(value.data));
      emit(GetRoomsSuccessState(selectRoomsForStudents!));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['message'];
          emit(GetRoomsErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(GetRoomsErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(GetRoomsErrorState('An error occurred. Please try again.'));
      }
    });
  }

  Future<void> makeCommentInRoom({
    required String roomId,
    required String comment,
  }) async {
    emit(MakeCommentInRoomLoadingState());
    await DioHelper.postData(
      url: MAKEROOMCOMMENT,
      baseUrl: BASEURL,
      data: {
        "user_id": stuId,
        "room_id": roomId,
        "comment": comment,
      },
    ).then((value) async {
      final resp = json.decode(value.data);
      if (resp["status"] == "success") {
        emit(MakeCommentInRoomSuccessState(resp["message"]));
      } else {
        emit(MakeCommentInRoomErrorState(resp["message"]));
      }
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['message'];
          emit(MakeCommentInRoomErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(MakeCommentInRoomErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(MakeCommentInRoomErrorState('An error occurred. Please try again.'));
      }
    });
  }
}