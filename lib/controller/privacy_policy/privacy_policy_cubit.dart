import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../constants/api_constants.dart';
import '../../constants/string_constants.dart';
import 'package:http/http.dart' as http;

import '../../models/privacy_model.dart';
part 'privacy_policy_state.dart';

class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  PrivacyPolicyCubit() : super(PrivacyPolicyInitial());

  PrivacyModel? privacyModel;
  String message = "";

  Future<void> getPrivacyMessage() async {
    emit(PrivacyPolicyLoading());
    try {
      http.Response response =
          await http.get(Uri.parse(ApiConstants.selectPrivacyPolicy));
      if (response.statusCode == 200) {
        privacyModel =
            PrivacyModel.fromjson(jsonDecode(response.body)["massage"]);
        message = privacyModel!.privacyText;
        emit(PrivacyPolicyLoaded());
      } else {
        emit(PrivacyPolicyFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(PrivacyPolicyFailure(message: tr(StringConstants.noInternet)));
    } catch (e) {
      emit(PrivacyPolicyFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }
}
