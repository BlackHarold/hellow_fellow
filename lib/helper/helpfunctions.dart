import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String _sharedPreferenceUserLoggedInKey = "IS_LOGGED_IN";
  static String _sharedPreferenceUserNameKey = "USER_NAME_KEY";
  static String _sharedPreferenceUserEmailKey = "USER_EMAIL_KEY";

  static Future<void> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    print('set isUserLoggedIn: ${isUserLoggedIn}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(
        _sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  ///setting data to SharedPreference
  static Future<void> saveUserNameSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_sharedPreferenceUserNameKey, userName);
  }

  static Future<void> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_sharedPreferenceUserEmailKey, userEmail);
  }

  ///getting data from SharedPreference
  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sharedPreferenceUserNameKey);
  }

  static Future<String> getEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sharedPreferenceUserEmailKey);
  }
}