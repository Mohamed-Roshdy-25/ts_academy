import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ts_academy/constants/constants.dart';

import '../../constants/api_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/notification_model.dart';
import 'package:http/http.dart' as http;
part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  List<NotificationModel> notificationList = [];
  Future<void> getNotification() async {
    emit(NotificationLoading());
    try {
      http.Response response =
          await http.post(Uri.parse(ApiConstants.selectNotification),
          body:  jsonEncode( {
            "student_id":stuId
          })
          );
      final responseData = jsonDecode(response.body)['massage'];
      if (response.statusCode == 200) {
        notificationList = List<NotificationModel>.from(
            (responseData as List).map((e) => NotificationModel.fromjson(e)));
        emit(NotificationSuccess());
      } else {
        emit(NotificationFailure(message:tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(NotificationFailure(message: tr(StringConstants.errorWhenResponse)));
    } catch (e) {
      emit(NotificationFailure(message:tr(StringConstants.errorWhenResponse)));
    }
  }

  Future<void> insertNotification({
    required String notificationTitle,
    required String notificationBody,
  }) async {
    emit(InsertNotificationLoading());

    // try {
    http.Response checkPhoneRes =
        await http.post(Uri.parse(ApiConstants.insertNotification),
            body: json.encode({
              "notification_body": notificationBody,
              "notification_title": notificationTitle,
            }));
    if (checkPhoneRes.statusCode == 200) {
      if (jsonDecode(checkPhoneRes.body)["status"] == "success") {
        emit(InsertNotificationSuccess());
      } else {
        emit(InsertNotificationFailure());
      }
    } else {
      emit(InsertNotificationFailure());
    }
    // } on SocketException {
    //   emit(InsertCourseCommentFailure(message: StringConstants.noInternet));
    // } catch (e) {
    //   emit(InsertCourseCommentFailure(
    //       message: StringConstants.errorWhenResponse));
    // }
  }

  // Future<void> insertNotification(
  //     {required String notificationTitle,
  //     required String notificationBody}) async {
  //   emit(InsertNotificationLoading());
  //   try {
  //     http.Response response = await http
  //         .post(Uri.parse(ApiConstants.insertNotification), body: {
  //       "notification_body": notificationBody,
  //       "notification_title": notificationTitle
  //     });
  //     if (response.statusCode == 200) {
  //       if (jsonDecode(response.body)['status'] == "success") {
  //         emit(InsertNotificationSuccess());
  //       } else {
  //         InsertNotificationFailure();
  //       }
  //     } else {
  //       emit(InsertNotificationFailure());
  //     }
  //   } on SocketException {
  //     emit(InsertNotificationFailure());
  //   } catch (e) {
  //     emit(InsertNotificationFailure());
  //   }
  // }

  Future<void> delNotification(String notificationId) async {
    emit(DeleteNotificationLoading());
    try {
      http.Response response = await http.get(Uri.parse(
          '${ApiConstants.deleteNotification}?notification_id=$notificationId'));
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status'] == "success") {
          emit(DeleteNotificationSuccess(message: responseData['massage']));
        } else {
          emit(DeleteNotificationFailure(message: responseData['massage']));
        }
      } else {
        emit(DeleteNotificationFailure(
            message: StringConstants.errorWhenResponse));
      }
    } on SocketException {
      emit(DeleteNotificationFailure(message: StringConstants.noInternet));
    } catch (e) {
      emit(DeleteNotificationFailure(
          message: StringConstants.errorWhenResponse));
    }
  }
}
