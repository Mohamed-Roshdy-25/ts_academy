import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_academy/modules/modules.dart';
import '../../screens/authorization/sign_in_screen.dart';
import '../../screens/menu_screens/change_language_screen.dart';
import '/constants/api_constants.dart';
import '/constants/string_constants.dart';
import '/controller/auth_cubit/auth_states.dart';

import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../models/user_model.dart';

class PhoneCubit extends Cubit<AuthStates> {
  PhoneCubit() : super(InitialAuth());

  String phoneNumber = "";

  String deviceId = '';

  // @override
  // void getDeviceId() {
  //   getDeviceId().then((value) {
  //       if(value!=null) {
  //         deviceId = value;
  //         emit(GetDeviceId());
  //       }
  //   } );
  //
  // }
  // Future<void> getDeviceId() async {
  //
  //   try {
  //     var fbm = await FirebaseMessaging.instance;
  //     fbm.getToken().then((value) {
  //       print("=========================================");
  //       deviceId = value!;
  //       print(value);
  //       print("=========================================");
  //     });
  //   } catch (e) {
  //     debugPrint('Failed to get device ID: $e');
  //   }
  // }

  late UserModel userModel;
  Future<void> checkPhoneNumber(
      {required String phoneNumber, required String serialNumber}) async {
    print('deviceToken ==========================================> $deviceToken');
    emit(PhoneAuthLoading());

    try {
      http.Response checkPhoneRes =
          await http.post(Uri.parse(ApiConstants.phoneEndpoint),
              body: json.encode({
                StringConstants.studentPhoneKey:
                    phoneNumber.trim().replaceAll("+", ""),
                StringConstants.studentSerialKey: deviceToken
              }));
      debugPrint(jsonDecode(checkPhoneRes.body).toString());
      if (checkPhoneRes.statusCode == 200) {
        if (jsonDecode(checkPhoneRes.body)["status"] == "new") {
          debugPrint("new number ");
          emit(PhoneAuthSuccessNew());
        } else if (jsonDecode(checkPhoneRes.body)["status"] == "exist") {
          debugPrint(" exist");
          userModel =
              UserModel.fromJson(jsonDecode(checkPhoneRes.body)['message']);
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


          emit(PhoneAuthSuccessExist());
        } else if (jsonDecode(checkPhoneRes.body)["status"] == "error") {
          emit(PhoneAuthFailure(
              errorMessage: jsonDecode(checkPhoneRes.body)["message"]));
        } else if (jsonDecode(checkPhoneRes.body)["status"] == "errorx") {
          print("erororororororororoororr");
          emit(PhoneAuthFailure(
              errorMessage: jsonDecode(checkPhoneRes.body)["message"]));
        }
      } else {
        //  create status --> error  when error in db

        emit(PhoneAuthFailure(errorMessage: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      debugPrint("No internet");
      emit(PhoneAuthFailure(errorMessage: tr(StringConstants.noInternet)));
    } catch (e) {
      debugPrint(e.toString());
      emit(PhoneAuthFailure(errorMessage: tr(StringConstants.errorWhenResponse)));
    }   
  }


  Future<void> selectUserInfo(BuildContext context) async {
    print('deviceToken ==========================================> $deviceToken');

    emit(SelectUserInfoLoadingState());

    debugPrint("start selectUserInfo");
    try {
      http.Response checkPhoneRes =
          await http.post(Uri.parse(ApiConstants.selectUserInfo),
              body: json.encode({
            "student_id": stuId,
                StringConstants.studentSerialKey: deviceToken,
              }));
      debugPrint("=============== selectUserInf==========================>"+jsonDecode(checkPhoneRes.body).toString());
      debugPrint("===============status code selectUserInf==========================>"+checkPhoneRes.statusCode.toString());
      if (checkPhoneRes.statusCode == 200) {
        // print('=============== selectUserInfo ${checkPhoneRes.statusCode}');
       if (jsonDecode(checkPhoneRes.body)["status"] == "success") {
         debugPrint("select user info ------------ > >  > >  > "+jsonDecode(checkPhoneRes.body).toString());
          debugPrint("exist");
          userModel =
              UserModel.fromJson(jsonDecode(checkPhoneRes.body)['massage']);
          print('=======================> appVersion ${userModel.appVersion.toString()}');
          final sharedPref = await SharedPreferences.getInstance();
          await sharedPref.setString("userId", userModel.studentId.toString());
          stuId = sharedPref.getString("userId");
          await sharedPref.setString("VersionNumberFromAPI", userModel.appVersion.toString());
          versionNumberFromAPI = sharedPref.getString("VersionNumberFromAPI");
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



          debugPrint("_ _ _ _  _  _  _ _ __ _ _ _ __ _ __ _ _ _ _ _ _ __ _  __ _ _ __ ");
          debugPrint(simBool.toString());
          debugPrint("_ _ _ _  _  _  _ _ __ _ _ _ __ _ __ _ _ _ _ _ _ __ _  __ _ _ __ ");
           // if(jsonDecode(checkPhoneRes.body)["massage"]["sim_card"] == "0")  {
           //  if( simCardConstant == false)  {
           //    Modules().toast(tr(StringConstants.notAuthorized),  Colors.red);
           //    restartForLogin(context);
           //    emit(OutState( )) ;
           //  }
           // }
          emit(SelectUserInfoSuccess());
        }else if(jsonDecode(checkPhoneRes.body)["status"] =="out"){
         restartForLogin(context);
         debugPrint("no no no  no  no ") ;
       }
      } else {
        // restartForLogin(context);

        //  create status --> error  when error in db

        emit(SelectUserInfoFailure(errorMessage:tr( StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(SelectUserInfoFailure(errorMessage:tr( StringConstants.noInternet)));
    } catch (e) {
      debugPrint(e.toString());
      // restartForLogin(context);

      emit(SelectUserInfoFailure(errorMessage:tr( StringConstants.errorWhenResponse)));
    }
  }



  bool  simBool = true;

  changeSimCard( bool t )async {
    simBool =t ;
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setBool("simCardConstant", simBool);
    simCardConstant = sharedPref.getBool("simCardConstant")!;

    emit(ChangeSimCardState( )) ;
  }
}
void restartForLogin(BuildContext context) async{
  final sharedPref = await SharedPreferences.getInstance();
  sharedPref.remove("userId");
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (BuildContext context) =>
        const RestartWidget(child: SignInScreen())),
        (Route<dynamic> route) => false,
  );
}