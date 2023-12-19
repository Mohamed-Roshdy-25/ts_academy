import 'package:ts_academy/controller/about_us/about_us_cubit.dart';
import 'package:ts_academy/controller/auth_cubit/phone_cubit.dart';
import 'package:ts_academy/screens/new_live_broadcast/utils/device_orientation.dart';
import '../../constants/constants.dart';
import '../../controller/settings_cubit/settings_cubit.dart';
import '../chain/chain_screen.dart';
import '../chain/chain_screen2.dart';
import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/constants/color_constants.dart';
import '/constants/image_constants.dart';
import '/screens/menu_screens/menu_screen.dart';
import '/screens/quizzes/quizzes_subjects.dart';
import '/screens/courses/ts_screen.dart';
import '../../controller/notification/notification_cubit.dart';
import '../notifications/notification_screen.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'enter_card.dart';
import 'home_posts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final screens = [
    const HomeScreenPosts(),
     ChainScreen2(title:tr(StringConstants.quizzes),),
    const ChainScreen(title:StringConstants.appName,),
    // const EnterCardScreen(),
    const NotificationScreen(),
    const MenuScreen()
  ];

  @override
  void initState() {
    debugPrint("user id $stuId");

    BlocProvider.of<PhoneCubit>(context)
        .selectUserInfo(context)
        .then((value) async {

          debugPrint("end select info ");

      try {
        await FirebaseMessaging.instance.subscribeToTopic('ts_Academy_Topic');
      } catch (e) {}
    });

    // debugPrint("my simCard " +
    //     BlocProvider.of<PhoneCubit>(context).simBool.toString());
    BlocProvider.of<SettingsCubit>(context).getSettings().then((value) {
      showDialogWhenNotificationSend();
      requestPermission();
    });

    super.initState();
  }

  void insertBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(backgroundMessage);
  }

  Future<void> backgroundMessage(RemoteMessage message) async {
    BlocProvider.of<NotificationCubit>(context).insertNotification(
        notificationTitle: message.notification!.title.toString(),
        notificationBody: "${message.notification!.body}");
  }

  void showDialogWhenNotificationSend() {
    FirebaseMessaging.onMessage.listen((event) {
      print(event.notification!.body);
      print("===================");
      BlocProvider.of<NotificationCubit>(context)
          .insertNotification(
              notificationTitle: event.notification!.title.toString(),
              notificationBody: "${event.notification!.body}")
          .then((value) {
        return showDialog(
            context: context,
            builder: (cxt) {
              return AlertDialog(
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Image.asset(
                            ImagesConstants.logo,
                            scale: 2.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        StringConstants.appName,
                        style: TextStyle(color: ColorConstants.purpal),
                      ),
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.all(10),
                content: Text("${event.notification!.body}"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        tr(StringConstants.ok),
                        style: TextStyle(color: ColorConstants.purpal),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        tr(StringConstants.cancel),
                        style: TextStyle(color: ColorConstants.purpal),
                      ))
                ],
              );
            });
      });
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

  //   try {
  //     NotificationSettings settings = await messaging.requestPermission(
  //       alert: true,
  //       announcement: false,
  //       badge: true,
  //       carPlay: false,
  //       criticalAlert: false,
  //       provisional: false,
  //       sound: true,
  //     );
  //     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //       print('User granted permission');
  //     } else if (settings.authorizationStatus ==
  //         AuthorizationStatus.provisional) {
  //       print('User granted provisional permission');
  //     } else {
  //       print('User declined or has not accepted permission');
  //     }
  //   } catch (e) {
  //     debugPrint("error");
  //   }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AbutUsCubit, AbutUsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
            body: OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                final bool connected = connectivity != ConnectivityResult.none;
                if (connected) {
                  return screens.elementAt(
                      BlocProvider.of<AbutUsCubit>(context).selectedIndex);
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          tr(StringConstants.noInternet),
                          style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w800,
                              color: ColorConstants.purpal),
                        ),
                      )
                    ],
                  );
                }
              },
              child: Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.darkBlue,
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: BlocProvider.of<AbutUsCubit>(context).selectedIndex,
              onTap: (value) {
                BlocProvider.of<AbutUsCubit>(context).changeIndex(value);
              },
              type: BottomNavigationBarType.shifting,
              showSelectedLabels: false,
              items: [
                BottomNavigationBarItem(
                    activeIcon: Image.asset(
                      ImagesConstants.home,
                      color: ColorConstants.darkBlue,
                      scale: 3.2,
                    ),
                    icon: Image.asset(
                      ImagesConstants.home,
                      color: Colors.black,
                      scale: 3.2,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    activeIcon: Image.asset(
                      ImagesConstants.quiz,
                      color: ColorConstants.darkBlue,
                      scale: 3.2,
                    ),
                    icon: Image.asset(
                      ImagesConstants.quiz,
                      color: Colors.black,
                      scale: 3.2,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    activeIcon: Image.asset(
                      ImagesConstants.logo,
                      height: 30,
                      color: ColorConstants.darkBlue,
                      scale: 3.2,
                    ),
                    icon: Image.asset(
                      ImagesConstants.logo,
                      height: 30,
                      color: Colors.black,
                      scale: 1,
                    ),
                    label: ''),
                // BottomNavigationBarItem(
                //     activeIcon: Image.asset(
                //       ImagesConstants.enterCode,
                //       height: 30,
                //       color: ColorConstants.darkBlue,
                //       scale: 3.2,
                //     ),
                //     icon: Image.asset(
                //       ImagesConstants.enterCode,
                //       height: 30,
                //       color: Colors.black,
                //       scale: 1,
                //     ),
                //     label: ''),
                BottomNavigationBarItem(
                    activeIcon: Image.asset(
                      ImagesConstants.notification,
                      color: ColorConstants.darkBlue,
                      scale: 3.2,
                    ),
                    icon: Image.asset(
                      ImagesConstants.notification,
                      color: Colors.black,
                      scale: 3.2,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    activeIcon: Image.asset(
                      ImagesConstants.menu,
                      color: ColorConstants.darkBlue,
                      scale: 3.2,
                    ),
                    icon: Image.asset(
                      ImagesConstants.menu,
                      color: Colors.black,
                      scale: 3.2,
                    ),
                    label: ''),
              ],
            ));
      },
    );
  }
}
