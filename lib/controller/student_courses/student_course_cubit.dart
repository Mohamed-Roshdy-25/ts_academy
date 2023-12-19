import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as https;
import 'package:ts_academy/models/get_student_courses.dart';
import '../../constants/api_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/std_courses_model.dart';
part 'student_course_state.dart';

class StudentCourseCubit extends Cubit<StudentCourseState> {
  StudentCourseCubit() : super(StudentCourseInitial());
  List<StudentCoursesModel> allStudentCourses = [];
  Courses? studentSubscribedCourses;
  Future getAllStudentCourses(String studentId,String chainId) async {
    try {
    emit(StudentCourseLoading());
    final https.Response response = await https.post(Uri.parse(
        "${ApiConstants.studentCoursesEndpoint}"),
    body:  jsonEncode( {
      "student_id":studentId,
      "chain_id":chainId
    })
    );
    final responseData = jsonDecode(response.body)["massage"];
    if (response.statusCode == 200) {
      allStudentCourses = List<StudentCoursesModel>.from((responseData as List).map((e) => StudentCoursesModel.fromjson(e)));
      List<Map<String, dynamic>> filteredCourses = responseData.where((element) => element["own"] == true || element["free"] == "1").map((element) => element as Map<String, dynamic>).toList();
      studentSubscribedCourses = Courses.fromJson({"massage": filteredCourses});
      debugPrint(" StudentCourseCubit  ,,,,,,,,,,,,,,, "+ studentSubscribedCourses.toString());
      emit(StudentCourseLoaded());
    } else {
      emit(StudentCourseFailure(tr(StringConstants.errorWhenResponse)));
    }
    } on SocketException {
      emit(StudentCourseFailure(tr(StringConstants.noInternet)));
    } catch (e) {
      emit(StudentCourseFailure(tr(StringConstants.errorWhenResponse)));
    }
  }
}
