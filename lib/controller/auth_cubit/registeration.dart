import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/constants.dart';
import '../../models/user_model.dart';
import '/constants/api_constants.dart';
import '/constants/string_constants.dart';
import '/controller/auth_cubit/auth_states.dart';

import 'package:http/http.dart' as http;

import '../../models/university_model.dart';

class RegistrationCubit extends Cubit<AuthStates> {
  RegistrationCubit() : super(InitialAuth());

  String studentImage = "";
  late UserModel userModel;

  Future<void> getImagePath(XFile ?image) async {

    emit(GetImagePathLoading());
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(ApiConstants.getImagePath),
      );

      if (image != null) {
        var fileStream2 = http.ByteStream(Stream.castFrom(image.openRead()));
        var length2 = await image.length();
        var multipartFile2 = http.MultipartFile('image', fileStream2, length2,
            filename: image.path);
        request.files.add(multipartFile2);
      }

      final http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(await response.stream.bytesToString());

        if (responseJson['status'] == "success") {
          studentImage = responseJson['massage'];
          print(studentImage);
          emit(GetImagePathLoaded());
        } else {
          emit(GetImagePathFailure(tr(StringConstants.noInternet)));
        }
      } else {
        emit(GetImagePathFailure(tr(StringConstants.problemWentWrong)));
      }
    } on SocketException {
      emit(GetImagePathFailure(tr(StringConstants.problemWentWrong)));
    } catch (e) {
      emit(GetImagePathFailure(tr(StringConstants.problemWentWrong)));
    }
  }

  Future<void> register({
    required String phoneNumber,
    required String studentSerial,
    required String studentToken,
    required String studentGrade,
    required String universityId,
    required String studentName,
    // required String studentGender,
    required String studentPhoto,
  }) async {
    emit(RegisterLoading());
    try {
      http.Response registerResponse =
          await http.post(Uri.parse(ApiConstants.registerEndpoint),
              body: jsonEncode({
                StringConstants.studentNameKey: studentName,
                StringConstants.studentPhoneKey: phoneNumber,
                StringConstants.studentSerialKey: studentSerial,
                StringConstants.studentTokenKey: studentToken,
                StringConstants.studentGradeKey: studentGrade,
                StringConstants.universityIdKey: universityId,
                // StringConstants.studentGender: studentGender,
                StringConstants.studentPhoto: studentPhoto,

              }),
             );

      if (registerResponse.statusCode == 200) {
        debugPrint(jsonDecode(registerResponse.body)['status']);
        if (jsonDecode(registerResponse.body)['status'] == "success") {
          userModel =
              UserModel.fromJson(jsonDecode(registerResponse.body)['massage']);
          final sharedPref = await SharedPreferences.getInstance();
          await sharedPref.setString("userId", userModel.studentId.toString());

          stuId = sharedPref.getString("userId");
          await sharedPref.setString(
              "userPhoto", userModel.studentPhoto.toString());
          stuPhoto = sharedPref.getString("userPhoto");
          await sharedPref.setString(
              "userUniversity", userModel.universityName.toString());
          universityName = sharedPref.getString("userUniversity");
          await sharedPref.setString(
              "userPhone", userModel.studentPhone.toString());
          stuPhone = sharedPref.getString("userPhone");
          await sharedPref.setString("userName", userModel.studentName);
          myName = sharedPref.getString("userName");

          await sharedPref.setString("earphone_permission", userModel.earphone_permission);
          earphone_permission = sharedPref.getString("earphone_permission");

          await sharedPref.setString("all_permission", userModel.all_permission);
          all_permission = sharedPref.getString("all_permission");

          await sharedPref.setString("phone_jack", userModel.phone_jack);
          phone_jack = sharedPref.getString("phone_jack");

          await sharedPref.setString("sim_card", userModel.simCard);
          simCard = sharedPref.getString("sim_card");

          emit(RegisterSuccess(
              message: tr(StringConstants.done)));
        } else {
          emit(RegisterFailure(
              errorMessage: jsonDecode(registerResponse.body)["massage"]));
        }
      } else {
        emit(RegisterFailure(errorMessage:tr( StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(RegisterFailure(errorMessage: StringConstants.noInternet));
    } catch (e) {
      print("====================================================");
      print(e.toString());
      print("====================================================");
      emit(RegisterFailure(errorMessage: tr(StringConstants.errorWhenResponse)));
    }
  }

  List<UniversityModel> universities = [];
  List<String> universitiesName = [];
  Future<void> getUniversities() async {
    emit(GetUniversitiesLoading());
    try {
      http.Response res = await http.get(Uri.parse(ApiConstants.universityEndpoint));
      if (res.statusCode == 200) {
        if (jsonDecode(res.body)["status"] == "success") {
          universities = List<UniversityModel>.from((jsonDecode(res.body)["massage"] as List).map((e) => UniversityModel.fromJson(e)));
          print(jsonDecode(res.body));
          for (var university in jsonDecode(res.body)["massage"]) {
            String universityName = university['university_name'];
            universitiesName.add(universityName);
          }
          emit(GetUniversitiesSuccessfully());
        }
      } else {
        emit(GetUniversitiesFailure(
            errorMessage: "Error where try get universities"));
      }
    } on SocketException {
      emit(GetUniversitiesFailure(errorMessage: tr(StringConstants.noInternet)));
    } catch (e) {
      emit(GetUniversitiesFailure(errorMessage: tr(StringConstants.errorWhenResponse)));
    }
  }


  //
  //
  //
  // String ? photoUrlAfterRegister ;
  //
  // Future<void>  getPhoto( XFile ? file ) async {
  //   emit(GetPhotoLoading());
  //   try {
  //     final request = http.MultipartRequest(
  //       "POST",
  //       Uri.parse(ApiConstants.photo),
  //     );
  //     if (file != null) {
  //       var fileStream2 = http.ByteStream(Stream.castFrom(file.openRead()));
  //       var length2 = await file.length();
  //       var multipartFile2 = http.MultipartFile('image', fileStream2, length2,
  //           filename: file.path);
  //       request.files.add(multipartFile2);
  //     }
  //
  //     final http.StreamedResponse response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       final responseJson = jsonDecode(await response.stream.bytesToString());
  //
  //       if (responseJson["status"] == 1) {
  //         photoUrlAfterRegister= responseJson["massage"];
  //       }
  //       emit(GetPhotoSuccessfully());
  //     } else {
  //       emit(GetPhotoFailure(
  //           loginFailureMessage: tr(StringConstants.problemMessageInCubit)));
  //     }
  //   } on SocketException {
  //     emit(GetPhotoFailure(
  //         loginFailureMessage: tr(StringConstants.noInternet)));
  //   } catch (e) {
  //     emit(GetPhotoFailure(
  //         loginFailureMessage: tr(StringConstants.problemMessageInCubit)));
  //   }
  // }
}
