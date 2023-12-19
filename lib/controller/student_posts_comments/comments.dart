import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/models/new_comments_model.dart';
import 'package:ts_academy/models/reply_model.dart';
import 'package:ts_academy/network/dio_helper.dart';
import 'package:ts_academy/network/end_points.dart';

import '../../constants/api_constants.dart';
import '../../constants/constants.dart';
import '../../constants/string_constants.dart';
import '../../models/posts_comment_model.dart';
import 'package:http/http.dart' as http;
part 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit() : super(GetCommentsInitial());

  static CommentsCubit get(context) => BlocProvider.of(context);

  List<PostComments> commentList = [];

  Future<void> getComments(String postId) async {
    emit(GetCommentsLoading());
    try {
      http.Response response = await http.get(Uri.parse("${ApiConstants.selectPostsComments}?post_id=$postId"));
      final responseData = jsonDecode(response.body)['massage'];
      if (response.statusCode == 200) {
        commentList = List<PostComments>.from((responseData as List).map((e) => PostComments.fromjson(e)));
        emit(GetCommentsLoaded());
      } else {
        emit(GetCommentsFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(GetCommentsFailure(message: tr(StringConstants.noInternet)));
    } catch (e) {
      emit(GetCommentsFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }

  Future<void> addCommentInPosts({
    required String comment,
    required TextEditingController controller,
    required String postId,
    required String studentId,
  }) async {
    emit(InsertPostCommentsLoading());
    try {
      http.Response response = await http.post(Uri.parse(ApiConstants.insertCommentToPost),
          body: json.encode({'student_id': studentId, 'comment_details': comment, 'post_id': postId}));
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'] == 'success') {
          controller.clear();
          emit(InsertPostCommentsLoaded(message: jsonDecode(response.body)['massage']));
        } else {
          emit(InsertPostCommentsFailure(message: jsonDecode(response.body)['massage']));
        }
      } else {
        emit(InsertPostCommentsFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(InsertPostCommentsFailure(message: tr(StringConstants.noInternet)));
    } catch (e) {
      emit(InsertPostCommentsFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }

  NewCommentsModel? newCommentsModel;
  Future<void> getCommentsNew({
    required String postID,
  }) async {
    emit(GetCommentsLoadingState());
    try{
      await DioHelper.postData(
          url: SELECTPOSTCOMMENTS,
          baseUrl: BASEURL,
          data: {
            "post_id": postID,
            "user_id": stuId,
          }
      ).then((value) async {
        newCommentsModel = NewCommentsModel.fromJson(json.decode(value.data));
        emit(GetCommentsSuccessState(newCommentsModel!));
      }).catchError((error) {
        if (error is DioException) {
          if (error.response?.statusCode == 400) {
            final responseData = error.response?.data;
            final errorMessage = responseData['massage'];
            emit(GetCommentsErrorState(errorMessage));
          } else {
            // Handle other DioError cases
            emit(GetCommentsErrorState('Please check the Internet connection and try again.'));
          }
        } else {
          // Handle non-DioError cases
          debugPrint(error.toString());
          emit(GetCommentsErrorState('An error occurred. Please try again.'));
        }
      });
    }catch(e) {
      debugPrint(e.toString());
    }
  }

  ReplyModel? replyModel;
  Future<void> getReplies({
    required String commentID,
  }) async {
    emit(GetRepliesLoadingState());
    await DioHelper.postData(
        url: SELECTCOMMENTREPLIES,
        baseUrl: BASEURL,
        data: {
          "comment_id": commentID,
          "user_id": stuId,
        }
    ).then((value) async {
      replyModel = ReplyModel.fromJson(json.decode(value.data));
      emit(GetRepliesSuccessState(replyModel!));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['massage'];
          emit(GetRepliesErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(GetRepliesErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(GetRepliesErrorState('An error occurred. Please try again.'));
      }
    });
  }

  Future<void> makeReply({
    required String reply,
    required String commentId,
    required String mainCommentId,
  }) async {
    emit(MakeReplyLoadingState());
    await DioHelper.postData(
        url: MAKEREPLY,
        baseUrl: BASEURL,
        data: {
          "student_id": stuId,
          "reply_data": reply,
          "comment_id": commentId,
        }
    ).then((value) async {
      final res = json.decode(value.data);
      await getReplies(commentID: mainCommentId);
      emit(MakeReplySuccessState(res["massage"]));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['massage'];
          emit(MakeReplyErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(MakeReplyErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(MakeReplyErrorState('An error occurred. Please try again.'));
      }
    });
  }

  Future<void> deleteComment({
    required String commentId,
    required String postId,
  }) async {
    emit(DeleteCommentLoadingState());
    await DioHelper.postData(
        url: DELETECOMMENT,
        baseUrl: BASEURL,
        data: {
          "comment_id": commentId,
        }
    ).then((value) async {
      final res = json.decode(value.data);
      await getCommentsNew(postID: postId);
      emit(DeleteCommentSuccessState(res["massage"]));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['massage'];
          emit(DeleteCommentErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(DeleteCommentErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(DeleteCommentErrorState('An error occurred. Please try again.'));
      }
    });
  }

  Future<void> deleteReply({
    required String replyId,
    required String mainCommentId,
  }) async {
    emit(DeleteReplyLoadingState());
    await DioHelper.postData(
        url: DELETEREPLY,
        baseUrl: BASEURL,
        data: {
          "reply_id": replyId,
        }
    ).then((value) async {
      final res = json.decode(value.data);
      await getReplies(commentID: mainCommentId);
      emit(DeleteReplySuccessState(res["massage"]));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['massage'];
          emit(DeleteReplyErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(DeleteReplyErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(DeleteReplyErrorState('An error occurred. Please try again.'));
      }
    });
  }

  Future<void> reportReply({
    required String replyId,
    required String mainCommentId,
  }) async {
    emit(ReportReplyLoadingState());
    await DioHelper.postData(
        url: REPORTREPLY,
        baseUrl: BASEURL,
        data: {
          "reply_id": replyId,
          "user_id": stuId,
          "reason": "",
        }
    ).then((value) async {
      final res = json.decode(value.data);
      await getReplies(commentID: mainCommentId);
      emit(ReportReplySuccessState(res["massage"]));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['massage'];
          emit(ReportReplyErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(ReportReplyErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(ReportReplyErrorState('An error occurred. Please try again.'));
      }
    });
  }

  Future<void> reportComment({
    required String commentId,
    required String postId,
  }) async {
    emit(ReportCommentLoadingState());
    await DioHelper.postData(
        url: REPORTCOMMENT,
        baseUrl: BASEURL,
        data: {
          "comment_id": commentId,
          "user_id": stuId,
          "report_reason": "",
        }
    ).then((value) async {
      final res = json.decode(value.data);
      await getCommentsNew(postID: postId);
      emit(ReportCommentSuccessState(res["massage"]));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['massage'];
          emit(ReportCommentErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(ReportCommentErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(ReportCommentErrorState('An error occurred. Please try again.'));
      }
    });
  }

  TextEditingController newCommentController = TextEditingController();
  Future<void> editComment({
    required String commentId,
    required String postId,
  }) async {
    emit(EditCommentLoadingState());
    await DioHelper.postData(
        url: UPDATECOMMENT,
        baseUrl: BASEURL,
        data: {
          "comment_id": commentId,
          "value": newCommentController.text,
        }
    ).then((value) async {
      final res = json.decode(value.data);
      await getCommentsNew(postID: postId);
      emit(EditCommentSuccessState(res["massage"]));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['massage'];
          emit(EditCommentErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(EditCommentErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(EditCommentErrorState('An error occurred. Please try again.'));
      }
    });
  }

  TextEditingController newReplyController = TextEditingController();
  Future<void> editReply({
    required String replyId,
    required String userMentioned,
    required String mainCommentId,
  }) async {
    emit(EditReplyLoadingState());
    await DioHelper.postData(
        url: UPDATEREPLY,
        baseUrl: BASEURL,
        data: {
          "reply_id": replyId,
          "value": "$userMentioned **${newReplyController.text}",
        }
    ).then((value) async {
      final res = json.decode(value.data);
      await getReplies(commentID: mainCommentId);
      emit(EditReplySuccessState(res["massage"]));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['massage'];
          emit(EditReplyErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(EditReplyErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        // Handle non-DioError cases
        debugPrint(error.toString());
        emit(EditReplyErrorState('An error occurred. Please try again.'));
      }
    });
  }
}
