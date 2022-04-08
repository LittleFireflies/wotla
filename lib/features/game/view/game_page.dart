import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wotla/data/data_source.dart';
import 'package:wotla/data/providers/date_provider.dart';
import 'package:wotla/data/repositories/wotla_repository.dart';
import 'package:wotla/features/game/bloc/game_bloc.dart';
import 'package:wotla/features/game/bloc/game_event.dart';
import 'package:wotla/features/game/bloc/game_state.dart';
import 'package:wotla/features/game/widgets/answer_card.dart';
import 'package:wotla/features/game/widgets/wotla_input.dart';
import 'package:wotla/features/how_to/view/how_to_dialog.dart';
import 'package:wotla/features/statistic/view/statistic_dialog.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DateProvider(),
      child: BlocProvider(
        create: (context) => GameBloc(
          dataSource: DataSource(),
          repository: context.read<WotlaRepository>(),
          dateProvider: context.read<DateProvider>(),
        )..add(const LoadRecord()),
        child: const GameView(),
      ),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        title: const Text('WOTLA'),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const HowToDialog();
              },
            );
          },
          icon: const Icon(Icons.help_outline),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const StatisticDialog();
                },
              );
            },
            icon: const Icon(Icons.bar_chart),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SizedBox(
              width: 480,
              child: BlocConsumer<GameBloc, GameState>(
                listener: (context, state) {
                  final error = state.error;
                  if (error != null) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(error),
                          dismissDirection: DismissDirection.horizontal,
                        ),
                      );
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Image.network(
                                'https://jkt48.com/images/oglogo.png',
                                height: 200,
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final history = state.history[index];

                                  return AnswerCard(
                                    answer: history.answer,
                                    answerIdentifier: history.answerIdentifier,
                                  );
                                },
                                childCount: state.history.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const WotlaInput(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
