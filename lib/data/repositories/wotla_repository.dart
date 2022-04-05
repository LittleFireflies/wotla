import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wotla/data/models/user_record.dart';

class WotlaSharedPreferences {
  void saveTodayRecord(UserRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_records', json.encode(record.toJson()));
  }

  Future<UserRecord?> readUserRecord() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> userJson =
        json.decode(prefs.getString('user_records') ?? "{}");

    if (userJson.isEmpty) {
      return null;
    } else {
      return UserRecord.fromJson(userJson);
    }
  }
}

class WotlaRepository {
  final WotlaSharedPreferences sharedPreferences;

  const WotlaRepository(this.sharedPreferences);

  void saveTodayRecord(UserRecord record) {
    sharedPreferences.saveTodayRecord(record);
  }

  Future<UserRecord?> readUserRecord() async {
    return await sharedPreferences.readUserRecord();
  }
}
