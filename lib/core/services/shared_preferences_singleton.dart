import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSingleton {
  static late SharedPreferences _instance;

  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  static setBool(String key, bool value) async {
    await _instance.setBool(key, value);
  }

  static getBool(String key) {
    return _instance.getBool(key) ?? false;
  }

  static setString(String key, String value) async {
    await _instance.setString(key, value);
  }

  static getString(String key) {
    return _instance.getString(key) ?? "";
  }

  static deleteKey(String key) async {
    if (_instance.containsKey(key)) {
      await _instance.remove(key);
      log('$key has been deleted');
    } else {
      log('No value found for $key');
    }
  }
}
