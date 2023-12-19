import 'package:flutter/material.dart';

bool arabicLang = false;
List universitiesList = [];
List collegesList = [];
List classesList = [];
List tracksList = [];
List trackPosts = [];
// late UserModel userModel;
String? stuId;
String? versionNumberFromAPI;
bool simCardConstant = false;
String local = "en";
String? stuPhone;
String? stuPhoto;
String? deviceToken;
String? universityName;
String? stuBio;
String? agoraUserToken;
String? earphone_permission;
String? phone_jack;
String? simCard;
String? all_permission;

List subjectsList = [];
List myUniversitySubjects = [];
List myTsSubjects = [];
List otherSubjects = [];
List likedPosts = [];
List hidePosts = [];
String? myAccessToken, myName, myId;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

TextEditingController ttsIntervalTextEditingController =
    TextEditingController();
TextEditingController ttsTextEditingController = TextEditingController();
TextEditingController ttsSpeedTextEditingController = TextEditingController();
TextEditingController watermarkOpacityTextEditingController =
    TextEditingController();
TextEditingController maxSSTextEditingController = TextEditingController();
TextEditingController maxLoginTextEditingController = TextEditingController();
TextEditingController iOSVersionTextEditingController = TextEditingController();
TextEditingController androidVersionTextEditingController =
    TextEditingController();
TextEditingController forceUpdateMsgVersionTextEditingController =
    TextEditingController();

bool forceIos = false, forceAndroid = false;

// String? myAccessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjcyNDYzNzYzLCJpYXQiOjE2NzE4NTg5NjMsImp0aSI6ImQ4NDc3MWNjZDkxZjQ0Y2Y5OGI5MTJkY2NlYzc2ZmJmIiwidXNlcl9pZCI6Njh9.-YTYaYX6XBcbiQfyrpn5XxhqJVXOjbmKAEkOwUrGxsE";
