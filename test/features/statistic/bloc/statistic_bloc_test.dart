import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wotla/data/providers/date_provider.dart';
import 'package:wotla/features/statistic/bloc/statistic_bloc.dart';
import 'package:wotla/features/statistic/bloc/statistic_event.dart';
import 'package:wotla/features/statistic/bloc/statistic_state.dart';
import 'package:wotla/data/models/user_daily_record.dart';
import 'package:wotla/data/models/user_records.dart';
import 'package:wotla/data/models/user_statistic.dart';
import 'package:wotla/data/repositories/wotla_repository.dart';

import '../../../helper/models.dart';

class MockRepository extends Mock implements WotlaRepository {}

class MockDateProvider extends Mock implements DateProvider {}

void main() {
  late WotlaRepository repository;
  late DateProvider dateProvider;
  late StatisticBloc bloc;

  final today = DateTime(2022, 4, 4);
  final UserDailyRecord dailyRecord = UserDailyRecord(
    date: today,
    histories: TestModels.winOneTry,
    correct: true,
    correctAnswer: 'GITA',
  );
  final UserDailyRecord yesterdayDailyRecord = UserDailyRecord(
    date: today.subtract(const Duration(days: 1)),
    histories: TestModels.winOneTry,
    correct: true,
    correctAnswer: 'GITA',
  );
  final UserDailyRecord twoDaysAgoRecord = UserDailyRecord(
    date: today.subtract(const Duration(days: 2)),
    histories: TestModels.failedGame,
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
    dateProvider = MockDateProvider();
    bloc = StatisticBloc(repository, dateProvider);

    when(() => dateProvider.today).thenReturn(today);
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
        statistic: UserStatistic(
          gamesPlayed: 3,
          winPercentage: 66,
          winStreak: 2,
          maxWinStreak: 2,
        ),
        answerDistributions: {
          1: 2,
          2: 0,
          3: 0,
          4: 0,
          5: 0,
        },
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
        statistic: UserStatistic(
          gamesPlayed: 0,
          winPercentage: 0,
          winStreak: 0,
          maxWinStreak: 0,
        ),
        answerDistributions: {
          1: 0,
          2: 0,
          3: 0,
          4: 0,
          5: 0,
        },
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

  blocTest<StatisticBloc, StatisticState>(
    'emit user statistic '
    'when LoadUserStatistic event is added '
    'and returns successfully '
    'and user skips some days',
    setUp: () {
      final dayMinus4 = today.subtract(const Duration(days: 4));
      final dayMinus3 = today.subtract(const Duration(days: 3));

      when(() => repository.readUserRecords()).thenAnswer(
        (_) async => UserRecords({
          dayMinus4.toIso8601String(): UserDailyRecord(
            date: dayMinus4,
            histories: TestModels.winOneTry,
            correctAnswer: 'GITA',
            correct: true,
          ),
          dayMinus3.toIso8601String(): UserDailyRecord(
            date: dayMinus3,
            histories: TestModels.winThreeTries,
            correctAnswer: 'GITA',
            correct: true,
          ),
          today.toIso8601String(): UserDailyRecord(
            date: dayMinus3,
            histories: TestModels.winTwoTries,
            correctAnswer: 'GITA',
            correct: true,
          ),
        }),
      );
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LoadUserStatistic()),
    expect: () => [
      const StatisticLoadingState(),
      const StatisticLoadedState(
        statistic: UserStatistic(
          gamesPlayed: 3,
          winPercentage: 100,
          winStreak: 1,
          maxWinStreak: 2,
        ),
        answerDistributions: {
          1: 1,
          2: 1,
          3: 1,
          4: 0,
          5: 0,
        },
      ),
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
    expect(bloc.getMaxWinStreakCount([true, true, true]), 3);
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
