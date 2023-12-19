import 'dart:async';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pod_player/pod_player.dart';
// import 'package:screen_protector/screen_protector.dart';
import 'package:ts_academy/components/compnenets.dart';
import 'package:ts_academy/components/functions.dart';
import 'package:ts_academy/constants/color_constants.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/constants/image_constants.dart';
import 'package:ts_academy/constants/string_constants.dart';
import 'package:ts_academy/models/get_chapter_content.dart';
import 'package:ts_academy/modules/pdf_screen.dart';
import 'package:ts_academy/screens/courses/course_content_screen.dart';
import 'package:ts_academy/screens/new_course_content/cubit/cubit.dart';
import 'package:ts_academy/screens/new_course_content/cubit/states.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:math' as math;
import '../../controller/courses_Chapters/course_chapters_cubit.dart';

double height = 0;
double width = 0;

class VideoScreen extends StatefulWidget {
  final String ChapterName;
  final String ChapterId;
  final bool owned;
  final int index;
  final String videoUrl;

  const VideoScreen(
      {super.key,
      required this.ChapterName,
      required this.ChapterId,
      required this.index,
      required this.owned,
      required this.videoUrl});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String htmlContent = '';
  WebViewController? controller;
  late TabController tabController;
  TextEditingController commentController = TextEditingController();
  PodPlayerController? videoController;
  List<int> qualityOptions = [
    360,
    720,
    480,
    1080,
  ];
  bool isLoading = true;

  // Timer? timer;

