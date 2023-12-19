abstract class AuthStates {}

class InitialAuth extends AuthStates {}

class PhoneAuthLoading extends AuthStates {}

class PhoneAuthFailure extends AuthStates {
  final String errorMessage;
  PhoneAuthFailure({required this.errorMessage});
}

class PhoneAuthSuccessNew extends AuthStates {}
class OutState extends AuthStates {}
class ChangeSimCardState extends AuthStates {}

class PhoneAuthSuccessExist extends AuthStates {}
class SelectUserInfoLoadingState extends AuthStates {}
class SelectUserInfoSuccess extends AuthStates {}
class SelectUserInfoFailure extends AuthStates {
  final String errorMessage ;
  SelectUserInfoFailure(    { required this.errorMessage} ) ;
}

class GetDeviceIdSuccess extends AuthStates {}

class GetDeviceIdLoading extends AuthStates {}

class GetDeviceIdFailure extends AuthStates {
  final String errorMessage;
  GetDeviceIdFailure({required this.errorMessage});
}

class RegisterLoading extends AuthStates {}

class RegisterSuccess extends AuthStates {
  final String message;
  RegisterSuccess({required this.message});
}

class RegisterFailure extends AuthStates {
  final String errorMessage;
  RegisterFailure({required this.errorMessage});
}

class GetUniversitiesSuccessfully extends AuthStates {}

class GetUniversitiesFailure extends AuthStates {
  final String errorMessage;
  GetUniversitiesFailure({required this.errorMessage});
}

class GetUniversitiesLoading extends AuthStates {}

class GetImagePathLoading extends AuthStates {}

class GetImagePathLoaded extends AuthStates {}

class GetImagePathFailure extends AuthStates {
  final String message ;
  GetImagePathFailure ( this.message)  ;
}
