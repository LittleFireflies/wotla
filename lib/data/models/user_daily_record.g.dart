// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_daily_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDailyRecord _$UserDailyRecordFromJson(Map<String, dynamic> json) =>
    UserDailyRecord(
      date: DateTime.parse(json['date'] as String),
      histories: (json['histories'] as List<dynamic>)
          .map((e) => AnswerHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      correct: json['correct'] as bool,
      correctAnswer: json['correctAnswer'] as String,
    );

Map<String, dynamic> _$UserDailyRecordToJson(UserDailyRecord instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'histories': instance.histories,
      'correct': instance.correct,
      'correctAnswer': instance.correctAnswer,
    };
