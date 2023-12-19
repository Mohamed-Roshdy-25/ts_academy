import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/controller/permission_cubit/permission_cubit.dart';
import 'package:ts_academy/models/onBoarding_model.dart';

import '../../constants/api_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/about_us_model.dart';
import 'package:http/http.dart' as http;
part 'about_us_state.dart';

class AbutUsCubit extends Cubit<AbutUsState> {
  AbutUsCubit() : super(AbutUsInitial());
  AboutUSModel? aboutUSModel;
  String message = "";

  Future<void> getAboutUsMessage() async {
    emit(AbutUsLoading());
    try {
      http.Response response =
          await http.get(Uri.parse(ApiConstants.selectAboutUs));
      if (response.statusCode == 200) {
        aboutUSModel =
            AboutUSModel.fromjson(jsonDecode(response.body)["massage"]);
        message = aboutUSModel!.aboutText;
        emit(AbutUsLoaded());
      } else {
        emit(AbutUsFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(AbutUsFailure(message: tr(StringConstants.noInternet)));
    } catch (e) {
      emit(AbutUsFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }


  int selectedIndex = 0 ;
  changeIndex (int index)   {
    selectedIndex = index;
    emit(ChangeIndexState( ));
  }



  List<OnBoardingModel>  onBoardings = [ ];
  Future<void> makeOnBoarding() async {
    emit(OnBoardingLoading());
    debugPrint("Loading ........");
    try {
      http.Response response =
      await http.get(Uri.parse(ApiConstants.onBoarding));
      debugPrint(response.statusCode.toString());
      debugPrint(jsonDecode(response.body).toString());
      if (response.statusCode == 200) {
        debugPrint("start ");
        onBoardings  =  List<OnBoardingModel>.from(
    (jsonDecode(response.body) as List).map((e) => OnBoardingModel.fromJson(e)));
        debugPrint(onBoardings.toString());
        emit(OnBoardingLoaded());
      } else {

        debugPrint("not 200 ");
        emit(OnBoardingFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(OnBoardingFailure(message: tr(StringConstants.noInternet)));
    } catch (e) {
      debugPrint(e.toString());
      emit(OnBoardingFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }

}
