// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswerHistory _$AnswerHistoryFromJson(Map<String, dynamic> json) =>
    AnswerHistory(
      answer: json['answer'] as String,
      answerIdentifier: json['answerIdentifier'] as String,
    );

Map<String, dynamic> _$AnswerHistoryToJson(AnswerHistory instance) =>
    <String, dynamic>{
      'answer': instance.answer,
      'answerIdentifier': instance.answerIdentifier,
    };
