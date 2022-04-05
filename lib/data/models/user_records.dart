import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wotla/data/models/user_daily_record.dart';

part 'user_records.g.dart';

@JsonSerializable()
class UserRecords extends Equatable {
  final Map<String, UserDailyRecord> records;

  const UserRecords(this.records);

  factory UserRecords.fromJson(Map<String, dynamic> json) =>
      _$UserRecordsFromJson(json);

  Map<String, dynamic> toJson() => _$UserRecordsToJson(this);

  @override
  List<Object?> get props => [records];
}
