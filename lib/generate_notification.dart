import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class Notification {
  var serverKey = "";

// Replace with server token from firebase console settings.
  final String serverToken =
      'AAAAPN985Vs:APA91bGdUANifMTWZYgMcbL5XWisqzCEiS0jC_zI93VshfFrZuLtB0Hz1vBiJxX1be04mAld7wdMi-skkMtFJmNr1o7fdbgQfhnAGSBqFlCzz461f8rfB3056xEnRl4sfkhQ0bONX5QA';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> sendAndRetrieveMessage(
      {required String title, required String body}) async {
    await firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: false,
    );

    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body.toString(),
            'title': title.toString()
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done'
          },
          // 'to': await firebaseMessaging.getToken(),
          'to': '/topics/TsAcademy',
        },
      ),
    );
  }
}
