import 'package:equatable/equatable.dart';

class StudentTicket extends Equatable {
  final String ticketId;
  final String studentId;
  final String fullName;
  final String reason;
  final String issues;
  final String status;
  final String chatRoomId;
  final String data;

  const StudentTicket(
      {required this.ticketId,
      required this.studentId,
      required this.fullName,
      required this.reason,
      required this.issues,
      required this.status,
      required this.chatRoomId,
      required this.data});

  @override
  List<Object?> get props =>
      [ticketId, studentId, fullName, reason, issues, status, chatRoomId, data];

  factory StudentTicket.fromjson(Map<String, dynamic> json) => StudentTicket(
      ticketId: json['ticket_id'],
      studentId: json['student_id'],
      fullName: json['full_name'],
      reason: json['reason'],
      issues: json['issues'],
      status: json['status'],
      chatRoomId: json['chat_room_id'],
      data: json['date']);
}
