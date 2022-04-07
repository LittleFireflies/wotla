import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wotla/bloc/statistic_bloc.dart';
import 'package:wotla/bloc/statistic_event.dart';
import 'package:wotla/bloc/statistic_state.dart';
import 'package:wotla/data/models/answer_history.dart';
import 'package:wotla/data/models/user_daily_record.dart';
import 'package:wotla/data/models/user_records.dart';
import 'package:wotla/data/models/user_statistic.dart';
import 'package:wotla/data/repositories/wotla_repository.dart';

class MockRepository extends Mock implements WotlaRepository {}

void main() {
  late WotlaRepository repository;
  late StatisticBloc bloc;

  final today = DateTime(2022, 4, 4);
  final UserDailyRecord dailyRecord = UserDailyRecord(
    date: today,
    histories: const [
      AnswerHistory(
        answer: 'GITA',
        answerIdentifier: 'GITA',
      ),
    ],
    correct: true,
    correctAnswer: 'GITA',
  );
  final UserDailyRecord yesterdayDailyRecord = UserDailyRecord(
    date: today.subtract(const Duration(days: 1)),
    histories: const [
      AnswerHistory(
        answer: 'GITA',
        answerIdentifier: 'GITA',
      ),
    ],
    correct: true,
    correctAnswer: 'GITA',
  );
  final UserDailyRecord twoDaysAgoRecord = UserDailyRecord(
    date: today.subtract(const Duration(days: 2)),
    histories: const [
      AnswerHistory(
        answer: 'GABY',
        answerIdentifier: 'G+XX',
      ),
      AnswerHistory(
        answer: 'GABY',
        answerIdentifier: 'G+XX',
      ),
      AnswerHistory(
        answer: 'GABY',
        answerIdentifier: 'G+XX',
      ),
      AnswerHistory(
        answer: 'GABY',
        answerIdentifier: 'G+XX',
      ),
      AnswerHistory(
        answer: 'GABY',
        answerIdentifier: 'G+XX',
      ),
    ],
    correct: false,
    correctAnswer: 'GITA',
  );
  final UserRecords userRecords = UserRecords({
    twoDaysAgoRecord.date.toIso8601String(): twoDaysAgoRecord,
    yesterdayDailyRecord.date.toIso8601String(): yesterdayDailyRecord,
    dailyRecord.date.toIso8601String(): dailyRecord,
  });

  setUp(() {
    repository = MockRepository();
    bloc = StatisticBloc(repository);
  });

  blocTest<StatisticBloc, StatisticState>(
    'emit user statistic '
    'when LoadUserStatistic event is added '
    'and returns successfully',
    setUp: () {
      when(() => repository.readUserRecords())
          .thenAnswer((_) async => userRecords);
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LoadUserStatistic()),
    expect: () => [
      const StatisticLoadingState(),
      const StatisticLoadedState(
        UserStatistic(
          gamesPlayed: 3,
          winPercentage: 66,
          winStreak: 2,
          maxWinStreak: 2,
        ),
      ),
    ],
  );

  blocTest<StatisticBloc, StatisticState>(
    'emit user statistic '
    'when LoadUserStatistic event is added '
    'and returns null',
    setUp: () {
      when(() => repository.readUserRecords()).thenAnswer((_) async => null);
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LoadUserStatistic()),
    expect: () => [
      const StatisticLoadingState(),
      const StatisticLoadedState(
        UserStatistic(
          gamesPlayed: 0,
          winPercentage: 0,
          winStreak: 0,
          maxWinStreak: 0,
        ),
      ),
    ],
  );

  final exception = Exception('Error!');
  blocTest<StatisticBloc, StatisticState>(
    'emit user statistic '
    'when LoadUserStatistic event is added '
    'and exception thrown',
    setUp: () {
      when(() => repository.readUserRecords()).thenThrow(exception);
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LoadUserStatistic()),
    expect: () => [
      const StatisticLoadingState(),
      const StatisticLoadErrorState(StatisticBloc.errorMessage),
    ],
  );

  test('test win streak count', () {
    expect(bloc.getWinStreakCount([false, false, false]), 0);
    expect(bloc.getWinStreakCount([false, false, true]), 1);
    expect(bloc.getWinStreakCount([false, true, false]), 0);
    expect(bloc.getWinStreakCount([false, true, true]), 2);
    expect(bloc.getWinStreakCount([true, false, false]), 0);
    expect(bloc.getWinStreakCount([true, false, true]), 1);
    expect(bloc.getWinStreakCount([true, true, false]), 0);
    expect(bloc.getWinStreakCount([true, true, true]), 3);
  });

  test('test max win streak count', () {
    expect(bloc.getMaxWinStreakCount([false, false, false]), 0);
    expect(bloc.getMaxWinStreakCount([false, false, true]), 1);
    expect(bloc.getMaxWinStreakCount([false, true, false]), 1);
    expect(bloc.getMaxWinStreakCount([false, true, true]), 2);
    expect(bloc.getMaxWinStreakCount([true, false, false]), 1);
    expect(bloc.getMaxWinStreakCount([true, false, true]), 1);
    expect(bloc.getMaxWinStreakCount([true, true, false]), 2);
    expect(bloc.getMaxWinStreakCount([true, true, true]), 0);
    expect(
      bloc.getMaxWinStreakCount([
        true,
        true,
        true,
        false,
        false,
        false,
      ]),
      3,
    );
    expect(
      bloc.getMaxWinStreakCount([
        true,
        true,
        true,
        false,
        true,
        true,
        true,
      ]),
      3,
    );
    expect(
      bloc.getMaxWinStreakCount([
        true,
        true,
        false,
        true,
        true,
        true,
        true,
      ]),
      4,
    );
    expect(
      bloc.getMaxWinStreakCount([
        true,
        true,
        true,
        true,
        false,
        true,
        true,
        true,
      ]),
      4,
    );
  });
}
