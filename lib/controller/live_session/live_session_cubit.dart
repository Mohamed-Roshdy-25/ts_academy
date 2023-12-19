
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../constants/api_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/live_session_model.dart';

part 'live_session_state.dart';

class LiveSessionCubit extends Cubit<LiveSessionState> {
  LiveSessionCubit() : super(LiveSessionInitial());

  List<LiveSessionModel>liveSessionList=[];
  Future<void> getLiveSessionInfo(String studentID) async {
    emit(GetLiveSessionInfoLoading());
    try {
      http.Response response = await http.get(
          Uri.parse("${ApiConstants.getLiveSessionInfo}?student_id=$studentID"));
      final responseData = jsonDecode(response.body)['massage'];
      if (response.statusCode == 200) {
        if(jsonDecode(response.body)["status"]=="success"){
          liveSessionList = List<LiveSessionModel>.from(
              (responseData as List).map((e) => LiveSessionModel.fromJson(e)));
          emit(GetLiveSessionInfoLoaded());
        }else{
          emit(GetLiveSessionInfoFailure(message: jsonDecode(response.body)["status"]));
        }
      } else {
        emit(GetLiveSessionInfoFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(GetLiveSessionInfoFailure(message:tr( StringConstants.noInternet)));
    } catch (e) {
      emit(GetLiveSessionInfoFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }

}
