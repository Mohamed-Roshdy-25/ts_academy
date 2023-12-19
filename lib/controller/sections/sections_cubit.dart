import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/constants/api_constants.dart';
import '/constants/constants.dart';
import '/constants/string_constants.dart';
import '/controller/sections/sections_states.dart';

import 'package:http/http.dart' as http;
import '/models/sections_model.dart';
class SectionsCubit extends Cubit<SectionsStates>{
  SectionsCubit() : super(GetSectionsInitial());


  List<SectionsModel>  sections = [];


  Future<void> getSectionsForSpecificQuiz(
  {
    required String quizId, 
}
      )  async {
    sections.clear();
    emit(GetSectionsLoading());
    try {
      http.Response res= await http.get(Uri.parse('${ApiConstants.sectionsForQuizzes}?quiz_id=$quizId&student_id=$stuId'));


      if(res.statusCode ==200 ) {

        sections = List<SectionsModel>.from(
            (jsonDecode(res.body)["massage"] as List).map((e) => SectionsModel.fromJson(e)));
       debugPrint(
         sections.length.toString()
       );
        emit(GetSectionsSuccessfully());

      }
    }on SocketException {
      emit(GetSectionsFailure(message: tr(StringConstants.noInternet)));

    }
    catch(e) {
      debugPrint(
       e.toString()
      );
      emit(GetSectionsFailure(message: tr(StringConstants.errorWhenResponse)));

    }

    
    
    
    
  }

}