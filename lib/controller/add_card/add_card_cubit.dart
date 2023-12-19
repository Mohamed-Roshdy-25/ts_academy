import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../constants/api_constants.dart';
import '../../constants/string_constants.dart';
part 'add_card_state.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit() : super(AddCardInitial());

  Future<String> addCard({required String cardCode, required String stuId}) async {
    String message = "";
    emit(AddCardLoading());

    try {
      http.Response checkPhoneRes = await http.post(
          Uri.parse(ApiConstants.addCardEndpoint),
          body: json.encode({
            StringConstants.studentId: stuId,
            StringConstants.cardCode: cardCode
          }));
      debugPrint(jsonDecode(checkPhoneRes.body).toString());
      if (checkPhoneRes.statusCode == 200) {
        if (jsonDecode(checkPhoneRes.body)["status"] == "success") {
          message = jsonDecode(checkPhoneRes.body)["massage"];

          emit(AddCardLoaded(
              message: jsonDecode(checkPhoneRes.body)["massage"]));
        } else {
          message = jsonDecode(checkPhoneRes.body)["massage"];

          emit(AddCardFailure(
              errorMessage: jsonDecode(checkPhoneRes.body)["massage"]));
        }
      } else {
        message = jsonDecode(checkPhoneRes.body)["massage"];

        emit(AddCardFailure(
            errorMessage: jsonDecode(checkPhoneRes.body)["massage"]));
      }
    } on SocketException {
      message = tr(StringConstants.noInternet);

      emit(AddCardFailure(errorMessage: tr(StringConstants.noInternet)));
    } catch (e) {
      message = tr(StringConstants.errorWhenResponse);

      emit(AddCardFailure(errorMessage: tr(StringConstants.errorWhenResponse)));
    }
    return message;
  }
}
