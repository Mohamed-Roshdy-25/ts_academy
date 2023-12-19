import 'package:easy_localization/easy_localization.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:ts_academy/screens/courses/cubit/cubit.dart';
import 'package:ts_academy/screens/courses/cubit/states.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../constants/string_constants.dart';
import '../../controller/settings_cubit/settings_cubit.dart';
import '../new_course_content/cubit/cubit.dart';
import '/constants/color_constants.dart';
import '/modules/elevated_button.dart';
import '/modules/modules.dart';
import '/screens/courses/comments_list.dart';
import '../../constants/constants.dart';
import '../../constants/font_constants.dart';
import '../../constants/image_constants.dart';
import '../../controller/comments/comment_cubit.dart';
import '../../controller/courses_video/courses_video_cubit.dart';
import '../../modules/audio_tile.dart';
import '../../modules/pdf_screen.dart';

class CourseContentScreen extends StatefulWidget {
  const CourseContentScreen(
      {Key? key,
      required this.courseId,
      required this.courseName,
      required this.own})
      : super(key: key);
  final String courseName, courseId;
  final bool own;

  @override
  _CourseContentScreenState createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen> {
  int isLoad = 0;
  int tabIndex = 0;
  late WebViewController webViewController;
  final ScrollController _scrollController = ScrollController();

  void scrollToTop() {
    _scrollController.animateTo(
      0.0, // Scroll to the top
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url
                .startsWith('https://centerts.net/ts/publitio_player')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      );
    print(widget.courseId);
    Future.delayed(Duration.zero, () {
      debugPrint("course id :  ${widget.courseId}");
      BlocProvider.of<CoursesVideoCubit>(context)
          .getAllCourses(widget.courseId)
          .then((value) => setState(() {
                isLoad++;
              }));
    });
  }

  bool load = false;
  @override
  Widget build(BuildContext context) {
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    Size size = MediaQuery.of(context).size;
    return isLandscape
        ? Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomInset: true,
            body: HeadCourseContent(
              own: widget.own,
              type: BlocProvider.of<CoursesVideoCubit>(context).type == ""
                  ? BlocProvider.of<CoursesVideoCubit>(context)
                      .allCoursesData[0]
                      .type
                  : BlocProvider.of<CoursesVideoCubit>(context).type,
              desc:
                  BlocProvider.of<CoursesVideoCubit>(context).description == ""
                      ? BlocProvider.of<CoursesVideoCubit>(context)
                          .allCoursesData[0]
                          .videoDescription
                      : BlocProvider.of<CoursesVideoCubit>(context).description,
              title: BlocProvider.of<CoursesVideoCubit>(context).title == ""
                  ? BlocProvider.of<CoursesVideoCubit>(context)
                      .allCoursesData[0]
                      .videoTitle
                  : BlocProvider.of<CoursesVideoCubit>(context).title,
              link: BlocProvider.of<CoursesVideoCubit>(context).link == ""
                  ? BlocProvider.of<CoursesVideoCubit>(context)
                      .allCoursesData[0]
                      .videoUrl
                  : BlocProvider.of<CoursesVideoCubit>(context).link,
              controller: webViewController,
            ),
          )
        : BlocConsumer<WatchVideoCubit, WatchVideoStates>(
            listener: (context, state) {},
            builder: (context, state) {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: SystemUiOverlay.values);
              WatchVideoCubit watchVideoCubit = BlocProvider.of(context);
              return DefaultTabController(
                length: 2,
                child: WillPopScope(
                  onWillPop: () async {
                    if (WatchVideoCubit.get(context).isScreenSplitted) {
                      WatchVideoCubit.get(context)
                          .changeSplitScreen(value: false, pdfLink: "");
                      return false;
                    } else {
                      return true;
                    }
                  },
                  child: Scaffold(
                    resizeToAvoidBottomInset: true,
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
                                watchVideoCubit.changeSplitScreen(
                                    value: false, pdfLink: "");
                              },
                              icon:
                                  Icon(Icons.exit_to_app, color: Colors.white)),
                        if (!watchVideoCubit.isScreenSplitted)
                          IconButton(
                            onPressed: () async {
                              // await SystemChrome.setEnabledSystemUIMode(
                              //     SystemUiMode.manual,
                              //     overlays: []);
                              // SystemChrome.setPreferredOrientations(
                              //     [DeviceOrientation.landscapeLeft]);
                            },
                            icon: Icon(Icons.fullscreen, color: Colors.white),
                          ),
                      ],
                    ),
                    body: BlocConsumer<CoursesVideoCubit, CoursesVideoState>(
                      listener: (context, state) {
                        if (state is GetCoursesVideoFailure) {
                          Modules().toast(state.message, Colors.red);
                        }
                      },
                      builder: (context, state) {
                        return isLoad == 0
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: ColorConstants.purpal,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(20),
                                child:
                                    BlocProvider.of<CoursesVideoCubit>(context)
                                            .allCoursesData
                                            .isEmpty
                                        ? Center(
                                            child: Text(
                                              tr(StringConstants.noContentsYet),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : !watchVideoCubit.isScreenSplitted
                                            ? SingleChildScrollView(
                                                controller:
                                                    _scrollController, // Attach the ScrollController
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      '${BlocProvider.of<CoursesVideoCubit>(context).videosCoursesData.length} Videos | ${BlocProvider.of<CoursesVideoCubit>(context).audiosCoursesData.length} Audio | ${BlocProvider.of<CoursesVideoCubit>(context).pdfCoursesData.length} File',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    state is GetCoursesVideoLoading ||
                                                            state
                                                                is GetCoursesVideoFailure
                                                        ? SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.3,
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color:
                                                                    ColorConstants
                                                                        .purpal,
                                                              ),
                                                            ),
                                                          )
                                                        : HeadCourseContent(
                                                            own: widget.own,
                                                            type: BlocProvider
                                                                    .of<CoursesVideoCubit>(
                                                                        context)
                                                                .type,
                                                            desc: BlocProvider
                                                                    .of<CoursesVideoCubit>(
                                                                        context)
                                                                .description,
                                                            title: BlocProvider
                                                                    .of<CoursesVideoCubit>(
                                                                        context)
                                                                .title,
                                                            link: BlocProvider
                                                                    .of<CoursesVideoCubit>(
                                                                        context)
                                                                .link,
                                                            controller:
                                                                webViewController,
                                                          ),
                                                    const SizedBox(height: 15),
                                                    TabBar(
                                                      onTap: (index) {
                                                        setState(() {
                                                          tabIndex = index;
                                                        });
                                                        if (index == 1) {
                                                          BlocProvider.of<
                                                                      CommentCubit>(
                                                                  context)
                                                              .getComments(widget
                                                                  .courseId);
                                                        }
                                                      },
                                                      indicatorColor:
                                                          ColorConstants
                                                              .lightBlue,
                                                      labelColor: Colors.black,
                                                      labelStyle:
                                                          const TextStyle(
                                                              fontFamily:
                                                                  FontConstants
                                                                      .poppins,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                      tabs: [
                                                        Tab(
                                                            text: tr(
                                                                StringConstants
                                                                    .lectures)),
                                                        Tab(
                                                            text: tr(
                                                                StringConstants
                                                                    .comments)),
                                                      ],
                                                    ),
                                                    tabIndex == 0
                                                        ? ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 40),
                                                            itemCount: BlocProvider
                                                                    .of<CoursesVideoCubit>(
                                                                        context)
                                                                .allCoursesData
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  scrollToTop();
                                                                  BlocProvider.of<
                                                                              CoursesVideoCubit>(
                                                                          context)
                                                                      .changeIndexOfVideo(
                                                                          index);

                                                                  if (widget
                                                                      .own) {
                                                                    BlocProvider.of<CoursesVideoCubit>(
                                                                            context)
                                                                        .changeLinks(
                                                                            BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].videoUrl,
                                                                            BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].videoDescription,
                                                                            BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].type.toLowerCase(),
                                                                            BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].videoTitle)
                                                                        .then((value) {
                                                                      BlocProvider.of<CoursesVideoCubit>(
                                                                              context)
                                                                          .getAllCourses(widget
                                                                              .courseId)
                                                                          .then((value) =>
                                                                              scrollToTop());
                                                                    });
                                                                    debugPrint(
                                                                        BlocProvider.of<CoursesVideoCubit>(context)
                                                                            .link);
                                                                    debugPrint(
                                                                        BlocProvider.of<CoursesVideoCubit>(context)
                                                                            .type);
                                                                  } else {
                                                                    BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].free ==
                                                                            "no"
                                                                                .toLowerCase()
                                                                        ? showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return AlertDialog(
                                                                                content: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Text(tr(StringConstants.lockCourse)),
                                                                                    SizedBox(
                                                                                      height: 10,
                                                                                    ),
                                                                                    TextButton(
                                                                                      child: Text(
                                                                                        tr(StringConstants.ok),
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(ColorConstants.lightBlue)),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                title: Text(
                                                                                  tr(StringConstants.invalid_message),
                                                                                  style: TextStyle(color: ColorConstants.purpal),
                                                                                ),
                                                                              );
                                                                            })
                                                                        : BlocProvider.of<CoursesVideoCubit>(context)
                                                                            .changeLinks(
                                                                                BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].videoUrl,
                                                                                BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].videoDescription,
                                                                                BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].type.toLowerCase(),
                                                                                BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].videoTitle)
                                                                            .then((value) {
                                                                            BlocProvider.of<CoursesVideoCubit>(context).getAllCourses(widget.courseId).then((value) =>
                                                                                scrollToTop());
                                                                          });

                                                                    debugPrint(
                                                                        BlocProvider.of<CoursesVideoCubit>(context)
                                                                            .link);
                                                                    debugPrint(
                                                                        BlocProvider.of<CoursesVideoCubit>(context)
                                                                            .type);
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      border: Border.all(
                                                                          color: BlocProvider.of<CoursesVideoCubit>(context).videoIndex == index
                                                                              ? ColorConstants.lightBlue
                                                                              : Colors.white,
                                                                          width: 2)),
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              15),
                                                                  child: Row(
                                                                    children: [
                                                                      BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].type.toString().toLowerCase() ==
                                                                              'pdf'
                                                                          ? SizedBox(
                                                                              width: 40,
                                                                              height: 40,
                                                                              child: Image.asset(
                                                                                ImagesConstants.paper,
                                                                                color: BlocProvider.of<CoursesVideoCubit>(context).videoIndex == index ? ColorConstants.lightBlue : Colors.black,
                                                                              ),
                                                                            )
                                                                          : BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].type.toString().toLowerCase() == 'video'
                                                                              ? SizedBox(
                                                                                  width: 40,
                                                                                  height: 40,
                                                                                  child: Image.asset(
                                                                                    ImagesConstants.video,
                                                                                    color: BlocProvider.of<CoursesVideoCubit>(context).videoIndex == index ? ColorConstants.lightBlue : Colors.black,
                                                                                  ),
                                                                                )
                                                                              : CircleAvatar(
                                                                                  radius: 16,
                                                                                  backgroundColor: ColorConstants.darkBlue,
                                                                                  child: CircleAvatar(
                                                                                      backgroundColor: BlocProvider.of<CoursesVideoCubit>(context).videoIndex == index ? ColorConstants.lightBlue : Colors.white,
                                                                                      radius: 14,
                                                                                      child: Icon(
                                                                                        Icons.audiotrack,
                                                                                        color: Colors.black,
                                                                                      )),
                                                                                ),
                                                                      const SizedBox(
                                                                          width:
                                                                              15),
                                                                      Expanded(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].videoTitle,
                                                                                          style: const TextStyle(fontSize: 15, fontFamily: FontConstants.poppins),
                                                                                        ),
                                                                                      ),
                                                                                      if (BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].type.toString().toLowerCase() == 'pdf' && (BlocProvider.of<CoursesVideoCubit>(context).type == "" ? BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[0].type.toLowerCase() == 'video' : BlocProvider.of<CoursesVideoCubit>(context).type.toLowerCase() == 'video'))
                                                                                        IconButton(
                                                                                          icon: Icon(Icons.splitscreen, color: ColorConstants.lightBlue),
                                                                                          onPressed: () {
                                                                                            WatchVideoCubit.get(context).changeSplitScreen(
                                                                                              value: true,
                                                                                              pdfLink: BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].videoUrl,
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                    ],
                                                                                  ),

                                                                                  // Text(
                                                                                  //   BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].type.toString().toLowerCase() == 'pdf'
                                                                                  //       ? tr(StringConstants.pdf_file)
                                                                                  //       : "${BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].videoNumber} ${tr(StringConstants.mins)}",
                                                                                  //   style: const TextStyle(
                                                                                  //       fontSize: 13,
                                                                                  //       fontFamily: FontConstants.poppins,
                                                                                  //       color: Colors.grey),
                                                                                  // ),
                                                                                  const SizedBox(height: 8),
                                                                                  SizedBox(
                                                                                      width: size.width / 1.35,
                                                                                      child: const Divider(
                                                                                        thickness: 1,
                                                                                        color: Colors.black,
                                                                                        height: 1,
                                                                                      ))
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            // Text(
                                                                            //     BlocProvider.of<CoursesVideoCubit>(
                                                                            //             context)
                                                                            //         .allCoursesData[
                                                                            //             index]
                                                                            //         .videoId,
                                                                            //     style: TextStyle(
                                                                            //         fontSize: 11
                                                                            //             .sp,
                                                                            //         fontWeight: FontWeight
                                                                            //             .w500,
                                                                            //         color:
                                                                            //             ColorConstants.purpal)),
                                                                            widget.own
                                                                                ? const SizedBox()
                                                                                : BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[index].free == "no".toLowerCase()
                                                                                    ? const Icon(
                                                                                        Icons.lock,
                                                                                        color: Colors.black,
                                                                                      )
                                                                                    : const SizedBox()
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : CommentsList(
                                                            courseId:
                                                                widget.courseId)
                                                  ],
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  watchVideoCubit
                                                      .changeSplitScreen(
                                                          value: false,
                                                          pdfLink: "");
                                                },
                                                child: Column(
                                                  children: [
                                                    HeadCourseContent(
                                                      own: widget.own,
                                                      type: BlocProvider.of<
                                                                  CoursesVideoCubit>(
                                                              context)
                                                          .type,
                                                      desc: BlocProvider.of<
                                                                  CoursesVideoCubit>(
                                                              context)
                                                          .description,
                                                      title: BlocProvider.of<
                                                                  CoursesVideoCubit>(
                                                              context)
                                                          .title,
                                                      link: BlocProvider.of<
                                                                  CoursesVideoCubit>(
                                                              context)
                                                          .link,
                                                      controller:
                                                          webViewController,
                                                    ),
                                                    Expanded(
                                                      child: PdfScreenSplitting(
                                                        link: watchVideoCubit
                                                            .currentLinkPdfWithSplittedScreen,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                              );
                      },
                    ),
                  ),
                ),
              );
            },
          );
  }
}

