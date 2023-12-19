import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../constants/api_constants.dart';

part 'live_token_state.dart';

class LiveTokenCubit extends Cubit<LiveTokenState> {
  LiveTokenCubit() : super(LiveTokenInitial());

  Future<String> getLiveToken() async {
    emit(LiveTokenLoading());
    try {
      http.Response response = await http.get(
        Uri.parse(
          ApiConstants.rtcToken,
        ),
      );
      if (response.statusCode == 200) {
        emit(LiveTokenLoaded());

        return json.decode(response.body)['data']['RTC_TOKEN'];
      }
    } on SocketException {
    } catch (e) {}
    emit(LiveTokenFailure());
    return '';
  }
}
