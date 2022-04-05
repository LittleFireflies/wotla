import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wotla/data/models/answer_history.dart';

part 'user_record.g.dart';

@JsonSerializable()
class UserRecord extends Equatable {
  final DateTime date;
  final List<AnswerHistory> histories;
  final bool correct;
  final String correctAnswer;

  const UserRecord({
    required this.date,
    required this.histories,
    required this.correct,
    required this.correctAnswer,
  });

  factory UserRecord.fromJson(Map<String, dynamic> json) =>
      _$UserRecordFromJson(json);

  Map<String, dynamic> toJson() => _$UserRecordToJson(this);

  @override
  List<Object?> get props => [
        date,
        histories,
        correct,
        correctAnswer,
      ];
}
