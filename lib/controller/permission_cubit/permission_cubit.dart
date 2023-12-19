import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

import '../../constants/api_constants.dart';
import '../../constants/string_constants.dart';
part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit() : super(PermissionInitial());

  bool? earphonePermission;
  String postLivePermission = "";

  Future<void> getUserPermission(String studentID) async {
    emit(PermissionLoading());
    try {
      http.Response response = await http.get(Uri.parse(
          "${ApiConstants.userPermissionEndpoint}?student_id=$studentID"));
      if (response.statusCode == 200) {
        earphonePermission =
            bool.parse(jsonDecode(response.body)["earphone_permission"]);
        postLivePermission = jsonDecode(response.body)["all_permission"];
        emit(PermissionLoaded());
      } else {
        emit(PermissionFailure(message: tr(StringConstants.errorWhenResponse)));
      }
    } on SocketException {
      emit(PermissionFailure(message: tr(StringConstants.noInternet)));
    } catch (e) {
      emit(PermissionFailure(message: tr(StringConstants.errorWhenResponse)));
    }
  }
}
