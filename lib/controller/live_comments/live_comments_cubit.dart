
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../constants/api_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/live_comments_model.dart';
part 'live_comments_state.dart';

class LiveCommentsCubit extends Cubit<LiveCommentsState> {
  LiveCommentsCubit() : super(LiveCommentsInitial());
List<LiveCommentModel>commentsList=[];
  Future<void> getLiveComments(String studentID) async {
    emit(GetLiveCommentsLoading());
    // try {
      http.Response response = await http.post(
          Uri.parse("${ApiConstants.getLiveComments}"),body: jsonEncode(
        {"student_id":studentID}
      ));
      final responseData = jsonDecode(response.body)['massage'];
      if (response.statusCode == 200) {
        if(jsonDecode(response.body)["status"]=="success"){
          commentsList = List<LiveCommentModel>.from(
              (responseData as List).map((e) => LiveCommentModel.fromJson(e)));
          emit(GetLiveCommentsLoaded());
        }else{
          emit(GetLiveCommentsFailure(message: jsonDecode(response.body)["status"]));
        }
      } else {
        emit(GetLiveCommentsFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    // } on SocketException {
    //   emit(GetLiveCommentsFailure(message: StringConstants.noInternet));
    // } catch (e) {
    //   emit(GetLiveCommentsFailure(message: StringConstants.errorWhenResponse));
    // }
  }
  Future<void> addCommentInLive(
      {required String comment,
        required TextEditingController controller,
        required String liveId,
        required String studentId}) async {
    emit(InsertLiveCommentsLoading());
    try {
      http.Response response = await http.post(
          Uri.parse(ApiConstants.insertCommentToLive),
          body: json.encode({
            'student_id': studentId,
            'comment_details': comment,
            'live_id': liveId
          }));
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'] == 'success') {
          controller.clear();
          emit(InsertLiveCommentsLoaded(
              message: jsonDecode(response.body)['massage']));
        } else {
          emit(InsertLiveCommentsFailure(
              message: jsonDecode(response.body)['massage']));
        }
      } else {
        emit(InsertLiveCommentsFailure(
            message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(InsertLiveCommentsFailure(message:tr( StringConstants.noInternet)));
    } catch (e) {
      emit(InsertLiveCommentsFailure(
          message: tr(StringConstants.errorWhenResponse)));
    }
  }

  addCommentToList(LiveCommentModel comment) {
    commentsList.add(comment);
    emit(AddCommentToListState());
  }
}
