import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/models/get_chapter_content.dart';
import 'package:ts_academy/models/select_course_comments.dart';
import 'package:ts_academy/network/dio_helper.dart';
import 'package:ts_academy/network/end_points.dart';
import 'package:ts_academy/screens/new_course_content/cubit/states.dart';

class CourseContentCubit extends Cubit<CourseContentStates> {
  CourseContentCubit() : super(CourseContentInitialState());

  static CourseContentCubit get(context) => BlocProvider.of(context);

  int pdfCount = 0;
  int videoCount = 0;
  int musicCount = 0;
  ChapterContent? chapterContent;
  Future<void> getChapterContent({
    required String chapterId,
  }) async {
    emit(GetChapterContentLoadingState());
    await DioHelper.getData(
      url: CHAPTERCONTENT,
      baseUrl: BASEURL,
      query: {
        "chapter_id": chapterId,
      },
    ).then((value) async {
      chapterContent = ChapterContent.fromJson(json.decode(value.data));
      pdfCount = 0;
      videoCount = 0;
      musicCount = 0;
      for (final content in chapterContent!.massage!) {
        final type = content.type;
        switch (type) {
          case 'pdf':
            pdfCount++;
            break;
          case 'video':
            videoCount++;
            break;
          case 'music':
            musicCount++;
            break;
          default:
            break;
        }
      }
      emit(GetChapterContentSuccessState(chapterContent!));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['massage'];
          emit(GetChapterContentErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(GetChapterContentErrorState(
              'Please check the Internet connection and try again.'));
        }
      } else {
        emit(GetChapterContentErrorState(
            'An error occurred. Please try again.'));
      }
    });
  }

  //PodPlayerController? controller;
  int currentContentIndex = 0;
  Future<void> changeContentIndex(
      {required int index, required bool own}) async {
    currentContentIndex = index;
    emit(ChangeCurrentContentIndex());
  }

  bool isScreenSplitted = false;
  String currentLinkPdfWithSplittedScreen = "";
  void changeSplitScreen({required bool value, required String pdfLink}) {
    isScreenSplitted = value;
    currentLinkPdfWithSplittedScreen = pdfLink;
    emit(ChangeSplitScreenState());
  }

  CourseCommentsModel? courseCommentsModel;
  Future<void> getCourseComments({
    required String courseId,
  }) async {
    emit(GetCourseCommentsLoadingState());
    await DioHelper.getData(
      url: COURSECOMMENTS,
      baseUrl: BASEURL,
      query: {
        "course_id": courseId,
      },
    ).then((value) async {
      courseCommentsModel =
          CourseCommentsModel.fromJson(json.decode(value.data));
      emit(GetCourseCommentsSuccessState(courseCommentsModel!));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['massage'];
          emit(GetCourseCommentsErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(GetCourseCommentsErrorState(
              'Please check the Internet connection and try again.'));
        }
      } else {
        emit(GetCourseCommentsErrorState(
            'An error occurred. Please try again.'));
      }
    });
  }

  Future<void> makeCommentOnCourseContent({
    required String courseId,
    required String commentDetails,
  }) async {
    emit(MakeCourseCommentLoadingState());
    await DioHelper.postData(
      url: MAKECOMMENTTOCOURSECONTENT,
      baseUrl: BASEURL,
      data: {
        "student_id": stuId,
        "course_id": courseId,
        "comment_details": commentDetails,
      },
    ).then((value) async {
      final resp = json.decode(value.data);
      if (resp["status"] == "success") {
        getCourseComments(courseId: courseId);
        emit(MakeCourseCommentSuccessState(resp["massage"]));
      } else {
        emit(MakeCourseCommentErrorState(
            'An error occurred. Please try again.'));
      }
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['massage'];
          emit(MakeCourseCommentErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(MakeCourseCommentErrorState(
              'Please check the Internet connection and try again.'));
        }
      } else {
        emit(MakeCourseCommentErrorState(
            'An error occurred. Please try again.'));
      }
    });
  }

  bool keyboard = false;
  changeKeyboard(bool val) {
    keyboard = val;
    emit(ChangeKeyboardValue());
  }
}
