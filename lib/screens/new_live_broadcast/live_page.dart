import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:ts_academy/components/compnenets.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/models/comments_model.dart';
import 'package:ts_academy/screens/new_live_broadcast/cubit/cubit.dart';
import 'package:ts_academy/screens/new_live_broadcast/cubit/states.dart';
import 'package:ts_academy/screens/new_live_broadcast/widgets.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'utils/device_orientation.dart';
import 'utils/zegocloud_token.dart';

import 'key_center.dart';

class LivePage extends StatefulWidget {
  const LivePage({
    Key? key,
    required this.isHost,
    required this.localUserID,
    required this.localUserName,
    required this.roomID,
  }) : super(key: key);

  final bool isHost;
  final String localUserID;
  final String localUserName;
  final String roomID;

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  Widget? hostCameraView;
  int? hostCameraViewID;

  Widget? hostScreenView;
  int? hostScreenViewID;

  bool isCameraEnabled = true;
  bool isSharingScreen = false;
  bool isMicMuted = true;
  ZegoScreenCaptureSource? screenSharingSource;

  bool isLandscape = false;

  List<StreamSubscription> subscriptions = [];
  TextEditingController commentController = TextEditingController();
  List<CommentsModel> comments = [];
  bool commentsVisible = true;
  ScrollController scrollController = ScrollController();
  int numOfViews = 0;
  bool isFrontCamera = true;

  @override
  void initState() {
    startListenEvent();
    loginRoom();
    onRoomOnlineUserCountUpdate();
    subscriptions.addAll([
      NativeDeviceOrientationCommunicator().onOrientationChanged().listen((NativeDeviceOrientation orientation) {
        updateAppOrientation(orientation);
      }),
    ]);
    onReceiveBarrageMessage();
    onReceiveCustomCommand();
    useFrontCamera(false);
    super.initState();
  }

  @override
  void dispose() {
    for (var sub in subscriptions) {
      sub.cancel();
    }
    stopListenEvent();
    logoutRoom();
    resetAppOrientation();
    scrollController.dispose();
    super.dispose();
  }

  Widget get screenView => isSharingScreen ? (hostScreenView ?? const SizedBox()) : const SizedBox();
  Widget get cameraView => isCameraEnabled ? (hostCameraView ?? const SizedBox()) : const SizedBox();

  void updateAppOrientation(NativeDeviceOrientation orientation) async {
    if (isLandscape != orientation.isLandscape) {
      isLandscape = orientation.isLandscape;
      debugPrint('updateAppOrientation: ${orientation.name}');
      final videoConfig = await ZegoExpressEngine.instance.getVideoConfig();
      if (isLandscape && (videoConfig.captureWidth > videoConfig.captureHeight)) return;

      final oldValues = {
        'captureWidth': videoConfig.captureWidth,
        'captureHeight': videoConfig.captureHeight,
        'encodeWidth': videoConfig.encodeWidth,
        'encodeHeight': videoConfig.encodeHeight,
      };
      videoConfig
        ..captureHeight = oldValues['captureWidth']!
        ..captureWidth = oldValues['captureHeight']!
        ..encodeHeight = oldValues['encodeWidth']!
        ..encodeWidth = oldValues['encodeHeight']!;
      ZegoExpressEngine.instance.setAppOrientation(orientation.toZegoType);
      ZegoExpressEngine.instance.setVideoConfig(videoConfig);
    }
  }

