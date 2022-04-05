import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'answer_history.g.dart';

@JsonSerializable()
class AnswerHistory extends Equatable {
  final String answer;
  final String answerIdentifier;

  const AnswerHistory({
    required this.answer,
    required this.answerIdentifier,
  });

  factory AnswerHistory.fromJson(Map<String, dynamic> json) =>
      _$AnswerHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerHistoryToJson(this);

  @override
  List<Object?> get props => [answer, answerIdentifier];
}
