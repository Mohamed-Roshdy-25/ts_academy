part of 'settings_cubit.dart';

abstract class SettingsStates {}

class GetSettingsInitial extends SettingsStates {}

class GetSettingsLoading extends SettingsStates {}

class GetSettingsFailure extends SettingsStates {
  final String message;
  GetSettingsFailure(this.message);
}

class GetSettingsSuccess extends SettingsStates {}
