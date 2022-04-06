import 'package:equatable/equatable.dart';

abstract class StatisticEvent extends Equatable {
  const StatisticEvent();
}

class LoadUserStatistic extends StatisticEvent {
  const LoadUserStatistic();

  @override
  List<Object?> get props => [];
}
