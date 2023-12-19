import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants/api_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/stutent_posts.dart';
part 'student_posts_state.dart';

class StudentPostsCubit extends Cubit<StudentPostsState> {
  StudentPostsCubit() : super(StudentPostsInitial());

  List<StudentPosts> stdPost = [];
  List<bool> stdPostLikes = [];
  List<int> numberLikes = [];



 void changeLike( index ) {

    stdPostLikes[index] = !stdPostLikes[index];
    if(stdPostLikes[index] == false)  {
      numberLikes[index] -- ;
    }else{
      numberLikes[index] ++  ;
    }
    emit(ChangeLikesBool ( ) );
  }



  Future<void> getAllPosts({required String stuId}) async {
    emit(StudentPostsLoading());
    try {
      final http.Response response = await http
          .get(Uri.parse('${ApiConstants.selectAllPosts}?student_id=$stuId'));
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        stdPost = List<StudentPosts>.from(
            (responseData as List).map((e) => StudentPosts.fromjson(e)));
        stdPostLikes = List<bool>.from(stdPost.map((e) => e.isLike));
        numberLikes = List<int>.from(stdPost.map((e) => int.parse(e.likesCount)));
        debugPrint("list of Likes  =  ${stdPostLikes.toString()}");
        emit(StudentPostsLoaded());
      } else {
        emit(StudentPostsFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(StudentPostsFailure(message: tr(StringConstants.noInternet)));
    } catch (e) {
      emit(StudentPostsFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }

  String changeLikeStatus = "";
  String postId = "";
  Future<void> changeLikeCount(
      {required String studentId, required String postId}) async {
    emit(ChangeLikeCountLoading());
    try {
      http.Response response = await http.post(
          Uri.parse(ApiConstants.changeLike),
          body: jsonEncode({"student_id": studentId, "post_id": postId}));
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status'] == "success") {
          changeLikeStatus = responseData['massage'];
          postId = responseData['post_id'];
          emit(ChangeLikeCountSuccess());
        }
      } else {
        emit(ChangeLikeCountFailure());
      }
    } on SocketException {
      emit(ChangeLikeCountFailure());
    } catch (e) {
      emit(ChangeLikeCountFailure());
    }
  }


  String modifiedUrl = "";
  String imageUrl = "";
  Future<void> uploadFile(File file, BuildContext context) async {

    // Prepare the request
  try{  var request = http.MultipartRequest(
    'POST',
    Uri.parse(ApiConstants.getImagePath),
  );

  // Add the file to the request
  var fileStream = http.ByteStream(Stream.castFrom(file.openRead()));
  var length = await file.length();
  var multipartFile = http.MultipartFile(
    'image',
    fileStream,
    length,
    filename: file.path.split('/').last,
  );
  request.files.add(multipartFile);

  // Send the request and get the response
  var response = await request.send();

  // Check if the request was successful
  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(responseData);
    debugPrint(" ${jsonResponse['massage']}");
    if (jsonResponse["status"] == "success") {
        imageUrl += "${jsonResponse['massage']}**camp**";
        modifiedUrl =
            imageUrl.replaceAll(RegExp(r"\*\*camp\*\*([^*]*)$"), "");
     debugPrint("imageUrl $modifiedUrl");
  } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(jsonResponse["massage"]),
        ));
  }   } }else{

  if(context.mounted)  {
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      backgroundColor: Colors.red,
      content: Text(tr(StringConstants.problemWentWrong)),
    ));
  }

  }
  }on SocketException {
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      backgroundColor: Colors.red,
      content: Text(tr(StringConstants.noInternet)),
    ));
  } catch(e){
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      backgroundColor: Colors.red,
      content: Text(tr(StringConstants.problemWentWrong)),
    ));
  }
  }


  Future<File> platformFileToFile(PlatformFile platformFile) async {
    final path = platformFile.path;
    final file = File(path!);
    return file;
  }
  Future<void> uploadFilesToServer(List platformFiles , BuildContext context, String post) async {
    debugPrint("start uploadFilesToServer");
    imageUrl = "" ;
    modifiedUrl="";
    emit(UploadFilesLoading());
    debugPrint("start UploadFilesLoading");

    try {


    for (var platformFile  in platformFiles) {
      File file = await platformFileToFile(platformFile);
     if(context.mounted) {
       await uploadFile(file,context);
     }
    }
    emit(UploadFilesSuccess());
    createPosts(postContent: post, imagesPaths:modifiedUrl);
  }on SocketException  {
      emit(UploadFilesFailure(
          tr(StringConstants.noInternet)
      ));
    }catch(e) {
      debugPrint("error is ${e.toString()}");
    emit(UploadFilesFailure(
      tr(StringConstants.errorWhenResponse)
    ));

  }
  }

  Future<void> createPosts(
      {required String postContent, required String imagesPaths}) async {
    emit(CreatePostsLoading());
    try {
      http.Response res = await http.post(Uri.parse(ApiConstants.insertPost),
          body:
          jsonEncode({"post_content": postContent, "images": imagesPaths}));

      print(jsonDecode(res.body));
      String responseData = jsonDecode(res.body)['massage'].toString();
      if (res.statusCode == 200) {
        if (jsonDecode(res.body)['status'] == "success") {
          emit(CreatePostsLoaded(message: responseData));
        } else {
          emit(CreatePostsFailure(message: responseData));
        }
      } else {
        emit(CreatePostsFailure(message:  tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(CreatePostsFailure(message: tr(StringConstants.noInternet)));
    } catch (E) {
      // throw Exception();
      debugPrint(E.toString());
      emit(CreatePostsFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }

}
