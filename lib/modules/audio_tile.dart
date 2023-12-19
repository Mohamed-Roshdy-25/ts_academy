import 'dart:async';
import 'dart:math' as math;
import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../constants/color_constants.dart';
import '../controller/settings_cubit/settings_cubit.dart';
import '/constants/constants.dart';
import 'package:headset_connection_event/headset_event.dart';

class MusicTile extends StatefulWidget {
  final String musicURL;
  const MusicTile({Key? key, required this.musicURL}) : super(key: key);
  @override
  _MusicTileState createState() => _MusicTileState();
}

class _MusicTileState extends State<MusicTile> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  FlutterTts flutterTts = FlutterTts();
  Timer? timer;
  double _playbackRate = 1.0;
  // late BluetoothConnection _bluetoothConnection;
  // final Future<AudioSession> _audioSession = AudioSession.instance;
  Future<void> initTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(double.parse(
        BlocProvider.of<SettingsCubit>(context)
                .settingsModel!
                .tts_speedd
                .toString() ??
            "4.0"));
    await flutterTts.setVolume(2.0);
  }

  final _headsetPlugin = HeadsetEvent();
  HeadsetState _headsetState = HeadsetState.DISCONNECT;
  @override
  void initState() {
    super.initState();
    // _audioSession.then((session) {
    //   session.configure(const AudioSessionConfiguration.speech());
    //   session.interruptionEventStream.listen((event) {
    //     if (!event.begin) {
    //       _disposeAudio(); // If a wired hands-free device is connected, dispose of audio
    //     }
    //   });
    // });

    _headsetPlugin.requestPermission();
    _headsetPlugin.getCurrentState.then((val) {
      setState(() {
        _headsetState = val!;
      });
    });

    _headsetPlugin.setListener((val) {
      setState(() {
        _headsetState = val;
      });
    });
    initTts();
    setAudio();
    audioPlayer.onPlayerStateChanged.listen((event) {
      // isPlaying = event == PlayerState.PLAYING;
      if (mounted) {
        setState(() {
          isPlaying = event == PlayerState.playing;
        });
      }
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });
    // _listenForBluetoothConnection(); // Listen for headphone connection events
  }

  // void _listenForBluetoothConnection() {
  //   FlutterBluetoothSerial.instance
  //       .onStateChanged()
  //       .listen((BluetoothState state) {
  //     if (state == BluetoothState.STATE_OFF) {
  //       _disposeAudio(); // If Bluetooth is connected, dispose of audio
  //     }
  //   });
  // }

  void _disposeAudio() async {
    if (audioPlayer.state == PlayerState.playing) {
      await audioPlayer.stop(); // Stop playing audio
      await audioPlayer.dispose(); // Dispose of audio player
    }
  }

  Future setAudio() async {
    if (_headsetState == HeadsetState.CONNECT) {
      timer = Timer.periodic(
          Duration(
              seconds: int.parse(BlocProvider.of<SettingsCubit>(context)
                      .settingsModel!
                      .tts_interval
                      .toString() ??
                  "4")), (timer) async {
        if (audioPlayer.state == PlayerState.playing) {
          List<String> digits = stuId.toString().split('').toList();
          await flutterTts.speak('$digits');
          await audioPlayer.setSourceUrl(widget.musicURL);
          // Repeat song when completed
          audioPlayer.setReleaseMode(ReleaseMode.loop);
          audioPlayer.onPlayerComplete.listen((event) async {
            await flutterTts.stop();
          });
        }
      });
      audioPlayer.onPlayerComplete.listen((event) async {
        await flutterTts.stop();
        timer?.cancel();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    _disposeAudio(); // Dispose of audio player when widget is disposed
    // audioPlayer.dispose();
    timer?.cancel();
  }

  increaseAudioSpeed(double value) async {
    setState(() {
      _playbackRate = value;
    });
    await audioPlayer.setPlaybackRate(value);
  }

  String time(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  void showMyDialog({
    required BuildContext context,
    IconData? icon,
    required Function onConfirm,
    Widget? contentWidget,
    Widget? titleWidget,
    Key? formKey,
    String? confirmText,
    String? cancelText,
    bool isCancelButton = true,
  }) {
    showDialog<String>(
      context: context,
      builder: (dialogContext) => Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              icon: Icon(
                icon ?? Icons.info_outline,
                color: ColorConstants.lightBlue,
              ),
              backgroundColor: Theme.of(context).cardColor,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              title: titleWidget ?? const SizedBox(),
              content: contentWidget ?? const SizedBox(),
              contentPadding: contentWidget != null
                  ? const EdgeInsets.all(8)
                  : EdgeInsets.zero,
              actions: <Widget>[
                if (isCancelButton)
                  MaterialButton(
                    color: Colors.white,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                    child: Text(
                      cancelText ?? "Cancel",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: ColorConstants.lightBlue, fontSize: 20),
                    ),
                  ),
                MaterialButton(
                  color: ColorConstants.lightBlue,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  onPressed: () async {
                    await onConfirm();
                  },
                  child: Text(
                    confirmText ?? "Ok",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "The Flutter Song",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.blue[700]),
                  ),
                ),
                PopupMenuButton(
                    color: Colors.grey,
                    itemBuilder: (context) => [
                          PopupMenuItem(
                              child: TextButton(
                                  onPressed: () {
                                    increaseAudioSpeed(0.5);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    " 0.5 speed ",
                                    style: TextStyle(color: Colors.purple[900]),
                                  ))),
                          PopupMenuItem(
                              child: TextButton(
                                  onPressed: () {
                                    increaseAudioSpeed(0.75);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    " 0.75 speed ",
                                    style: TextStyle(color: Colors.purple[900]),
                                  ))),
                          PopupMenuItem(
                              child: TextButton(
                                  onPressed: () {
                                    increaseAudioSpeed(1);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    " 1 speed ",
                                    style: TextStyle(color: Colors.purple[900]),
                                  ))),
                          PopupMenuItem(
                              child: TextButton(
                                  onPressed: () {
                                    increaseAudioSpeed(1.25);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    " 1.25 speed ",
                                    style: TextStyle(color: Colors.purple[900]),
                                  ))),
                          PopupMenuItem(
                              child: TextButton(
                                  onPressed: () {
                                    increaseAudioSpeed(1.5);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    " 1.5 speed ",
                                    style: TextStyle(color: Colors.purple[900]),
                                  )))
                        ]),
              ],
            ),
          ),
          Slider(
              min: 0.0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              activeColor: Colors.white,
              inactiveColor: Colors.grey.withOpacity(0.3),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                double oldPlaybackRate = _playbackRate;
                await audioPlayer.setPlaybackRate(_playbackRate);
                await audioPlayer
                    .seek(position); // Get the current playback rate
                _playbackRate = oldPlaybackRate;
                await audioPlayer.setPlaybackRate(_playbackRate);
                //Optional Play audio if was paused
                await audioPlayer.resume();
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time(position) ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const Spacer(),
                Text(
                  time(duration - position) ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                child: GestureDetector(
                    onTap: () async {
                      if (position.inSeconds >= 10) {
                        audioPlayer
                            .seek(position - const Duration(seconds: 10));
                      } else {
                        audioPlayer.seek(
                            position - Duration(seconds: position.inSeconds));
                      }
                    },
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child:
                          Icon(Icons.update, color: Colors.grey[300], size: 25),
                    )),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  radius: 30,
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width / 12,
                    ),
//                     icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 30,
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                      } else {
                        try {
                          if (_headsetState == HeadsetState.CONNECT) {
                            await audioPlayer.play(UrlSource(widget.musicURL));
                          } else {
                            showMyDialog(
                              context: context,
                              onConfirm: () {
                                Navigator.pop(context);
                              },
                              isCancelButton: false,
                              contentWidget: Text(tr(StringConstants
                                  .earphone_connection_confirmation)),
                            );
                          }
                        } catch (E) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(tr(StringConstants.invalid_message)),
                            backgroundColor: Colors.red,
                          ));
                        }
                        // await audioPlayer.play(widget.musicURL!);
                      }
                    },
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                child: GestureDetector(
                  onTap: () async {
                    if (position.inSeconds < duration.inSeconds - 10) {
                      audioPlayer.seek(position + const Duration(seconds: 10));
                    } else if (position.inSeconds == duration.inSeconds) {
                      setState(() {
                        position = Duration.zero;
                      });
                    }
                  },
                  child: Icon(Icons.update, color: Colors.grey[300], size: 25),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
