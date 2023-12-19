part of 'live_token_cubit.dart';

abstract class LiveTokenState {}

class LiveTokenInitial extends LiveTokenState {}
class LiveTokenLoading extends LiveTokenState {}
class LiveTokenLoaded extends LiveTokenState {}
class LiveTokenFailure extends LiveTokenState {}
