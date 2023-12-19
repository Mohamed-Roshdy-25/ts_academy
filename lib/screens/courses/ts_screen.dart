import 'package:cached_network_image/cached_network_image.dart';
import '../../controller/about_us/about_us_cubit.dart';
import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '/controller/courses_Chapters/course_chapters_cubit.dart';
import '/controller/student_courses/student_course_cubit.dart';
import '/screens/courses/courses_screen.dart';
import '../../constants/color_constants.dart';
import '../../constants/constants.dart';
import '../../constants/font_constants.dart';
import '../../modules/modules.dart';

class TSScreen extends StatefulWidget {
  const TSScreen({Key? key, required this.sectionName, required this.subjectId, required this.chainId})
      : super(key: key);
  final String sectionName;
  final String subjectId;
  final String chainId;

  @override
  State<TSScreen> createState() => _TSScreenState();
}

class _TSScreenState extends State<TSScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      BlocProvider.of<StudentCourseCubit>(context).getAllStudentCourses(stuId!,widget.chainId );
    });
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   // DeviceOrientation.landscapeLeft,
    //   // DeviceOrientation.landscapeRight,
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StudentCourseCubit>(context);
    return Scaffold(
        // appBar: Modules().appBar(widget.sectionName),
        appBar: Modules().appBar('Ts Academy'),
        body: BlocConsumer<StudentCourseCubit, StudentCourseState>(
          listener: (context, state) {
            if (state is StudentCourseFailure) {
              Modules().toast(state.message,Colors.red);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(13),
              child: state is StudentCourseLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: ColorConstants.darkBlue,
                    ))
                  : bloc.allStudentCourses.isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Align(
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset('assets/lottie/nothing.json'),
                                  Text(tr(StringConstants
                                      .there_is_no_course_until_now))
                                ],
                              ),
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            BlocProvider.of<StudentCourseCubit>(context)
                                .getAllStudentCourses(stuId!,  widget.chainId);
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    // "Chapters",
                                    tr("tracks"),
                                    style: const TextStyle(
                                        fontFamily: FontConstants.poppins,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                ListView.builder(
                                  itemCount: bloc.allStudentCourses.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    print(bloc.allStudentCourses[index].courseId);
                                    return CourseWidget(
                                      courseId: bloc
                                          .allStudentCourses[index].courseId,
                                      courseName: bloc
                                          .allStudentCourses[index].courseName,
                                      coursePhoto: bloc
                                          .allStudentCourses[index].coursePhoto,
                                      own: bloc.allStudentCourses[index].own,
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
            );
          },
        ));
  }
}

class CourseWidget extends StatelessWidget {
  const CourseWidget(
      {Key? key,
      required this.coursePhoto,
      required this.courseId,
      required this.courseName,
      required this.own})
      : super(key: key);

  final String coursePhoto;
  final String courseId;
  final String courseName;
  final bool own;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            BlocProvider.of<CourseChaptersCubit>(context)
                .getAllStudentCourses(courseId);
            return CoursesScreen(
              sectionName: courseName,
              subjectId: courseId,
              courseOwn: own,
            );
          },
        ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              Container(
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
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14)),
                        child: CachedNetworkImage(
                          imageUrl: coursePhoto,
                          fit: BoxFit.cover,
                          placeholder: (context, builder) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: ColorConstants.darkBlue,
                              ),
                            );
                          },
                          errorWidget: (context, builder, child) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
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
            ],
          ),
        ),
      ),
    );
  }
}
