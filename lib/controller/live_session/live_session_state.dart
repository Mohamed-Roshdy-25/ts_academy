part of 'live_session_cubit.dart';

abstract class LiveSessionState {}

class LiveSessionInitial extends LiveSessionState {}
class GetLiveSessionInfoLoading extends LiveSessionState {}
class GetLiveSessionInfoLoaded extends LiveSessionState {}
class GetLiveSessionInfoFailure extends LiveSessionState {
  final String message;
  GetLiveSessionInfoFailure({required this.message});
}