class HeadCourseContent extends StatefulWidget {
  const HeadCourseContent(
      {super.key,
      required this.type,
      required this.desc,
      required this.title,
      required this.link,
      required this.own,
      required this.controller});
  final String type;
  final String desc;
  final String title;
  final String link;
  final bool own;
  final WebViewController controller;
  @override
  State<HeadCourseContent> createState() => _HeadCourseContentState();
}

class _HeadCourseContentState extends State<HeadCourseContent>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    debugPrint(widget.own.toString());
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return BlocConsumer<CoursesVideoCubit, CoursesVideoState>(
      listener: (context, state) {
        if (state is ChangeLinksFailure) {
          Modules().toast(tr(StringConstants.invalid_message));
        }
      },
      builder: (context, state) {
        return isLandscape
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: widget.type.toLowerCase() == 'video'
                    ? Center(
                        child: WillPopScope(
                        onWillPop: () async {
                          // await SystemChrome.setEnabledSystemUIMode(
                          //     SystemUiMode.manual,
                          //     overlays: SystemUiOverlay.values);
                          // SystemChrome.setPreferredOrientations(
                          //     [DeviceOrientation.portraitUp]);
                          return false;
                        },
                        child: BlocProvider.of<CoursesVideoCubit>(context)
                            .setWebViewAsset(
                                height: MediaQuery.of(context).size.height,
                                controller: widget.controller,
                                videoUrl: widget.link),
                      ))
                    : widget.type.toLowerCase() == 'pdf'
                        ? NewPdfScreen(
                            link: widget.link,
                          )
                        : MusicTile(musicURL: widget.link),
              )
            : Column(
                children: [
                  widget.type == ""
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[0].free ==
                                      "no".toLowerCase() &&
                                  widget.own == false
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Center(
                                    child: Text(
                                      tr(StringConstants.lockCourse),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[0].type == 'video'.toLowerCase() && widget.own ||
                                      (BlocProvider.of<CoursesVideoCubit>(context)
                                                  .allCoursesData[0]
                                                  .free ==
                                              "yes".toLowerCase() &&
                                          widget.own == false)
                                  ? BlocProvider.of<CoursesVideoCubit>(context)
                                      .setWebViewAsset(
                                      height: 180,
                                      controller: widget.controller,
                                      videoUrl:
                                          BlocProvider.of<CoursesVideoCubit>(
                                                  context)
                                              .allCoursesData[0]
                                              .videoUrl
                                              .toString(),
                                    )
                                  : BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[0].type == 'pdf'.toLowerCase() && widget.own ||
                                          (BlocProvider.of<CoursesVideoCubit>(context)
                                                      .allCoursesData[0]
                                                      .free ==
                                                  "yes".toLowerCase() &&
                                              widget.own == false)
                                      ? NewPdfScreen(
                                          link: BlocProvider.of<
                                                  CoursesVideoCubit>(context)
                                              .allCoursesData[0]
                                              .videoUrl
                                              .toString(),
                                        )
                                      : BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[0].type == "audio".toLowerCase() && widget.own ||
                                              (BlocProvider.of<CoursesVideoCubit>(context)
                                                          .allCoursesData[0]
                                                          .free ==
                                                      "yes".toLowerCase() &&
                                                  widget.own == false)
                                          ? MusicTile(musicURL: BlocProvider.of<CoursesVideoCubit>(context).allCoursesData[0].videoUrl.toString())
                                          : SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              child: Center(
                                                child: Text(
                                                  tr(StringConstants
                                                      .lockCourse),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child:
                              widget.type.toLowerCase() == 'video'.toLowerCase()
                                  ? BlocProvider.of<CoursesVideoCubit>(context)
                                      .setWebViewAsset(
                                          controller: widget.controller,
                                          videoUrl: widget.link,
                                          height: 180)
                                  // ? VideoPlayerScreenWidget(link: link,)
                                  : widget.type == 'pdf'.toLowerCase()
                                      ? NewPdfScreen(
                                          link: widget.link,
                                        )
                                      : MusicTile(musicURL: widget.link),
                        ),
                  if (!WatchVideoCubit.get(context).isScreenSplitted)
                    const SizedBox(height: 15),
                  if (!WatchVideoCubit.get(context).isScreenSplitted)
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title == ""
                                ? BlocProvider.of<CoursesVideoCubit>(context)
                                    .allCoursesData[0]
                                    .videoTitle
                                : widget.title,
                            style: TextStyle(
                                fontFamily: FontConstants.poppins,
                                color: ColorConstants.lightBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            tr(StringConstants.description),
                            style: const TextStyle(
                                fontFamily: FontConstants.poppins,
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            widget.type == ""
                                ? BlocProvider.of<CoursesVideoCubit>(context)
                                    .allCoursesData[0]
                                    .videoDescription
                                : widget.desc,
                            style: TextStyle(
                                fontFamily: FontConstants.poppins,
                                color: Colors.grey[600],
                                fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                ],
              );
      },
    );
  }
}

/*class PdfScreen extends StatelessWidget {
  const PdfScreen({Key? key, required this.link}) : super(key: key);

  final String link;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.9,
          // padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              SfPdfViewer.network(link,
                  enableTextSelection: false,
                  canShowScrollHead: false,
                  enableDoubleTapZooming: false,
                  pageLayoutMode: PdfPageLayoutMode.single),
              Center(
                child: Transform.rotate(
                    angle: 75,
                    child: Text(
                      "$stuId",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black.withOpacity(double.parse(
                              BlocProvider.of<SettingsCubit>(context).settingsModel!.watermark_opacity.toString())),
                          fontFamily: 'Poppins'),
                    )),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Transform.rotate(
                  angle: 75,
                  child: Text(
                    "$stuId",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black.withOpacity(double.parse(
                          BlocProvider.of<SettingsCubit>(context).settingsModel!.watermark_opacity.toString())),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Transform.rotate(
                  angle: 75,
                  child: Text(
                    "$stuId",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black.withOpacity(double.parse(
                          BlocProvider.of<SettingsCubit>(context).settingsModel!.watermark_opacity.toString())),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Transform.rotate(
                  angle: 75,
                  child: Text(
                    "$stuId",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black.withOpacity(double.parse(
                          BlocProvider.of<SettingsCubit>(context).settingsModel!.watermark_opacity.toString())),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Transform.rotate(
                  angle: 75,
                  child: Text(
                    "$stuId",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black.withOpacity(double.parse(
                          BlocProvider.of<SettingsCubit>(context).settingsModel!.watermark_opacity.toString())),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        ElevatedButtonWidget(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: ((context) => PDFScreen(link: link))));
          },
          buttonText: tr(StringConstants.open_full_pdf),
        ),
        // ElevatedButtonWidget(
        //   onPressed: () {
        //     openFile(
        //       url:
        //           "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
        //       fileName: "FlutterBook.pdf",
        //     );
        //   },
        //   buttonText: 'Download PDF',
        // ),
      ],
    );
  }
}*/
class PdfScreenSplitting extends StatefulWidget {
  const PdfScreenSplitting({Key? key, required this.link}) : super(key: key);

  final String link;

  @override
  State<PdfScreenSplitting> createState() => _PdfScreenSplittingState();
}

class _PdfScreenSplittingState extends State<PdfScreenSplitting> {
  bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    // document = await PDFDocument.fromURL(widget.link);
    /* cacheManager: CacheManager(
          Config(
            "customCacheKey",
            stalePeriod: const Duration(days: 2),
            maxNrOfCacheObjects: 10,
          ),
        ), */
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isLoading) Center(child: CircularProgressIndicator()),
        if (!_isLoading)
          SfPdfViewer.network(
            widget.link,
            enableDoubleTapZooming: true,
            scrollDirection: PdfScrollDirection.horizontal,
            canShowPaginationDialog: true,
          ),
        // PDFViewer(
        //   document: document,
        //   lazyLoad: false,
        //   zoomSteps: 1,
        //   pickerButtonColor: ColorConstants.lightBlue,
        //   minScale: 1,
        //   maxScale: 50,
        //   showPicker: true,
        //   showNavigation: false,
        //   scrollDirection: Axis.vertical,
        //   numberPickerConfirmWidget: Text(
        //     "تأكيد",
        //   ),
        //   tooltip: PDFViewerTooltip(pick: "اختر صفحة",),
        // ),
        Positioned(
          top: 20,
          left: 20,
          child: Transform.rotate(
            angle: 75,
            child: Text(
              "$stuId",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: 'Poppins',
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Transform.rotate(
            angle: 75,
            child: Text(
              "$stuId",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.grey[400],
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: Transform.rotate(
            angle: 75,
            child: Text(
              "$stuId",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.grey[400],
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Transform.rotate(
            angle: 75,
            child: Text(
              "$stuId",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.grey[400],
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
        /////
      Center(
        child: Text(
                "$stuId",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.grey[400],
                  fontFamily: 'Poppins',
                ),
              ),
      ),
      ],
    );
  }
}

class NewPdfScreen extends StatefulWidget {
  const NewPdfScreen({Key? key, required this.link}) : super(key: key);

  final String link;

  @override
  State<NewPdfScreen> createState() => _NewPdfScreenState();
}

class _NewPdfScreenState extends State<NewPdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: BlocProvider.of<CourseContentCubit>(context).keyboard
                  ? 0
                  : MediaQuery.of(context).size.height / 1.9,
              // padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  //   PDFViewer(
                  //     document: document,
                  //     lazyLoad: false,
                  //     zoomSteps: 1,
                  //     enableSwipeNavigation: false,
                  //     pickerButtonColor: ColorConstants.lightBlue,
                  //     showPicker: false,
                  //     showNavigation: false,
                  // ),
                  SfPdfViewer.network(
                    widget.link,
                    canShowPaginationDialog: true,
                    canShowPageLoadingIndicator: false,
                    canShowScrollStatus: true,
                    canShowScrollHead: true,
                    scrollDirection: PdfScrollDirection.horizontal,
                  ),
                  // Center(
                  //   child: Transform.rotate(
                  //       angle: 75,
                  //       child: Text(
                  //         "$stuId",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 30,
                  //             color: Colors.black.withOpacity(double.parse(
                  //                 BlocProvider.of<SettingsCubit>(context)
                  //                     .settingsModel!
                  //                     .watermark_opacity
                  //                     .toString())),
                  //             fontFamily: 'Poppins'),
                  //       )),
                  // ),
                  // Positioned(
                  //   top: 20,
                  //   left: 20,
                  //   child: Transform.rotate(
                  //     angle: 75,
                  //     child: Text(
                  //       "$stuId",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 30,
                  //         color: Colors.black.withOpacity(double.parse(
                  //             BlocProvider.of<SettingsCubit>(context)
                  //                 .settingsModel!
                  //                 .watermark_opacity
                  //                 .toString())),
                  //         fontFamily: 'Poppins',
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   top: 20,
                  //   right: 20,
                  //   child: Transform.rotate(
                  //     angle: 75,
                  //     child: Text(
                  //       "$stuId",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 30,
                  //         color: Colors.black.withOpacity(double.parse(
                  //             BlocProvider.of<SettingsCubit>(context)
                  //                 .settingsModel!
                  //                 .watermark_opacity
                  //                 .toString())),
                  //         fontFamily: 'Poppins',
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   bottom: 20,
                  //   left: 20,
                  //   child: Transform.rotate(
                  //     angle: 75,
                  //     child: Text(
                  //       "$stuId",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 30,
                  //         color: Colors.black.withOpacity(double.parse(
                  //             BlocProvider.of<SettingsCubit>(context)
                  //                 .settingsModel!
                  //                 .watermark_opacity
                  //                 .toString())),
                  //         fontFamily: 'Poppins',
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   bottom: 20,
                  //   right: 20,
                  //   child: Transform.rotate(
                  //     angle: 75,
                  //     child: Text(
                  //       "$stuId",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 30,
                  //         color: Colors.black.withOpacity(double.parse(
                  //             BlocProvider.of<SettingsCubit>(context)
                  //                 .settingsModel!
                  //                 .watermark_opacity
                  //                 .toString())),
                  //         fontFamily: 'Poppins',
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // randomTextWidget(10,0),
            // randomTextWidget(MediaQuery.of(context).size.width*.9,0),
            Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 70.h),
                randomTextWidget(),
              ],
            )),
            // randomTextWidget(10,MediaQuery.of(context).size.height*.4,),
            // randomTextWidget(MediaQuery.of(context).size.width*.9,MediaQuery.of(context).size.height*.4),
          ],
        ),
        SizedBox(height: 15.h),
        ElevatedButtonWidget(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => PDFScreen(link: widget.link))));
          },
          buttonText: tr(StringConstants.open_full_pdf),
        ),
      ],
    );
  }

  Widget randomTextWidget() {


    return Opacity(
      opacity: .3,
      child: Transform.rotate(
        angle: 50,
        child: Stack(
          children: [
            Text(
              '$stuId',
              style: TextStyle(
                fontSize: 100,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 4
                  ..color = Colors.grey.withOpacity(0.8),
              ),
            ),
            Text(
              '$stuId',
              style: TextStyle(
                fontSize: 100,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Future<File?> downloadPDF(String url, String fileName) async {
//   final appStorage = await getTemporaryDirectory();
//   final file = File('${appStorage.path}/$fileName');
//   try {
//     final response = await Dio().get(url,
//         options:
//             Options(followRedirects: false, responseType: ResponseType.bytes));
//     final raf = file.openSync(mode: FileMode.write);
//     raf.writeFromSync(response.data);
//     await raf.close();
//     return file;
//   } catch (e) {
//     print(e.toString());
//     return null;
//   }
// }
//
// Future openFile({required String url, String? fileName}) async {
//   final name = fileName ?? url.split('/').last;
//   final file = await downloadPDF(url, name);
//   if (file == null) {
//     return;
//   }
//   print("===================================");
//   print('Path ${file.path}');
//   print("===================================");
//   OpenFile.open(file.path);
// }
