class QuestionAndAnswer {
  final String questionId;
  final String sectionId;
  final String studentId;
  final String quizId;
  final List<String> questionAns;
  final String questionTitle;
  final String qusTrueAns;

  QuestionAndAnswer(
      {required this.quizId,
      required this.studentId,
      required this.sectionId,
      required this.questionAns,
      required this.questionId,
      required this.questionTitle,
      required this.qusTrueAns});

  factory QuestionAndAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAndAnswer(
        quizId: json["quiz_id"],
        studentId: json["student_id"],
        sectionId: json["section_id"],
        questionAns: List<String>.from(json["question_ans"]),
        questionId: json["question_id"],
        questionTitle: json["question_txt"],
        qusTrueAns: json["qus_true_ans"]);
  }
}
