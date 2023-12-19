import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable{
  final String notificationId;
  final String notificationTitle;
  final String notificationBody;

const  NotificationModel(
    {required this.notificationId,required this.notificationTitle,required this.notificationBody});

  @override
  List<Object?> get props => [notificationId,notificationTitle,notificationBody];
  factory NotificationModel.fromjson(Map<String,dynamic>json)=>NotificationModel(notificationId: json['notification_id'], notificationTitle: json['notification_title'], notificationBody: json['notification_body']);

}