import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wotla/bloc/game_bloc.dart';
import 'package:wotla/bloc/game_event.dart';
import 'package:wotla/bloc/game_state.dart';
import 'package:wotla/data/data_source.dart';
import 'package:wotla/data/models/answer_history.dart';

class MockDataSource extends Mock implements DataSource {}

void main() {
  late DataSource dataSource;
  late GameBloc bloc;

  setUp(() {
    dataSource = MockDataSource();
    bloc = GameBloc(dataSource);
  });

  blocTest<GameBloc, GameState>(
    'emit valid state '
    'when InputChanged event is added',
    build: () => bloc,
    act: (bloc) => bloc.add(const InputChanged('answer')),
    expect: () => [
      const GameState(
        answer: 'ANSWER',
        history: [],
      ),
    ],
  );

  blocTest<GameBloc, GameState>(
    'add answer history '
    'when InputSubmitted event is added '
    'and answer is correct',
    setUp: () {
      when(() => dataSource.getAnswer()).thenReturn('Gita');
    },
    build: () => bloc,
    act: (bloc) => bloc
      ..add(const InputChanged('Gita'))
      ..add(const InputSubmitted()),
    expect: () => [
      const GameState(
        answer: 'GITA',
        history: [],
      ),
      const GameState(
        answer: 'GITA',
        history: [AnswerHistory(answer: 'GITA', answerIdentifier: 'GITA')],
      ),
    ],
    verify: (_) {
      verify(() => dataSource.getAnswer()).called(1);
    },
  );

  blocTest<GameBloc, GameState>(
    'add answer history '
    'when InputSubmitted event is added '
    'and answer is incorrect',
    setUp: () {
      when(() => dataSource.getAnswer()).thenReturn('Gita');
    },
    build: () => bloc,
    act: (bloc) => bloc
      ..add(const InputChanged('Gebi'))
      ..add(const InputSubmitted()),
    expect: () => [
      const GameState(
        answer: 'GEBI',
        history: [],
      ),
      const GameState(
        answer: 'GEBI',
        history: [AnswerHistory(answer: 'GEBI', answerIdentifier: 'GXX+')],
      ),
    ],
    verify: (_) {
      verify(() => dataSource.getAnswer()).called(1);
    },
  );

  group('Answer Check', () {
    late GameBloc wotla;

    setUp(() {
      wotla = GameBloc(dataSource);
    });

    test('test answer with same length', () {
      expect('GXX+',
          wotla.checkAnswer('Gita'.toUpperCase(), 'Gebi'.toUpperCase()));
      expect('GITA',
          wotla.checkAnswer('Gita'.toUpperCase(), 'Gita'.toUpperCase()));
      expect('AZIZI',
          wotla.checkAnswer('Azizi'.toUpperCase(), 'Azizi'.toUpperCase()));
      expect('ONIEL',
          wotla.checkAnswer('Oniel'.toUpperCase(), 'Oniel'.toUpperCase()));
    });

    test('test answer with different length length', () {
      expect('XEXXX+',
          wotla.checkAnswer('Beby'.toUpperCase(), 'Celine'.toUpperCase()));
      expect('X++XX+',
          wotla.checkAnswer('Lia'.toUpperCase(), 'Raisha'.toUpperCase()));
      expect('+X+++',
          wotla.checkAnswer('Gita'.toUpperCase(), 'Angga'.toUpperCase()));
    });
  });
}
