import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {

  String userIdKey = "USERKEY";
  String userTokenKey = 'USERTOKENKEY';
  String userNameKey = "USERNAMEKEY";
  String nameKey = "NAMEKEY";
  String notif1 = "NOTIF1";
  String notif2 = "NOTIF2";
  String notif3 = "NOTIF3";
  String userAddressKey = "USERADDRESSKEY";
  String userHeightKey = "USERHEIGHTKEY";
  String userStatusKey = "USERSTATUSKEY";
  String userGenderKey = "USERGenderKEY";
  String userCityKey = "USERCITYKEY";
  String userDobKey = "USERDOBKEY";
  String userLikesKey = "USERLIKESKEY";
  String userProfilePhoto = 'USERPROFILEPHOTO';
  String userPoints = 'USERPOINTS';
  String userVisitorsKey = 'USERVISITORSDATA';
  String userChatSeenDate = 'USERCHATSEENDATE';
  String userLikePointDate = 'USERLIKEPOINTDATE';
  String userVisitorPointDate = 'USERVISITORPOINTDATE';

  clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userTokenKey); await prefs.remove(userIdKey);
    await prefs.remove(userAddressKey); await prefs.remove(userHeightKey);
    await prefs.remove(userNameKey); await prefs.remove(userStatusKey);
    await prefs.remove(userCityKey);
    await prefs.remove(userDobKey); await prefs.remove(userProfilePhoto);
    await prefs.remove(userPoints); await prefs.remove(userChatSeenDate);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString(userNameKey).toString();
    return username;
  }

  Future<bool> saveName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(nameKey, getUserName);
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString(nameKey).toString();
    return username;
  }

  Future<bool> saveUserToken(String getUserToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userTokenKey, getUserToken);
  }

  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(userTokenKey).toString();
    return token;
  }

  Future<bool> saveUserId(String getUserToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserToken);
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(userIdKey).toString();
    return token;
  }

  Future<bool> saveNotification1(String getUserToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(notif1, getUserToken);
  }

  getNotification1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(notif1).toString();
    return token;
  }

  Future<bool> saveNotification2(String getUserToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(notif2, getUserToken);
  }

  getNotification2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(notif2).toString();
    return token;
  }

  Future<bool> saveNotification3(String getUserToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(notif3, getUserToken);
  }

  getNotification3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(notif3).toString();
    return token;
  }

  Future<bool> saveUserProfilePhoto(String getUserProfilePhoto) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfilePhoto, getUserProfilePhoto);
  }

  Future<bool> saveUserAddress(String getUserAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userAddressKey, getUserAddress);
  }

  Future<bool> saveUserStatus(String getUserStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userStatusKey, getUserStatus);
  }

  Future<bool> saveUserHeight(String getUserHeight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userHeightKey, getUserHeight);
  }

  Future<bool> saveUserDob(String getUserDob) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userDobKey, getUserDob);
  }

  Future<bool> saveUserCity(String getUserCity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userCityKey, getUserCity);
  }

  Future<bool> saveUserPoints(String getUserPoints) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPoints, getUserPoints);
  }

  Future<String> getUserPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPoint = prefs.getString(userPoints).toString();
    return userPoint;
  }

  Future<bool> saveUserLikes(String getUserLikesData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userLikesKey, getUserLikesData);
  }

  Future<String> getUserLikes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPoint = prefs.getString(userLikesKey).toString();
    return userPoint;
  }

  Future<bool> saveUserVisitors(String getUserVisitorsData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userVisitorsKey, getUserVisitorsData);
  }

  Future<String> getUserVisitors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPoint = prefs.getString(userVisitorsKey).toString();
    return userPoint;
  }

  Future<bool> saveUserGender(String getUserGenderData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userGenderKey, getUserGenderData);
  }

  Future<bool> saveUserChatSeenDate(String getUserChatSeenDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userChatSeenDate, getUserChatSeenDate);
  }

  Future<String> getUserChatSeenDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String chatSeenDate = prefs.getString(userChatSeenDate).toString();
    return chatSeenDate;
  }

  Future<bool> saveUserTodayLikePoints(String getUserChatSeenDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userLikePointDate, getUserChatSeenDate);
  }

  Future<String> getUserTodayLikePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String chatSeenDate = prefs.getString(userLikePointDate).toString();
    return chatSeenDate;
  }

  Future<bool> saveUserTodayVisitorPoints(String getUserChatSeenDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userVisitorPointDate, getUserChatSeenDate);
  }

  Future<String> getUserTodayVisitorPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String chatSeenDate = prefs.getString(userVisitorPointDate).toString();
    return chatSeenDate;
  }

  Future<String> getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String status = prefs.getString(userStatusKey).toString();
    return status;
  }

  Future<String> getUserGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String status = prefs.getString(userGenderKey).toString();
    return status;
  }

  Future<String> getUserProfilePhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profilePhoto = prefs.getString(userProfilePhoto).toString();
    return profilePhoto;
  }

  Future<String> getUserAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = prefs.getString(userAddressKey).toString();
    return address;
  }

  Future<String?> getUserHeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String height = prefs.getString(userHeightKey).toString();
    return height;
  }

  Future<String?> getUserCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString(userCityKey).toString();
    return city;
  }

  Future<String?> getUserDob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dob = prefs.getString(userDobKey).toString();
    return dob;
  }


}