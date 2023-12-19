import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../controller/about_us/about_us_cubit.dart';
import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/constants/color_constants.dart';
import '/constants/font_constants.dart';
import '/modules/modules.dart';
import '/screens/menu_screens/about_us_screen.dart';
import '/screens/menu_screens/privacy_policy_screen.dart';
import '/screens/menu_screens/profile/student_profile.dart';
import '/screens/menu_screens/Tickets/tickets_screen.dart';
import '../authorization/sign_in_screen.dart';
import 'change_language_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => BlocProvider.of<AbutUsCubit>(context).changeIndex(0),
      child: Scaffold(
          appBar: Modules().appBar(tr(StringConstants.menu)),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuTile(
                  text: tr(StringConstants.my_profile),
                  iconData: Icons.person_pin,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StudentProfile()));
                  },
                ),
                // MenuTile(
                //   text: tr(StringConstants.notificationSetting),
                //   iconData: Icons.notifications_active_outlined,
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) =>
                //                 const NotificationSettingScreen()));
                //   },
                // ),
                MenuTile(
                  text: tr(StringConstants.tickets),
                  iconData: Icons.message,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TicketsScreen()));
                  },
                ),
                MenuTile(
                    text: tr(StringConstants.changeLanguage),
                    iconData: Icons.settings,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ChangeLanguageScreen()));
                    }),
                MenuTile(
                  text: tr(StringConstants.about),
                  iconData: Icons.info_outline,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutUsScreen()));
                  },
                ),
                MenuTile(
                  text: tr(StringConstants.privacyPolicy),
                  iconData: Icons.privacy_tip_outlined,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen()));
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    // setState(()=> myAccessToken = null);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('userId');
                    // ignore: use_build_context_synchronously
                    Navigator.popUntil(context,
                        ModalRoute.withName(Navigator.defaultRouteName));
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()))
                        .then((value) async {
                      try {
                        await FirebaseMessaging.instance
                            .unsubscribeFromTopic('ts_Academy_Topic');
                      } catch (e) {}
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(25, 15, 25, 0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorConstants.lightBlue),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(2, 2),
                            blurRadius: 2)
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                            width: 70,
                            child: Icon(Icons.power_settings_new,
                                color: Colors.red, size: 30)),
                        Text(
                          tr(StringConstants.signOut),
                          style: const TextStyle(
                              fontFamily: FontConstants.poppins,
                              fontSize: 15,
                              color: Colors.red,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class MenuTile extends StatelessWidget {
  const MenuTile(
      {Key? key,
      required this.text,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  final String? text;
  final IconData? iconData;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(25, 15, 25, 0),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorConstants.lightBlue),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(2, 2),
                blurRadius: 2)
          ],
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: 70,
                child:
                    Icon(iconData, color: ColorConstants.lightBlue, size: 30)),
            Text(
              text!,
              style: const TextStyle(
                  fontFamily: FontConstants.poppins,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
