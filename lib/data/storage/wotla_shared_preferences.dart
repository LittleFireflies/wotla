import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wotla/data/models/user_records.dart';

class WotlaSharedPreferences {
  final Future<SharedPreferences> sharedPreferences;

  const WotlaSharedPreferences(this.sharedPreferences);

  static const String _userRecordsKey = 'user_records';

  Future<void> saveTodayRecord(UserRecords records) async {
    final prefs = await sharedPreferences;
    await prefs.setString(_userRecordsKey, json.encode(records.toJson()));
  }

  Future<UserRecords?> readUserRecords() async {
    final prefs = await sharedPreferences;
    final Map<String, dynamic> userJson =
        json.decode(prefs.getString(_userRecordsKey) ?? "{}");

    if (userJson.isEmpty) {
      return null;
    } else {
      return UserRecords.fromJson(userJson);
    }
  }
}
