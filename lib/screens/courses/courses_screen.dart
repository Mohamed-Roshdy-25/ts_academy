import 'package:cached_network_image/cached_network_image.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/screens/force_update_screen.dart';
import 'package:ts_academy/screens/new_course_content/cubit/cubit.dart';
import 'package:ts_academy/screens/new_course_content/cubit/states.dart';
import 'package:ts_academy/screens/new_course_content/new_course_content_screen.dart';
import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/controller/courses_Chapters/course_chapters_cubit.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../modules/modules.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen(
      {Key? key,
      required this.sectionName,
      required this.subjectId,
      required this.courseOwn})
      : super(key: key);
  final String sectionName;
  final String subjectId;
  final bool courseOwn;

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   // DeviceOrientation.landscapeLeft,
    //   // DeviceOrientation.landscapeRight,
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseChaptersCubit>(context);
    return BlocConsumer<CourseContentCubit, CourseContentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        CourseContentCubit courseContentCubit = BlocProvider.of(context);
        return Scaffold(
            appBar: Modules().appBar(widget.sectionName),
            body: BlocConsumer<CourseChaptersCubit, CourseChaptersState>(
              listener: (context, state) {
                if (state is CourseChaptersFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(13),
                  child: state is CourseChaptersLoading
                      ? Center(
                          child: CircularProgressIndicator(
                          color: ColorConstants.darkBlue,
                        ))
                      : bloc.allStudentCourses.isEmpty
                          ? Center(
                              child: Text(
                              tr(StringConstants.no_chapters),
                            ))
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Text(
                                      "subjects".tr(),
                                      // tr(StringConstants.courses),
                                      style: TextStyle(
                                          fontFamily: FontConstants.poppins,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  ListView.builder(
                                    itemCount: bloc.allStudentCourses.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return CourseWidget(
                                        onPress: () {
                                          if (versionNumberFromAPI == "2") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NewCourseContentScreen(
                                                  index: index,
                                                  ChapterName: bloc
                                                      .allStudentCourses[index]
                                                      .chapterTitle,
                                                  ChapterId: bloc
                                                      .allStudentCourses[index]
                                                      .chapterId,
                                                  owned: bloc
                                                      .allStudentCourses[index]
                                                      .own,
                                                ),
                                              ),
                                            );
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ForceUpdateScreen(),
                                              ),
                                            );
                                          }
                                          /*Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => CourseContentScreen(
                                                      courseId: bloc.allStudentCourses[index].chapterId,
                                                      courseName: bloc.allStudentCourses[index].chapterTitle,
                                                      own: widget.courseOwn,
                                                    )));*/
                                        },
                                        courseId: bloc
                                            .allStudentCourses[index].courseId,
                                        courseName: bloc
                                            .allStudentCourses[index]
                                            .chapterTitle,
                                        coursePhoto: bloc
                                            .allStudentCourses[index]
                                            .chapterPhoto,
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                );
              },
            ));
      },
    );
  }
}

class CourseWidget extends StatelessWidget {
  const CourseWidget(
      {Key? key,
      required this.coursePhoto,
      required this.courseId,
      required this.courseName,
      required this.onPress})
      : super(key: key);

  final String coursePhoto;
  final String courseId;
  final String courseName;
  final void Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ColorConstants.lightBlue, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 170,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(14)),
                    child: CachedNetworkImage(
                      imageUrl: coursePhoto,
                      fit: BoxFit.cover,
                      placeholder: (context, builder) {
                        return const SizedBox();
                      },
                      errorWidget: (context, builder, child) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      courseName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          fontFamily: FontConstants.poppins,
                          color: Colors.indigo,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
