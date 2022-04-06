import 'package:equatable/equatable.dart';

class UserStatistic extends Equatable {
  final int gamesPlayed;
  final int winPercentage;
  final int winStreak;
  final int maxWinStreak;

  const UserStatistic({
    required this.gamesPlayed,
    required this.winPercentage,
    required this.winStreak,
    required this.maxWinStreak,
  });

  @override
  List<Object?> get props => [
        gamesPlayed,
        winPercentage,
        winStreak,
        maxWinStreak,
      ];
}
