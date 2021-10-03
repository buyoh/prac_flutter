
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static AppStorage? _instance;
  static AppStorage getInstance() {
    if (_instance == null)
      _instance = AppStorage._();
    return _instance!;
  }
  AppStorage._();

  void store(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  Future<String?> load(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey(key) ? pref.getString(key) : null;
  }

  void eraseAll() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
