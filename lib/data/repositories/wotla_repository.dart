import 'package:wotla/data/models/user_daily_record.dart';
import 'package:wotla/data/models/user_records.dart';
import 'package:wotla/data/providers/date_provider.dart';
import 'package:wotla/data/storage/wotla_shared_preferences.dart';

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
