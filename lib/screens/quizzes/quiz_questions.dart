import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '/animations/dialog_animation.dart';
import '/constants/color_constants.dart';
import '/constants/string_constants.dart';
import '/controller/questuons_for_each_section/question_for_each_section_cubit.dart';
import '/controller/questuons_for_each_section/question_for_each_section_states.dart';
import '/controller/sections/sections_cubit.dart';
import '/controller/sections/sections_states.dart';
import '/models/question_answer_model.dart';
import '/modules/elevated_button.dart';

import '../../constants/font_constants.dart';
import '../../modules/modules.dart';

class QuizQuestions extends StatefulWidget {
  const QuizQuestions(
      {Key? key,
      required this.sectionName,
      required this.sectionId,
      required this.quizId,
      required this.indexOfSection})
      : super(key: key);
  final String sectionName;
  final String sectionId;
  final String quizId;
  final int indexOfSection;
  @override
  _QuizQuestionsState createState() => _QuizQuestionsState();
}

class _QuizQuestionsState extends State<QuizQuestions> {
  bool isSubmit = false;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<QuestionAndAnswerCubit>(context).setCountZero();
    BlocProvider.of<QuestionAndAnswerCubit>(context).setCheckAnswerEqualZero();
    BlocProvider.of<QuestionAndAnswerCubit>(context)
        .getQuestionsAndAnswer(sectionId: widget.sectionId);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<QuestionAndAnswerCubit>(context);
    return Scaffold(
      appBar: Modules().appBar(widget.sectionName.toString()),
      body: BlocConsumer<QuestionAndAnswerCubit, QuestionAndAnswerStates>(
          listener: (ctx, state) {
        if (state is QuestionAndAnswerFailure) {
          Modules().toast(state.message, Colors.red);

        } else if (state is StoreAnswersForStudentSuccess) {
          Modules().toast(state.message, Colors.green);

        } else if (state is StoreAnswersForStudentFailure) {
          Modules().toast(state.message, Colors.red);
          ;
        }
      }, builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              ListView.builder(
                itemCount: bloc.questionsAndAnswer.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return QuizQuestionWidget(
                    completeOrNot: BlocProvider.of<SectionsCubit>(context)
                        .sections[widget.indexOfSection]
                        .completeOrNot,
                    questionAndAnswer: bloc.questionsAndAnswer[index],
                    isSumbit: isSubmit,
                  );
                },
              ),
              SizedBox(height: 15.h),
              state is StoreAnswersForStudentLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: ColorConstants.darkBlue,
                    ))
                  : state is QuestionAndAnswerLoading ||
                          state is QuestionAndAnswerFailure ||
                          bloc.questionsAndAnswer.isEmpty
                      ? const SizedBox()
                      : BlocProvider.of<SectionsCubit>(context)
                                  .sections[widget.indexOfSection]
                                  .completeOrNot ==
                              "completed"
                          // ||
                          // BlocProvider.of<QuestionAndAnswerCubit>(context).checkAnswer== true

                          ? ElevatedButtonWidget(
                              buttonText: tr(StringConstants.back),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                          : bloc.counterOfAnswers ==
                                      bloc.questionsAndAnswer.length &&
                                  isSubmit == false
                              ? ElevatedButtonWidget(
                                  buttonText: StringConstants.submit,
                                  onPressed: () {
                                    setState(() {
                                      isSubmit = true;
                                    });
                                    //
                                    debugPrint(
                                        "section id : ${widget.sectionId}");
                                    debugPrint(
                                        "score value : ${bloc.scoreValue}");
                                    debugPrint(
                                        "total value : ${bloc.questionsAndAnswer.length}");

                                    BlocProvider.of<QuestionAndAnswerCubit>(
                                            context)
                                        .storeSectionScoreForEachStudent(
                                            studentScore:
                                                bloc.scoreValue.toString(),
                                            totalDegree: bloc
                                                .questionsAndAnswer.length
                                                .toString(),
                                            sectionId: widget.sectionId)
                                        .then((value) {
                                      BlocProvider.of<QuestionAndAnswerCubit>(
                                              context)
                                          .changeCheckAnswerToTrue();

                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AnimatedDialog(
                                              child: Padding(
                                                padding: EdgeInsets.all(20.0.h),
                                                child: state
                                                            is StoreAnswersForStudentLoading ||
                                                        state
                                                            is GetSectionsLoading
                                                    ? const CircularProgressIndicator()
                                                    : SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          // mainAxisAlignment:
                                                          //     MainAxisAlignment
                                                          //         .center,
                                                          children: [
                                                            Text(
                                                              "${bloc.scoreValue}/${bloc.questionsAndAnswer.length}",
                                                              style: TextStyle(
                                                                  color: ColorConstants
                                                                      .darkBlue,
                                                                  fontSize: 20),
                                                            ),
                                                            SizedBox(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      // mainAxisAlignment:
                                                                      //     MainAxisAlignment
                                                                      //         .center,
                                                                      // crossAxisAlignment:
                                                                      //     CrossAxisAlignment
                                                                      //         .stretch,
                                                                      children: [
                                                                        AttendanceDaysWidget(
                                                                          txt: tr(
                                                                              StringConstants.total_degree),
                                                                          isGreen:
                                                                              true,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              MediaQuery.of(context).size.width * 0.04,
                                                                        ),
                                                                        AttendanceDaysWidget(
                                                                            txt:
                                                                                tr(StringConstants.score_value),
                                                                            isGreen: false),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: SfRadialGauge(
                                                                        // backgroundColor: Colors.black,
                                                                        axes: [
                                                                          RadialAxis(
                                                                            minimum:
                                                                                0,
                                                                            maximum:
                                                                                BlocProvider.of<QuestionAndAnswerCubit>(context).questionsAndAnswer.length.toDouble(),
                                                                            showLabels:
                                                                                false,
                                                                            showTicks:
                                                                                false,
                                                                            startAngle:
                                                                                0,
                                                                            endAngle:
                                                                                360,
                                                                            axisLineStyle:
                                                                                const AxisLineStyle(
                                                                              thickness: 0.0,
                                                                              color: Colors.transparent,
                                                                              thicknessUnit: GaugeSizeUnit.logicalPixel,
                                                                            ),
                                                                            pointers: <GaugePointer>[
                                                                              RangePointer(
                                                                                color: Colors.red,
                                                                                value: BlocProvider.of<QuestionAndAnswerCubit>(context).questionsAndAnswer.length.toDouble(),
                                                                                width: 0.95,
                                                                                pointerOffset: 0.05,
                                                                                sizeUnit: GaugeSizeUnit.factor,
                                                                              )
                                                                            ],
                                                                          ),
                                                                          RadialAxis(
                                                                            minimum:
                                                                                0,
                                                                            maximum:
                                                                                BlocProvider.of<QuestionAndAnswerCubit>(context).questionsAndAnswer.length.toDouble(),
                                                                            showLabels:
                                                                                false,
                                                                            showTicks:
                                                                                false,
                                                                            startAngle:
                                                                                0,
                                                                            endAngle:
                                                                                360,
                                                                            axisLineStyle:
                                                                                const AxisLineStyle(
                                                                              thickness: 0.0,
                                                                              color: Colors.transparent,
                                                                              thicknessUnit: GaugeSizeUnit.logicalPixel,
                                                                            ),
                                                                            pointers: <GaugePointer>[
                                                                              RangePointer(
                                                                                color: ColorConstants.darkBlue,
                                                                                value: bloc.scoreValue.toDouble(),
                                                                                width: 0.95,
                                                                                pointerOffset: 0.05,
                                                                                sizeUnit: GaugeSizeUnit.factor,
                                                                              )
                                                                            ],
                                                                          )
                                                                          // 1
                                                                          // 7
                                                                        ]),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                     Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          4),
                                                                  child: Text(
                                                                     tr(StringConstants.back)),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                            );
                                          });
                                    });

                                    // BlocProvider.of<SectionsCubit>(context).getSectionsForSpecificQuiz(quizId: widget.quizId).then((value) {
                                    //
                                    // });
                                  })
                              :isSubmit == false? Container(
                                  alignment: AlignmentDirectional.center,
                                  child: Text(
                                    tr(StringConstants
                                        .just_complete_the_questions),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ):Container(
                alignment: AlignmentDirectional.center,
                child: Text(
                  tr(StringConstants
                      .the_questions_are_completed),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class QuizQuestionWidget extends StatefulWidget {
  const QuizQuestionWidget(
      {Key? key,
      required this.questionAndAnswer,
      required this.completeOrNot,
      required this.isSumbit})
      : super(key: key);
  final QuestionAndAnswer questionAndAnswer;
  final String completeOrNot;
  final bool isSumbit;

  @override
  _QuizQuestionWidgetState createState() => _QuizQuestionWidgetState();
}

class _QuizQuestionWidgetState extends State<QuizQuestionWidget> {
  int? selectedAnswer, trueAnswer;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    trueAnswer = widget.questionAndAnswer.questionAns
        .indexOf(widget.questionAndAnswer.qusTrueAns);
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          width: size.width,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.questionAndAnswer.questionTitle,
                style: TextStyle(
                    fontFamily: FontConstants.poppins,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 20.h),
              ...widget.questionAndAnswer.questionAns.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        if (widget.isSumbit) {
                          return;
                        } else {
                          if (selectedAnswer == null) {
                            BlocProvider.of<QuestionAndAnswerCubit>(context)
                                .counterPlus();
                          }

                          setState(() => selectedAnswer =
                              widget.questionAndAnswer.questionAns.indexOf(e));

                          if (selectedAnswer == trueAnswer &&
                              BlocProvider.of<QuestionAndAnswerCubit>(context)
                                      .counterOfAnswers >
                                  BlocProvider.of<QuestionAndAnswerCubit>(
                                          context)
                                      .scoreValue) {
                            BlocProvider.of<QuestionAndAnswerCubit>(context)
                                .plusScore();
                          } else {
                            if (selectedAnswer != trueAnswer &&
                                BlocProvider.of<QuestionAndAnswerCubit>(context)
                                        .counterOfAnswers <=
                                    BlocProvider.of<QuestionAndAnswerCubit>(
                                            context)
                                        .scoreValue) {
                              BlocProvider.of<QuestionAndAnswerCubit>(context)
                                  .minusScore();
                            }
                          }
                        }
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: selectedAnswer ==
                                    widget.questionAndAnswer.questionAns
                                        .indexOf(e)
                                ? Colors.indigo
                                : Colors.grey[400],
                            child: const Text("A",
                                style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(width: 10.w),
                          SizedBox(
                            width: size.width / 1.5,
                            child: Text(
                              e,
                              style: TextStyle(
                                  color: selectedAnswer ==
                                          widget.questionAndAnswer.questionAns
                                              .indexOf(e)
                                      ? Colors.indigo
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: FontConstants.poppins,
                                  fontSize: 15.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              // ListView.builder(
              //   physics: const NeverScrollableScrollPhysics(),
              //     itemCount: widget.questionAndAnswer.questionAns.length,
              //     itemBuilder: (ctx, index) {
              //   return         Padding(
              //     padding: const EdgeInsets.only(bottom: 10),
              //     child: GestureDetector(
              //       onTap: (){
              //         setState(()=> selectedAnswer = 0);
              //       },
              //       child: Row(
              //         children: [
              //           CircleAvatar(
              //             backgroundColor: selectedAnswer == 0 ? Colors.indigo : Colors.grey[400],
              //             child: const Text("A", style: TextStyle(color: Colors.white)),
              //           ),
              //           const SizedBox(width: 10),
              //           SizedBox(
              //             width: size.width / 1.5,
              //             child: Text("Meaning of UI/UX Design?", style: TextStyle(
              //                 color: selectedAnswer == 0 ? Colors.indigo : Colors.black,
              //                 fontWeight: FontWeight.w600,
              //                 fontFamily: FontConstants.poppins, fontSize: 15),),
              //           ),
              //         ],
              //       ),
              //     ),
              //   )     ;
              // }),

              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10),
              //   child: GestureDetector(
              //     onTap: (){
              //       setState(()=> selectedAnswer = 1);
              //     },
              //     child: Row(
              //       children: [
              //         CircleAvatar(
              //           backgroundColor: selectedAnswer == 1 ? Colors.indigo : Colors.grey[400],
              //           child: const Text("B", style: TextStyle(color: Colors.white)),
              //         ),
              //         const SizedBox(width: 10),
              //         SizedBox(
              //           width: size.width / 1.5,
              //           child: Text("Meaning of UI/UX Design?", style: TextStyle(
              //               color: selectedAnswer == 1 ? Colors.indigo : Colors.black,
              //               fontWeight: FontWeight.w600,
              //               fontFamily: FontConstants.poppins, fontSize: 15),),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10),
              //   child: GestureDetector(
              //     onTap: (){
              //       setState(()=> selectedAnswer = 2);
              //     },
              //     child: Row(
              //       children: [
              //         CircleAvatar(
              //           backgroundColor: selectedAnswer == 2 ? Colors.indigo : Colors.grey[400],
              //           child: const Text("C", style: TextStyle(color: Colors.white)),
              //         ),
              //         const SizedBox(width: 10),
              //         SizedBox(
              //           width: size.width / 1.5,
              //           child: Text("Meaning of UI/UX Design?", style: TextStyle(
              //               color: selectedAnswer == 2 ? Colors.indigo : Colors.black,
              //               fontWeight: FontWeight.w600,
              //               fontFamily: FontConstants.poppins, fontSize: 15),),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10),
              //   child: GestureDetector(
              //     onTap: (){
              //       setState(()=> selectedAnswer = 3);
              //     },
              //     child: Row(
              //       children: [
              //         CircleAvatar(
              //           backgroundColor: selectedAnswer == 3 ? Colors.indigo : Colors.grey[400],
              //           child: const Text("D", style: TextStyle(color: Colors.white)),
              //         ),
              //         const SizedBox(width: 10),
              //         SizedBox(
              //           width: size.width / 1.5,
              //           child: Text("Meaning of UI/UX Design?", style: TextStyle(
              //               color: selectedAnswer == 3 ? Colors.indigo : Colors.black,
              //               fontWeight: FontWeight.w600,
              //               fontFamily: FontConstants.poppins, fontSize: 15),),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              ,
              widget.completeOrNot == "completed" ||
                      BlocProvider.of<QuestionAndAnswerCubit>(context)
                          .checkAnswer
                  ? GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.w),
                                    topLeft: Radius.circular(15.w))),
                            builder: (context) {
                              return ModelSheetCustomQuestionsAndAnswer(
                                  questionAndAnswer: widget.questionAndAnswer,
                                  trueAnswer: widget
                                      .questionAndAnswer.questionAns
                                      .indexOf(
                                          widget.questionAndAnswer.qusTrueAns),
                                  selectedAnswer: selectedAnswer);
                            });
                      },
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          StringConstants.checkAnswer,
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontFamily: FontConstants.poppins,
                              fontSize: 15),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class ModelSheetCustomQuestionsAndAnswer extends StatelessWidget {
  const ModelSheetCustomQuestionsAndAnswer(
      {Key? key,
      required this.questionAndAnswer,
      required this.trueAnswer,
      required this.selectedAnswer})
      : super(key: key);

  final QuestionAndAnswer questionAndAnswer;
  final int trueAnswer;
  final int? selectedAnswer;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.all(25.h),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Column(
            children: [
              Container(
                width: 100.w,
                height: 3.h,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(height: 25.h),
              Text(
                tr(StringConstants.check_answer),
                style: const TextStyle(
                    fontFamily: FontConstants.poppins,
                    color: Colors.indigo,
                    fontSize: 17,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 30.h),
              Text(
                questionAndAnswer.questionTitle,
                style: const TextStyle(
                    fontFamily: FontConstants.poppins,
                    fontSize: 15,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 20.h),
              ...questionAndAnswer.questionAns.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: trueAnswer ==
                                    questionAndAnswer.questionAns.indexOf(e) &&
                                selectedAnswer !=
                                    questionAndAnswer.questionAns.indexOf(e)
                            ? Colors.green
                            : trueAnswer !=
                                        questionAndAnswer.questionAns
                                            .indexOf(e) &&
                                    selectedAnswer ==
                                        questionAndAnswer.questionAns.indexOf(e)
                                ? Colors.red
                                : trueAnswer !=
                                            questionAndAnswer.questionAns
                                                .indexOf(e) &&
                                        selectedAnswer ==
                                            questionAndAnswer.questionAns
                                                .indexOf(e)
                                    ? Colors.red
                                    : trueAnswer ==
                                                questionAndAnswer.questionAns
                                                    .indexOf(e) &&
                                            selectedAnswer ==
                                                questionAndAnswer.questionAns
                                                    .indexOf(e)
                                        ? Colors.green
                                        : Colors.grey[400],
                        child: const Text("A",
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Text(
                          e,
                          style: TextStyle(
                              color: trueAnswer ==
                                          questionAndAnswer.questionAns
                                              .indexOf(e) &&
                                      selectedAnswer !=
                                          questionAndAnswer.questionAns
                                              .indexOf(e)
                                  ? Colors.green
                                  : trueAnswer !=
                                              questionAndAnswer.questionAns
                                                  .indexOf(e) &&
                                          selectedAnswer ==
                                              questionAndAnswer.questionAns
                                                  .indexOf(e)
                                      ? Colors.red
                                      : trueAnswer ==
                                                  questionAndAnswer.questionAns
                                                      .indexOf(e) &&
                                              selectedAnswer ==
                                                  questionAndAnswer.questionAns
                                                      .indexOf(e)
                                          ? Colors.green
                                          : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: FontConstants.poppins,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  selectedAnswer == null
                      ? ""
                      : trueAnswer == selectedAnswer
                          ? StringConstants.correctAnswer
                          : StringConstants.wrongAnswer,
                  style: TextStyle(
                      color: trueAnswer == selectedAnswer
                          ? Colors.green
                          : Colors.red,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              )

              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10),
              //   child: Row(
              //     children: [
              //       CircleAvatar(
              //         backgroundColor: trueAnswer == 1 && selectedAnswer != 1 ? Colors.green
              //             : trueAnswer != 1 && selectedAnswer == 1 ? Colors.red
              //             : trueAnswer == 1 && selectedAnswer == 1 ? Colors.green
              //             : Colors.grey[400],
              //         child: const Text("B", style: TextStyle(color: Colors.white)),
              //       ),
              //       const SizedBox(width: 10),
              //       SizedBox(
              //         width: size.width / 1.5,
              //         child: Text("Meaning of UI/UX Design?", style: TextStyle(
              //             color: trueAnswer == 1 && selectedAnswer != 1 ? Colors.green
              //                 : trueAnswer != 1 && selectedAnswer == 1 ? Colors.red
              //                 : trueAnswer == 1 && selectedAnswer == 1 ? Colors.green
              //                 : Colors.black,
              //             fontWeight: FontWeight.w600,
              //             fontFamily: FontConstants.poppins, fontSize: 15),),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10),
              //   child: Row(
              //     children: [
              //       CircleAvatar(
              //         backgroundColor: trueAnswer == 2 && selectedAnswer != 2 ? Colors.green
              //             : trueAnswer != 2 && selectedAnswer == 2 ? Colors.red
              //             : trueAnswer == 2 && selectedAnswer == 2 ? Colors.green
              //             : Colors.grey[400],
              //         child: const Text("C", style: TextStyle(color: Colors.white)),
              //       ),
              //       const SizedBox(width: 10),
              //       SizedBox(
              //         width: size.width / 1.5,
              //         child: Text("Meaning of UI/UX Design?", style: TextStyle(
              //             color: trueAnswer == 2 && selectedAnswer != 2 ? Colors.green
              //                 : trueAnswer != 2 && selectedAnswer == 2 ? Colors.red
              //                 : trueAnswer == 2 && selectedAnswer == 2 ? Colors.green
              //                 : Colors.black,
              //             fontWeight: FontWeight.w600,
              //             fontFamily: FontConstants.poppins, fontSize: 15),),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10),
              //   child: Row(
              //     children: [
              //       CircleAvatar(
              //         backgroundColor: trueAnswer == 3 && selectedAnswer != 3 ? Colors.green
              //             : trueAnswer != 3 && selectedAnswer == 3 ? Colors.red
              //             : trueAnswer == 3 && selectedAnswer == 3 ? Colors.green
              //             : Colors.grey[400],
              //         child: const Text("D", style: TextStyle(color: Colors.white)),
              //       ),
              //       const SizedBox(width: 10),
              //       SizedBox(
              //         width: size.width / 1.5,
              //         child: Text("Meaning of UI/UX Design?", style: TextStyle(
              //             color: trueAnswer == 3 && selectedAnswer != 3 ? Colors.green
              //                 : trueAnswer != 3 && selectedAnswer == 3 ? Colors.red
              //                 : trueAnswer == 3 && selectedAnswer == 3 ? Colors.green
              //                 : Colors.black,
              //             fontWeight: FontWeight.w600,
              //             fontFamily: FontConstants.poppins, fontSize: 15),),
              //       ),
              //     ],
              //   ),
              // ),
              ,
              SizedBox(height: 40.h),
            ],
          ),
        )
      ],
    );
  }
}

class AttendanceDaysWidget extends StatelessWidget {
  const AttendanceDaysWidget(
      {Key? key, required this.txt, required this.isGreen})
      : super(key: key);

  final bool isGreen;

  final String txt;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: MediaQuery.of(context).size.width * 0.018,
          backgroundColor: isGreen ? Colors.red : ColorConstants.darkBlue,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: Text(
              txt,
              maxLines: 1,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