  void resetAppOrientation() => updateAppOrientation(NativeDeviceOrientation.portraitUp);

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return BlocConsumer<ZegoCloudCubit, ZegoCloudStates>(
          listener: (context, state) {},
          builder: (context, state) {
            ZegoCloudCubit zegoCloudCubit = BlocProvider.of(context);
            return Scaffold(
              resizeToAvoidBottomInset: false,
              extendBody: true,
              body: Stack(
                children: [
                  Container(color: Colors.black),
                  Builder(builder: (context) {
                    if (!isSharingScreen) return cameraView;
                    if (!widget.isHost) return screenView;
                    return const Center(
                        child: Text('You are sharing your screen', style: TextStyle(color: Colors.white)));
                  }),
                  PositionedDirectional(
                    bottom: MediaQuery.of(context).orientation == Orientation.portrait ? 140 : 100,
                    end: 20,
                    child: SizedBox(
                      width: MediaQuery.of(context).orientation == Orientation.portrait ? 100 : 200,
                      child: AspectRatio(
                        aspectRatio:
                            MediaQuery.of(context).orientation == Orientation.portrait ? 9.0 / 16.0 : 16.0 / 9.0,
                        child: (isSharingScreen ? cameraView : screenView),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  SafeArea(
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! > 0) {
                          setState(() {
                            commentsVisible = false;
                          });
                        }
                      },
                      child: Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Visibility(
                          visible: commentsVisible,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: 16,
                                top: MediaQuery.of(context).size.height / 2,
                                end: MediaQuery.of(context).size.width / 2),
                            child: ListView.separated(
                              reverse: true,
                              controller: scrollController,
                              itemBuilder: (context, indexComments) {
                                comments.sort((a, b) => b.date!.compareTo(a.date!));
                                return BuildComment(
                                  context: context,
                                  username: comments[indexComments].userName!,
                                  userImage: comments[indexComments].userImage!,
                                  comment: comments[indexComments].message!,
                                  userId: comments[indexComments].userId!,
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                              itemCount: comments.length,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            commentsVisible = true;
                          });
                        },
                        child: Visibility(
                          visible: !commentsVisible,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 16, bottom: 8),
                            child: Text("Show Comments", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 60,
                    child: GestureDetector(
                      onTap: () async {
                        if (widget.isHost) {
                          showProgressIndicator(context: context, text: "Endding room...");
                          zegoCloudCubit.endRoomInBackend(roomId: widget.roomID).then((value) async {
                            sendBarrageMessage(roomID: widget.roomID, message: "End_Room__");
                            zegoCloudCubit.getRoomsForStudents().then((value) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          });
                        } else {
                          await zegoCloudCubit.leaveRoom(roomId: widget.roomID).then((value) {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Text(widget.isHost ? 'End Live' : 'Leave Live', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 60,
                    child: GestureDetector(
                      onTap: () {
                        buildAudienceBottomSheet(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.remove_red_eye_outlined, color: Colors.white),
                            SizedBox(width: 12),
                            Text(numOfViews.toString(), style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Transform.translate(
                offset: Offset(0, isKeyboardVisible ? -MediaQuery.of(context).viewInsets.bottom + 10 : 0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, right: 12, left: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.isHost && !isKeyboardVisible) ...[
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: myTextFormField(
                              context: context,
                              controller: commentController,
                              fillColor: Colors.black26,
                              hintColor: Colors.white,
                              textColor: Colors.white,
                              radius: 8,
                              hint: "write comment",
                              onTap: () {},
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ActionButton(
                          icon: isSharingScreen
                              ? Container(
                                  padding: EdgeInsets.all(8),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black26,
                                  ),
                                  child: Icon(Icons.screen_share, color: Colors.white))
                              : Container(
                                  padding: EdgeInsets.all(8),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.redAccent,
                                  ),
                                  child: Icon(Icons.stop_screen_share_rounded, color: Colors.white)),
                          onPressed: () async {
                            if (isSharingScreen) {
                              await stopScreenSharing();
                            } else {
                              await startScreenSharing();
                            }
                          },
                        ),
                        ActionButton(
                          icon: isCameraEnabled
                              ? Container(
                                  padding: EdgeInsets.all(8),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black26,
                                  ),
                                  child: Icon(Icons.camera_alt_rounded, color: Colors.white))
                              : Container(
                                  padding: EdgeInsets.all(8),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.redAccent,
                                  ),
                                  child: Image.asset(
                                    "assets/icons/camera_slash.png",
                                    width: 16,
                                    height: 16,
                                  )),
                          onPressed: () {
                            setState(() {
                              isCameraEnabled = !isCameraEnabled;
                              ZegoExpressEngine.instance
                                  .setStreamExtraInfo(jsonEncode({'isCameraEnabled': isCameraEnabled}));
                              ZegoExpressEngine.instance.enableCamera(isCameraEnabled);
                            });
                          },
                        ),
                        ActionButton(
                          icon: !isMicMuted
                              ? Container(
                                  padding: EdgeInsets.all(8),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black26,
                                  ),
                                  child: Icon(Icons.mic, color: Colors.white))
                              : Container(
                                  padding: EdgeInsets.all(8),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.redAccent,
                                  ),
                                  child: Icon(Icons.mic_off_sharp, color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              isMicMuted = !isMicMuted;
                              ZegoExpressEngine.instance
                                  .setStreamExtraInfo(jsonEncode({'isCameraEnabled': isCameraEnabled}));
                              ZegoExpressEngine.instance.muteMicrophone(isMicMuted);
                            });
                          },
                        ),
                        ActionButton(
                          icon: Container(
                              padding: EdgeInsets.all(8),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black26,
                              ),
                              child: Icon(Icons.flip_camera_ios, color: Colors.white)),
                          onPressed: () {
                            useFrontCamera(!isFrontCamera);
                          },
                        ),
                      ],
                      if (widget.isHost && isKeyboardVisible) ...[
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: myTextFormField(
                              context: context,
                              controller: commentController,
                              fillColor: Colors.black26,
                              hintColor: Colors.white,
                              textColor: Colors.white,
                              radius: 8,
                              hint: "write comment",
                              onTap: () {},
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ActionButton(
                          icon: Container(
                              padding: EdgeInsets.all(8),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.redAccent,
                              ),
                              child: Icon(Icons.send, color: Colors.white)),
                          onPressed: () {
                            if (commentController.text.isNotEmpty) {
                              sendBarrageMessage(roomID: widget.roomID, message: commentController.text);
                              zegoCloudCubit.makeCommentInRoom(
                                roomId: widget.roomID,
                                comment: commentController.text,
                              );
                              commentController.clear();
                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                      ],
                      if (!widget.isHost && !isKeyboardVisible) ...[
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: myTextFormField(
                              context: context,
                              controller: commentController,
                              fillColor: Colors.black26,
                              hintColor: Colors.white,
                              textColor: Colors.white,
                              radius: 8,
                              hint: "write comment",
                              onTap: () {},
                            ),
                          ),
                        ),
                      ],
                      if (!widget.isHost && isKeyboardVisible) ...[
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: myTextFormField(
                              context: context,
                              controller: commentController,
                              fillColor: Colors.black26,
                              hintColor: Colors.white,
                              textColor: Colors.white,
                              radius: 8,
                              hint: "write comment",
                              onTap: () {},
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ActionButton(
                          icon: Container(
                              padding: EdgeInsets.all(8),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.redAccent,
                              ),
                              child: Icon(Icons.send, color: Colors.white)),
                          onPressed: () {
                            if (commentController.text.isNotEmpty) {
                              sendCustomCommandToSpecifiedUser(
                                  roomID: widget.roomID,
                                  command: commentController.text,
                                  toUserList: [
                                    ZegoUser(zegoCloudCubit.roomDetails!.message!.userData!.studentId!,
                                        zegoCloudCubit.roomDetails!.message!.userData!.studentName!)
                                  ]);
                              zegoCloudCubit.makeCommentInRoom(
                                roomId: widget.roomID,
                                comment: commentController.text,
                              );
                              commentController.clear();
                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
            );
          },
        );
      },
    );
  }

  Future<ZegoRoomLoginResult> loginRoom() async {
    // The value of `userID` is generated locally and must be globally unique.
    final user = ZegoUser(widget.localUserID, widget.localUserName);

    // The value of `roomID` is generated locally and must be globally unique.
    final roomID = widget.roomID;

    // onRoomUserUpdate callback can be received when "isUserStatusNotify" parameter value is "true".
    ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig()..isUserStatusNotify = true;

    if (kIsWeb) {
      // ! ** Warning: ZegoTokenUtils is only for use during testing. When your application goes live,
      // ! ** tokens must be generated by the server side. Please do not generate tokens on the client side!
      roomConfig.token = ZegoTokenUtils.generateToken(appID, serverSecret, widget.localUserID);
    }
    // log in to a room
    // Users must log in to the same room to call each other.
    return ZegoExpressEngine.instance
        .loginRoom(roomID, user, config: roomConfig)
        .then((ZegoRoomLoginResult loginRoomResult) async {
      debugPrint('loginRoom: errorCode:${loginRoomResult.errorCode}, extendedData:${loginRoomResult.extendedData}');
      if (loginRoomResult.errorCode == 0) {
        if (widget.isHost) {
          startPreview();
          startPublish();
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('loginRoom failed: ${loginRoomResult.errorCode}')));
      }
      return loginRoomResult;
    });
  }

  Future<ZegoRoomLogoutResult> logoutRoom() async {
    stopPreview();
    stopPublish();
    stopScreenSharing();
    if (screenSharingSource != null) ZegoExpressEngine.instance.destroyScreenCaptureSource(screenSharingSource!);
    return ZegoExpressEngine.instance.logoutRoom(widget.roomID);
  }

  void startListenEvent() {
    // Callback for updates on the status of other users in the room.
    // Users can only receive callbacks when the isUserStatusNotify property of ZegoRoomConfig is set to `true` when logging in to the room (loginRoom).
    ZegoExpressEngine.onRoomUserUpdate = (roomID, updateType, List<ZegoUser> userList) {
      debugPrint(
          'onRoomUserUpdate: roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => e.userID)}');
    };
    // Callback for updates on the status of the streams in the room.
    ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, List<ZegoStream> streamList, extendedData) {
      debugPrint(
          'onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}, extendedData: $extendedData');
      if (updateType == ZegoUpdateType.Add) {
        for (final stream in streamList) {
          startPlayStream(stream.streamID);
        }
      } else {
        for (final stream in streamList) {
          stopPlayStream(stream.streamID);
        }
      }
    };
    // Callback for updates on the current user's room connection status.
    ZegoExpressEngine.onRoomStateUpdate = (roomID, state, errorCode, extendedData) {
      debugPrint(
          'onRoomStateUpdate: roomID: $roomID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
    };

    // Callback for updates on the current user's stream publishing changes.
    ZegoExpressEngine.onPublisherStateUpdate = (streamID, state, errorCode, extendedData) {
      debugPrint(
          'onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
    };
    ZegoExpressEngine.onPublisherStateUpdate = (streamID, state, errorCode, extendedData) {
      debugPrint(
          'onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
    };

    ZegoExpressEngine.onRoomStreamExtraInfoUpdate = (String roomID, List<ZegoStream> streamList) {
      for (ZegoStream stream in streamList) {
        try {
          Map<String, dynamic> extraInfoMap = jsonDecode(stream.extraInfo);
          if (extraInfoMap['isCameraEnabled'] is bool) {
            setState(() {
              isCameraEnabled = extraInfoMap['isCameraEnabled'];
            });
          }
        } catch (e) {
          debugPrint('streamExtraInfo is not json');
        }
      }
    };
    ZegoExpressEngine.onApiCalledResult = (int errorCode, String funcName, String info) {
      if (errorCode != 0) {
        String errorMessage = 'onApiCalledResult, $funcName failed: $errorCode, $info';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
        debugPrint(errorMessage);

        if (funcName == 'startScreenCapture') {
          stopScreenSharing();
        }
      }
    };

    ZegoExpressEngine.onPlayerVideoSizeChanged = (String streamID, int width, int height) {
      String message = 'onPlayerVideoSizeChanged: $streamID, ${width}x$height,isLandScape: ${width > height}';
      debugPrint(message);
    };
  }

  void stopListenEvent() {
    ZegoExpressEngine.onRoomUserUpdate = null;
    ZegoExpressEngine.onRoomStreamUpdate = null;
    ZegoExpressEngine.onRoomStateUpdate = null;
    ZegoExpressEngine.onPublisherStateUpdate = null;
    ZegoExpressEngine.onApiCalledResult = null;
    ZegoExpressEngine.onPlayerVideoSizeChanged = null;
  }

  Future<void> startScreenSharing() async {
    screenSharingSource ??= (await ZegoExpressEngine.instance.createScreenCaptureSource())!;
    await ZegoExpressEngine.instance.setVideoConfig(
      ZegoVideoConfig.preset(ZegoVideoConfigPreset.Preset1080P)..fps = 30,
      channel: ZegoPublishChannel.Aux,
    );
    await ZegoExpressEngine.instance.setVideoSource(ZegoVideoSourceType.ScreenCapture, channel: ZegoPublishChannel.Aux);
    await screenSharingSource!.startCapture();
    String streamID = '${widget.roomID}_${widget.localUserID}_screen';
    await ZegoExpressEngine.instance.startPublishingStream(streamID, channel: ZegoPublishChannel.Aux);
    await ZegoExpressEngine.instance.stopPublishingStream(channel: ZegoPublishChannel.Aux);
    await ZegoExpressEngine.instance.startPublishingStream(streamID, channel: ZegoPublishChannel.Aux);
    setState(() => isSharingScreen = true);

    bool needPreview = false;
    // ignore: dead_code
    if (needPreview && (hostScreenViewID == null)) {
      await ZegoExpressEngine.instance.createCanvasView((viewID) async {
        hostScreenViewID = viewID;
        ZegoCanvas previewCanvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.ScaleToFill);
        ZegoExpressEngine.instance.startPreview(canvas: previewCanvas, channel: ZegoPublishChannel.Aux);
      }).then((canvasViewWidget) {
        // use this canvasViewWidget to preview the screensharing
        setState(() => hostScreenView = canvasViewWidget);
      });
    }
  }

  Future<void> stopScreenSharing() async {
    await screenSharingSource?.stopCapture();
    await ZegoExpressEngine.instance.stopPreview(channel: ZegoPublishChannel.Aux);
    await ZegoExpressEngine.instance.stopPublishingStream(channel: ZegoPublishChannel.Aux);
    await ZegoExpressEngine.instance.setVideoSource(ZegoVideoSourceType.None, channel: ZegoPublishChannel.Aux);
    if (mounted) setState(() => isSharingScreen = false);
    if (hostScreenViewID != null) {
      await ZegoExpressEngine.instance.destroyCanvasView(hostScreenViewID!);
      if (mounted) {
        setState(() {
          hostScreenViewID = null;
          hostScreenView = null;
        });
      }
    }
  }

  Future<void> startPreview() async {
    // cameraView
    ZegoExpressEngine.instance.enableCamera(true);
    await ZegoExpressEngine.instance.createCanvasView((viewID) {
      hostCameraViewID = viewID;
      ZegoCanvas previewCanvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.ScaleToFill);
      ZegoExpressEngine.instance.startPreview(canvas: previewCanvas, channel: ZegoPublishChannel.Main);
    }).then((canvasViewWidget) {
      setState(() => hostCameraView = canvasViewWidget);
    });
  }

  Future<void> stopPreview() async {
    ZegoExpressEngine.instance.stopPreview(channel: ZegoPublishChannel.Main);
    if (hostCameraViewID != null) {
      await ZegoExpressEngine.instance.destroyCanvasView(hostCameraViewID!);
      if (mounted) {
        setState(() {
          hostCameraViewID = null;
          hostCameraView = null;
        });
      }
    }
  }

  Future<void> startPublish() async {
    // After calling the `loginRoom` method, call this method to publish streams.
    // The StreamID must be unique in the room.
    String streamID = '${widget.roomID}_${widget.localUserID}_live';
    return ZegoExpressEngine.instance.startPublishingStream(streamID, channel: ZegoPublishChannel.Main);
  }

  Future<void> stopPublish() async {
    return ZegoExpressEngine.instance.stopPublishingStream();
  }

  Future<void> startPlayStream(String streamID) async {
    bool isScreenSharingStream = streamID.endsWith('_screen');
    await ZegoExpressEngine.instance.createCanvasView((viewID) {
      if (isScreenSharingStream) {
        hostScreenViewID = viewID;
      } else {
        hostCameraViewID = viewID;
      }
      ZegoCanvas canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFit);
      ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
    }).then((canvasViewWidget) {
      setState(() {
        if (isScreenSharingStream) {
          hostScreenView = canvasViewWidget;
          isSharingScreen = true;
        } else {
          hostCameraView = canvasViewWidget;
        }
      });
    });
  }

  Future<void> stopPlayStream(String streamID) async {
    bool isScreenSharingStream = streamID.endsWith('_screen');

    ZegoExpressEngine.instance.stopPlayingStream(streamID);
    if (isScreenSharingStream) {
      if (hostScreenViewID != null) {
        ZegoExpressEngine.instance.destroyCanvasView(hostScreenViewID!);
        if (mounted) {
          setState(() {
            hostScreenViewID = null;
            hostScreenView = null;
            isSharingScreen = false;
          });
        }
      }
    } else {
      if (hostCameraViewID != null) {
        ZegoExpressEngine.instance.destroyCanvasView(hostCameraViewID!);
        if (mounted) {
          setState(() {
            hostCameraViewID = null;
            hostCameraView = null;
          });
        }
      }
    }
  }

  void sendBarrageMessage({required String roomID, required String message}) {
    final userImage = stuPhoto != ""
        ? stuPhoto
        : "https://camp-coding.tech//shlonak//user//home//images//957959159_1693151625item_img.jpeg";
    ZegoExpressEngine.instance.sendBarrageMessage(roomID, "${message}**${userImage}");
    if (message.split("**").first != "End_Room__") {
      CommentsModel newComment = CommentsModel(
        message: message.split("**").first,
        roomId: roomID,
        date: DateTime.now(),
        userId: stuId,
        userName: myName,
        userImage: userImage,
      );
      comments.add(newComment);
      setState(() {});
    }
  }

  Future<void> onReceiveBarrageMessage() async {
    ZegoExpressEngine.onIMRecvBarrageMessage = (String roomID, List<ZegoBarrageMessageInfo> messageList) async {
      for (ZegoBarrageMessageInfo message in messageList) {
        if (message.message.split('**').first == "End_Room__") {
          showProgressIndicator(context: context, text: "Live ended");
          await ZegoCloudCubit.get(context).getRoomsForStudents().then((value) {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        } else {
          CommentsModel newComment = CommentsModel(
            message: message.message.split('**').first,
            roomId: roomID,
            date: DateTime.now(),
            userId: message.fromUser.userID,
            userImage: message.message.split('**').last,
            userName: message.fromUser.userName,
          );
          comments.add(newComment);
          setState(() {});
        }
      }
    };
  }

  void sendCustomCommandToSpecifiedUser(
      {required String roomID, required String command, required List<ZegoUser> toUserList}) {
    final userImage = stuPhoto != ""
        ? stuPhoto
        : "https://camp-coding.tech//shlonak//user//home//images//957959159_1693151625item_img.jpeg";
    ZegoExpressEngine.instance.sendCustomCommand(roomID, "${command}**${userImage}", toUserList);
  }

  void onReceiveCustomCommand() {
    ZegoExpressEngine.onIMRecvCustomCommand = (String roomID, ZegoUser fromUser, String command) {
      CommentsModel newComment = CommentsModel(
        message: command.split('**').first,
        roomId: roomID,
        date: DateTime.now(),
        userId: fromUser.userID,
        userImage: command.split('**').last,
        userName: fromUser.userName,
      );
      comments.add(newComment);
      setState(() {});
    };
  }

  void onRoomOnlineUserCountUpdate() {
    ZegoExpressEngine.onRoomOnlineUserCountUpdate = (String roomID, int count) {
      print("===========================");
      setState(() {
        numOfViews = count;
      });
    };
  }

  void buildAudienceBottomSheet(BuildContext context) {
    showMyBottomSheet(
      context: context,
      bgColor: Colors.white,
      maxHeight: MediaQuery.of(context).size.height - 120,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: BlocConsumer<ZegoCloudCubit, ZegoCloudStates>(
          listener: (context, state) {},
          builder: (context, state) {
            ZegoCloudCubit zegoCloudCubit = BlocProvider.of(context);
            return Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Members ",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "(${zegoCloudCubit.roomDetails!.message!.usersInRooms!.length})",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                myDivider(paddingHz: 0),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            zegoCloudCubit.roomDetails!.message!.usersInRooms![index].userImage!,
                          ),
                        ),
                        title: Text(
                          zegoCloudCubit.roomDetails!.message!.usersInRooms![index].userName!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          zegoCloudCubit.roomDetails!.message!.userData!.studentId == stuId
                              ? "You, The host"
                              : "Audience",
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 20),
                    itemCount: zegoCloudCubit.roomDetails!.message!.usersInRooms!.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> useFrontCamera(bool enable, {ZegoPublishChannel? channel}) async {
    setState(() {
      if (enable) {
        isFrontCamera = true;
      } else {
        isFrontCamera = false;
      }
    });
    return await ZegoExpressEngine.instance.useFrontCamera(enable, channel: channel);
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: onPressed,
        child: icon,
      ),
    );
  }
}
