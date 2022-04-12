import 'package:equatable/equatable.dart';
import 'package:wotla/data/models/user_statistic.dart';

abstract class StatisticState extends Equatable {
  const StatisticState();
}

class StatisticLoadingState extends StatisticState {
  const StatisticLoadingState();

  @override
  List<Object?> get props => [];
}

class StatisticLoadedState extends StatisticState {
  final UserStatistic statistic;
  final Map<int, int> answerDistributions;

  const StatisticLoadedState({
    required this.statistic,
    required this.answerDistributions,
  });

  @override
  List<Object?> get props => [
        statistic,
        answerDistributions,
      ];
}

class StatisticLoadErrorState extends StatisticState {
  final String message;

  const StatisticLoadErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
