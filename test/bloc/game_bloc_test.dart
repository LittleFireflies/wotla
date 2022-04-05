import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wotla/bloc/game_bloc.dart';
import 'package:wotla/bloc/game_event.dart';
import 'package:wotla/bloc/game_state.dart';
import 'package:wotla/data/data_source.dart';
import 'package:wotla/data/models/answer_history.dart';
import 'package:wotla/data/providers/date_provider.dart';
import 'package:wotla/data/repositories/wotla_repository.dart';
import 'package:wotla/utils/const.dart';

class MockDataSource extends Mock implements DataSource {}

class MockRepository extends Mock implements WotlaRepository {}

class MockDateProvider extends Mock implements DateProvider {}

void main() {
  late DataSource dataSource;
  late DateProvider dateProvider;
  late WotlaRepository repository;
  late GameBloc bloc;

  const correctAnswer = 'Gita';

  setUp(() {
    dataSource = MockDataSource();
    dateProvider = MockDateProvider();
    repository = MockRepository();
    when(() => dataSource.getAnswer()).thenReturn('Gita');

    bloc = GameBloc(
      dataSource: dataSource,
      repository: repository,
      dateProvider: dateProvider,
    );

    when(() => dataSource.loadMemberList())
        .thenReturn(['GITA', 'MARSHA', 'CHRISTY', 'GABY']);
    when(() => dateProvider.today).thenReturn(DateTime(2022, 4, 4));
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
        correctAnswer: correctAnswer,
      ),
    ],
  );

  blocTest<GameBloc, GameState>(
    'add answer history '
    'when InputSubmitted event is added '
    'and answer is correct',
    build: () => bloc,
    act: (bloc) => bloc
      ..add(const InputChanged('Gita'))
      ..add(const InputSubmitted()),
    expect: () => [
      const GameState(
        answer: 'GITA',
        history: [],
        correctAnswer: correctAnswer,
      ),
      const GameState(
        answer: 'GITA',
        history: [AnswerHistory(answer: 'GITA', answerIdentifier: 'GITA')],
        attempts: 1,
        correctAnswer: correctAnswer,
        correct: true,
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
    build: () => bloc,
    act: (bloc) => bloc
      ..add(const InputChanged('Gaby'))
      ..add(const InputSubmitted()),
    expect: () => [
      const GameState(
        answer: 'GABY',
        history: [],
        correctAnswer: correctAnswer,
      ),
      const GameState(
        answer: 'GABY',
        history: [AnswerHistory(answer: 'GABY', answerIdentifier: 'G+XX')],
        attempts: 1,
        correctAnswer: correctAnswer,
        correct: false,
      ),
    ],
    verify: (_) {
      verify(() => dataSource.getAnswer()).called(1);
    },
  );

  blocTest<GameBloc, GameState>(
    'add answer history '
    'when InputSubmitted event is added '
    'and answer is not exist in data pool',
    build: () => bloc,
    act: (bloc) => bloc
      ..add(const InputChanged('Gebi'))
      ..add(const InputSubmitted()),
    expect: () => [
      const GameState(
        answer: 'GEBI',
        history: [],
        correctAnswer: correctAnswer,
      ),
      const GameState(
        answer: 'GEBI',
        history: [],
        attempts: 0,
        correctAnswer: correctAnswer,
        error: WotlaConst.invalidAnswerMessage,
      ),
    ],
    verify: (_) {
      verify(() => dataSource.getAnswer()).called(1);
    },
  );

  blocTest<GameBloc, GameState>(
    'add answer history '
    'when InputSubmitted event is added '
    'and answer is already submitted',
    setUp: () {
      when(() => dataSource.loadMemberList()).thenReturn(['GITA', 'CHRISTY']);
    },
    seed: () {
      return const GameState(
        correctAnswer: correctAnswer,
        history: [
          AnswerHistory(answer: 'CHRISTY', answerIdentifier: 'XXX+XXX'),
        ],
        attempts: 1,
      );
    },
    build: () => bloc,
    act: (bloc) => bloc
      ..add(const InputChanged('Christy'))
      ..add(const InputSubmitted()),
    expect: () => [
      const GameState(
        answer: 'CHRISTY',
        history: [
          AnswerHistory(answer: 'CHRISTY', answerIdentifier: 'XXX+XXX'),
        ],
        attempts: 1,
        correctAnswer: correctAnswer,
      ),
      const GameState(
        answer: 'CHRISTY',
        history: [
          AnswerHistory(answer: 'CHRISTY', answerIdentifier: 'XXX+XXX'),
        ],
        attempts: 1,
        correctAnswer: correctAnswer,
        error: WotlaConst.submittedAnswerMessage,
      ),
    ],
    verify: (_) {
      verify(() => dataSource.getAnswer()).called(1);
    },
  );

  group('Answer Check', () {
    late GameBloc wotla;

    setUp(() {
      wotla = GameBloc(
        dataSource: dataSource,
        repository: repository,
        dateProvider: dateProvider,
      );
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
