import 'package:shared_preferences/shared_preferences.dart';

Future saveLoginStatus(String pictureUrl, String displayName, String email) async {

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("isLoggin", true);
  prefs.setString("picture", pictureUrl);
  prefs.setString("displayName", displayName); 
  prefs.setString("email", email);
}


Future<bool> isLoggin() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("isLoggin") ?? false;
}

Future<String?> getPictureUrl() async {

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? pictureUrl = prefs.getString("picture");
  return pictureUrl;
}
Future<String?> getDisplayName() async {

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? displayName = prefs.getString("displayName");
  return displayName;
}

Future<String?> getEmail() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString("email");
  return email;
}

Future clearLoginInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}
