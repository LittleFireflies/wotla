import 'package:equatable/equatable.dart';
import 'package:wotla/data/models/answer_history.dart';

class GameState extends Equatable {
  final String answer;
  final String correctAnswer;
  final List<AnswerHistory> history;
  final int attempts;
  final bool correct;
  final String? error;
  final DateTime? nextGameTime;
  final bool triggerAlmost;

  const GameState({
    this.answer = '',
    required this.correctAnswer,
    required this.history,
    this.attempts = 0,
    this.correct = false,
    this.error,
    this.nextGameTime,
    this.triggerAlmost = false,
  });

  GameState copyWith({
    String? answer,
    List<AnswerHistory>? history,
    int? attempts,
    bool? correct,
    String? error,
    String? correctAnswer,
    DateTime? nextGameTime,
    bool? triggerAlmost,
  }) {
    return GameState(
      answer: answer ?? this.answer,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      history: history ?? this.history,
      attempts: attempts ?? this.attempts,
      correct: correct ?? this.correct,
      error: error,
      nextGameTime: nextGameTime ?? this.nextGameTime,
      triggerAlmost: triggerAlmost ?? false,
    );
  }

  @override
  List<Object?> get props => [
        answer,
        correctAnswer,
        history,
        attempts,
        correct,
        error,
        nextGameTime,
        triggerAlmost,
      ];
}
