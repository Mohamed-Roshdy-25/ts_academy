import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/api_constants.dart';
import '../../constants/constants.dart';
import '../../constants/string_constants.dart';
import '../../models/student_ticket.dart';
import 'package:http/http.dart' as http;
part 'struden_ticket_state.dart';

class StudentTickerCubit extends Cubit<StudentTicketState> {
  StudentTickerCubit() : super(StudentTicketInitial());
  List<StudentTicket> allTicket = [];

  String ? ticketPhoto ;
  Future<void> getAllTicket() async {
    emit(StudentTicketLoading());
    try {
      final http.Response response = await http
          .get(Uri.parse('${ApiConstants.selectAllTickets}?student_id=$stuId'));
      final responseData = jsonDecode(response.body)["massage"];
      if (response.statusCode == 200) {
        allTicket = List<StudentTicket>.from(
            (responseData as List).map((e) => StudentTicket.fromjson(e)));
        emit(StudentTicketLoaded());
      } else {
        emit(StudentTicketFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(StudentTicketFailure(message: tr(StringConstants.noInternet)));
    } catch (e) {
      emit(StudentTicketFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }

  Future<void> getImagePath(XFile ?image) async {
    emit(GetImagePathLoading());
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(ApiConstants.getImagePath),
      );

      if (image != null) {
        var fileStream2 = http.ByteStream(Stream.castFrom(image.openRead()));
        var length2 = await image.length();
        var multipartFile2 = http.MultipartFile('image', fileStream2, length2,
            filename: image.path);
        request.files.add(multipartFile2);
      }

      final http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(await response.stream.bytesToString());

        if (responseJson['status'] == "success") {
          ticketPhoto = responseJson['massage'];
          debugPrint(ticketPhoto);
          emit(GetImagePathLoaded());
        } else {
          emit(GetImagePathFailure(tr(StringConstants.noInternet)));
        }
      } else {
        emit(GetImagePathFailure(tr(StringConstants.problemWentWrong)));
      }
    } on SocketException {
      emit(GetImagePathFailure(tr(StringConstants.problemWentWrong)));
    } catch (e) {
      emit(GetImagePathFailure(tr(StringConstants.problemWentWrong)));
    }
  }

  Future<void> insertTicket({
    required String fullName,
    required String reason,
    required String issues,
    required String photo,
  }) async {
    emit(InsertStudentTicketLoading());
    try {
      final http.Response response =
          await http.post(Uri.parse(ApiConstants.insertTicket),
              body: json.encode({
                "student_id": "$stuId",
                "full_name": fullName.toString(),
                "reason": reason.toString(),
                "issues": issues.toString(),
                "photo_url": photo.toString(),
              }));
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status'] == "success") {
          emit(InsertStudentTicketLoaded(message: responseData['massage']));
        } else {
          emit(InsertStudentTicketFailure(message: responseData['massage']));
        }
      } else {
        emit(InsertStudentTicketFailure(
            message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(InsertStudentTicketFailure(message: tr(StringConstants.noInternet)));
    } catch (e) {
      emit(InsertStudentTicketFailure(
          message: tr(StringConstants.errorWhenResponse)));
    }
  }
}
