import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String userLoggedInkey = "USERLOGGEDINKEY";
  static String userLoggedInEmail = "USERLOGGEDINEMAIL";

  static saveUserLoggedInDetails({
    @required bool isLoggedin,
    @required String email,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(userLoggedInkey, isLoggedin);
    prefs.setString(userLoggedInEmail, email);
  }

  static Future<bool> getUserLoggedInDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(userLoggedInkey);
    } catch (err) {
      return false;
    }
  }

  static Future<String> getLoggedEmail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString(userLoggedInEmail);
      return email;
    } catch (err) {
      return null;
    }
  }

  static clearStorage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (err) {}
  }
}
