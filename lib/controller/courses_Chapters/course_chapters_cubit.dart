import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/constants/constants.dart';

import '../../constants/api_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/course_chapters_model.dart';
import 'package:http/http.dart' as https;

part 'course_chapters_state.dart';

class CourseChaptersCubit extends Cubit<CourseChaptersState> {
  CourseChaptersCubit() : super(CourseChaptersInitial());
  List<CourseChapters> allStudentCourses = [];
  Future getAllStudentCourses(
    String courseId,
  ) async {
    try {
      emit(CourseChaptersLoading());
      final https.Response response = await https.post(Uri.parse(ApiConstants.courseChaptersEndpoint),
          body: json.encode({
            "course_id": courseId,
            "student_id": stuId,
          }));

      debugPrint(response.body.toString());
      final responseData = jsonDecode(response.body)["massage"];
      if (response.statusCode == 200) {
        allStudentCourses = List<CourseChapters>.from((responseData as List)
            .map((e) => CourseChapters.fromjson(e))
            /*.where((course) => course.own == false && course.hidden == "no")*/);
        print(allStudentCourses.toString());
        emit(CourseChaptersLoaded());
      } else {
        emit(CourseChaptersFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(CourseChaptersFailure(message: tr(StringConstants.noInternet)));
    } catch (e) {
      emit(CourseChaptersFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }
}
