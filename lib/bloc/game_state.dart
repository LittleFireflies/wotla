import 'package:equatable/equatable.dart';

class GameState extends Equatable {
  final String answer;

  const GameState({
    this.answer = '',
  });

  GameState copyWith({String? answer}) {
    return GameState(
      answer: answer ?? this.answer,
    );
  }

  @override
  List<Object?> get props => [answer];
}
