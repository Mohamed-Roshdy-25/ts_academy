import 'dart:async';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/constants/string_constants.dart';
import 'package:ts_academy/screens/new_course_content/cubit/cubit.dart';
import 'package:ts_academy/screens/new_course_content/cubit/states.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CourseVideoScreen extends StatefulWidget {
  const CourseVideoScreen({super.key});

  @override
  State<CourseVideoScreen> createState() => _CourseVideoScreenState();
}

class _CourseVideoScreenState extends State<CourseVideoScreen> {
  double _xPosition = 0;
  double _yPosition = 0;
  Timer? ttsTimer;
  late final WebViewController _controller;

  @override
  void initState() {
    final currentSelectedSubjectContentData =
    (context.read<CourseContentCubit>().chapterContent != null && context.read<CourseContentCubit>().chapterContent!.massage!.isNotEmpty)
        ? context.read<CourseContentCubit>().chapterContent!.massage![context.read<CourseContentCubit>().currentContentIndex]
        : null;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(currentSelectedSubjectContentData!.videoUrl!));
    _moveText();
    _handleTts(true);
    super.initState();

  }



  void setTtsAudio() {
    if (ttsTimer == null) {
      ttsTimer = Timer.periodic(const Duration(seconds: 75), (timer) async {
        List<String> digits = stuId.toString().split('').toList();
        await flutterTts.speak('$digits');
      });
    }
  }

  FlutterTts flutterTts = FlutterTts();

  Future<void> initTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.6);
    await flutterTts.setPitch(0.5);
    await flutterTts.setVolume(0.5); // Volume should be between 0 and 1

    // Get the list of available voices
    List<dynamic> voices = await flutterTts.getVoices;

    // Find and set another voice (replace 'desiredVoiceName' with the actual voice name you want to use)
    for (dynamic voice in voices) {
      if (voice['voiceName'] == 'desiredVoiceName') {
        await flutterTts.setVoice(voice['voiceName']);
        break; // Stop after setting the voice
      }
    }
  }

  void _moveText() {
    Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      if (mounted) {
        setState(() {
          _xPosition = _randomPosition(MediaQuery.of(context).size.width - 100);
          _yPosition = _randomPosition(MediaQuery.of(context).size.height - 100);
        });
      }
    });
  }

  double _randomPosition(double max) {
    return Random().nextDouble() * max;
  }

  void _handleTts(bool playTts) {
    if (playTts) {
      initTts();
      setTtsAudio();
    } else {
      ttsTimer?.cancel();
      ttsTimer = null;
    }
  }

  @override
  void dispose() {
    _handleTts(false);
    super.dispose();
  }

  @override
  void deactivate() {
    _handleTts(false);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseContentCubit, CourseContentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        CourseContentCubit courseContentCubit = BlocProvider.of(context);
        final currentSelectedSubjectContentData =
            (courseContentCubit.chapterContent != null && courseContentCubit.chapterContent!.massage!.isNotEmpty)
                ? courseContentCubit.chapterContent!.massage![courseContentCubit.currentContentIndex]
                : null;
        return (currentSelectedSubjectContentData != null && courseContentCubit.chapterContent!.massage!.isNotEmpty)
            ? WillPopScope(
                onWillPop: () async {
                  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                  return true;
                },
                child: Scaffold(
                  extendBody: true,
                  body: Stack(
                    fit: StackFit.expand,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: WebViewWidget(controller: _controller),
                      ),
                      randomTextWidget(),
                    ],
                  ),
                ),
              )
            : Center(
                child: Text(
                  tr(StringConstants.noContentsYet),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
      },
    );
  }

  Widget randomTextWidget() {
    return AnimatedPositioned(
      left: _xPosition,
      top: _yPosition,
      duration: const Duration(milliseconds: 1000),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 3,
        ),
        color: Colors.black38,
        child: Transform.rotate(
          angle: 50,
          child: Text(
            '${myName} $stuId',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white70, fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }
}
