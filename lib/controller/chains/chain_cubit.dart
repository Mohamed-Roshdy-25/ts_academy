
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/constants/api_constants.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/controller/chains/chain_states.dart';
import 'package:ts_academy/models/chain_model.dart';
import 'package:http/http.dart' as http;
class ChainCubit extends Cubit <ChainStates>{
  ChainCubit():super(ChainInitial());


  List<ChainModel> chains= [] ;

  Future<void>  getChains () async{

    emit(GetChainsLoading()) ;

    try {
      http.Response response =await http.post(Uri.parse(ApiConstants.getChains),
        body:  jsonEncode({
          "student_id":stuId
        }  )
      );
      if(response.statusCode== 200) {
        chains = List<ChainModel>.from((jsonDecode(response.body)["massage"] as List).map((e) => ChainModel.fromJson(e)));

        debugPrint(chains.toString());
        emit(GetChainsSuccess()) ;
      }else{
        emit(GetChainsFailure());
      }
    }on SocketException{
      emit(GetChainsFailure());
    }  catch(e) {
      emit(GetChainsFailure());
    }



  }




}