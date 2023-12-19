import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '/controller/quizz/quizzes_cubit.dart';
import '/screens/quizzes/quiz_sections.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../constants/image_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/quizzes_model.dart';
import '../../modules/modules.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({Key? key, required this.courseId}) : super(key: key);
  final String courseId;
  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<QuizzesCubit>(context)
        .getALlQuizzes(courseId: widget.courseId);
  }

  final bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<QuizzesCubit>(context);

    return Scaffold(
      appBar: Modules().appBar(tr(StringConstants.quizzes)),
      body: BlocConsumer<QuizzesCubit, QuizzesState>(
        listener: (context, state) {
          if (state is QuizzesFailure) {
            Modules().toast(state.message,  Colors.red);
          } else if (state is DeleteQuizFailure) {
            Modules().toast(state.message,  Colors.red);

          } else if (state is DeleteQuiz) {
            Modules().toast(state.message,  Colors.red);

          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(13),
            child: state is QuizzesLoading
                ? Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.darkBlue,
                ))
                : bloc.completedQuizzesList.isEmpty && bloc.notCompleted.isEmpty
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
                          .there_is_no_quizzes_until_now))
                    ],
                  ),
                ),
              ),
            )
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  bloc.notCompleted.isEmpty
                      ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                            'assets/lottie/nothing.json'),
                        Text(tr(StringConstants
                            .there_is_no_quizzes_until_now))
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: bloc.notCompleted.length,
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CustomQuizCard(
                          model: bloc.notCompleted[index],
                          borderColor: ColorConstants.darkBlue,
                          btn: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                padding:
                                const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.indigo,
                                    borderRadius:
                                    BorderRadius.circular(
                                        5)),
                                child: Text(
                                    tr(StringConstants
                                        .continue_quiz),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11)),
                              )),
                          onPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        QuizSections(
                                          quizId: bloc
                                              .notCompleted[
                                          index]
                                              .quizId,
                                          quizImage: bloc
                                              .notCompleted[
                                          index]
                                              .quizPhoto,
                                          quizName: bloc
                                              .notCompleted[
                                          index]
                                              .quizTitle,
                                          quizQuestions: bloc
                                              .notCompleted[
                                          index]
                                              .numOfQuestions,
                                        )));
                          });
                    },
                  ),
                  Text(
                    StringConstants.previousScreen,
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  bloc.completedQuizzesList.isEmpty
                      ? Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                            ImagesConstants.emptyLottie),
                        Text(
                          tr(StringConstants
                              .no_previous_quizzes),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: bloc.completedQuizzesList.length,
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CustomQuizCard(
                          model:
                          bloc.completedQuizzesList[index],
                          borderColor: Colors.white,
                          // btn: IconButton(
                          //     onPressed: () {
                          //       bloc
                          //           .delete(
                          //               quizId: bloc
                          //                   .completedQuizzesList[
                          //                       index]
                          //                   .quizId)
                          //           .then((value) =>
                          //               bloc.getALlQuizzes(
                          //                   courseId: bloc
                          //                       .completedQuizzesList[
                          //                           index]
                          //                       .courseId));
                          //     },
                          //     icon: const Icon(
                          //         Icons.restore_from_trash),
                          //     color: Colors.red),
                          btn: SizedBox(),
                          onPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        QuizSections(
                                          quizId: bloc
                                              .completedQuizzesList[
                                          index]
                                              .quizId,
                                          quizImage: bloc
                                              .completedQuizzesList[
                                          index]
                                              .quizPhoto,
                                          quizName: bloc
                                              .completedQuizzesList[
                                          index]
                                              .quizTitle,
                                          quizQuestions: bloc
                                              .completedQuizzesList[
                                          index]
                                              .numOfQuestions,
                                        )));
                          });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomQuizCard extends StatelessWidget {
  const CustomQuizCard({
    Key? key,
    required this.borderColor,
    required this.model,
    required this.btn,
    this.onPress,
  }) : super(key: key);

  final Color borderColor;
  final QuizzModel model;
  final Widget btn;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(7),
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: model.quizPhoto,
                    fit: BoxFit.cover,
                    placeholder: (context, builder) {
                      return const SizedBox();
                    },
                    errorWidget: (context, builder, child) {
                      return const SizedBox();
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.quizTitle,
                          style: const TextStyle(
                              fontFamily: FontConstants.poppins,
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
                              " ${model.numOfQuestions} ${tr(StringConstants.question)} ",
                              style: TextStyle(
                                  fontFamily: FontConstants.poppins,
                                  fontSize: 14,
                                  color: Colors.grey[500]),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      Text('${tr(StringConstants.quiz)}# ${model.quizId}',
                          style: const TextStyle(
                            fontFamily: FontConstants.poppins,
                            fontSize: 14,
                          )),
                      const SizedBox(height: 10),
                      btn
                    ],
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
