import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/constants/string_constants.dart';
import '/controller/sections/sections_states.dart';
import '/screens/quizzes/quiz_questions.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../controller/sections/sections_cubit.dart';
import '../../modules/modules.dart';

class QuizSections extends StatefulWidget {
  const QuizSections(
      {Key? key,
      required this.quizId,
      required this.quizName,
      required this.quizImage,
      required this.quizQuestions})
      : super(key: key);
  final String quizName;
  final String quizQuestions;
  final String quizId;
  final String quizImage;

  @override
  State<QuizSections> createState() => _QuizSectionsState();
}

class _QuizSectionsState extends State<QuizSections> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      BlocProvider.of<SectionsCubit>(context)
          .getSectionsForSpecificQuiz(quizId: widget.quizId);
    });
    debugPrint("Hello Sections");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Modules().appBar(widget.quizName.toString()),
      body: BlocConsumer<SectionsCubit, SectionsStates>(
          listener: (ctx, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(13),
              child: state is GetSectionsLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: ColorConstants.darkBlue,
                    ))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Material(
                              elevation: 3,
                              borderRadius: BorderRadius.circular(7),
                              child: Container(
                                width: size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      color: ColorConstants.lightBlue,
                                      width: 1),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 90.h,
                                      width: 90.w,
                                      child: CachedNetworkImage(
                                          imageUrl: widget.quizImage.toString(),
                                          placeholder: (ctx, s) {
                                            return const SizedBox();
                                          },
                                          errorWidget: (c, s, d) {
                                            return const Icon(Icons.error);
                                          },
                                          fit: BoxFit.cover),
                                    ),
                                    SizedBox(
                                      width: 12.w,
                                    ),
                                    SizedBox(
                                      width: size.width / 2.5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.quizName.toString(),
                                            style: const TextStyle(
                                                fontFamily:
                                                    FontConstants.poppins,
                                                color: Colors.indigo,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.note_outlined,
                                                size: 17,
                                                color: Colors.grey[500],
                                              ),
                                              Text(
                                                '${widget.quizQuestions.toString()} ${tr(StringConstants.questions)}',
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontConstants.poppins,
                                                    fontSize: 14,
                                                    color: Colors.grey[500]),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        '${tr(StringConstants.quiz)}# ${widget.quizId.toString()}',
                                        style: TextStyle(
                                          fontFamily: FontConstants.poppins,
                                          fontSize: 14.sp,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: Text(
                              StringConstants.quizSections,
                              style: TextStyle(
                                fontFamily: FontConstants.poppins,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ListViewForSections(quizId: widget.quizId)
                        ],
                      ),
                    ),
            );
          }),
    );
  }
}

class ListViewForSections extends StatelessWidget {
  const ListViewForSections({Key? key, required this.quizId}) : super(key: key);

  final String quizId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.of<SectionsCubit>(context).sections.isEmpty
        ?  Center(child: Text(tr(StringConstants.no_sections)))
        : ListView.builder(
            itemCount: BlocProvider.of<SectionsCubit>(context).sections.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final sections = BlocProvider.of<SectionsCubit>(context).sections;
              if (sections.isEmpty) {
                return  Text(tr(StringConstants.no_sections));
              }
              if (index >= 0 && index < sections.length) {
                final section = sections[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuizQuestions(
                                  indexOfSection: index,
                                  quizId: quizId,
                                  // completeOrNot:BlocProvider.of<SectionsCubit>(context).sections[index].completeOrNot ,
                                  sectionId: section.sectionId,
                                  sectionName: section.sectionName,
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              BlocProvider.of<SectionsCubit>(context)
                                  .sections[index]
                                  .sectionName,
                              style: const TextStyle(
                                  fontFamily: FontConstants.poppins,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900),
                            ),
                            const Spacer(),
                            BlocProvider.of<SectionsCubit>(context)
                                        .sections[index]
                                        .completeOrNot ==
                                    "completed"
                                ? Text(
                                    BlocProvider.of<SectionsCubit>(context)
                                        .sections[index]
                                        .completeOrNot,
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const SizedBox(),
                            SizedBox(
                              width: 10.w,
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 17)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          );
  }
}
