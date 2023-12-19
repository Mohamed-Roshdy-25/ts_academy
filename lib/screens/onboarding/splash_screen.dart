import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/controller/auth_cubit/phone_cubit.dart';
import 'package:ts_academy/screens/force_update_screen.dart';
import '../../main.dart';
import '/constants/constants.dart';
import '/constants/image_constants.dart';
import '/screens/home/home_page.dart';
import 'on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }
  @override
  void initState() {

    // Modules().getUniversities();
    // Modules().getColleges();
    // Modules().getClasses();
    // Modules().getTracks();
    // SharedPreferenceHelper().getUserToken().then((value){setState(()=> myAccessToken = value);});
    // SharedPreferenceHelper().getUserId().then((value){setState(()=> myId = value);});
    // SharedPreferenceHelper().getName().then((value){setState(()=> myName = value);});
    context.read<PhoneCubit>().selectUserInfo(context).then((value) async {
      print("++++++++++++++++++++++++++++++++++++++++++++++++++");
      print(versionNumberFromAPI);
      print("++++++++++++++++++++++++++++++++++++++++++++++++++");
      try {
        await FirebaseMessaging.instance.subscribeToTopic('ts_Academy_Topic');
      } catch (e) {}
      if (context.mounted) {
        // false
        // if(await isEmulator() ==false ){

        //   exit(0);
        // }else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
              stuId != null
                  ? versionNumberFromAPI == "2"
                  ? const HomePage()
                  : const ForceUpdateScreen()
                  : const OnBoardingScreen(),
            ),
          );
        }
      //}
    }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 230,
          height: 230,
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(150),
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Image.asset(ImagesConstants.logo),
            ),
          ),
        ),
      ),
    );
  }
}
