import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wotla/data/models/answer_history.dart';

part 'user_daily_record.g.dart';

@JsonSerializable()
class UserDailyRecord extends Equatable {
  final DateTime date;
  final List<AnswerHistory> histories;
  final bool correct;
  final String correctAnswer;

  const UserDailyRecord({
    required this.date,
    required this.histories,
    required this.correct,
    required this.correctAnswer,
  });

  factory UserDailyRecord.fromJson(Map<String, dynamic> json) =>
      _$UserDailyRecordFromJson(json);

  Map<String, dynamic> toJson() => _$UserDailyRecordToJson(this);

  @override
  List<Object?> get props => [
        date,
        histories,
        correct,
        correctAnswer,
      ];
}
