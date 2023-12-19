part of 'notification_cubit.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class InsertNotificationLoading extends NotificationState {}

class InsertNotificationSuccess extends NotificationState {}

class InsertNotificationFailure extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {}

class NotificationFailure extends NotificationState {
  final String message;
  NotificationFailure({required this.message});
}

class DeleteNotificationLoading extends NotificationState {}

class DeleteNotificationSuccess extends NotificationState {
  final String message;
  DeleteNotificationSuccess({required this.message});
}

class DeleteNotificationFailure extends NotificationState {
  final String message;
  DeleteNotificationFailure({required this.message});
}
