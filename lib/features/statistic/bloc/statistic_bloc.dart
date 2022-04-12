import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wotla/data/providers/date_provider.dart';
import 'package:wotla/features/statistic/bloc/statistic_event.dart';
import 'package:wotla/features/statistic/bloc/statistic_state.dart';
import 'package:wotla/data/models/user_daily_record.dart';
import 'package:wotla/data/models/user_statistic.dart';
import 'package:wotla/data/repositories/wotla_repository.dart';
import 'package:wotla/utils/const.dart';
import 'package:wotla/utils/map_extension.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final WotlaRepository _repository;
  final DateProvider _dateProvider;

  static const errorMessage = 'Tidak dapat memuat statistik';

  StatisticBloc(
    WotlaRepository repository,
    DateProvider dateProvider,
  )   : _repository = repository,
        _dateProvider = dateProvider,
        super(const StatisticLoadingState()) {
    on<LoadUserStatistic>((event, emit) => _onLoadUserStatistic(emit));
  }

  Future<void> _onLoadUserStatistic(Emitter<StatisticState> emit) async {
    emit(const StatisticLoadingState());

    try {
      final userRecords = await _repository.readUserRecords();
      final answerDistributions = <int, int>{
        1: 0,
        2: 0,
        3: 0,
        4: 0,
        5: 0,
      };

      if (userRecords != null) {
        final completedGames = userRecords.records.exclude(
          (key, value) =>
              !value.correct && value.histories.length < WotlaConst.maxAttempt,
        );

        // Fill missing date games. Will be deleted after
        // GameStat storage introduced
        final filledRecords = fillEmptyGames(completedGames);

        final gamesPlayed = filledRecords
            .exclude((key, value) => value.correctAnswer.isEmpty)
            .length;
        final winGamesRecord =
            filledRecords.exclude((key, value) => !value.correct);
        final winPercentage =
            (winGamesRecord.length / gamesPlayed * 100).toInt();
        final latestWinStreak = getWinStreakCount(
          filledRecords.entries.map((e) => e.value.correct).toList(),
        );
        final maxWinStreak = getMaxWinStreakCount(
          filledRecords.entries.map((e) => e.value.correct).toList(),
        );

        winGamesRecord.forEach((key, value) {
          answerDistributions[value.histories.length] =
              (answerDistributions[value.histories.length] ?? 0) + 1;
        });

        emit(
          StatisticLoadedState(
            statistic: UserStatistic(
              gamesPlayed: gamesPlayed,
              winPercentage: winPercentage,
              winStreak: latestWinStreak,
              maxWinStreak: maxWinStreak,
            ),
            answerDistributions: answerDistributions,
          ),
        );
      } else {
        emit(
          StatisticLoadedState(
            statistic: const UserStatistic(
              gamesPlayed: 0,
              winPercentage: 0,
              winStreak: 0,
              maxWinStreak: 0,
            ),
            answerDistributions: answerDistributions,
          ),
        );
      }
    } catch (e) {
      emit(const StatisticLoadErrorState(errorMessage));
    }
  }

  SplayTreeMap<String, UserDailyRecord> fillEmptyGames(
    Map<String, UserDailyRecord> completedGames,
  ) {
    final firstGameDate = DateTime.parse(completedGames.keys.first);
    final todayDate = _dateProvider.today;
    var date = firstGameDate;
    while (date != todayDate) {
      if (completedGames[date.toIso8601String()] == null) {
        completedGames[date.toIso8601String()] = UserDailyRecord(
          date: date,
          histories: const [],
          correct: false,
          correctAnswer: '',
        );
      }
      date = date.add(const Duration(days: 1));
    }

    final sorted = SplayTreeMap<String, UserDailyRecord>.from(
      completedGames,
      (a, b) => a.compareTo(b),
    );

    return sorted;
  }

  int getWinStreakCount(List<bool> recordsResult) {
    int winStreak = 0;

    for (int i = recordsResult.length - 1; i >= 0; i--) {
      if (recordsResult[i]) {
        winStreak++;
      } else {
        break;
      }
    }

    return winStreak;
  }

  int getMaxWinStreakCount(List<bool> recordsResult) {
    int maxWinStreak = 0;
    int winStreak = 0;

    for (int i = recordsResult.length - 1; i >= 0; i--) {
      if (recordsResult[i]) {
        winStreak++;
      } else {
        winStreak = 0;
      }
      if (winStreak > maxWinStreak) {
        maxWinStreak = winStreak;
      }
    }

    return maxWinStreak;
  }
}
