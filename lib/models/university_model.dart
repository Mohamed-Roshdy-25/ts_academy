class UniversityModel {
  final String universityId;
  final String universityName;
  final String hide;
  final String collegeName;
  UniversityModel(
      {required this.universityId,
      required this.collegeName,
      required this.hide,
      required this.universityName});
  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    return UniversityModel(
        universityId: json["university_id"],
        hide: json["hide"],
        universityName: json["university_name"],
        collegeName: json['college_name']);
  }
}
