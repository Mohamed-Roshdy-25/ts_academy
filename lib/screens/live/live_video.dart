/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:ts_academy/constants/color_constants.dart';

import 'live_comments_page.dart';

class LiveStream extends StatefulWidget {
  const LiveStream({
    Key? key,
  }) : super(key: key);

  @override
  _LiveStreamState createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  String channelName = "Cx_Academy_Live";
  String liveToken =
      "007eJxTYJhbX8g8/4rK/Nleit4fJ1yaPL1Ed8L6Sq+OR+Z58V6GHhoKDEYpxgamSSamxiYWxiZmaWaJBhapFiaWyQZGacaJyebm+g6vUxoCGRnO3DzAwsgAgSA+P4NzRbxjcmJKam5lvE9mWSoDAwBg5SKg";

  bool isLive = false;
  int uid = int.parse("101"); // uid of the local user
  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  bool _isHost =
      true; // Indicates whether the user has joined as a host or audience
  late RtcEngine agoraEngine; // Agora engine instance
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold
  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    if (mounted) {
      setupVideoSDKEngine();
    }
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();
    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(
        const RtcEngineContext(appId: '2d305b45348346f6a08e849c02f3ac77'));
    // await agoraEngine.enableVideo();
    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage("localUserUid joinedTheChannel");
          if (mounted) {
            setState(() {
              _isJoined = true;
            });
          }
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("remote User Uid joined The Channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("remoteUserUid leftTheChannel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  void _switchCamera() {
    agoraEngine.switchCamera();
  }

  void join() async {
    // Set channel options
    ChannelMediaOptions options;
    // Set channel profile and client role
    if (_isHost) {
      await agoraEngine.enableVideo();
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
      await agoraEngine.startPreview();
    } else {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
    }
    await agoraEngine.joinChannel(
      token: liveToken,
      channelId: channelName,
      options: options,
      uid: uid,
    );
    isLive = true;
  }

  void leave() {
    setState(() {
      _isJoined = false;
      isLive = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  bool isMuted = false;
  void _muteAudio() {
    setState(() {
      isMuted = !isMuted;
    });
    agoraEngine.muteLocalAudioStream(isMuted);
  }

  @override
  void dispose() async {
    super.dispose();
    await agoraEngine.leaveChannel();
    agoraEngine.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: ColorConstants.purpal,
          title: const Text(
            "liveStreaming",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            // Container for the local video
            GestureDetector(
              onDoubleTap: () {
                _switchCamera();
              },
              child: Stack(
                children: [
                  isLive
                      ? Container(
                          height: MediaQuery.of(context).size.height * .9,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(child: _videoPanel()),
                        )
                      : const SizedBox(),
                  Positioned(
                      bottom: 10,
                      right: 0,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: isMuted
                                ? const Icon(Icons.mic_off)
                                : const Icon(Icons.mic),
                            onPressed: () {
                              _muteAudio();
                            },
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LiveCommentPage()));
                              },
                              icon: const Icon(Icons.comment))
                        ],
                      )),
                  _isJoined
                      ? Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              leave();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Text(
                                "Leave",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ))
                      : const SizedBox()
                ],
              ),
            ),
            // Radio Buttons
            isLive
                ? const SizedBox()
                : Row(children: <Widget>[
                    Radio<bool>(
                      value: true,
                      activeColor: Colors.purple,
                      groupValue: _isHost,
                      onChanged: (value) => _handleRadioValueChange(value),
                    ),
                    const Text("host"),
                    Radio<bool>(
                      value: false,
                      activeColor: Colors.purple,
                      groupValue: _isHost,
                      onChanged: (value) => _handleRadioValueChange(value),
                    ),
                    const Text("audience"),
                  ]),
            // Button Row
            Row(
              children: <Widget>[
                !isLive
                    ? Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            join();
                          },
                          child: const Text("join"),
                        ),
                      )
                    : const SizedBox(),
                // const SizedBox(width: 10),
                // Expanded(
                //   child: ElevatedButton(
                //     child: const Text("leave"),
                //     onPressed: () => {leave()},
                //   ),
                // ),
              ],
            ),
            // Button Row ends
          ],
        ));
  }

  Widget _videoPanel() {
    if (!_isJoined) {
      return const Text(
        "joinChannel",
        textAlign: TextAlign.center,
      );
    } else if (_isHost) {
      // Show local video preview
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      // Show remote video
      if (_remoteUid != null) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: agoraEngine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(channelId: channelName),
          ),
        );
      } else {
        return const Text(
          "waitingForHostToJoin",
          textAlign: TextAlign.center,
        );
      }
    }
  }

// Set the client role when a radio button is selected
  void _handleRadioValueChange(bool? value) async {
    setState(() {
      _isHost = (value == true);
    });
    if (_isJoined) leave();
  }
}
*/
