import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wotla/data/models/user_daily_record.dart';
import 'package:wotla/data/models/user_records.dart';
import 'package:wotla/data/providers/date_provider.dart';

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

class WotlaRepository {
  final WotlaSharedPreferences sharedPreferences;
  final DateProvider dateProvider;

  const WotlaRepository(this.sharedPreferences, this.dateProvider);

  Future<void> saveTodayRecord(UserDailyRecord record) async {
    final records = await readUserRecords();

    records?.records[record.date.toIso8601String()] = record;

    await sharedPreferences.saveTodayRecord(records ??
        UserRecords({
          record.date.toIso8601String(): record,
        }));
  }

  Future<UserRecords?> readUserRecords() async {
    final records = await sharedPreferences.readUserRecords();
    return records;
  }

  Future<UserDailyRecord?> readTodayRecord() async {
    final records = await readUserRecords();

    return records?.records[dateProvider.today.toIso8601String()];
  }
}
