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

  const StatisticLoadedState(this.statistic);

  @override
  List<Object?> get props => [statistic];
}

class StatisticLoadErrorState extends StatisticState {
  final String message;

  const StatisticLoadErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
