import 'package:cached_network_image/cached_network_image.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/controller/chains/chain_cubit.dart';
import 'package:ts_academy/controller/chains/chain_states.dart';
import 'package:ts_academy/screens/courses/ts_screen.dart';
import 'package:ts_academy/screens/force_update_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controller/about_us/about_us_cubit.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../modules/modules.dart';

class ChainScreen extends StatefulWidget {
  const ChainScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChainScreen> createState() => _ChainScreenState();
}

class _ChainScreenState extends State<ChainScreen> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   // DeviceOrientation.landscapeLeft,
    //   // DeviceOrientation.landscapeRight,
    // ]);
    BlocProvider.of<ChainCubit>(context).getChains();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => BlocProvider.of<AbutUsCubit>(context).changeIndex(0),
      child: Scaffold(
          appBar: Modules().appBar(widget.title),
          body: BlocConsumer<ChainCubit, ChainStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(13),
                  child: state is GetChainsLoading
                      ? Center(
                          child: CircularProgressIndicator(
                          color: ColorConstants.darkBlue,
                        ))
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              ListView.builder(
                                itemCount: BlocProvider.of<ChainCubit>(context)
                                    .chains
                                    .length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ChainWidget(
                                    onPress: () {
                                      if (versionNumberFromAPI == "2") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TSScreen(
                                              chainId:
                                                  BlocProvider.of<ChainCubit>(
                                                          context)
                                                      .chains[index]
                                                      .chain_id,
                                              subjectId: "",
                                              sectionName: "",
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
                                    courseId:
                                        BlocProvider.of<ChainCubit>(context)
                                            .chains[index]
                                            .chain_id,
                                    courseName:
                                        BlocProvider.of<ChainCubit>(context)
                                            .chains[index]
                                            .chain_name,
                                    coursePhoto:
                                        BlocProvider.of<ChainCubit>(context)
                                            .chains[index]
                                            .photo,
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                );
              })),
    );
  }
}

class ChainWidget extends StatelessWidget {
  const ChainWidget(
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
