import 'package:equatable/equatable.dart';

class LiveSessionModel extends Equatable{

  final String liveSessionId;
  final String courseId;
  final String date;
  final String doctorId;
  final String status;
  final String liveTitle;
  final String courseName;

  const LiveSessionModel(
      {required this.liveSessionId,required
      this.courseId,required
      this.date,required
      this.doctorId,required
      this.status,required
      this.liveTitle,required
      this.courseName});
   factory LiveSessionModel.fromJson(Map<String,dynamic>json){
     return LiveSessionModel(liveSessionId: json["live_session_id"], courseId: json["course_id"], date: json["meeting_room_id"], doctorId: json['doctor_id'], status: json['status'], liveTitle: json["live_session_title"], courseName: json["course_name"]);
   }
  @override
  // TODO: implement props
  List<Object?> get props => [
     liveSessionId,
    courseId,
    date,
    doctorId,
    status,
    liveTitle,
    courseName
  ];

}
