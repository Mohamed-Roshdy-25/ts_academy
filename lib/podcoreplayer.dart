// part of 'package:pod_player/src/pod_player.dart';

// class PodCoreVideoPlayer extends StatefulWidget {
//   final VideoPlayerController videoPlayerCtr;
//   final double videoAspectRatio;
//   final String tag;

//   const PodCoreVideoPlayer(
//       {super.key,
//         required this.videoPlayerCtr,
//         required this.videoAspectRatio,
//         required this.tag
//       });

//   @override
//   State<PodCoreVideoPlayer> createState() => _PodCoreVideoPlayerState();
// }

// class _PodCoreVideoPlayerState extends State<PodCoreVideoPlayer> {


//   @override
//   void initState() {
//     super.initState();
//     _moveText();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _podCtr = Get.find<PodGetXVideoController>(tag: widget.tag);
//     return Builder(
//       builder: (_ctrx) {
//         return RawKeyboardListener(
//           autofocus: true,
//           focusNode:
//           (_podCtr.isFullScreen ? FocusNode() : _podCtr.keyboardFocusWeb) ??
//               FocusNode(),
//           onKey: (value) => _podCtr.onKeyBoardEvents(
//             event: value,
//             appContext: _ctrx,
//             tag: widget.tag,
//           ),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               Center(
//                 child: AspectRatio(
//                   aspectRatio: widget.videoAspectRatio,
//                   child: VideoPlayer(widget.videoPlayerCtr),
//                 ),
//               ),
//               GetBuilder<PodGetXVideoController>(
//                 tag: widget.tag,
//                 id: 'podVideoState',
//                 builder: (_) => GetBuilder<PodGetXVideoController>(
//                   tag: widget.tag,
//                   id: 'video-progress',
//                   builder: (_podCtr) {
//                     if (_podCtr.videoThumbnail == null) {
//                       return const SizedBox();
//                     }

//                     if (_podCtr.podVideoState == PodVideoState.paused &&
//                         _podCtr.videoPosition == Duration.zero) {
//                       return SizedBox.expand(
//                         child: TweenAnimationBuilder<double>(
//                           builder: (context, value, child) => Opacity(
//                             opacity: value,
//                             child: child,
//                           ),
//                           tween: Tween<double>(begin: 0.7, end: 1),
//                           duration: const Duration(milliseconds: 400),
//                           child: DecoratedBox(
//                             decoration: BoxDecoration(
//                               image: _podCtr.videoThumbnail,
//                             ),
//                           ),
//                         ),
//                       );
//                     }
//                     return const SizedBox();
//                   },
//                 ),
//               ),
//               _VideoOverlays(tag: widget.tag),
//               IgnorePointer(
//                 child: GetBuilder<PodGetXVideoController>(
//                   tag: widget.tag,
//                   id: 'podVideoState',
//                   builder: (_podCtr) {
//                     final loadingWidget = _podCtr.onLoading?.call(context) ??
//                         const Center(
//                           child: CircularProgressIndicator(
//                             backgroundColor: Colors.transparent,
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         );

//                     if (kIsWeb) {
//                       switch (_podCtr.podVideoState) {
//                         case PodVideoState.loading:
//                           return loadingWidget;
//                         case PodVideoState.paused:
//                           return const Center(
//                             child: Icon(
//                               Icons.play_arrow,
//                               size: 45,
//                               color: Colors.white,
//                             ),
//                           );
//                         case PodVideoState.playing:
//                           return Center(
//                             child: TweenAnimationBuilder<double>(
//                               builder: (context, value, child) => Opacity(
//                                 opacity: value,
//                                 child: child,
//                               ),
//                               tween: Tween<double>(begin: 1, end: 0),
//                               duration: const Duration(seconds: 1),
//                               child: const Icon(
//                                 Icons.pause,
//                                 size: 45,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           );
//                         case PodVideoState.error:
//                           return const SizedBox();
//                       }
//                     } else {
//                       if (_podCtr.podVideoState == PodVideoState.loading) {
//                         return loadingWidget;
//                       }
//                       return const SizedBox();
//                     }
//                   },
//                 ),
//               ),
//               if (!kIsWeb)
//                 GetBuilder<PodGetXVideoController>(
//                   tag: widget.tag,
//                   id: 'full-screen',
//                   builder: (_podCtr) => _podCtr.isFullScreen
//                       ? const SizedBox()
//                       : GetBuilder<PodGetXVideoController>(
//                     tag: widget.tag,
//                     id: 'overlay',
//                     builder: (_podCtr) => _podCtr.isOverlayVisible ||
//                         !_podCtr.alwaysShowProgressBar
//                         ? const SizedBox()
//                         : Align(
//                       alignment: Alignment.bottomCenter,
//                       child: PodProgressBar(
//                         tag: widget.tag,
//                         alignment: Alignment.bottomCenter,
//                         podProgressBarConfig:
//                         _podCtr.podProgressBarConfig,
//                       ),
//                     ),
//                   ),
//                 ),
//               if(_podCtr.isFullScreen)
//                 randomTextWidget(),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   double _xPosition = 100;
//   double _yPosition = 100;
//   Widget randomTextWidget() {
//     return AnimatedPositioned(
//       left: _xPosition,
//       top: _yPosition,
//       duration: const Duration(milliseconds: 1000),
//       child: Transform.rotate(
//         angle: 50,
//         child: Stack(
//           children: [
//             Text(
//               '$stuId',
//               style: TextStyle(
//                 fontSize: 18,
//                 foreground: Paint()
//                   ..style = PaintingStyle.stroke
//                   ..strokeWidth = 4
//                   ..color = ColorConstants.lightBlue.withOpacity(0.8),
//               ),
//             ),
//             Text(
//               '$stuId',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   double _randomPosition(double max) {
//     return ((max == 1 && MediaQuery.of(context).orientation == Orientation.landscape ? 350 : 100) *
//         (Random().nextInt(5) * (0.5 - (10020 % 1000) / 1000)));
//   }

//   void _moveText() {
//     Timer.periodic(const Duration(milliseconds: 5000), (timer) {
//       if (mounted) {
//         setState(() {
//           _xPosition = _randomPosition(1);
//           _yPosition = _randomPosition(250);
//         });
//       }
//     });
//   }
// }
