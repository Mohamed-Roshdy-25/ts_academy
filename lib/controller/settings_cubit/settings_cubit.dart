import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ts_academy/constants/string_constants.dart';
import '../../constants/api_constants.dart';
import '../../models/settings_model.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsStates> {
  SettingsCubit() : super(GetSettingsInitial());

  SettingsModel? settingsModel;
  Future<void> getSettings() async {
    debugPrint("Start get Settings");
    emit(GetSettingsLoading());
    try {
      http.Response res = await http.get(Uri.parse(ApiConstants.settings));
      debugPrint(jsonDecode(res.body).toString());
      if (res.statusCode == 200) {
        settingsModel = SettingsModel.fromJson(jsonDecode(res.body)["massage"]);
        debugPrint(settingsModel.toString());
        emit(GetSettingsSuccess());
      } else {
        emit(GetSettingsFailure(tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(GetSettingsFailure(tr(StringConstants.noInternet)));
    } catch (E) {
      debugPrint(E.toString());
      emit(GetSettingsFailure(tr(StringConstants.errorWhenResponse)));
    }
  }
}
