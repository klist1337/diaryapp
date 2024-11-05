import 'package:diaryapp/helpers/constants.dart';
import 'package:flutter/material.dart';
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

 Icon? getIconByFeeling(String feeling) {
     for (var feel in feelings) {
      if (feel["feeling"] == feeling) {
        return feel["icon"];
      }
     }
     return null;
  }

getDay(String date) {
    final String dateDays = date.split(' ')[0];
    return dateDays.split('-')[2];
  }
  getYear(String date) {
    final String dateDays = date.split(' ')[0];
    return dateDays.split('-')[0];
  }

  getMonth(String date) {
    List<String> month =  ["January", "February", "March", "April", "May", "June", "July",
                            "August", "September", "October", "November", "December"];
    final monthNumber = int.parse(date.split('-')[1]);
    return month[monthNumber - 1];
  }