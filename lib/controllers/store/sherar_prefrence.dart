import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  String storekye = "token";

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  Future<void> writeData(String token) async {
    final prefs = await _prefs;
    await prefs.setString(storekye, token);
  }

  Future<String?> readData() async {
    final prefs = await _prefs;
    return prefs.getString(storekye);
  }

  Future<void> deleteData() async {
    final prefs = await _prefs;
    await prefs.remove(storekye);
  }
}
