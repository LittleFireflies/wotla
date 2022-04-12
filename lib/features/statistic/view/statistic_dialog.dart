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
import 'package:wotla/features/statistic/widgets/answer_distribution_bar.dart';
import 'package:wotla/features/statistic/widgets/statistic_text.dart';

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
                      child: StatisticText(
                        value: state.statistic.gamesPlayed.toString(),
                        label: 'Main',
                      ),
                    ),
                    Expanded(
                      child: StatisticText(
                        value: state.statistic.winPercentage.toString(),
                        label: '% Menang',
                      ),
                    ),
                    Expanded(
                      child: StatisticText(
                        value: state.statistic.winStreak.toString(),
                        label: 'Win Streak',
                      ),
                    ),
                    Expanded(
                      child: StatisticText(
                        value: state.statistic.maxWinStreak.toString(),
                        label: 'Max Win Streak',
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

                    return AnswerDistributionBar(
                      ratio: [ratio, minRatio].reduce(max),
                      label: answer.key.toString(),
                      value: answer.value.toString(),
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
