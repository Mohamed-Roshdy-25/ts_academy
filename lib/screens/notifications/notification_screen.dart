import '../../controller/about_us/about_us_cubit.dart';
import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../constants/image_constants.dart';
import '../../controller/notification/notification_cubit.dart';
import '../../modules/modules.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      BlocProvider.of<NotificationCubit>(context).getNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>
          BlocProvider.of<AbutUsCubit>(context).changeIndex(0),
      child: Scaffold(
        appBar: Modules().appBar(tr(StringConstants.notification)),
        body: BlocConsumer<NotificationCubit, NotificationState>(
          listener: (context, state) {
            if (state is NotificationFailure) {
             Modules().toast(state.message, Colors.red);
             Modules().toast(state.message, Colors.red);
             ;
            } else if (state is DeleteNotificationSuccess) {
              Modules().toast(state.message, Colors.green);

            }
          },
          builder: (context, state) {
            return state is NotificationLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: ColorConstants.darkBlue,
                  ))
                : BlocProvider.of<NotificationCubit>(context)
                        .notificationList
                        .isEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/lottie/nothing.json'),
                            Text(tr(StringConstants.no_notification_until_now))
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr(StringConstants.latest_notifications),
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.purpal,
                                    fontFamily: FontConstants.poppins),
                              ),
                              ListView.builder(
                                  reverse: true,
                                  padding: EdgeInsets.symmetric(vertical: 9.h),
                                  itemCount:
                                      BlocProvider.of<NotificationCubit>(context)
                                          .notificationList
                                          .length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.h, horizontal: 4.w),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Ts Academy",
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            Text(
                                              BlocProvider.of<NotificationCubit>(
                                                      context)
                                                  .notificationList[index]
                                                  .notificationBody,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.sp,
                                                  color: ColorConstants.purpal),
                                            )
                                          ],
                                        ),
                                        // trailing: PopupMenuButton(
                                        //     itemBuilder: (context) => [
                                        //           PopupMenuItem(
                                        //               child: TextButton(
                                        //                   onPressed: () {
                                        //                     Navigator.pop(
                                        //                         context);
                                        //                     BlocProvider.of<
                                        //                                 NotificationCubit>(
                                        //                             context)
                                        //                         .delNotification(BlocProvider
                                        //                                 .of<NotificationCubit>(
                                        //                                     context)
                                        //                             .notificationList[
                                        //                                 index]
                                        //                             .notificationId)
                                        //                         .then((value) {
                                        //                       BlocProvider.of<
                                        //                                   NotificationCubit>(
                                        //                               context)
                                        //                           .getNotification();
                                        //                     });
                                        //                   },
                                        //                   child: Text(
                                        //                     tr(StringConstants
                                        //                         .remove_this_notification),
                                        //                     style: TextStyle(
                                        //                         color: Colors
                                        //                             .purple[900]),
                                        //                   ))),
                                        //           const PopupMenuItem(
                                        //               child: Divider(
                                        //             thickness: 1,
                                        //             color: Colors.black,
                                        //           )),
                                        //           PopupMenuItem(
                                        //               child: TextButton(
                                        //                   onPressed: () async {
                                        //                     await FirebaseMessaging
                                        //                         .instance
                                        //                         .unsubscribeFromTopic(
                                        //                             'TsAcademy');
                                        //                     Navigator.of(context)
                                        //                         .push(
                                        //                             MaterialPageRoute(
                                        //                                 builder:
                                        //                                     (_) {
                                        //                       return const NotificationSettingScreen();
                                        //                     }));
                                        //                   },
                                        //                   child: Text(
                                        //                     tr(StringConstants
                                        //                         .turn_off_these_notifications),
                                        //                   )))
                                        //         ]),
                                        leading: CircleAvatar(
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
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      );
          },
        ),
      ),
    );
  }
}
