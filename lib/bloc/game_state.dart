import 'package:equatable/equatable.dart';
import 'package:wotla/data/models/answer_history.dart';

class GameState extends Equatable {
  final String answer;
  final String correctAnswer;
  final List<AnswerHistory> history;
  final int attempts;

  const GameState({
    this.answer = '',
    required this.correctAnswer,
    required this.history,
    this.attempts = 0,
  });

  GameState copyWith({
    String? answer,
    List<AnswerHistory>? history,
    int? attempts,
  }) {
    return GameState(
      answer: answer ?? this.answer,
      correctAnswer: correctAnswer,
      history: history ?? this.history,
      attempts: attempts ?? this.attempts,
    );
  }

  @override
  List<Object?> get props => [
        answer,
        correctAnswer,
        history,
        attempts,
      ];
}
