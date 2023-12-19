import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/screens/courses/cubit/states.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WatchVideoCubit extends Cubit<WatchVideoStates> {
  WatchVideoCubit() : super(WatchVideoInitialState());

  static WatchVideoCubit get(context) => BlocProvider.of(context);


  bool isScreenSplitted = false;
  String currentLinkPdfWithSplittedScreen = "";
  void changeSplitScreen({required bool value,required String pdfLink}){
    isScreenSplitted = value;
    currentLinkPdfWithSplittedScreen = pdfLink;
   
    print(pdfLink);
    emit(ChangeSplitScreenState());
  }

  late YoutubePlayerController controller;

  Map<String,int> map =  {};

  changeMap(String key , int value )  {
    map.addAll({"$key":value});
    emit(ChangeControllerState());
  }

}