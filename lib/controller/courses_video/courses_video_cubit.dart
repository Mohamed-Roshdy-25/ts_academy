import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as https;
import 'package:webview_flutter/webview_flutter.dart';
import '../../constants/api_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/course_video_model.dart';

part 'courses_video_state.dart';

class CoursesVideoCubit extends Cubit<CoursesVideoState> {
  CoursesVideoCubit() : super(GetCoursesVideoInitial());
  List<CourseVideoModel> allCoursesData = [];
  List<CourseVideoModel> videosCoursesData = [];
  List<CourseVideoModel> audiosCoursesData = [];
  List<CourseVideoModel> pdfCoursesData = [];
  Future getAllCourses(String chapterId) async {
    
    debugPrint("loading");
    videosCoursesData.clear();
    audiosCoursesData.clear();
    pdfCoursesData.clear();
    emit(GetCoursesVideoLoading());
    try {
      final https.Response response =
          await https.get(Uri.parse("${ApiConstants.videoCourseEndpoint}?chapter_id=$chapterId"));
      final responseData = jsonDecode(response.body)["massage"];
      if (response.statusCode == 200) {
        allCoursesData = List<CourseVideoModel>.from((responseData as List).map((e) => CourseVideoModel.fromjson(e)));
        for (int i = 0; i < allCoursesData.length; i++) {
          if (allCoursesData[i].type.toString().toLowerCase() == "video") {
            videosCoursesData.add(allCoursesData[i]);
          } else if (allCoursesData[i].type.toString().toLowerCase() == "audio") {
            audiosCoursesData.add(allCoursesData[i]);
          } else {
            pdfCoursesData.add(allCoursesData[i]);
          }
        }
        emit(GetCoursesVideoLoaded());
      } else {
        debugPrint("error");
      
        emit(GetCoursesVideoFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(GetCoursesVideoFailure(message: tr(StringConstants.noInternet)));
    } catch (e) {
      emit(GetCoursesVideoFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }

  String link = "";
  String description = "";
  String type = "";
  String title = "";
  Future<void> changeLinks(String newLink, String newDescription, String newType, String newTitle) async {
    emit(ChangeLinksLoading());
    try {
      link = newLink;
      description = newDescription;
      type = newType;
      title = newTitle;
      emit(ChangeLinksSuccess());
    } catch (e) {
      emit(ChangeLinksFailure());
    }
  }

  int videoIndex = 0;
  void changeIndexOfVideo(int v) {
    videoIndex = v;
    emit(ChangeIndexOfVideoState());
  }

  Widget setWebViewAsset({required WebViewController controller, required String videoUrl,required double height}) {
    controller.loadRequest(Uri.parse(videoUrl));
    emit(VideoLoadedInWebView());
    return SizedBox(height: 180, child: WebViewWidget(controller: controller));
  }
}