  double _xPosition = 100;
  double _yPosition = 100;
  Timer? ttsTimer;
  bool isFullScreen = false;
  bool isVideoPlaying = false;
  FlutterTts flutterTts = FlutterTts();
  int ttsCounter = 0;
  int maxcount = 60;
  List<String> digits = [];



  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3),() {
      setState(() {
        isLoading = false;
      });
    },);
    print('before build');
    // SystemChrome.restoreSystemUIOverlays();
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.landscapeLeft,
    //   ]);
    // });
    if(mounted){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);
    }
    _moveText();
    initTts();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    htmlContent = '''
    <!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body,html {
      margin: 0;
      padding: 0;
      overflow: hidden;
      touch-action: none; /* Disable pinch-to-zoom on mobile devices */
      background-color: black;
      max-height:100vh;
      max-width:100vw;
    }
    // #player {
    // display:none
    // }
  </style>
   <script type="text/javascript">

</script>
</head>
<body>
  <iframe
    src="https://player.vimeo.com/video/${widget.videoUrl}"
    // width="${height}vw"
    // height="${width}vh"
    
    style="padding: 0; margin: 0; display: block;"
    frameborder="0"
    allow="autoplay;"
  ></iframe>

</body>
</html>
    ''';



    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)..setBackgroundColor(Colors.black)
      ..loadRequest(Uri.parse('https://player.vimeo.com/video/${widget.videoUrl}'));
    // ..setNavigationDelegate(NavigationDelegate(
    //   onNavigationRequest: (request) => NavigationDecision.prevent,
    // ));
    digits = stuId.toString().split('').toList();
    counter();
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   _isVideoPlaying.stream.listen((event) {
    //     if (event) {
    //       print(
    //           'isPlaying =============================================================> $event');
    //       // if ( !ttsTimer!.isActive) {
    //       ttsCounter++;
    //       List<String> digits = stuId.toString().split('').toList();
    //
    //       print('++++++++++++++++++ $ttsCounter');
    //       print('++++++++++++++++++ $maxcount');
    //       if (ttsCounter == maxcount) {
    //         ttsCounter = 0;
    //         Random random = Random();
    //         maxcount = 60;
    //         maxcount = maxcount + (random.nextInt(6));
    //
    //         flutterTts.speak('$digits');
    //       }
    //       // timer = Timer.periodic(
    //       //   Duration(seconds: 5),
    //       //       (timer)  {
    //       //     // videoController.play();
    //       //
    //       //     // ttsNumber = digits;
    //       //      flutterTts.setVolume(0.8); // Volume should be between 0 and 1
    //       //
    //       //     // flutterTts.speak('$digits');
    //       //   },
    //       // );
    //       // // }
    //     } else {
    //       print(
    //           'isPlaying =============================================================> $event');
    //       // flutterTts.setVolume(0);
    //       // timer?.cancel();// Volume should be between 0 and 1
    //       flutterTts.stop();
    //     }
    //   });
    // });
    // Initialize tabController here

    Future.delayed(Duration.zero, () async {
      //   try {
      //     final chapterId = BlocProvider.of<CourseChaptersCubit>(context)
      //         .allStudentCourses[widget.index]
      //         .chapterId;

      //     // Fetch and initialize chapter content
      //     await BlocProvider.of<CourseContentCubit>(context)
      //         .getChapterContent(chapterId: chapterId);

      //     // isRecording();
      //     context.read<CourseContentCubit>().currentContentIndex = 0;

      //     if (context.mounted &&
      //         context.read<CourseContentCubit>().chapterContent != null &&
      //         context
      //             .read<CourseContentCubit>()
      //             .chapterContent!
      //             .massage!
      //             .isNotEmpty) {
      //       final subjectContentData = context
      //           .read<CourseContentCubit>()
      //           .chapterContent!
      //           .massage![context.read<CourseContentCubit>().currentContentIndex];

      //       if ((subjectContentData.type == "video" ||
      //               subjectContentData.type == "audio") &&
      //           (subjectContentData.free! == "yes" || widget.owned == true)) {
      //         if (subjectContentData.videoUrl != null) {

      //         }
      //       }

      //     }
      //   } catch (e) {
      //     print("Error initializing videoController: $e");
      //   }
      // Fetch course comments
      final courseId = BlocProvider.of<CourseChaptersCubit>(context)
          .allStudentCourses[widget.index]
          .chapterId;
      await BlocProvider.of<CourseContentCubit>(context)
          .getCourseComments(courseId: courseId);
    });




  }

  int counterNum = 1;

  counter() {
    ttsTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // if (isVideoPlaying != videoController.isVideoPlaying) {
      //   SchedulerBinding.instance.addPostFrameCallback((_) {
      //     setState(() {
      //       isVideoPlaying = videoController.isVideoPlaying;
      //       // _isVideoPlaying.sink.add(videoController.isVideoPlaying);
      //     });
      //   });
      ttsCounter++;

      if(kDebugMode) {
        print('++++++++++++++++++ $ttsCounter');
        print('++++++++++++++++++ $maxcount');
      }
      if (ttsCounter == maxcount) {
        ttsCounter = 0;
        Random random = Random();
        maxcount = 60;
        maxcount = maxcount + (random.nextInt(6));

        flutterTts.speak('$digits');
      }
      // print('VideoPlaying ==========> ${videoController?.isVideoPlaying}');
      // _isVideoPlaying.sink.add(videoController?.isVideoPlaying);
      // if(videoController?.isVideoPlaying){
      //     for (counterNum = 1; counterNum <= 60; counterNum++) {
      //       print(counterNum);
      //       if (counterNum == 60) {
      //         counterNum = 0;
      //       }
      //     }
      //
      // }
    });
    //     _handleTts(videoController?.isVideoPlaying);
    //   }
    // });
    // _isVideoPlaying.stream.listen((event) {
    //
    //   if(event) {
    //     print('isPlaying ============> $event');
    //     // for (counterNum = 1; counterNum <= 60; counterNum++) {
    //     //   print(counterNum);
    //     //   if (counterNum == 60) {
    //     //     counterNum = 0;
    //     //   }
    //     // }
    //   }
    // });

    // while (true) {
    //   print(counter);
    //
    //   if (counter == 60) {
    //     counter = 1;
    //   } else {
    //     counter++;
    //   }
    // }
  }

  // isRecording() async {
  //   ScreenProtector.addListener(() {}, (isRecording) {
  //     isRecording
  //         ? print('==============> is recording')
  //         : print('==============> not recording');
  //     videoController?.pause();
  //   });
  // }

  StreamController _isVideoPlaying = StreamController<bool>();
  @override
  void didUpdateWidget(covariant VideoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void videoListener() {
    // Future.microtask(() {
    //   if (isVideoPlaying != videoController?.isVideoPlaying) {
    //     SchedulerBinding.instance.addPostFrameCallback((_) {
    //       setState(() {
    //         isVideoPlaying = videoController!.isVideoPlaying;
    //         // _isVideoPlaying.sink.add(videoController?.isVideoPlaying);
    //       });
    //     });
    //     print('VideoPlaying ==========> ${videoController?.isVideoPlaying}');
    //     _handleTts(videoController!.isVideoPlaying);
    //   }
    // });
  }

  // void setTtsAudio(PodPlayerController videoController) {
  //   if (videoController.isVideoPlaying) {
  //     if (!ttsTimer!.isActive) {
  //       ttsTimer = Timer.periodic(
  //         Duration(seconds: 55),
  //         (timer) async {
  //           videoController.play();
  //           List<String> digits = stuId.toString().split('').toList();
  //           // await flutterTts.speak('$digits');
  //         },
  //       );
  //     }
  //   } else {
  //     ttsTimer?.cancel();
  //     flutterTts.stop();
  //   }
  // }

  Future<void> initTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(0.5);
    await flutterTts.setVolume(0.8); // Volume should be between 0 and 1

    // Get the list of available voices
    // List<dynamic> voices = await flutterTts.getVoices;

    // Find and set another voice (replace 'desiredVoiceName' with the actual voice name you want to use)
    // for (dynamic voice in voices) {
    //   if (voice['voiceName'] == 'desiredVoiceName') {
    //     await flutterTts.setVoice(voice['voiceName']);
    //     break; // Stop after setting the voice
    //   }
    // }
  }

  void _handleTts(bool playTts) {
    if (playTts) {
      initTts();
      // setTtsAudio(videoController);
    } else {
      _stopTTS();
    }
  }

  void _stopTTS() {
    flutterTts.stop();
    ttsTimer?.cancel();
    // ttsTimer = null;
  }

  void _moveText() {
    Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      if (mounted) {
        setState(() {
          _xPosition = _randomPosition(200);
          _yPosition = _randomPosition(180);
        });
      }
    });
  }

  double _randomPosition(double max) {
    return Random().nextDouble() * max;
  }


  @override
  void dispose() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
    videoController?.dispose();
    _isVideoPlaying.close();
    controller!.clearCache();
    controller!.clearLocalStorage();
    controller!.reload();
    // try {
    videoController?.removeListener(videoListener);
    videoController?.dispose();
    // } catch (e) {
    //   videoController?.dispose();
    //
    //   print(e.toString());
    // }
    tabController.dispose();
    ttsTimer!.cancel();
    _handleTts(false);
    // SystemChrome.restoreSystemUIOverlays();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorConstants.lightBlue,
      systemNavigationBarColor: ColorConstants.lightBlue,
    ));

    super.dispose();
  }

  @override
  void deactivate() {
    _handleTts(false);
    // try {
    //   videoController?.pause();
    // } catch (e) {
    //   print(e.toString());
    // }
    super.deactivate();
  }

  void _handleTabChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('after build');
      controller!.runJavaScript(
          '''
        function hideGrandparentElementByText(text) {
  let allElements = document.querySelectorAll('*');

  allElements.forEach(element => {
    if (element.childNodes.length === 1 && element.childNodes[0].nodeType === Node.TEXT_NODE && element.textContent.includes(text)) {
      let grandparent = element.parentNode.parentNode;
      grandparent.style.display = 'none';
    }
  });
         let element = document.querySelector("#player > div.vp-player-ui-overlays > div.ControlBar_module_controlBarWrapper__ea0d6863 > div.vp-controls.ControlBar_module_controls__ea0d6863 > div > button.Button_module_button__6c261677.shared_module_focusable__63d26f6d.Button_module_customColor__6c261677.Button_module_xs__6c261677.Button_module_icon__6c261677.Tooltip_module_tooltipContainer__21ae5b80.exclude-global-button-styles.ControlBarButton_module_controlBarButton__88a67ab4.shared_module_focusable__63d26f6d.fullscreen.FullscreenButton_module_fullscreen__e0e92a4f")
if(element){
element.style.display = "none"}
}

setInterval(() => {
  hideGrandparentElementByText('Debug');
},100)
        '''
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          // PodVideoPlayer(
          //   podPlayerLabels:
          //       PodPlayerLabels(
          //           quality: "Quality"),
          //   controller: videoController!,
          //   onToggleFullScreen:
          //       (value) async {
          //     setState(() {
          //       isFullScreen = value;
          //     });
          //     if (value == true) {
          //       await SystemChrome
          //           .setEnabledSystemUIMode(
          //               SystemUiMode.manual,
          //               overlays: []);
          //       await SystemChrome
          //           .setPreferredOrientations([
          //         DeviceOrientation
          //             .landscapeLeft
          //       ]);
          //     } else {
          //       await SystemChrome
          //           .setEnabledSystemUIMode(
          //               SystemUiMode.manual,
          //               overlays:
          //                   SystemUiOverlay
          //                       .values);
          //       await SystemChrome
          //           .setPreferredOrientations([
          //         DeviceOrientation
          //             .portraitUp
          //       ]);
          //     }
          //   },
          // ),
          controller == null
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Center(
            child:
            // VimeoPlayer(
            //   videoId: widget.videoUrl,
            // ),
            WebViewWidget(
              controller: controller!,
            ),
          ),
          Positioned(
              left: 5,
              top: 20,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                  ))),
          // Positioned(
          //     left: 0,
          //     child: Container(
          //       height: MediaQuery.sizeOf(context).width,
          //       width: MediaQuery.sizeOf(context).height*.1,
          //       color: Colors.black,
          //     )),
          randomTextWidget(),
          if(isLoading)
            Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: CircularProgressIndicator(color: Colors.white,),
            )
        ],
      ),
    );
    //   OrientationBuilder(builder: (context, orientation) {
    //   return BlocConsumer<CourseContentCubit, CourseContentStates>(
    //     listener: (context, state) {},
    //     builder: (context, state) {
    //       CourseContentCubit courseContentCubit = BlocProvider.of(context);
    //
    //       List<Massage> pdfs = courseContentCubit.chapterContent!.massage!
    //           .where((element) => element.type == 'pdf')
    //           .toList();
    //
    //
    //
    //       final currentSelectedSubjectContentData =
    //       (courseContentCubit.chapterContent != null && courseContentCubit.chapterContent!.massage!.isNotEmpty)
    //           ? courseContentCubit.chapterContent!
    //           .massage![courseContentCubit.currentContentIndex]
    //           : null;
    //       return AnnotatedRegion<SystemUiOverlayStyle>(
    //         value: SystemUiOverlayStyle(
    //           statusBarColor: ColorConstants.darkBlue,
    //           statusBarBrightness: Brightness.light,
    //           statusBarIconBrightness: Brightness.light,
    //           systemNavigationBarColor: Colors.transparent,
    //           systemNavigationBarIconBrightness: Brightness.dark,
    //         ),
    //         child: DefaultTabController(
    //           length: 2,
    //           child: WillPopScope(
    //             onWillPop: () async {
    //               BlocProvider.of<CourseContentCubit>(context)
    //                   .changeKeyboard(false);
    //               if (courseContentCubit.isScreenSplitted) {
    //                 courseContentCubit.changeSplitScreen(
    //                     value: false, pdfLink: "");
    //                 Navigator.pop(context);
    //
    //                 return false;
    //               } else if (isFullScreen) {
    //                 Navigator.pop(context);
    //
    //                 return false;
    //               } else {
    //                 if (isVideoPlaying) {
    //                   Navigator.pop(context);
    //
    //                   videoController?.pause();
    //                 }
    //                 return true;
    //               }
    //             },
    //             child: KeyboardVisibilityBuilder(
    //               builder: (context, isKeyboardVisible) {
    //                 return Scaffold(
    //                   resizeToAvoidBottomInset: true,
    //                   appBar: AppBar(
    //                     title: Text(widget.ChapterName,
    //                         style: TextStyle(color: Colors.white)),
    //                     centerTitle: true,
    //                     backgroundColor: ColorConstants.lightBlue,
    //                     leading: Padding(
    //                       padding: const EdgeInsets.all(10.0),
    //                       child: CircleAvatar(
    //                         backgroundColor: Colors.white,
    //                         child: Center(
    //                           child: Padding(
    //                             padding: const EdgeInsets.all(3),
    //                             child: Image.asset(
    //                               ImagesConstants.logo,
    //                               scale: 2.5,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     actions: [
    //                       courseContentCubit.isScreenSplitted
    //                           ? IconButton(
    //                         onPressed: () {
    //                           courseContentCubit.changeSplitScreen(
    //                               value: false, pdfLink: "");
    //                         },
    //                         icon: Icon(
    //                           Icons.exit_to_app,
    //                           color: Colors.white,
    //                         ),
    //                       )
    //                           : IconButton(
    //                           onPressed: () {
    //                             Navigator.pop(context);
    //                           },
    //                           icon: Icon(
    //                             Icons.exit_to_app,
    //                             color: Colors.white,
    //                           )),
    //                     ],
    //                   ),
    //                   body: state is GetChapterContentLoadingState
    //                       ? Center(
    //                       child: CircularProgressIndicator(
    //                           color: ColorConstants.lightBlue))
    //                       : (
    //                       currentSelectedSubjectContentData != null
    //                       // &&
    //                       //         courseContentCubit
    //                       //             .chapterContent!.massage!.isNotEmpty
    //                   )
    //                       ? !courseContentCubit.isScreenSplitted
    //                       ? ListView(
    //                     controller: _scrollController,
    //                     padding: EdgeInsets.only(
    //                         bottom: MediaQuery.of(context)
    //                             .viewInsets
    //                             .bottom),
    //                     // crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       // Padding(
    //                       //   padding: const EdgeInsets.symmetric(
    //                       //       horizontal: 30, vertical: 12),
    //                       //   child: IntrinsicHeight(
    //                       //     child: Row(
    //                       //       children: [
    //                       //         Expanded(
    //                       //           child: Row(
    //                       //             mainAxisAlignment:
    //                       //                 MainAxisAlignment.center,
    //                       //             children: [
    //                       //               Icon(
    //                       //                 Icons.play_arrow,
    //                       //                 color: ColorConstants
    //                       //                     .darkBlue,
    //                       //                 size: 16,
    //                       //               ),
    //                       //               SizedBox(width: 8),
    //                       //               Text(
    //                       //                 courseContentCubit
    //                       //                     .videoCount
    //                       //                     .toString(),
    //                       //                 style: TextStyle(
    //                       //                   fontSize: 14,
    //                       //                   color: Colors.black,
    //                       //                   fontFamily: "Poppins",
    //                       //                   fontWeight:
    //                       //                       FontWeight.w500,
    //                       //                 ),
    //                       //               ),
    //                       //               Text(
    //                       //                 "Video".tr(),
    //                       //                 style: TextStyle(
    //                       //                   fontSize: 14,
    //                       //                   color: Colors.black,
    //                       //                   fontFamily: "Poppins",
    //                       //                   fontWeight:
    //                       //                       FontWeight.w500,
    //                       //                 ),
    //                       //               ),
    //                       //             ],
    //                       //           ),
    //                       //         ),
    //                       //         VerticalDivider(
    //                       //           thickness: 1,
    //                       //           color: Colors.black,
    //                       //         ),
    //                       //         Expanded(
    //                       //           child: Row(
    //                       //             mainAxisAlignment:
    //                       //                 MainAxisAlignment.center,
    //                       //             children: [
    //                       //               Text(
    //                       //                 courseContentCubit
    //                       //                     .musicCount
    //                       //                     .toString(),
    //                       //                 style: TextStyle(
    //                       //                   fontSize: 14,
    //                       //                   color: Colors.black,
    //                       //                   fontFamily: "Poppins",
    //                       //                   fontWeight:
    //                       //                       FontWeight.w500,
    //                       //                 ),
    //                       //               ),
    //                       //               Text(
    //                       //                 "Audio".tr(),
    //                       //                 style: TextStyle(
    //                       //                   fontSize: 14,
    //                       //                   color: Colors.black,
    //                       //                   fontFamily: "Poppins",
    //                       //                   fontWeight:
    //                       //                       FontWeight.w500,
    //                       //                 ),
    //                       //                 textAlign:
    //                       //                     TextAlign.center,
    //                       //               ),
    //                       //             ],
    //                       //           ),
    //                       //         ),
    //                       //         VerticalDivider(
    //                       //           thickness: 1,
    //                       //           color: Colors.black,
    //                       //         ),
    //                       //         Expanded(
    //                       //           child: Row(
    //                       //             mainAxisAlignment:
    //                       //                 MainAxisAlignment.center,
    //                       //             children: [
    //                       //               Text(
    //                       //                 courseContentCubit
    //                       //                     .pdfCount
    //                       //                     .toString(),
    //                       //                 style: TextStyle(
    //                       //                   fontSize: 14,
    //                       //                   color: Colors.black,
    //                       //                   fontFamily: "Poppins",
    //                       //                   fontWeight:
    //                       //                       FontWeight.w500,
    //                       //                 ),
    //                       //               ),
    //                       //               Text(
    //                       //                 "File".tr(),
    //                       //                 style: TextStyle(
    //                       //                   fontSize: 14,
    //                       //                   color: Colors.black,
    //                       //                   fontFamily: "Poppins",
    //                       //                   fontWeight:
    //                       //                       FontWeight.w500,
    //                       //                 ),
    //                       //               ),
    //                       //             ],
    //                       //           ),
    //                       //         ),
    //                       //       ],
    //                       //     ),
    //                       //   ),
    //                       // ),
    //                       if ((currentSelectedSubjectContentData
    //                           .free! ==
    //                           "yes" ||
    //                           widget.owned) &&
    //                           currentSelectedSubjectContentData
    //                               .type! !=
    //                               "pdf")
    //                         SizedBox(
    //                           height: BlocProvider.of<
    //                               CourseContentCubit>(
    //                               context)
    //                               .keyboard
    //                               ? 0
    //                               : 220,
    //                           child: Stack(
    //                             children: [
    //                               // PodVideoPlayer(
    //                               //   podPlayerLabels:
    //                               //       PodPlayerLabels(
    //                               //           quality: "Quality"),
    //                               //   controller: videoController!,
    //                               //   onToggleFullScreen:
    //                               //       (value) async {
    //                               //     setState(() {
    //                               //       isFullScreen = value;
    //                               //     });
    //                               //     if (value == true) {
    //                               //       await SystemChrome
    //                               //           .setEnabledSystemUIMode(
    //                               //               SystemUiMode.manual,
    //                               //               overlays: []);
    //                               //       await SystemChrome
    //                               //           .setPreferredOrientations([
    //                               //         DeviceOrientation
    //                               //             .landscapeLeft
    //                               //       ]);
    //                               //     } else {
    //                               //       await SystemChrome
    //                               //           .setEnabledSystemUIMode(
    //                               //               SystemUiMode.manual,
    //                               //               overlays:
    //                               //                   SystemUiOverlay
    //                               //                       .values);
    //                               //       await SystemChrome
    //                               //           .setPreferredOrientations([
    //                               //         DeviceOrientation
    //                               //             .portraitUp
    //                               //       ]);
    //                               //     }
    //                               //   },
    //                               // ),
    //                               controller == null ? Center(child: CircularProgressIndicator(),) : WebViewWidget(
    //                                 controller: controller!,
    //                               ),
    //                               randomTextWidget(),
    //                             ],
    //                           ),
    //                         ),
    //                       /*SizedBox(
    //                                 height: 220,
    //                                 child: Stack(
    //                                   children: [
    //                                     WebViewWidget(controller: courseContentCubit.webViewController!),
    //                                     InAppWebView(
    //                                       initialUrlRequest: URLRequest(url: Uri.parse(currentSelectedSubjectContentData.videoUrl!)),
    //                                       initialOptions: InAppWebViewGroupOptions(
    //                                         android: AndroidInAppWebViewOptions(
    //                                           useWideViewPort: false,
    //                                         ),
    //                                         ios: IOSInAppWebViewOptions(
    //                                           enableViewportScale: false,
    //                                           allowsInlineMediaPlayback: true,
    //                                         ),
    //                                         crossPlatform: InAppWebViewOptions(
    //                                           javaScriptEnabled: true,
    //                                           mediaPlaybackRequiresUserGesture: true
    //                                         ),
    //                                       ),
    //                                       onWebViewCreated: (InAppWebViewController controller) async {
    //                                         courseContentCubit.inAppWebViewController = controller;
    //                                         controller.addJavaScriptHandler(
    //                                           handlerName: "playVideo",
    //                                           callback: (args) {
    //                                           },
    //                                         );
    //                                         controller.addJavaScriptHandler(
    //                                           handlerName: "pauseVideo",
    //                                           callback: (args) {
    //                                           },
    //                                         );
    //                                       },
    //                                       onEnterFullscreen: (InAppWebViewController controller) async {
    //                                         await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    //                                         SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    //                                         setState(() {
    //                                           isFullScreen = true;
    //                                         });
    //                                         null;
    //                                       },
    //                                       onExitFullscreen: (InAppWebViewController controller) async {
    //                                         await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    //                                         SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //                                         setState(() {
    //                                           isFullScreen = false;
    //                                         });
    //                                       },
    //                                       onLoadStop: (InAppWebViewController controller, Uri? url) {
    //                                         controller.evaluateJavascript(
    //                                           source: """
    //                                             var video = document.querySelector('video'); // Assuming there's only one video element on the page
    //                                             if (video) {
    //                                               video.addEventListener('play', function() {
    //                                                   window.flutter_inappwebview.callHandler('playVideo');
    //                                                 console.log("Video is playing");
    //                                               });
    //                                               video.addEventListener('pause', function() {
    //                                                 console.log("Video is paused");
    //                                                 window.flutter_inappwebview.callHandler('pauseVideo');
    //                                               });
    //                                             }
    //                                           """,
    //                                         );
    //                                       },
    //                                       onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
    //                                         print("Console: ${consoleMessage.message}");
    //                                         print("================================================");
    //                                       },
    //                                     ),
    //                                     randomTextWidget(),
    //                                   ],
    //                                 ),
    //                               ),*/
    //                       if (currentSelectedSubjectContentData
    //                           .free! ==
    //                           "no" &&
    //                           !widget.owned)
    //                         SizedBox(
    //                           height: BlocProvider.of<
    //                               CourseContentCubit>(
    //                               context)
    //                               .keyboard
    //                               ? 0
    //                               : 220,
    //                           child: Center(
    //                             child: Text(
    //                               tr(StringConstants.lockCourse),
    //                               style: TextStyle(
    //                                   fontWeight: FontWeight.bold,
    //                                   fontSize: 15),
    //                               textAlign: TextAlign.center,
    //                             ),
    //                           ),
    //                         ),
    //                       if ((currentSelectedSubjectContentData
    //                           .free! ==
    //                           "yes" ||
    //                           widget.owned) &&
    //                           currentSelectedSubjectContentData
    //                               .type! ==
    //                               "pdf")
    //                         NewPdfScreen(
    //                             link:
    //                             currentSelectedSubjectContentData
    //                                 .videoUrl!),
    //                       Padding(
    //                         padding: const EdgeInsets.symmetric(
    //                             horizontal: 16),
    //                         child: Column(
    //                           crossAxisAlignment:
    //                           CrossAxisAlignment.start,
    //                           children: [
    //                             SizedBox(
    //                               height: 10,
    //                             ),
    //                             Text(
    //                                 currentSelectedSubjectContentData
    //                                     .videoTitle!,
    //                                 style: TextStyle(
    //                                     color: Colors.black,
    //                                     fontWeight: FontWeight.w600,
    //                                     fontSize: 18)),
    //                             SizedBox(
    //                               height: 12,
    //                             ),
    //                             Text("Description".tr(),
    //                                 style: TextStyle(
    //                                     color: Colors.black,
    //                                     fontWeight: FontWeight.w600,
    //                                     fontSize: 18)),
    //                             SizedBox(
    //                               height: 12,
    //                             ),
    //                             ExpandableText(
    //                               currentSelectedSubjectContentData
    //                                   .videoDescription!,
    //                               expandText: 'ShowMore'.tr(),
    //                               collapseText: 'ShowLess'.tr(),
    //                               maxLines: 3,
    //                               linkColor:
    //                               ColorConstants.lightBlue,
    //                               style: TextStyle(
    //                                   color: Colors.black45,
    //                                   fontWeight: FontWeight.w400,
    //                                   fontSize: 14),
    //                             ),
    //                             TabBar(
    //                               controller: tabController,
    //                               indicatorColor:
    //                               ColorConstants.lightBlue,
    //                               labelColor:
    //                               ColorConstants.lightBlue,
    //                               unselectedLabelColor:
    //                               Colors.black,
    //                               tabs: [
    //                                 Tab(text: "pdfs".tr()),
    //                                 Tab(text: "Comments".tr()),
    //                               ],
    //                             ),
    //                             SizedBox(
    //                               height: 12,
    //                             ),
    //                             if (tabController.index == 0)
    //                               ListView.separated(
    //                                 shrinkWrap: true,
    //                                 physics:
    //                                 NeverScrollableScrollPhysics(),
    //                                 itemBuilder: (context, index) {
    //                                   // final List<Massage> pdfFiles =
    //                                   //     courseContentCubit
    //                                   //         .chapterContent!
    //                                   //         .massage!
    //                                   //         .where((element) =>
    //                                   //             element.type ==
    //                                   //             "pdf")
    //                                   //         .toList();
    //
    //
    //                                   return ListTile(
    //                                     onTap: () async {
    //                                       scrollToTop();
    //                                       // await courseContentCubit
    //                                       //     .changeContentIndex(
    //                                       //   index: index,
    //                                       //   own: widget.owned,
    //                                       // )
    //                                       // .then((value) async {
    //                                       final newUrl = pdfs[
    //                                       index]
    //                                           .videoUrl;
    //                                       final isFree =
    //                                           pdfs[index]
    //                                               .free ==
    //                                               "yes";
    //                                       if (newUrl != null &&
    //                                           newUrl != "" &&
    //                                           (isFree ||
    //                                               widget.owned)) {
    //                                         if (pdfs[
    //                                         index]
    //                                             .type ==
    //                                             "pdf") {
    //                                           Navigator.push(
    //                                               context,
    //                                               MaterialPageRoute(
    //                                                   builder: ((context) =>
    //                                                       PDFScreen(
    //                                                           link:
    //                                                           newUrl))));
    //                                         }
    //
    //                                         // try {
    //                                         //   if (courseContentCubit
    //                                         //           .chapterContent!
    //                                         //           .massage![
    //                                         //               index]
    //                                         //           .type ==
    //                                         //       "video"
    //                                         //           .toLowerCase()) {
    //
    //                                         //     await videoController
    //                                         //         ?.changeVideo(
    //                                         //       playVideoFrom:
    //                                         //           PlayVideoFrom
    //                                         //               .vimeo(
    //                                         //                   newUrl),
    //                                         //       playerConfig:
    //                                         //           PodPlayerConfig(
    //                                         //         videoQualityPriority:
    //                                         //             qualityOptions,
    //                                         //         autoPlay:
    //                                         //             false,
    //                                         //       ),
    //                                         //     );
    //                                         //   }else{
    //
    //                                         videoController
    //                                             ?.pause();
    //                                         flutterTts.stop();
    //
    //                                         //   }
    //                                         // } catch (e) {
    //                                         //   videoController =
    //                                         //       PodPlayerController(
    //                                         //     playVideoFrom:
    //                                         //         PlayVideoFrom
    //                                         //             .vimeo(
    //                                         //                 newUrl),
    //                                         //     podPlayerConfig:
    //                                         //         PodPlayerConfig(
    //                                         //       videoQualityPriority:
    //                                         //           qualityOptions,
    //                                         //       autoPlay: false,
    //                                         //     ),
    //                                         //   )
    //                                         //         ..initialise()
    //                                         //         ..addListener(
    //                                         //             () =>
    //                                         //                 videoListener());
    //                                         // }
    //                                       }
    //                                       // });
    //                                     },
    //                                     leading: pdfs[index]
    //                                         .type ==
    //                                         "pdf"
    //                                         ? Icon(
    //                                       FontAwesomeIcons
    //                                           .filePdf,
    //                                       color: courseContentCubit
    //                                           .currentContentIndex ==
    //                                           index
    //                                           ? ColorConstants
    //                                           .lightBlue
    //                                           : Colors.black,
    //                                     )
    //                                         : pdfs[index]
    //                                         .type ==
    //                                         "audio"
    //                                         ? Icon(
    //                                       FontAwesomeIcons
    //                                           .fileAudio,
    //                                       color: courseContentCubit
    //                                           .currentContentIndex ==
    //                                           index
    //                                           ? ColorConstants
    //                                           .lightBlue
    //                                           : Colors
    //                                           .black,
    //                                     )
    //                                         : Container(
    //                                       width: 25,
    //                                       decoration:
    //                                       BoxDecoration(
    //                                         color: courseContentCubit
    //                                             .currentContentIndex ==
    //                                             index
    //                                             ? ColorConstants
    //                                             .lightBlue
    //                                             : Colors
    //                                             .white,
    //                                         shape: BoxShape
    //                                             .circle,
    //                                         border: Border
    //                                             .all(
    //                                           color: ColorConstants
    //                                               .lightBlue,
    //                                         ),
    //                                       ),
    //                                       child: Center(
    //                                         child: Text(
    //                                           (index + 1)
    //                                               .toString(),
    //                                           style:
    //                                           TextStyle(
    //                                             color: courseContentCubit.currentContentIndex ==
    //                                                 index
    //                                                 ? Colors
    //                                                 .white
    //                                                 : ColorConstants
    //                                                 .lightBlue,
    //                                           ),
    //                                         ),
    //                                       ),
    //                                     ),
    //                                     title: Text(
    //                                       pdfs[index]
    //                                           .videoTitle ??
    //                                           "",
    //                                       style: TextStyle(
    //                                           color: Colors.black,
    //                                           fontWeight:
    //                                           FontWeight.w400,
    //                                           fontSize: 14),
    //                                       maxLines: 1,
    //                                       overflow:
    //                                       TextOverflow.ellipsis,
    //                                     ),
    //                                     subtitle:
    //                                     pdfs[index].type ==
    //                                         "video"
    //                                         ? Column(
    //                                       crossAxisAlignment:
    //                                       CrossAxisAlignment
    //                                           .start,
    //                                       children: [
    //                                         Row(
    //                                           mainAxisAlignment:
    //                                           MainAxisAlignment
    //                                               .spaceBetween,
    //                                           children: [
    //                                             Row(
    //                                               children: [
    //                                                 Icon(
    //                                                   Icons.play_arrow,
    //                                                   size:
    //                                                   16,
    //                                                   color: courseContentCubit.currentContentIndex == index
    //                                                       ? ColorConstants.lightBlue
    //                                                       : Colors.black,
    //                                                 ),
    //                                                 SizedBox(
    //                                                   width:
    //                                                   10,
    //                                                 ),
    //                                                 Text(
    //                                                     "Video File"),
    //                                               ],
    //                                             ),
    //                                             Row(
    //                                               children: [
    //                                                 if (pdfs[index].free == "no" &&
    //                                                     !widget.owned)
    //                                                   Icon(Icons.lock, color: Colors.black45),
    //                                               ],
    //                                             ),
    //                                           ],
    //                                         ),
    //                                         Divider(
    //                                             color: Colors
    //                                                 .black45),
    //                                       ],
    //                                     )
    //                                         : pdfs[index]
    //                                         .type ==
    //                                         "pdf"
    //                                         ? Column(
    //                                       crossAxisAlignment:
    //                                       CrossAxisAlignment
    //                                           .start,
    //                                       children: [
    //                                         Row(
    //                                           mainAxisAlignment:
    //                                           MainAxisAlignment.spaceBetween,
    //                                           children: [
    //                                             Text(
    //                                               "Pdf File",
    //                                               style: TextStyle(
    //                                                   color: Colors.black87,
    //                                                   fontWeight: FontWeight.w400,
    //                                                   fontSize: 12),
    //                                               maxLines:
    //                                               1,
    //                                               overflow:
    //                                               TextOverflow.ellipsis,
    //                                             ),
    //                                             Row(
    //                                               children: [
    //                                                 if (pdfs[index].free == "no" && !widget.owned)
    //                                                   Icon(Icons.lock, color: Colors.black45),
    //                                                 if (currentSelectedSubjectContentData.type != "pdf" && (currentSelectedSubjectContentData.free == "yes" || widget.owned) && (pdfs[index].free == "yes" || widget.owned))
    //                                                   SizedBox(
    //                                                     width: 10,
    //                                                   ),
    //                                                 if (currentSelectedSubjectContentData.type != "pdf" && (currentSelectedSubjectContentData.free == "yes" || widget.owned) && (pdfs[index].free == "yes" || widget.owned))
    //                                                   GestureDetector(
    //                                                     onTap: () {
    //                                                       courseContentCubit.changeSplitScreen(
    //                                                         value: true,
    //                                                         pdfLink: pdfs[index].videoUrl!,
    //                                                       );
    //                                                     },
    //                                                     child: Icon(Icons.splitscreen, color: Colors.black45),
    //                                                   ),
    //                                               ],
    //                                             ),
    //                                           ],
    //                                         ),
    //                                         Divider(
    //                                             color:
    //                                             Colors.black45),
    //                                       ],
    //                                     )
    //                                         : Column(
    //                                       crossAxisAlignment:
    //                                       CrossAxisAlignment
    //                                           .start,
    //                                       children: [
    //                                         Row(
    //                                           mainAxisAlignment:
    //                                           MainAxisAlignment.spaceBetween,
    //                                           children: [
    //                                             Text(
    //                                               "Audio File",
    //                                               style: TextStyle(
    //                                                   color: Colors.black87,
    //                                                   fontWeight: FontWeight.w400,
    //                                                   fontSize: 12),
    //                                               maxLines:
    //                                               1,
    //                                               overflow:
    //                                               TextOverflow.ellipsis,
    //                                             ),
    //                                             Row(
    //                                               children: [
    //                                                 if (pdfs[index].free == "no" && !widget.owned)
    //                                                   Icon(Icons.lock, color: Colors.black45),
    //                                               ],
    //                                             ),
    //                                           ],
    //                                         ),
    //                                         Divider(
    //                                             color:
    //                                             Colors.black45),
    //                                       ],
    //                                     ),
    //                                   );
    //                                 },
    //                                 separatorBuilder:
    //                                     (context, index) =>
    //                                     SizedBox(
    //                                       height: 0,
    //                                     ),
    //                                 itemCount: pdfs.length,
    //                               ),
    //                             if (tabController.index == 1)
    //                               ListView.separated(
    //                                 shrinkWrap: true,
    //                                 physics:
    //                                 NeverScrollableScrollPhysics(),
    //                                 itemBuilder: (context, index) {
    //                                   courseContentCubit
    //                                       .courseCommentsModel!
    //                                       .massage!
    //                                       .sort((a, b) => b.date!
    //                                       .compareTo(a.date!));
    //                                   DateTime commentDate = DateTime
    //                                       .parse(courseContentCubit
    //                                       .courseCommentsModel!
    //                                       .massage![index]
    //                                       .date!);
    //                                   String
    //                                   formattedTimeDifference =
    //                                   formatTimeDifference(
    //                                       commentDate);
    //                                   return ListTile(
    //                                     leading: courseContentCubit
    //                                         .courseCommentsModel!
    //                                         .massage![index]
    //                                         .ownerData!
    //                                         .studentPhoto ==
    //                                         ""
    //                                         ? Icon(
    //                                       FontAwesomeIcons
    //                                           .user,
    //                                       color:
    //                                       Colors.black45,
    //                                     )
    //                                         : CircleAvatar(
    //                                       radius: 25,
    //                                       backgroundImage: NetworkImage(
    //                                           courseContentCubit
    //                                               .courseCommentsModel!
    //                                               .massage![
    //                                           index]
    //                                               .ownerData!
    //                                               .studentPhoto!),
    //                                     ),
    //                                     title: Text(
    //                                       courseContentCubit
    //                                           .courseCommentsModel!
    //                                           .massage![index]
    //                                           .ownerData!
    //                                           .studentName ??
    //                                           "",
    //                                       style: TextStyle(
    //                                           color: Colors.black,
    //                                           fontWeight:
    //                                           FontWeight.w400,
    //                                           fontSize: 14),
    //                                     ),
    //                                     subtitle: ExpandableText(
    //                                       courseContentCubit
    //                                           .courseCommentsModel!
    //                                           .massage![index]
    //                                           .commentDetails!,
    //                                       expandText:
    //                                       'ShowMore'.tr(),
    //                                       collapseText:
    //                                       'ShowLess'.tr(),
    //                                       maxLines: 3,
    //                                       linkColor: ColorConstants
    //                                           .lightBlue,
    //                                       style: TextStyle(
    //                                           color: Colors.black45,
    //                                           fontWeight:
    //                                           FontWeight.w400,
    //                                           fontSize: 14),
    //                                     ),
    //                                     trailing: Text(
    //                                       formattedTimeDifference,
    //                                       style: TextStyle(
    //                                           color: Colors.grey,
    //                                           fontSize: 10),
    //                                     ),
    //                                   );
    //                                 },
    //                                 separatorBuilder:
    //                                     (context, index) =>
    //                                     SizedBox(
    //                                       height: 0,
    //                                     ),
    //                                 itemCount: courseContentCubit
    //                                     .courseCommentsModel!
    //                                     .massage!
    //                                     .length,
    //                               ),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   )
    //                       : Column(
    //                     children: [
    //                       Stack(
    //                         children: [
    //                           PodVideoPlayer(
    //                             controller: videoController!,
    //                             onToggleFullScreen: (value) async {
    //                               setState(() {
    //                                 isFullScreen = value;
    //                               });
    //                               if (value == true) {
    //                                 await SystemChrome
    //                                     .setEnabledSystemUIMode(
    //                                     SystemUiMode.manual,
    //                                     overlays: []);
    //                                 await SystemChrome
    //                                     .setPreferredOrientations([
    //                                   DeviceOrientation
    //                                       .landscapeLeft
    //                                 ]);
    //                               } else {
    //                                 await SystemChrome
    //                                     .setEnabledSystemUIMode(
    //                                     SystemUiMode.manual,
    //                                     overlays:
    //                                     SystemUiOverlay
    //                                         .values);
    //                                 await SystemChrome
    //                                     .setPreferredOrientations([
    //                                   DeviceOrientation.portraitUp
    //                                 ]);
    //                               }
    //                             },
    //                           ),
    //                           randomTextWidget(),
    //                         ],
    //                       ),
    //                       /*SizedBox(
    //                                 height: 220,
    //                                 child: Stack(
    //                                   children: [
    //                                     InAppWebView(
    //                                       initialUrlRequest: URLRequest(
    //                                           url: Uri.parse(currentSelectedSubjectContentData.videoUrl!)),
    //                                       initialOptions: InAppWebViewGroupOptions(
    //                                         android: AndroidInAppWebViewOptions(
    //                                           useWideViewPort: false,
    //                                         ),
    //                                         ios: IOSInAppWebViewOptions(
    //                                           enableViewportScale: false,
    //                                         ),
    //                                         crossPlatform: InAppWebViewOptions(
    //                                           javaScriptEnabled: true,
    //                                         ),
    //                                       ),
    //                                       onWebViewCreated: (InAppWebViewController controller) async {
    //                                         courseContentCubit.inAppWebViewController = controller;
    //                                         controller.addJavaScriptHandler(
    //                                           handlerName: "playVideo",
    //                                           callback: (args) {
    //                                           },
    //                                         );
    //
    //                                         controller.addJavaScriptHandler(
    //                                           handlerName: "pauseVideo",
    //                                           callback: (args) {
    //                                           },
    //                                         );
    //                                       },
    //                                       onEnterFullscreen: (InAppWebViewController controller) {
    //                                         setState(() {
    //                                           isFullScreen = true;
    //                                         });
    //                                       },
    //                                       onExitFullscreen: (InAppWebViewController controller) {
    //                                         setState(() {
    //                                           isFullScreen = false;
    //                                         });
    //                                       },
    //                                       onLoadStop: (InAppWebViewController controller, Uri? url) {
    //                                         controller.evaluateJavascript(
    //                                           source: """
    //                                             var video = document.querySelector('video');
    //                                             if (video) {
    //                                               video.addEventListener('play', function() {
    //                                                 window.flutter_inappwebview.callHandler('playVideo');
    //                                                 console.log("Video is playing");
    //                                               });
    //                                               video.addEventListener('pause', function() {
    //                                                 console.log("Video is paused");
    //                                                 window.flutter_inappwebview.callHandler('pauseVideo');
    //                                               });
    //                                             }
    //                                           """,
    //                                         );
    //                                       },
    //                                       onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
    //                                         print("Console: ${consoleMessage.message}");
    //                                       },
    //                                     ),
    //                                     randomTextWidget(),
    //                                   ],
    //                                 ),
    //                               ),*/
    //                       Expanded(
    //                         child: PdfScreenSplitting(
    //                           link: courseContentCubit
    //                               .currentLinkPdfWithSplittedScreen,
    //                         ),
    //                       ),
    //                     ],
    //                   )
    //                       : Center(
    //                     child: Text(
    //                       tr(StringConstants.noContentsYet),
    //                       style: const TextStyle(
    //                           fontWeight: FontWeight.bold),
    //                     ),
    //                   ),
    //                   bottomNavigationBar: tabController.index == 1
    //                       ? Transform.translate(
    //                     offset: Offset(
    //                         0,
    //                         isKeyboardVisible
    //                             ? -MediaQuery.of(context).viewInsets.bottom
    //                             : 0),
    //                     child: Padding(
    //                       padding: const EdgeInsets.symmetric(
    //                           horizontal: 8, vertical: 16),
    //                       child: Row(
    //                         children: [
    //                           Expanded(
    //                             child: myTextFormField(
    //                               onTap: () {
    //                                 BlocProvider.of<CourseContentCubit>(
    //                                     context)
    //                                     .changeKeyboard(true);
    //                               },
    //                               context: context,
    //                               controller: commentController,
    //                               hint: "make comment hint".tr(),
    //                               fillColor: Colors.deepPurple[200],
    //                               border: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.all(
    //                                     Radius.circular(12)),
    //                                 borderSide: BorderSide(
    //                                   color: Colors.deepPurple,
    //                                 ),
    //                               ),
    //                               enabledBorder: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.all(
    //                                     Radius.circular(12)),
    //                                 borderSide: BorderSide(
    //                                   color: Colors.deepPurple,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             width: 20,
    //                           ),
    //                           GestureDetector(
    //                               onTap: () {
    //                                 if (commentController.text.isNotEmpty) {
    //                                   courseContentCubit
    //                                       .makeCommentOnCourseContent(
    //                                       courseId: widget.ChapterId,
    //                                       commentDetails:
    //                                       commentController.text);
    //                                   SystemChannels.textInput
    //                                       .invokeMethod('TextInput.hide');
    //                                   commentController.clear();
    //                                   BlocProvider.of<CourseContentCubit>(
    //                                       context)
    //                                       .changeKeyboard(false);
    //                                   FocusScope.of(context).unfocus();
    //                                 }
    //                               },
    //                               child: Icon(Icons.send,
    //                                   color: ColorConstants.lightBlue)),
    //                         ],
    //                       ),
    //                     ),
    //                   )
    //                       : null,
    //                 );
    //               },
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // },
    //   );
  }

  List handlePosition(double height){
    if(height >= 1300) //pro 12.9
        {
      return [MediaQuery.sizeOf(context).height*.165,MediaQuery.sizeOf(context).height*.062];
    }

    if(height >= 1180 && height < 1300) //ipad xth Gen
        {
      return [MediaQuery.sizeOf(context).height*.145,MediaQuery.sizeOf(context).height*.075];
    }

    if(height >= 1133 && height < 1180) //pro 11,ipad mini
        {
      return [MediaQuery.sizeOf(context).height*.125,MediaQuery.sizeOf(context).height*.08];
    }

    if(height >= 1024 && height < 1133) //pro 9.7, pro 10.5, air
        {
      return [MediaQuery.sizeOf(context).height*.145,MediaQuery.sizeOf(context).height*.075];
    }
    return [];
  }

  Widget randomTextWidget() {
    return AnimatedPositioned(
      left: _xPosition,
      top: _yPosition,
      duration: const Duration(milliseconds: 1000),
      child: Transform.rotate(
        angle: 50,
        child: Stack(
          children: [
            Text(
              '$stuId',
              style: TextStyle(
                fontSize: 18,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 4
                  ..color = ColorConstants.lightBlue.withOpacity(0.8),
              ),
            ),
            Text(
              '$stuId',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
