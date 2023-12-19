part of 'add_card_cubit.dart';

abstract class AddCardState {}

class AddCardInitial extends AddCardState {
  String? message;
  AddCardInitial({this.message = ""});
}

class AddCardLoading extends AddCardState {
  String? message;
  AddCardLoading({this.message = ""});
}

class AddCardLoaded extends AddCardState {
  final String message;
  AddCardLoaded({required this.message});
}

class AddCardFailure extends AddCardState {
  final String errorMessage;
  AddCardFailure({required this.errorMessage});
}
