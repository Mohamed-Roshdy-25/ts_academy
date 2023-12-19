import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
part 'generate_tokenn_state.dart';

class GenerateTokenCubit extends Cubit<GenerateTokenState> {
  GenerateTokenCubit() : super(GenerateTokenInitial());
  String token = "";
  Future<void> generateToken(
      {required String stuId,
      required String channelName,
      required String role,
      required String tokenType}) async {
    emit(GenerateTokenLoading());
    try {
      http.Response response = await http.get(Uri.parse(
          'https://ts-agoura-3b0922cdb0f4.herokuapp.com/rtc/$channelName/$role/$tokenType/$stuId/'));
      // https://ts-agoura-3b0922cdb0f4.herokuapp.com/rtc/testmeet/publisher/userAccount/222/
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        token = responseData['rtcToken'];
        emit(GenerateTokenLoaded());
      } else {
        emit(GenerateTokenFailure(message: 'errorWhenResponse'));
      }
    } on SocketException {
      emit(GenerateTokenFailure(message: "errorWhenResponse"));
    } catch (e) {
      emit(GenerateTokenFailure(message: "errorWhenResponse"));
    }
  }
}
