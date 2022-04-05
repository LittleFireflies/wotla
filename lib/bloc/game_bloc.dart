import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wotla/bloc/game_event.dart';
import 'package:wotla/bloc/game_state.dart';
import 'package:wotla/data/data_source.dart';
import 'package:wotla/data/models/answer_history.dart';
import 'package:wotla/data/models/user_record.dart';
import 'package:wotla/data/repositories/wotla_repository.dart';
import 'package:wotla/utils/const.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final DataSource _dataSource;
  final WotlaRepository _repository;

  GameBloc(DataSource dataSource, WotlaRepository repository)
      : _dataSource = dataSource,
        _repository = repository,
        super(GameState(history: [], correctAnswer: dataSource.getAnswer())) {
    on<LoadRecord>((event, emit) async {
      final records = await _repository.readUserRecord();

      if (records != null) {
        emit(state.copyWith(
          history: records.histories,
          attempts: records.histories.length,
          correctAnswer: records.correctAnswer,
          correct: records.correct,
        ));
      }
    });
    on<InputChanged>((event, emit) {
      emit(state.copyWith(answer: event.answer.toUpperCase()));
    });
    on<InputSubmitted>((event, emit) {
      final historyAnswers =
          state.history.map((history) => history.answer).toList();

      if (!_dataSource.loadMemberList().contains(state.answer)) {
        emit(state.copyWith(error: WotlaConst.invalidAnswerMessage));
      } else if (historyAnswers.contains(state.answer)) {
        emit(state.copyWith(error: WotlaConst.submittedAnswerMessage));
      } else {
        final result =
            checkAnswer(state.correctAnswer.toUpperCase(), state.answer);
        final history = [
          ...state.history,
          AnswerHistory(answer: state.answer, answerIdentifier: result)
        ];
        final attempts = state.attempts + 1;

        final correct = result == state.answer;

        _repository.saveTodayRecord(UserRecord(
          histories: history,
          date: DateTime.now(),
          correct: correct,
          correctAnswer: state.correctAnswer,
        ));

        emit(state.copyWith(
          history: history,
          attempts: attempts,
          correct: correct,
        ));
      }
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

    for (int i = 0; i < length; i++) {
      chars.add(this[i]);
    }

    return chars;
  }
}
