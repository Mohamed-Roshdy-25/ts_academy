part of 'permission_cubit.dart';

abstract class PermissionState {}

class PermissionInitial extends PermissionState {}

class PermissionLoading extends PermissionState {}

class PermissionLoaded extends PermissionState {}

class PermissionFailure extends PermissionState {
  final String message;
  PermissionFailure({required this.message});
}
