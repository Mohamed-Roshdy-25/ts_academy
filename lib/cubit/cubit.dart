import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/cubit/states.dart';
import 'package:ts_academy/network/dio_helper.dart';
import 'package:ts_academy/network/end_points.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainInitialState());

  static MainCubit get(context) => BlocProvider.of(context);

  bool isAndroidReview = true;
  Future<void> checkAndroidReview() async {
    emit(CheckAndroidLoadingState());
    await DioHelper.getData(
      url: CHECKANDROIDREVIEW,
      baseUrl: BASEURL,
    ).then((value) async {
      final res = value.data.toString();
      if (res == "1") {
        isAndroidReview = true;
        emit(CheckAndroidSuccessState(res));
      } else {
        isAndroidReview = false;
        emit(CheckAndroidSuccessState(res));
      }
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['message'];
          emit(CheckAndroidErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(CheckAndroidErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        emit(CheckAndroidErrorState('An error occurred. Please try again.'));
      }
    });
  }

  bool isTSUpToDated = true;
  String latestVersion = "";
  Future<void> checkTSUpToDated() async {
    emit(CheckAndroidVersionLoadingState());
    await DioHelper.getData(
      url: CHECKANDROIDREVIEW,
      baseUrl: BASEURL,
    ).then((value) async {
      final res = value.data.toString();
      if (value.statusCode == 200) {
        latestVersion = res;
        print('===================> res $latestVersion');
        emit(CheckAndroidVersionSuccessState(res));
      } else {
        emit(CheckAndroidVersionErrorState('An error occurred. Please try again.'));
      }
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          final responseData = error.response?.data;
          final errorMessage = responseData['message'];
          emit(CheckAndroidVersionErrorState(errorMessage));
        } else {
          // Handle other DioError cases
          emit(CheckAndroidVersionErrorState('Please check the Internet connection and try again.'));
        }
      } else {
        emit(CheckAndroidVersionErrorState('An error occurred. Please try again.'));
      }
    });
  }
}
