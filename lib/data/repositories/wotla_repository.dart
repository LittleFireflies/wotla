import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wotla/data/models/user_daily_record.dart';
import 'package:wotla/data/models/user_records.dart';
import 'package:wotla/data/repositories/date_repository.dart';

class WotlaSharedPreferences {
  final Future<SharedPreferences> sharedPreferences;

  const WotlaSharedPreferences(this.sharedPreferences);

  Future<void> saveTodayRecord(UserRecords records) async {
    final prefs = await sharedPreferences;
    await prefs.setString('user_records', json.encode(records.toJson()));
  }

  Future<UserRecords?> readUserRecords() async {
    final prefs = await sharedPreferences;
    final Map<String, dynamic> userJson =
        json.decode(prefs.getString('user_records') ?? "{}");

    if (userJson.isEmpty) {
      return null;
    } else {
      return UserRecords.fromJson(userJson);
    }
  }
}

class WotlaRepository {
  final WotlaSharedPreferences sharedPreferences;
  final DateRepository dateRepository;

  const WotlaRepository(this.sharedPreferences, this.dateRepository);

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

    return records?.records[dateRepository.today.toIso8601String()];
  }
}
