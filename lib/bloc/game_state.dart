import 'package:equatable/equatable.dart';
import 'package:wotla/data/models/answer_history.dart';

class GameState extends Equatable {
  final String answer;
  final List<AnswerHistory> history;
  final int attempts;

  const GameState({
    this.answer = '',
    required this.history,
    this.attempts = 0,
  });

  GameState copyWith({
    String? answer,
    List<AnswerHistory>? history,
    int? attempts
  }) {
    return GameState(
      answer: answer ?? this.answer,
      history: history ?? this.history,
      attempts: attempts ?? this.attempts,
    );
  }

  @override
  List<Object?> get props => [
        answer,
        history,
        attempts,
      ];
}
