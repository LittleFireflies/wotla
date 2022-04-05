// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_records.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRecords _$UserRecordsFromJson(Map<String, dynamic> json) => UserRecords(
      (json['records'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, UserDailyRecord.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$UserRecordsToJson(UserRecords instance) =>
    <String, dynamic>{
      'records': instance.records,
    };
