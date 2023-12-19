part of 'struden_ticket_cubit.dart';

abstract class StudentTicketState {}

class StudentTicketInitial extends StudentTicketState {}

class StudentTicketLoading extends StudentTicketState {}

class StudentTicketLoaded extends StudentTicketState {}
class GetImagePathLoading extends StudentTicketState {}
class GetImagePathLoaded extends StudentTicketState {}
class GetImagePathFailure extends StudentTicketState {
  final String message  ;
  GetImagePathFailure( this.message);
}

class StudentTicketFailure extends StudentTicketState {
  final String message;
  StudentTicketFailure({required this.message});
}

class InsertStudentTicketLoading extends StudentTicketState {}

class InsertStudentTicketLoaded extends StudentTicketState {
  final String message;
  InsertStudentTicketLoaded({required this.message});
}

class InsertStudentTicketFailure extends StudentTicketState {
  final String message;
  InsertStudentTicketFailure({required this.message});
}
