part of 'privacy_policy_cubit.dart';

abstract class PrivacyPolicyState {}

class PrivacyPolicyInitial extends PrivacyPolicyState {}

class PrivacyPolicyLoading extends PrivacyPolicyState {}

class PrivacyPolicyLoaded extends PrivacyPolicyState {}

class PrivacyPolicyFailure extends PrivacyPolicyState {
  final String message;
  PrivacyPolicyFailure({required this.message});
}
