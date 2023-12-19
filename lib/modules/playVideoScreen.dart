import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pod_player/pod_player.dart';
import '../constants/constants.dart';

class VideoPlayerScreenWidget extends StatefulWidget {
  const VideoPlayerScreenWidget({Key? key, required this.videoLink})
      : super(key: key);
  final String videoLink;

  @override
  State<VideoPlayerScreenWidget> createState() =>
      _VideoPlayerScreenWidgetState();
}

class _VideoPlayerScreenWidgetState extends State<VideoPlayerScreenWidget> {
  late final PodPlayerController controller;
  double _xPosition = 0;
  double _yPosition = 0;

  @override
  void initState() {
    super.initState();
    initTts();
    controller = PodPlayerController(
      podPlayerConfig: const PodPlayerConfig(
        videoQualityPriority: [720, 480, 360, 144],
        autoPlay: false,
        isLooping: false,
      ),
      playVideoFrom: PlayVideoFrom.vimeo(
        widget.videoLink,
      ),
    )..initialise().then((value) {
        setTtsAudio();
      });
    if (mounted) {
      _moveText();
    }
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   // DeviceOrientation.landscapeLeft,
    //   // DeviceOrientation.landscapeRight,
    // ]);
  }

  void loadVideo() async {
    final urls =
        await PodPlayerController.getYoutubeUrls(widget.videoLink.toString());
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.networkQualityUrls(videoUrls: urls!),
      podPlayerConfig: const PodPlayerConfig(
        videoQualityPriority: [720, 480, 360, 144],
      ),
    )..initialise().then((value) => setTtsAudio());
  }

  Timer? timer;
  Future setTtsAudio() async {
    timer = Timer.periodic(const Duration(seconds: 6), (timer) async {
      if (controller.isVideoPlaying) {
        controller.play();
        await flutterTts.speak('$myName $stuId');
      } else {
        await flutterTts.stop();
      }
    });

    controller.addListener(() {
      if (controller.isVideoPlaying) {
        if (!timer!.isActive) {
          timer = Timer.periodic(
            const Duration(seconds: 5),
            (timer) async {
              controller.play();
              List<String> digits = stuId.toString().split('').toList();
              await flutterTts.speak('$myName $digits');
            },
          );
        }
      } else {
        timer?.cancel();
        flutterTts.stop();
      }
    });
  }

  FlutterTts flutterTts = FlutterTts();
  Future<void> initTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(3.0);
    await flutterTts.setVolume(3.0);
  }

  void _moveText() {
    Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      if (mounted) {
        setState(() {
          _xPosition = _randomPosition();
          _yPosition = _randomPosition();
        });
      }
    });
  }

  double _randomPosition() {
    return (100 * (Random().nextInt(5) * (0.5 - (10020 % 1000) / 1000)));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    timer?.cancel();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        podVideo(),
        randomTextWidget(),
      ],
    );
  }

  void _toggleFullScreen(bool isFullScreen) {
    // if (isFullScreen) {
    //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    //   SystemChrome.setPreferredOrientations(
    //       [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    // } else {
    //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //       overlays: SystemUiOverlay.values);
    //   SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    // }
  }

  Widget podVideo() {
    return PodVideoPlayer(
      onToggleFullScreen: (bool isFullScreen) async {
        _toggleFullScreen(isFullScreen);
      },
      podPlayerLabels: const PodPlayerLabels(play: "play", pause: "pause"),
      controller: controller,
    );
  }

  Widget randomTextWidget() {
    return Positioned(
      left: _xPosition,
      top: _yPosition,
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        child: Transform.rotate(
          angle: 75,
          child: Column(
            children: [
              Text(
                '$myName',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.3),
                    fontFamily: 'Poppins'),
              ),
              Text(
                '$stuId',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black.withOpacity(.3),
                    fontFamily: 'Poppins'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
