abstract class MainStates{}
class MainInitialState extends MainStates{}

class CheckAndroidLoadingState extends MainStates{}
class CheckAndroidSuccessState extends MainStates{
  final String msg;
  CheckAndroidSuccessState(this.msg);
}
class CheckAndroidErrorState extends MainStates{
  final String err;
  CheckAndroidErrorState(this.err);
}

class CheckAndroidVersionLoadingState extends MainStates{}
class CheckAndroidVersionSuccessState extends MainStates{
  final String msg;
  CheckAndroidVersionSuccessState(this.msg);
}
class CheckAndroidVersionErrorState extends MainStates{
  final String err;
  CheckAndroidVersionErrorState(this.err);
}