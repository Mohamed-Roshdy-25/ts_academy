//
// // class VideoPlayerScreen extends StatefulWidget {
// //   final String videoUrl;
// //   const VideoPlayerScreen({super.key, required this.videoUrl});
// //
// //   @override
// //   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// // }
// //
// // class _VideoPlayerScreenState extends State<VideoPlayerScreen>
// //     with SingleTickerProviderStateMixin {
// //   late  YoutubePlayerController  _controller;
// //   bool isScreenTapped = false;
// //   bool isFullScreen = false;
// //   String userName = myName!;
// //   String userId = stuId!;
// //   Timer? _ttsTimer;
// //   bool _isVideoPlaying = false;
// //    FlutterTts flutterTts=FlutterTts();
// //   double _xPosition = 0;
// //   double _yPosition = 0;
// //   final _headsetPlugin = HeadsetEvent();
// //   HeadsetState? _headsetState;
// //   int? lengthVideo;
// //
// //   static const List<double> _examplePlaybackRates = <double>[
// //     0.25,
// //     0.5,
// //     1.0,
// //     1.5,
// //     2.0,
// //     3.0,
// //     5.0,
// //     10.0,
// //   ];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     Future.delayed(Duration.zero, () {
// //       BlocProvider.of<PermissionCubit>(context).getUserPermission(stuId!);
// //     });
// //     initTts();
// //     _controller = YoutubePlayerController(
// //       initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
// //       flags: YoutubePlayerFlags(
// //         autoPlay: true,
// //         mute: false,
// //         enableCaption: false,
// //       ),
// //     )..addListener(_onVideoStatusChanged);
// //     _headsetPlugin.requestPermission();
// //     _headsetPlugin.getCurrentState.then((val) {
// //       setState(() {
// //         _headsetState = val!;
// //       });
// //     });
// //
// //     _headsetPlugin.setListener((val) {
// //       setState(() {
// //         _headsetState = val;
// //       });
// //     });
// //     if (mounted) {
// //       _moveText();
// //     }
// //   }
// //
// //   Timer? timer;
// //   Future setTtsAudio() async {
// //       if (_controller.value.isPlaying) {
// //         if (!timer!.isActive) {
// //           timer = Timer.periodic(
// //              Duration(seconds: int.parse(BlocProvider.of<SettingsCubit>(context).settingsModel?.tts_interval??"10")),
// //             (timer) async {
// //               _controller.play();
// //               List<String> digits = stuId.toString().split('').toList();
// //               await flutterTts.speak('$myName $digits');
// //             },
// //           );
// //         }
// //       } else {
// //         timer?.cancel();
// //         flutterTts.stop();
// //       }
// //
// //   }
// //
// //   Future<void> initTts() async {
// //     await flutterTts.setLanguage('en-US');
// //     await flutterTts.setSpeechRate(3.0);
// //     await flutterTts.setVolume(double.parse(BlocProvider.of<SettingsCubit>(context).settingsModel?.tts_speedd??"5.5"));
// //   }
// //
// //   void _stopTTS() {
// //     flutterTts.stop();
// //     _ttsTimer?.cancel();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     flutterTts.stop();
// //     _ttsTimer?.cancel();
// //     super.dispose();
// //   }
// //
// //   void _moveText() {
// //     Timer.periodic(const Duration(seconds: 1), (timer) {
// //       if (mounted) {
// //         setState(() {
// //           _xPosition = _randomPosition();
// //           _yPosition = _randomPosition();
// //         });
// //       }
// //     });
// //   }
// //
// //   double _randomPosition() {
// //     return (100 * (Random().nextInt(4) * (0.5 - (10020 % 1000) / 1000)));
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         _buildVideoPlayer(
// //             isFullScreen: isFullScreen,
// //             speedList: _examplePlaybackRates,
// //             isHeadsetConnect: _headsetState ?? HeadsetState.DISCONNECT),
// //         _buildNameOverlay(),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildVideoPlayer(
// //       {required bool isFullScreen,
// //       required List<double> speedList,
// //       required HeadsetState isHeadsetConnect}) {
// //
// //     if (_controller.value.isPlaying) {
// //       return AspectRatio(
// //         aspectRatio: 16 / 9,
// //         child: Stack(
// //           alignment: Alignment.bottomCenter,
// //           children: [
// //             Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 GestureDetector(
// //                     onTap: () {
// //                       setState(() {
// //                         isScreenTapped = !isScreenTapped;
// //                       });
// //                     },
// //                     child: YoutubePlayer( controller: _controller,)),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: GestureDetector(
// //                         onDoubleTap: () {
// //                           setState(() {
// //                             isScreenTapped = false;
// //                           });
// //                           Duration currentPosition = _controller.value.position;
// //                           Duration targetPosition =
// //                               currentPosition - const Duration(seconds: 10);
// //                           _controller.seekTo(targetPosition);
// //                         },
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: GestureDetector(
// //                         onDoubleTap: () {
// //                           setState(() {
// //                             isScreenTapped = false;
// //                           });
// //                           Duration currentPosition = _controller.value.position;
// //                           Duration targetPosition =
// //                               currentPosition + const Duration(seconds: 10);
// //                           _controller.seekTo(targetPosition);
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //             isScreenTapped
// //                 ? const SizedBox()
// //                 : Padding(
// //                     padding:
// //                         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                     child: Row(
// //                       children: [
// //                         GestureDetector(
// //                             onTap: () {
// //                               if (BlocProvider.of<PermissionCubit>(context)
// //                                       .earphonePermission ==
// //                                   true) {
// //                                 setState(() {
// //                                   _controller.value.isPlaying
// //                                       ? _controller.pause()
// //                                       : _controller.play();
// //                                 });
// //                               } else {
// //                                 if (isHeadsetConnect == HeadsetState.CONNECT) {
// //                                   setState(() {
// //                                     _controller.value.isPlaying
// //                                         ? _controller.pause()
// //                                         : _controller.play();
// //                                   });
// //                                 } else {
// //                                   showMyDialog(
// //                                     context: context,
// //                                     onConfirm: () {
// //                                       Navigator.pop(context);
// //                                     },
// //                                     isCancelButton: false,
// //                                     contentWidget: Text(tr(StringConstants
// //                                         .earphone_connection_confirmation)),
// //                                   );
// //                                 }
// //                               }
// //                             },
// //                             child: Icon(
// //                               _controller.value.isPlaying
// //                                   ? Icons.pause
// //                                   : Icons.play_arrow,
// //                               color: Colors.white,
// //                             )),
// //                         const SizedBox(width: 10),
// //                         ValueListenableBuilder(
// //                           valueListenable: _controller,
// //                           builder: (context, VideoPlayerValue value, child) {
// //                             //Do Something with the value.
// //                             return Text(
// //                               value.position.toString().substring(0, 7),
// //                               style: const TextStyle(color: Colors.white),
// //                             );
// //                           },
// //                         ),
// //                         Expanded(
// //                           child: VideoProgressIndicator(
// //                             _controller,
// //                             colors: VideoProgressColors(
// //                               playedColor: ColorConstants.purpal,
// //                               backgroundColor: Colors.white,
// //                               bufferedColor: Colors.grey,
// //                             ),
// //                             allowScrubbing: true,
// //                             padding: const EdgeInsets.all(8),
// //                           ),
// //                         ),
// //                         Row(
// //                           children: [
// //                             PopupMenuButton<double>(
// //                               initialValue: _controller.value.playbackSpeed,
// //                               tooltip: 'Playback speed',
// //                               onSelected: (double speed) {
// //                                 setState(() {
// //                                   speed = speed;
// //                                 });
// //                                 _controller.setPlaybackSpeed(speed);
// //                               },
// //                               itemBuilder: (BuildContext context) {
// //                                 return <PopupMenuItem<double>>[
// //                                   for (final double speed in speedList)
// //                                     PopupMenuItem<double>(
// //                                       value: speed,
// //                                       child: Text('${speed}x'),
// //                                     )
// //                                 ];
// //                               },
// //                               child: Padding(
// //                                 padding: const EdgeInsets.symmetric(
// //                                   // Using less vertical padding as the text is also longer
// //                                   // horizontally, so it feels like it would need more spacing
// //                                   // horizontally (matching the aspect ratio of the video).
// //                                   vertical: 12,
// //                                   horizontal: 16,
// //                                 ),
// //                                 child: Text(
// //                                   '${_controller.value.playbackSpeed}x',
// //                                   style: const TextStyle(
// //                                       color: Colors.white,
// //                                       fontWeight: FontWeight.bold),
// //                                 ),
// //                               ),
// //                             ),
// //                             GestureDetector(
// //                               onTap: () async {
// //                                 if (MediaQuery.of(context).orientation ==
// //                                     Orientation.landscape) {
// //                                   _controller.pause();
// //                                   await SystemChrome.setEnabledSystemUIMode(
// //                                       SystemUiMode.manual,
// //                                       overlays: SystemUiOverlay.values);
// //                                   SystemChrome.setPreferredOrientations(
// //                                       [DeviceOrientation.portraitUp]);
// //                                 } else {
// //                                   _controller.pause();
// //                                   await SystemChrome.setEnabledSystemUIMode(
// //                                       SystemUiMode.manual,
// //                                       overlays: []);
// //                                   SystemChrome.setPreferredOrientations(
// //                                       [DeviceOrientation.landscapeLeft]);
// //                                 }
// //                               },
// //                               child: const Icon(
// //                                 Icons.fullscreen,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //           ],
// //         ),
// //       );
// //     } else {
// //       return Center(
// //         child: CircularProgressIndicator(
// //           color: ColorConstants.purpal,
// //         ),
// //       );
// //     }
// //   }
// //
// //   Widget _buildNameOverlay() {
// //     return Positioned(
// //       left: _xPosition,
// //       top: _yPosition,
// //       child: Text(
// //         userName,
// //         style: TextStyle(
// //           color: Colors.white.withOpacity(double.parse(
// //               BlocProvider.of<SettingsCubit>(context)
// //                       .settingsModel!
// //                       .watermark_opacity
// //                       .toString() ??
// //                   ".3")),
// //           fontSize: 16.0,
// //           fontWeight: FontWeight.bold,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _onVideoStatusChanged() {
// //     final isPlaying = _controller.value.isPlaying;
// //     if (isPlaying && !_isVideoPlaying) {
// //       _isVideoPlaying = true;
// //       setTtsAudio();
// //     } else if (!isPlaying && _isVideoPlaying) {
// //       _isVideoPlaying = false;
// //       _stopTTS();
// //     }
// //   }
// //
// //   // void _startTTS() {
// //   //   _ttsTimer = Timer.periodic(
// //   //       Duration(
// //   //           seconds: int.parse(BlocProvider.of<SettingsCubit>(context)
// //   //                   .settingsModel!
// //   //                   .tts_interval
// //   //                   .toString() ??
// //   //               "4")), (timer) {
// //   //     flutterTts.speak("$userName $userId");
// //   //     flutterTts.setLanguage('en-US');
// //   //     flutterTts.setSpeechRate(double.parse(
// //   //         BlocProvider.of<SettingsCubit>(context)
// //   //                 .settingsModel!
// //   //                 .tts_speedd
// //   //                 .toString() ??
// //   //             "4.0"));
// //   //     flutterTts.setVolume(.4);
// //   //   });
// //   // }
// //
// //   void showMyDialog({
// //     required BuildContext context,
// //     IconData? icon,
// //     required Function onConfirm,
// //     Widget? contentWidget,
// //     Widget? titleWidget,
// //     Key? formKey,
// //     String? confirmText,
// //     String? cancelText,
// //     bool isCancelButton = true,
// //   }) {
// //     showDialog<String>(
// //       context: context,
// //       builder: (dialogContext) => Form(
// //         key: formKey,
// //         child: Center(
// //           child: SingleChildScrollView(
// //             child: AlertDialog(
// //               icon: Icon(
// //                 icon ?? Icons.info_outline,
// //                 color: ColorConstants.lightBlue,
// //               ),
// //               backgroundColor: Theme.of(context).cardColor,
// //               shape: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(20),
// //                 borderSide: BorderSide.none,
// //               ),
// //               title: titleWidget ?? const SizedBox(),
// //               content: contentWidget ?? const SizedBox(),
// //               contentPadding: contentWidget != null
// //                   ? const EdgeInsets.all(8)
// //                   : EdgeInsets.zero,
// //               actions: <Widget>[
// //                 if (isCancelButton)
// //                   MaterialButton(
// //                     color: Colors.white,
// //                     shape: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                       borderSide: BorderSide.none,
// //                     ),
// //                     onPressed: () {
// //                       Navigator.pop(context, tr(StringConstants.cancel));
// //                     },
// //                     child: Text(
// //                       cancelText ?? tr(StringConstants.cancel),
// //                       style: Theme.of(context).textTheme.bodyLarge!.copyWith(
// //                           color: ColorConstants.lightBlue, fontSize: 20),
// //                     ),
// //                   ),
// //                 MaterialButton(
// //                   color: ColorConstants.lightBlue,
// //                   shape: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(8),
// //                     borderSide: BorderSide.none,
// //                   ),
// //                   onPressed: () async {
// //                     await onConfirm();
// //                   },
// //                   child: Text(
// //                     confirmText ?? tr(StringConstants.ok),
// //                     style: Theme.of(context)
// //                         .textTheme
// //                         .bodyLarge!
// //                         .copyWith(color: Colors.white, fontSize: 20),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// // import 'dart:io';
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:pod_player/pod_player.dart';
// // import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// // import '../constants/constants.dart';
// // import '../controller/courses_video/courses_video_cubit.dart';
// // import '../models/course_video_model.dart';
// //
// // class VideoPlayerScreenWidget extends StatefulWidget {
// //   const VideoPlayerScreenWidget(
// //       {Key? key,
// //       required this.videoLink,
// //       required this.videoId,
// //       required this.view,
// //       required this.model})
// //       : super(key: key);
// //   final String videoLink;
// //   final String videoId;
// //   final bool view;
// //   final CourseVideoModel model;
// //
// //   @override
// //   State<VideoPlayerScreenWidget> createState() =>
// //       _VideoPlayerScreenWidgetState();
// // }
// //
// // class _VideoPlayerScreenWidgetState extends State<VideoPlayerScreenWidget> {
// //   late YoutubePlayerController controller;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     try {
// //       refresh = false;
// //       setState(() {
// //
// //       });
// //       controller = YoutubePlayerController(
// //         podPlayerConfig: const PodPlayerConfig(
// //           videoQualityPriority: [720, 480, 360, 144],
// //           autoPlay: false,
// //           isLooping: false,
// //           forcedVideoFocus: true
// //         ),
// //         playVideoFrom: PlayVideoFrom.youtube(widget.videoLink,
// //             videoPlayerOptions:
// //             VideoPlayerOptions(allowBackgroundPlayback: true)),
// //       )
// //         ..addListener(_onVideoStatusChanged)
// //         ..initialise();
// //
// //       SystemChrome.setPreferredOrientations([
// //         DeviceOrientation.portraitUp,
// //         DeviceOrientation.portraitDown,
// //         // DeviceOrientation.landscapeLeft,
// //         // DeviceOrientation.landscapeRight,
// //       ]);
// //     }on SocketException{
// //       setState(() {
// //         refresh = true;
// //
// //       });
// //     } catch (e) {
// //       debugPrint("error " +e.toString());
// //         refresh = true;
// //         setState(() {
// //
// //         });
// //     }
// //   }
// //
// //   void _onVideoStatusChanged() {
// //     final Duration position = controller.videoPlayerValue!.position;
// //     final Duration duration = controller.videoPlayerValue!.duration;
// //     debugPrint(position.inSeconds.toString());
// //     debugPrint(duration.inSeconds.toString());
// //
// //     if (position.inSeconds >= (duration.inSeconds / 3) &&
// //         (widget.view == false || BlocProvider.of(context).view == false)) {
// //       debugPrint("update ------->");
// //       BlocProvider.of<CoursesVideoCubit>(context).updateView(
// //           studentId: stuId!, contentId: widget.videoId, model: BlocProvider.of(context));
// //       debugPrint("update ------->");
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     controller.dispose();
// //
// //   super.dispose();
// //   }
// //
// //   bool refresh = false;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         podVideo(),
// //         if(refresh)
// //         IconButton(
// //           onPressed: () {
// //               try {
// //                 refresh = false;
// //                 setState(() {
// //
// //                 });
// //                 controller = PodPlayerController(
// //                   podPlayerConfig: const PodPlayerConfig(
// //                     videoQualityPriority: [720, 480, 360, 144],
// //                     autoPlay: false,
// //                     isLooping: false,
// //                   ),
// //                   playVideoFrom: PlayVideoFrom.youtube(widget.videoLink,
// //                       videoPlayerOptions:
// //                       VideoPlayerOptions(allowBackgroundPlayback: true)),
// //                 )
// //                   ..addListener(_onVideoStatusChanged)
// //                   ..initialise();
// //
// //                 SystemChrome.setPreferredOrientations([
// //                   DeviceOrientation.portraitUp,
// //                   DeviceOrientation.portraitDown,
// //                   // DeviceOrientation.landscapeLeft,
// //                   // DeviceOrientation.landscapeRight,
// //                 ]);
// //               }on SocketException{
// //                 setState(() {
// //                   refresh = true;
// //
// //                 });
// //               }  catch (e) {
// //                 debugPrint("error " +e.toString());
// //
// //                 if (e is PlatformException) {
// //                   refresh = true;
// //                   setState(() {
// //
// //                   });
// //                 }
// //               }
// //
// //           },
// //           icon: Icon(
// //             Icons.refresh,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   void _toggleFullScreen(bool isFullScreen) {
// //     if (isFullScreen) {
// //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
// //       SystemChrome.setPreferredOrientations(
// //           [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
// //     } else {
// //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
// //           overlays: SystemUiOverlay.values);
// //       SystemChrome.setPreferredOrientations(DeviceOrientation.values);
// //     }
// //   }
// //
// //   Widget podVideo() {
// //     return PodVideoPlayer(
// //       onToggleFullScreen: (bool isFullScreen) async {
// //         _toggleFullScreen(isFullScreen);
// //       },
// //       podPlayerLabels: const PodPlayerLabels(play: "play", pause: "pause"),
// //       controller: controller,
// //     );
// //   }
// // }
//

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ts_academy/screens/courses/cubit/cubit.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants/constants.dart';

class VideoPlayerScreenWidget extends StatefulWidget {
  const VideoPlayerScreenWidget({
    Key? key,
    required this.videoLink,
  }) : super(key: key);

  final String videoLink;

  @override
  State<VideoPlayerScreenWidget> createState() =>
      _VideoPlayerScreenWidgetState();
}

class _VideoPlayerScreenWidgetState extends State<VideoPlayerScreenWidget> {
  late YoutubePlayerController controller;
  double _xPosition = 0;
  double _yPosition = 0;
  bool isVideoPlaying = false; // Track video playback state
  Timer? ttsTimer;

  @override
  void initState() {
    super.initState();
    _initializeController();
    if (mounted) {
      _moveText();
      initTts();
      // setTtsAudio();
    }
  }

  void setTtsAudio() {
    if (ttsTimer == null) {
      ttsTimer = Timer.periodic(const Duration(seconds: 65), (timer) async {
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
    await flutterTts.setVolume(1); // Volume should be between 0 and 1

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
          _xPosition = _randomPosition(1);
          _yPosition = _randomPosition(250);
        });
      }
    });
  }

  double _randomPosition(double max) {
    return ((max == 1 &&
        MediaQuery.of(context).orientation == Orientation.landscape
        ? 350
        : 100) *
        (Random().nextInt(5) * (0.5 - (10020 % 1000) / 1000)));
  }



  bool isFullScreen = false;

  void _initializeController() {
    try {
      controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoLink) ?? '',
        flags: YoutubePlayerFlags(
          autoPlay: true,
          loop: false,
          controlsVisibleAtStart: true,
          disableDragSeek: false,
          startAt: BlocProvider.of<WatchVideoCubit>(context).map[widget.videoLink]??0,
        ),
      )..addListener(() {
        final isPlaying = controller.value.isPlaying;
        if (isPlaying != isVideoPlaying) {
          setState(() {
            isVideoPlaying = isPlaying;
            _handleTts(isPlaying); // Handle TTS based on video playback state
          });
        }
        if (controller.value.isFullScreen != isFullScreen) {
          setState(() {
            isFullScreen = controller.value.isFullScreen;
            if (isFullScreen) {
              //controller.value.position.inSeconds.toDouble()
              if(controller.value.position.inSeconds!=0){
                BlocProvider.of<WatchVideoCubit>(context).changeMap(widget.videoLink, controller.value.position.inSeconds);
              }

            } else {
              // Restore the saved position when exiting full-screen mode
            }
          });
        }
      });
      if (BlocProvider.of<WatchVideoCubit>(context).map[widget.videoLink] !=
          null) {
        controller.seekTo(
          Duration(
            seconds: BlocProvider.of<WatchVideoCubit>(context).map[widget.videoLink]!,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error initializing YouTube player: ${e.toString()}");
    }
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
    controller.dispose();
    ttsTimer?.cancel();
    flutterTts.stop();
    flutterTts.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).orientation==Orientation.landscape? MediaQuery.of(context).size.width:250,
          width: double.infinity,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                actionsPadding: EdgeInsets.all(0),
                controller: controller,
                showVideoProgressIndicator: true,
                //   onReady: () {
                //     controller.addListener(_onVideoStatusChanged);
                //
                // },
              ),
              builder: (context, player) {
                return player;
              },
            ),
          ),
        ),
        randomTextWidget(),

      ],
    );
    //   Stack(
    //   children: [
    //     SizedBox(
    //
    //       height: MediaQuery.of(context).orientation == Orientation.landscape
    //           ? MediaQuery.of(context).size.width
    //           : 250,
    //       width:MediaQuery.of(context).orientation == Orientation.landscape
    //           ? MediaQuery.of(context).size.width
    //           :  MediaQuery.of(context).size.width,
    //       child: YoutubePlayerBuilder(
    //
    //         player: YoutubePlayer(
    //           actionsPadding: EdgeInsets.all(0),
    //           controller: controller,
    //           showVideoProgressIndicator: true,
    //
    //         ),
    //         builder: (context, player) {
    //           return player;
    //         },
    //       ),
    //     ),
    //     randomTextWidget(),
    //   ],
    // );
  }

  Widget randomTextWidget() {
    return AnimatedPositioned(
      left: _xPosition,
      top: _yPosition,
      duration: const Duration(
        milliseconds: 1000,
      ),
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
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white70,
                fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }
}