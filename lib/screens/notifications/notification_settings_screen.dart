import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/constants/color_constants.dart';
import '/constants/font_constants.dart';
import '/modules/modules.dart';

import '../../modules/elevated_button.dart';
import '../../modules/shared_preferences.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({Key? key}) : super(key: key);

  @override
  _NotificationSettingScreenState createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool muteAllNotificationSwitch = false;
  bool muteCommentNotificationSwitch = false;
  bool muteLikeNotificationSwitch = false;

  @override
  void initState() {
    super.initState();
    SharedPreferenceHelper().getNotification1().then((value) {
      if (value != null && value != 'null' && value != '') {
        setState(
            () => muteAllNotificationSwitch = value == 'true' ? true : false);
      } else {
        setState(() => muteAllNotificationSwitch = false);
      }
    });
    SharedPreferenceHelper().getNotification2().then((value) {
      if (value != null && value != 'null' && value != '') {
        setState(() =>
            muteCommentNotificationSwitch = value == 'true' ? true : false);
      } else {
        setState(() => muteCommentNotificationSwitch = false);
      }
    });
    SharedPreferenceHelper().getNotification3().then((value) {
      if (value != null && value != 'null' && value != '') {
        setState(
            () => muteLikeNotificationSwitch = value == 'true' ? true : false);
      } else {
        setState(() => muteLikeNotificationSwitch = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Modules().appBar('Notification Settings'),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "All Notification Settings",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: FontConstants.poppins),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                              tr(StringConstants.mute_all_notifications),
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: FontConstants.poppins),
                            ),
                            Switch(
                              value: muteAllNotificationSwitch,
                              inactiveThumbColor: Colors.grey[300],
                              activeColor: ColorConstants.lightBlue,
                              activeTrackColor:
                                  ColorConstants.lightBlue.withOpacity(0.5),
                              onChanged: (value) async {
                                setState(() {
                                  muteAllNotificationSwitch = value;
                                });
                                print(value);
                                // setState(()=> muteAllNotificationSwitch = !muteAllNotificationSwitch);
                                await SharedPreferenceHelper()
                                    .saveNotification1(value.toString());
                                SharedPreferenceHelper()
                                    .getNotification1()
                                    .then((value) {
                                  setState(() => muteAllNotificationSwitch =
                                      value == 'true' ? true : false);
                                });
                              },
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                              tr(StringConstants.mute_specific_notifications),
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: FontConstants.poppins),
                            ),
                            Switch(
                              value: muteLikeNotificationSwitch,
                              inactiveThumbColor: Colors.grey[300],
                              activeColor: ColorConstants.lightBlue,
                              activeTrackColor:
                                  ColorConstants.lightBlue.withOpacity(0.5),
                              onChanged: (value) async {
                                setState(() {
                                  muteLikeNotificationSwitch = value;
                                });
                                setState(() => muteLikeNotificationSwitch =
                                    !muteLikeNotificationSwitch);
                                await SharedPreferenceHelper()
                                    .saveNotification3(value.toString());
                                SharedPreferenceHelper()
                                    .getNotification3()
                                    .then((value) {
                                  setState(() => muteLikeNotificationSwitch =
                                      value == 'true' ? true : false);
                                });
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: ElevatedButtonWidget(
                    onPressed: () async {
                      Modules().toast(tr(StringConstants.notification_settings_saved));
                    },
                    buttonText: tr(StringConstants.done),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
