import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
}

class LoadRecord extends GameEvent {
  const LoadRecord();

  @override
  List<Object?> get props => [];
}

class InputChanged extends GameEvent {
  final String answer;

  const InputChanged(this.answer);

  @override
  List<Object?> get props => [answer];
}

class InputSubmitted extends GameEvent {
  const InputSubmitted();

  @override
  List<Object?> get props => [];
}
