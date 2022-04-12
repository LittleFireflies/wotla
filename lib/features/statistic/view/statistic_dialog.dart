import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wotla/data/providers/date_provider.dart';
import 'package:wotla/data/repositories/wotla_repository.dart';
import 'package:wotla/data/storage/wotla_shared_preferences.dart';
import 'package:wotla/features/statistic/bloc/statistic_bloc.dart';
import 'package:wotla/features/statistic/bloc/statistic_event.dart';
import 'package:wotla/features/statistic/bloc/statistic_state.dart';

class StatisticDialog extends StatelessWidget {
  const StatisticDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WotlaRepository(
        WotlaSharedPreferences(SharedPreferences.getInstance()),
        DateProvider(),
      ),
      child: BlocProvider(
        create: (context) => StatisticBloc(
          context.read<WotlaRepository>(),
          DateProvider(),
        )..add(const LoadUserStatistic()),
        child: const StatisticDialogView(),
      ),
    );
  }
}

class StatisticDialogView extends StatelessWidget {
  const StatisticDialogView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Statistik'),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: BlocBuilder<StatisticBloc, StatisticState>(
        builder: (context, state) {
          if (state is StatisticLoadedState) {
            final maxDistributions = state.answerDistributions.entries
                .map((e) => e.value)
                .reduce(max);
            // var oldestUser = users.reduce((currentUser, nextUser) => currentUser['age'] > nextUser['age'] ? currentUser : nextUser)

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(state.statistic.gamesPlayed.toString()),
                          const Text(
                            'Main',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(state.statistic.winPercentage.toString()),
                          const Text(
                            '% Menang',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(state.statistic.winStreak.toString()),
                          const Text(
                            'Win Streak',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(state.statistic.maxWinStreak.toString()),
                          const Text(
                            'Max Win Streak',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const Text(
                  'Distribusi Jawaban',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Column(
                  children: state.answerDistributions.entries.map((answer) {
                    const minRatio = 0.10;
                    double ratio = answer.value / maxDistributions;
                    if (ratio.isNaN) {
                      ratio = minRatio;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Text('${answer.key}'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FractionallySizedBox(
                              alignment: Alignment.topLeft,
                              widthFactor: [minRatio, ratio].reduce(max),
                              child: Container(
                                color: Colors.blueGrey,
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  '${answer.value}',
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              ],
            );
          } else if (state is StatisticLoadErrorState) {
            return Text(state.message);
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
              ],
            );
          }
        },
      ),
    );
  }
}
