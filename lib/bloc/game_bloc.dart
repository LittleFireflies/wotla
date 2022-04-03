import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wotla/bloc/game_event.dart';
import 'package:wotla/bloc/game_state.dart';
import 'package:wotla/data/data_source.dart';
import 'package:wotla/data/models/answer_history.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final DataSource _dataSource;

  GameBloc(DataSource dataSource)
      : _dataSource = dataSource,
        super(const GameState(history: [])) {
    on<InputChanged>((event, emit) {
      emit(state.copyWith(answer: event.answer.toUpperCase()));
    });
    on<InputSubmitted>((event, emit) {
      final result =
          checkAnswer(_dataSource.getAnswer().toUpperCase(), state.answer);
      final history = [
        ...state.history,
        AnswerHistory(answer: state.answer, answerIdentifier: result)
      ];
      final attempts = state.attempts + 1;

      emit(state.copyWith(
        history: history,
        attempts: attempts,
      ));
    });
  }

  String checkAnswer(String correctAnswer, String userAnswer) {
    final userAnswerChars = userAnswer.toChars();
    final checkAnswer = <String>[];

    for (int i = 0; i < userAnswerChars.length; i++) {
      try {
        if (userAnswerChars[i] == correctAnswer[i]) {
          checkAnswer.add(userAnswerChars[i]);
        } else if (correctAnswer.contains(userAnswerChars[i])) {
          checkAnswer.add('+');
        } else {
          checkAnswer.add('X');
        }
      } catch (e) {
        if (correctAnswer.contains(userAnswerChars[i])) {
          checkAnswer.add('+');
        } else {
          checkAnswer.add('X');
        }
      }
    }

    print(userAnswer);
    return checkAnswer.join();
  }
}

extension StringExtension on String {
  List<String> toChars() {
    final chars = <String>[];

    for (int i = 0; i < this.length; i++) {
      chars.add(this[i]);
    }

    return chars;
  }
}
