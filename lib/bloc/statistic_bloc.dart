import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wotla/bloc/statistic_event.dart';
import 'package:wotla/bloc/statistic_state.dart';
import 'package:wotla/data/models/user_statistic.dart';
import 'package:wotla/data/repositories/wotla_repository.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final WotlaRepository _repository;

  static const errorMessage = 'Tidak dapat memuat statistik';

  StatisticBloc(WotlaRepository repository)
      : _repository = repository,
        super(const StatisticLoadingState()) {
    on<LoadUserStatistic>((event, emit) async {
      emit(const StatisticLoadingState());

      try {
        final userRecords = await _repository.readUserRecords();

        if (userRecords != null) {
          final gamesPlayed = userRecords.records.length;
          final winGamesRecord = userRecords.records
            ..removeWhere((key, value) => !value.correct);
          final winPercentage =
              (winGamesRecord.length / gamesPlayed * 100).toInt();
          final latestWinStreak = getWinStreakCount(
              userRecords.records.entries.map((e) => e.value.correct).toList());
          final maxWinStreak = getMaxWinStreakCount(
              userRecords.records.entries.map((e) => e.value.correct).toList());

          emit(
            StatisticLoadedState(
              UserStatistic(
                gamesPlayed: gamesPlayed,
                winPercentage: winPercentage,
                winStreak: latestWinStreak,
                maxWinStreak: maxWinStreak,
              ),
            ),
          );
        } else {
          emit(const StatisticLoadedState(UserStatistic(
            gamesPlayed: 0,
            winPercentage: 0,
            winStreak: 0,
            maxWinStreak: 0,
          )));
        }
      } catch (e) {
        emit(StatisticLoadErrorState(errorMessage));
      }
    });
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
