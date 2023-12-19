class SectionsModel {
  final String sectionId;
  final String sectionName;
  final String quizId;
  final String studentId;
  final String date;
  final String completeOrNot;
  SectionsModel(
      {required this.quizId,
      required this.date,
      required this.sectionId,
      required this.sectionName,
      required this.studentId,
      required this.completeOrNot});
  factory SectionsModel.fromJson(Map<String, dynamic> json) {
    return SectionsModel(
        date: json["date"],
        quizId: json["quiz_id"],
        sectionId: json["section_id"],
        sectionName: json["section_name"],
        studentId: json["student_id"],
        completeOrNot: json["complete_or_not"]);
  }
}
