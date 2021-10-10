
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static AppStorage? _instance;
  static AppStorage get instance {
    if (_instance == null)
      _instance = AppStorage._();
    return _instance!;
  }
  AppStorage._();

  Future<void> store(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  Future<bool> containsKey(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey(key);
  }

  Future<String?> load(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey(key) ? pref.getString(key) : null;
  }

  Future<void> eraseAll() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  Future<String> dump() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, String> li = {};
    for (final key in pref.getKeys()) {
      final str = pref.getString(key);
      if (str != null) li[key] = str;
    }
    return json.encode(li);
  }
  Future<void> restoreFromDumped(String dumped) async {
    final listRaw = json.decode(dumped);
    for (final pair in listRaw.entries) {
      pair.key as String;
      pair.value as String;
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    for (final pair in listRaw.entries) {
      await pref.setString(pair.key, pair.value);
    }
  }
}
