part of 'about_us_cubit.dart';

abstract class AbutUsState {}

class AbutUsInitial extends AbutUsState {}
class ChangeIndexState extends AbutUsState {}

class AbutUsLoading extends AbutUsState {}


class AbutUsLoaded extends AbutUsState {}

class AbutUsFailure extends AbutUsState {
  final String message;

  AbutUsFailure({required this.message});
}
class OnBoardingLoading extends AbutUsState {}


class OnBoardingLoaded extends AbutUsState {}

class OnBoardingFailure extends AbutUsState {
  final String message;

  OnBoardingFailure({required this.message});
}
