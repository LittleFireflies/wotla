import 'package:equatable/equatable.dart';
import 'package:wotla/data/models/answer_history.dart';

class GameState extends Equatable {
  final String answer;
  final List<AnswerHistory> history;

  const GameState({
    this.answer = '',
    required this.history,
  });

  GameState copyWith({
    String? answer,
    List<AnswerHistory>? history,
  }) {
    return GameState(
      answer: answer ?? this.answer,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props => [
        answer,
        history,
      ];
}
