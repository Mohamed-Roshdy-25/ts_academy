
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '/constants/string_constants.dart';
import '/controller/questuons_for_each_section/question_for_each_section_states.dart';

import '../../constants/api_constants.dart';
import '../../constants/constants.dart';
import '../../models/question_answer_model.dart';

class QuestionAndAnswerCubit extends Cubit<QuestionAndAnswerStates> {
  QuestionAndAnswerCubit() : super(QuestionAndAnswerInitial());



List<QuestionAndAnswer>  questionsAndAnswer  = [] ;


int ?selectedAnswer;


Future<void> getQuestionsAndAnswer(
  {
    required String sectionId,
}
    )  async{
  questionsAndAnswer =[ ];

  try{
    emit(QuestionAndAnswerLoading());


    http.Response res= await http.get(
      Uri.parse("${ApiConstants.questionAndAnswerEnpPointForSection}?section_id=$sectionId&student_id=$stuId")
    );

    if(res.statusCode==200) {

      if(jsonDecode(res.body)["status"] == "success") {
        questionsAndAnswer = List<QuestionAndAnswer>.from(
            (jsonDecode(res.body)["massage"] as List).map((e) => QuestionAndAnswer.fromJson(e)));

        debugPrint(questionsAndAnswer.toString());
        emit(QuestionAndAnswerSuccessfully());
      }
      else{

        emit(QuestionAndAnswerFailure(message: jsonDecode(res.body)["massage"]));

      }
    }else{
      emit(QuestionAndAnswerFailure(message: jsonDecode(res.body)["massage"]));

    }
  }on SocketException {
    emit(QuestionAndAnswerFailure(message:tr(StringConstants.noInternet)));

  }
  catch(e){
    emit(QuestionAndAnswerFailure(message:tr(StringConstants.errorWhenResponse)));

  }
}





int counterOfAnswers= 0 ;
 counterPlus( )   {

   counterOfAnswers++;
   debugPrint("counter of questions = $counterOfAnswers");
   emit(QuestionSelected());


}
setCountZero( ) {
   counterOfAnswers = 0;
   emit(ZeroAnswers());

}



Future<void> storeSectionScoreForEachStudent(
  {
  required String sectionId,
  required String studentScore,
  required String totalDegree,
}
    ) async {

try{
  http.Response res =await http.post(
      Uri.parse(
          ApiConstants.addAnswerForSectionForStudent),
      body: jsonEncode({
        "section_id" : sectionId,
        "student_id" : stuId,
        "student_score": studentScore,
        "total_degree":totalDegree
      })
  );
  if(res.statusCode == 200){

    if(jsonDecode(res.body)["status"] == "success") {
      emit(StoreAnswersForStudentSuccess(
        message: jsonDecode(res.body)["massage"]
      )) ;
    }else {
      emit(StoreAnswersForStudentFailure(message:jsonDecode(res.body)["massage"]) );

    }
  }else{
    emit(StoreAnswersForStudentFailure(message:tr(StringConstants.errorWhenResponse)));

  }
}on SocketException {
  emit(StoreAnswersForStudentFailure(message: tr(StringConstants.noInternet)));


}
catch(e) {
  emit(StoreAnswersForStudentFailure(message: tr(StringConstants.errorWhenResponse)));
}
}


int scoreValue= 0;

plusScore( ) {

  scoreValue++ ;
  print (scoreValue.toString());
  emit(ScoreValueState());
}





minusScore ( ) {
  scoreValue--;
  debugPrint (scoreValue.toString());
  emit(ScoreValueMinusState());
}


// {
// "question_id": "1",
// "section_id": "2",
// "student_id": "9",
// "quiz_id": "10",
// "question_txt": "dd",
// "question_ans": [
// "kopurpo;lmwrihyu",
// "oirw",
// "knm"
// ],
// "qus_true_ans": "knm"
// }





bool checkAnswer= false ;

setCheckAnswerEqualZero () {
  checkAnswer = false;
  emit(CheckAnswerFalseState());


}

changeCheckAnswerToTrue  () {
  checkAnswer = true;
  emit(CheckAnswerTrueState());

}

setSelectAnswer (  int? selectAnswer , int? trueAnswer )    {
  selectedAnswer = trueAnswer ;
  emit(SetSelectedInTrueState());
}
}