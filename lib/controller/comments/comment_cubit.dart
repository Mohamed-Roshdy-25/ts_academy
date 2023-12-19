import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:bloc/bloc.dart';
import '../../constants/api_constants.dart';
import '../../constants/constants.dart';
import '../../constants/string_constants.dart';
import '../../models/comment_model.dart';
part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentInitial());
  List<CommentModel> commentsList = [];

  addCommentList( CommentModel model)  {
    commentsList.add(model);
    emit(AddedSucceffuly());
  }

  Future<void> getComments(String courseId) async {
    emit(CommentLoading());
    try {
      final https.Response response = await https.get(
          Uri.parse("${ApiConstants.getCommentsEndPoint}?course_id=$courseId"));
      final responseData = jsonDecode(response.body)["massage"];
      if (response.statusCode == 200) {
        commentsList = List<CommentModel>.from(
            (responseData as List).map((e) => CommentModel.fromjson(e)));
        emit(CommentLoaded());
        debugPrint(commentsList.toString());
        print("comments done");
      } else {
        print("eror get comments");
        emit(CommentFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      print("eror get comments");
      emit(CommentFailure(message: tr(StringConstants.errorWhenResponse)));
    } catch (e) {
      print("eror get comments");
      emit(CommentFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }

  // Stream<List<CommentModel>> getStreamComments() {
  //   return Stream.fromIterable([commentsList]);
  // }

  Future<void> addComment(
      {required String commentDetails,
      required String stuId,
      required String courseId}) async {
    String message = "";
    emit(InsertCourseCommentLoading());

    try {
      https.Response checkPhoneRes =
          await https.post(Uri.parse(ApiConstants.postCommentsEndPoint),
              body: json.encode({
                StringConstants.studentId: stuId,
                StringConstants.courseId: courseId,
                StringConstants.commentDetails: commentDetails,
              }));
      debugPrint(jsonDecode(checkPhoneRes.body).toString());
      if (checkPhoneRes.statusCode == 200) {
        if (jsonDecode(checkPhoneRes.body)["status"] == "success") {
          message = jsonDecode(checkPhoneRes.body)["massage"];
         addCommentList(
              CommentModel(
                  studentPhoto:stuPhoto??"" ,
                  studentName: myName??"",
                  studentId: stuId,
                  date: null,
                  commentId: null,
                  commentDetails:commentDetails ,
                  courseId:  null,
                  postId: "0"

              )
          );
          emit(InsertCourseCommentLoaded(message: message));
        } else {
          message = jsonDecode(checkPhoneRes.body)["massage"];
          emit(InsertCourseCommentFailure(message: message));
        }
      } else {
        emit(InsertCourseCommentFailure(
            message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(InsertCourseCommentFailure(message: tr(StringConstants.errorWhenResponse)));
    } catch (e) {
      emit(InsertCourseCommentFailure(
          message: tr(StringConstants.errorWhenResponse)));
    }
  }

  clearTextField(TextEditingController controller) {
    controller.clear();
    emit(ClearTextFieldState());
  }
}
