import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_device/safe_device.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_checker/store_checker.dart';
import 'package:ts_academy/constants/color_constants.dart';
import 'package:ts_academy/controller/chains/chain_cubit.dart';
import 'package:ts_academy/cubit/cubit.dart';
import 'package:ts_academy/cubit/states.dart';
import 'package:ts_academy/screens/courses/cubit/cubit.dart';
import 'dart:async';
import 'package:ts_academy/screens/new_course_content/cubit/cubit.dart';
import 'package:ts_academy/screens/new_live_broadcast/cubit/cubit.dart';
import '/constants/constants.dart';
import '/controller/auth_cubit/phone_cubit.dart';
import '/controller/auth_cubit/registeration.dart';
import '/controller/questuons_for_each_section/question_for_each_section_cubit.dart';
import '/controller/sections/sections_cubit.dart';
import 'controller/live_comments/live_comments_cubit.dart';
import 'controller/live_session/live_session_cubit.dart';
import 'controller/permission_cubit/permission_cubit.dart';
import 'screens/onboarding/splash_screen.dart';
import 'controller/about_us/about_us_cubit.dart';
import 'controller/add_card/add_card_cubit.dart';
import 'controller/comments/comment_cubit.dart';
import 'controller/courses_Chapters/course_chapters_cubit.dart';
import 'controller/courses_video/courses_video_cubit.dart';
import 'controller/notification/notification_cubit.dart';
import 'controller/privacy_policy/privacy_policy_cubit.dart';
import 'controller/settings_cubit/settings_cubit.dart';
import 'controller/student_posts_comments/comments.dart';
import 'controller/quizz/quizzes_cubit.dart';
import 'controller/student_courses/student_course_cubit.dart';
import 'controller/student_posts/student_posts_cubit.dart';
import 'controller/student_ticket/struden_ticket_cubit.dart';
import 'package:firebase_core/firebase_core.dart';

bool? isRecording;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

isRecording = await ScreenProtector.isRecording();
  if(isRecording??false){
    exit(0);
  }

  //
  // if (screenRecord ?? false) {
  //   exit(0);
  // }


  try {
    var fbm = await FirebaseMessaging.instance;
    await fbm.getToken().then((value) {
      print("=========================================");
      deviceToken = value;
      print("========================================= device token $deviceToken");

      print(value);
      print("=========================================");
    });
  } catch (e) {}
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //     overlays: SystemUiOverlay.values);

  final sharedPref = await SharedPreferences.getInstance();
  stuId = sharedPref.getString("userId");
  stuBio = sharedPref.getString('stuBio');
  myName = sharedPref.getString("userName");
  stuPhoto = sharedPref.getString("userPhoto");
  stuPhone = sharedPref.getString("userPhone");
  universityName = sharedPref.getString("userUniversity");
  earphone_permission = sharedPref.getString("earphone_permission");
  all_permission = sharedPref.getString("all_permission");
  phone_jack = sharedPref.getString("phone_jack");
  simCard = sharedPref.getString("sim_card");
  versionNumberFromAPI = sharedPref.getString("VersionNumberFromAPI");
  simCardConstant = sharedPref.getBool("simCardConstant") ?? simCardConstant;
  local = sharedPref.getString("locale") ?? "ar";
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      await serviceWorkerController
          .setServiceWorkerClient(AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      ));
    }
  }

  debugPrint("------------------------------------");
  debugPrint(stuId);
  debugPrint("------------------------------------");
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => MainCubit()..checkAndroidReview()),
        BlocProvider(create: (ctx) => PhoneCubit()),
        BlocProvider(create: (ctx) => LiveCommentsCubit()),
        BlocProvider(create: (ctx) => LiveSessionCubit()),
        BlocProvider(create: (ctx) => RegistrationCubit()),
        BlocProvider(create: (ctx) => AddCardCubit()),
        BlocProvider(create: (ctx) => StudentCourseCubit()),
        BlocProvider(create: (ctx) => CoursesVideoCubit()),
        BlocProvider(create: (ctx) => QuizzesCubit()),
        BlocProvider(create: (ctx) => CourseChaptersCubit()),
        BlocProvider(create: (ctx) => SectionsCubit()),
        BlocProvider(create: (ctx) => QuestionAndAnswerCubit()),
        BlocProvider(create: (ctx) => CommentCubit()),
        BlocProvider(create: (ctx) => StudentTickerCubit()),
        BlocProvider(create: (ctx) => StudentPostsCubit()),
        BlocProvider(create: (ctx) => CommentsCubit()),
        BlocProvider(create: (ctx) => NotificationCubit()),
        BlocProvider(create: (ctx) => AbutUsCubit()),
        BlocProvider(create: (ctx) => PrivacyPolicyCubit()),
        BlocProvider(create: (ctx) => SettingsCubit()),
        BlocProvider(create: (ctx) => PermissionCubit()),
        BlocProvider(create: (ctx) => ChainCubit()),
        BlocProvider(
          create: (ctx) => ZegoCloudCubit()
            ..getRoomsForStudents()
            ..getRoomsForAdmin(),
        ),
        BlocProvider(create: (ctx) => WatchVideoCubit()),
        BlocProvider(create: (ctx) => CourseContentCubit()),
      ],
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en'), // English (United States)
          Locale('ar'), // Arabic
        ],
        path: 'assets/translations',
        // <-- change the path of the translation files
        fallbackLocale: const Locale('ar'),
        saveLocale: true,
        startLocale: const Locale('ar'),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // double lastFrame = 0.0;
  // Timer? screenshotTimer;
