abstract class QuestionAndAnswerStates { }
 class QuestionAndAnswerInitial extends QuestionAndAnswerStates{ }
 class QuestionAndAnswerSuccessfully extends QuestionAndAnswerStates { }
 class QuestionAndAnswerLoading  extends QuestionAndAnswerStates{

}
 class QuestionAndAnswerFailure extends QuestionAndAnswerStates{
 final String message;

 QuestionAndAnswerFailure( {
  required this.message
 });


 }

class QuestionSelected  extends QuestionAndAnswerStates{}
class ZeroAnswers  extends QuestionAndAnswerStates{}

class StoreAnswersForStudentLoading extends QuestionAndAnswerStates{}
class StoreAnswersForStudentSuccess extends QuestionAndAnswerStates{
 final String message;

 StoreAnswersForStudentSuccess( {
  required this.message
 });
}
class StoreAnswersForStudentFailure extends QuestionAndAnswerStates{
 final String message;

 StoreAnswersForStudentFailure( {
  required this.message
 });
}
class ScoreValueState extends QuestionAndAnswerStates{
}
class ScoreValueMinusState extends QuestionAndAnswerStates{
}
class CheckAnswerFalseState extends QuestionAndAnswerStates{
}
class CheckAnswerTrueState extends QuestionAndAnswerStates{
}
class SetSelectedInTrueState extends QuestionAndAnswerStates{
}

