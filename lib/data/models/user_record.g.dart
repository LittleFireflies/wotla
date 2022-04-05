// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRecord _$UserRecordFromJson(Map<String, dynamic> json) => UserRecord(
      date: DateTime.parse(json['date'] as String),
      histories: (json['histories'] as List<dynamic>)
          .map((e) => AnswerHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      correct: json['correct'] as bool,
      correctAnswer: json['correctAnswer'] as String,
    );

Map<String, dynamic> _$UserRecordToJson(UserRecord instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'histories': instance.histories,
      'correct': instance.correct,
      'correctAnswer': instance.correctAnswer,
    };
