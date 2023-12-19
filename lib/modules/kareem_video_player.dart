import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ts_academy/constants/color_constants.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/constants/font_constants.dart';
import 'package:ts_academy/constants/image_constants.dart';
import 'package:ts_academy/screens/courses/course_content_screen.dart';
import 'package:ts_academy/screens/courses/cubit/cubit.dart';
import 'package:ts_academy/screens/courses/cubit/states.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class KareemVideoPlayer extends StatefulWidget {
  final String videoLink;
  final String courseName;
  const KareemVideoPlayer({super.key, required this.videoLink, required this.courseName});

  @override
  _KareemVideoPlayerState createState() => _KareemVideoPlayerState();
}

class _KareemVideoPlayerState extends State<KareemVideoPlayer> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  late PlayerState playerState;
  bool _isPlayerReady = false;

  double _xPosition = 0;
  double _yPosition = 0;
  Timer? ttsTimer;

  void setTtsAudio() {
    if (ttsTimer == null) {
      ttsTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        List<String> digits = stuId.toString().split('').toList();
        await flutterTts.speak('$digits');
      });
    }
  }

  FlutterTts flutterTts = FlutterTts();
  bool isVideoPlaying = false;

  Future<void> initTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.setVolume(8.0); // Volume should be between 0 and 1

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
    return ((max == 1 && MediaQuery.of(context).orientation == Orientation.landscape ? 350 : 100) *
        (Random().nextInt(5) * (0.5 - (10020 % 1000) / 1000)));
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoLink) ?? '',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    playerState = PlayerState.unknown;
    if (mounted) {
      _moveText();
      initTts();
    }
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        playerState = _controller.value.playerState;
      });
    }
    final isPlaying = _controller.value.isPlaying;
    if (isPlaying != isVideoPlaying) {
      setState(() {
        isVideoPlaying = isPlaying;
        _handleTts(isPlaying); // Handle TTS based on video playback state
      });
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
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
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    ttsTimer?.cancel();
    flutterTts.stop();
    flutterTts.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchVideoCubit, WatchVideoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        WatchVideoCubit watchVideoCubit = BlocProvider.of(context);
        return Stack(
          children: [
            YoutubePlayerBuilder(
              onExitFullScreen: () {
                // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
              },
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                onReady: () {
                  _isPlayerReady = true;
                },
                onEnded: (data) {},
              ),
              builder: (context, player) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      widget.courseName,
                      style: const TextStyle(
                        fontFamily: FontConstants.poppins,
                        color: Colors.white,
                      ),
                    ),
                    leading: GestureDetector(
                      onTap: () async {
                        // await Modules().getTrackPosts();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
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
                    ),
                    centerTitle: true,
                    backgroundColor: ColorConstants.lightBlue,
                    actions: [
                      if (watchVideoCubit.isScreenSplitted)
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              watchVideoCubit.changeSplitScreen(value: false, pdfLink: "");
                            },
                            icon: Icon(Icons.exit_to_app, color: Colors.white)),
                    ],
                  ),
                  body: Column(
                    children: [
                      Stack(
                        children: [
                          player,
                          randomTextWidget(),
                        ],
                      ),
                      Expanded(
                        child: PdfScreenSplitting(
                          link: watchVideoCubit.currentLinkPdfWithSplittedScreen,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            if(_controller.value.isFullScreen)
              randomTextWidget(),
          ],
        );
      },
    );
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white70, fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }
}
