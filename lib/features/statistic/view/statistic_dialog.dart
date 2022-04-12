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
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Text('1'),
                          const SizedBox(width: 8),
                          Container(
                            color: Colors.grey,
                            width: 100,
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '0',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Text('1'),
                          const SizedBox(width: 8),
                          Container(
                            color: Colors.grey,
                            width: 100,
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '0',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Text('1'),
                          const SizedBox(width: 8),
                          Container(
                            color: Colors.grey,
                            width: 100,
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '0',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Text('1'),
                          const SizedBox(width: 8),
                          Container(
                            color: Colors.grey,
                            width: 100,
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '0',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Text('1'),
                          const SizedBox(width: 8),
                          Container(
                            color: Colors.grey,
                            width: 100,
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '0',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