final ScreenCaptureEvent screenListener = ScreenCaptureEvent();
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<PhoneCubit>(context).getDeviceId();

    initPlatformState();
    // checkScreenRecord();
    // Periodically check for changes in the content
    // screenshotTimer = Timer.periodic(Duration(seconds: 1), (timer) {
    //   if (lastFrame == 0.0 || lastFrame != MediaQuery.of(context).size.height) {
    //     SystemNavigator.pop();
    //     print("User tried to take a screenshot!");
    //   }
    //   lastFrame = MediaQuery.of(context).size.height;
    // });
    // initScreenRecordingDetection();


checkScreenRecord();

  }
  
checkScreenRecord() async {
    screenListener.addScreenRecordListener((recorded) {
      if(recorded){
        exit(0);
      }
    });

    screenListener.watch();
  }
  // Future<void> initScreenRecordingDetection() async {
  //   const platform = MethodChannel('screen_recording_detection');
  //
  //   try {
  //     final isRecording = await platform.invokeMethod('isRecording');
  //     if (isRecording) {
  //       SystemNavigator.pop();
  // exit(0);
  //       print("User tried to take a screen recording!");
  //     }
  //   } on PlatformException catch (e) {
  //     print("Failed to detect screen recording: ${e.message}");
  //   }
  // }

  // @override
  // void dispose() {
  //   screenshotTimer?.cancel();
  //   super.dispose();
  // }
  //
  // final ScreenCaptureEvent screenListener = ScreenCaptureEvent();
  // checkScreenRecord() async {
  //   // if (screenRecord ?? false) {
  //   //   exit(0);
  //   // }
  //
  //   screenListener.addScreenRecordListener((recorded) {
  //     if (recorded) {
  //       exit(0);
  //     }
  //   });
  //
  //   screenListener.watch();
  // }

  String source = 'None';

  Future<void> initPlatformState() async {
    Source installationSource;
    try {
      installationSource = await StoreChecker.getSource;
    } on PlatformException {
      installationSource = Source.UNKNOWN;
    }
    if (!mounted) return;
    setState(() {
      switch (installationSource) {
        case Source.IS_INSTALLED_FROM_PLAY_STORE:
          source = "Play Store";
          break;
        case Source.IS_INSTALLED_FROM_PLAY_PACKAGE_INSTALLER:
          source = "Google Package installer";
          break;
        case Source.IS_INSTALLED_FROM_RU_STORE:
          source = "RuStore";
          break;
        case Source.IS_INSTALLED_FROM_LOCAL_SOURCE:
          source = "Local Source";
          break;
        case Source.IS_INSTALLED_FROM_AMAZON_APP_STORE:
          source = "Amazon Store";
          break;
        case Source.IS_INSTALLED_FROM_HUAWEI_APP_GALLERY:
          source = "Huawei App Gallery";
          break;
        case Source.IS_INSTALLED_FROM_SAMSUNG_GALAXY_STORE:
          source = "Samsung Galaxy Store";
          break;
        case Source.IS_INSTALLED_FROM_SAMSUNG_SMART_SWITCH_MOBILE:
          source = "Samsung Smart Switch Mobile";
          break;
        case Source.IS_INSTALLED_FROM_XIAOMI_GET_APPS:
          source = "Xiaomi Get Apps";
          break;
        case Source.IS_INSTALLED_FROM_OPPO_APP_MARKET:
          source = "Oppo App Market";
          break;
        case Source.IS_INSTALLED_FROM_VIVO_APP_STORE:
          source = "Vivo App Store";
          break;
        case Source.IS_INSTALLED_FROM_OTHER_SOURCE:
          source = "Other Source";
          break;
        case Source.IS_INSTALLED_FROM_APP_STORE:
          source = "App Store";
          break;
        case Source.IS_INSTALLED_FROM_TEST_FLIGHT:
          source = "Test Flight";
          break;
        case Source.UNKNOWN:
          source = "Unknown Source";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('===========================> $versionNumberFromAPI');
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: ColorConstants.darkBlue,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: BlocConsumer<MainCubit, MainStates>(
            listener: (context, state) {},
            builder: (context, state) {
              MainCubit mainCubit = BlocProvider.of(context);
              if(!mainCubit.isAndroidReview){
                isEmulator().then((isEmelator) {
                  if (isEmelator) {
                    exit(0);
                  }
                });

              }
              return MaterialApp(
                navigatorKey: navigatorKey,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales:
                    EasyLocalization.of(context)!.supportedLocales,
                locale: EasyLocalization.of(context)!.locale,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  textTheme:
                      GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
                  secondaryHeaderColor: Color(0xFF3D155F),
                  primaryColor: Color(0xFF3D15A9),
                ),
                home:
                mainCubit.isAndroidReview
                    ?
                const SplashScreen()
                    : source == "Play Store" ||
                    source == "App Store"||
                            source == "Huawei App Gallery"
                    // ||
                    //         source == "Local Source"
                    //     || source == 'Test Flight'
                        ?
                const SplashScreen()
                        : Scaffold(
                            backgroundColor: Colors.white,
                            body: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 60),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    color: ColorConstants.lightBlue,
                                  ),
                                  child: Text(
                                    "To ensure a secure installation, please use the official source for our app:\nGoogle Play Store.\nHuawei App Gallery.\nApp Store",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
              );
            },
          ),
        );
      },
   );
  }
}

Future<bool> isEmulator() async {
  bool isRealDevice = await SafeDevice.isRealDevice;
  bool isJailBroken = await SafeDevice.isJailBroken;
  //  bool isSafeDevice = await SafeDevice.isSafeDevice;
  debugPrint("isRealDevice " + isRealDevice.toString());
  debugPrint("isJailBroken" + isJailBroken.toString());

  return isRealDevice && isJailBroken == false;
}

// class SimCardChecker {
//   static const MethodChannel _channel = MethodChannel('sim_card_checker');
//
//   static Future<bool> hasSIMCard() async {
//     return await _channel.invokeMethod('hasSIMCard');
//   }
// }
