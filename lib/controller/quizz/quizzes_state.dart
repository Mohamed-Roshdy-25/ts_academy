part of 'quizzes_cubit.dart';

abstract class QuizzesState {}

class QuizzesInitial extends QuizzesState {}

class QuizzesLoaded extends QuizzesState {}






class QuizzesLoading extends QuizzesState {}

class QuizzesFailure extends QuizzesState {
  final String message;
  QuizzesFailure({required this.message});
}
class DeleteQuiz extends QuizzesState {
  final String message;
  DeleteQuiz({required this.message});
}

class DeleteQuizLoading extends QuizzesState {}

class DeleteQuizFailure extends QuizzesState {
  final String message;
  DeleteQuizFailure({required this.message});
}
