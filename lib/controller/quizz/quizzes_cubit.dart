import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/constants/constants.dart';
import '/models/quizzes_model.dart';
import 'package:http/http.dart' as https;
import '../../constants/api_constants.dart';
import '../../constants/string_constants.dart';
part 'quizzes_state.dart';

class QuizzesCubit extends Cubit<QuizzesState> {
  QuizzesCubit() : super(QuizzesInitial());
  List<QuizzModel> completedQuizzesList = [];
  List<QuizzModel> notCompleted = [];
  Future getALlQuizzes({required String courseId}) async {
    try {
      completedQuizzesList.clear();
      notCompleted.clear();
      emit(QuizzesLoading());
      final https.Response response = await https.get(Uri.parse(
          "${ApiConstants.quizzesEndpoint}?student_id=$stuId&course_id=$courseId"));
      final responseData =
      jsonDecode(response.body)["message"];
      if (response.statusCode == 200) {
        completedQuizzesList = List<QuizzModel>.from(
            (responseData["old_quizzes_array"] as List).map((e) => QuizzModel.fromjson(e)));
        notCompleted = List<QuizzModel>.from(
            (responseData["new_quizzes_array"] as List).map((e) => QuizzModel.fromjson(e)));
        emit(QuizzesLoaded());
      } else {
        emit(QuizzesFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(QuizzesFailure(message: tr(StringConstants.noInternet)));
    } catch (e) {
      emit(QuizzesFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }

  Future<void> delete({required String quizId}) async {
    emit(DeleteQuizLoading());

    try {
      final https.Response response = await https.get(Uri.parse(
          "${ApiConstants.deleteQuizEndPoint}?quiz_id=$quizId&student_id=$stuId"));
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData["status"] == "success") {
          emit(DeleteQuiz(message: responseData["massage"]));
        } else {
          emit(DeleteQuizFailure(message: responseData["massage"]));
        }
      } else {
        emit(DeleteQuizFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(DeleteQuizFailure(message: tr(StringConstants.noInternet)));
    } catch (e) {
      emit(DeleteQuizFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }
}
