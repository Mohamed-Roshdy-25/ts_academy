/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/constants/color_constants.dart';
import 'package:ts_academy/constants/font_constants.dart';
import 'package:ts_academy/constants/image_constants.dart';
import 'package:ts_academy/controller/courses_video/courses_video_cubit.dart';
import 'package:ts_academy/modules/kareem_video_player.dart';
import 'package:ts_academy/screens/courses/course_content_screen.dart';
import 'package:ts_academy/screens/courses/cubit/cubit.dart';
import 'package:ts_academy/screens/courses/cubit/states.dart';

class SplittedScreen extends StatefulWidget {
  final bool own;
  final String courseName;
  const SplittedScreen({super.key, required this.own,required this.courseName});

  @override
  State<SplittedScreen> createState() => _SplittedScreenState();
}

class _SplittedScreenState extends State<SplittedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchVideoCubit,WatchVideoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        WatchVideoCubit watchVideoCubit = BlocProvider.of(context);
        return KareemVideoPlayer(
            videoLink: BlocProvider.of<CoursesVideoCubit>(context).link,
            screenWidget: Scaffold(
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
                          watchVideoCubit.changeSplitScreen(value: false, pdfLink: "");
                        },
                        icon: Icon(Icons.exit_to_app, color: Colors.white)),
                ],
              ),
              body: Expanded(
                child: PdfScreenSplitting(
                  link: watchVideoCubit.currentLinkPdfWithSplittedScreen,
                ),
              ),
            ),
        );
      },
    );
  }
}
*/
