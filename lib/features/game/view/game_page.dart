import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wotla/data/data_source.dart';
import 'package:wotla/data/providers/date_provider.dart';
import 'package:wotla/data/repositories/wotla_repository.dart';
import 'package:wotla/features/game/bloc/game_bloc.dart';
import 'package:wotla/features/game/bloc/game_event.dart';
import 'package:wotla/features/game/bloc/game_state.dart';
import 'package:wotla/features/game/widgets/wotla_input.dart';
import 'package:wotla/features/statistic/view/statistic_dialog.dart';
import 'package:wotla/utils/const.dart';

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
                return AlertDialog(
                  title: const Text('Cara Bermain'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Tebak WOTLA dalam ${WotlaConst.maxAttempt} kesempatan.',
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Jawaban merupakan nama panggilan member JKT48 yang terdaftar pada web jkt48.com.',
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Setelah jawaban dikirimkan, warna huruf akan berubah untuk menunjukkan seberapa dekat tebakanmu dengan jawabannya.',
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Jika huruf berwarna hijau, maka huruf tersebut telah berada pada posisi yang tepat.',
                      ),
                      Text(
                        'Jika huruf berwarna kuning, maka huruf tersebut terdapat pada jawaban, namun posisinya belum tepat.',
                      ),
                    ],
                  ),
                );
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
                                  var charIndex = 0;

                                  return Card(
                                    color: const Color(0xFFFF99BB),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: history.answerIdentifier
                                            .toChars()
                                            .map((char) {
                                          final widget = Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              history.answer[charIndex],
                                              style: TextStyle(
                                                color: char == 'X'
                                                    ? Colors.black
                                                    : char == '+'
                                                        ? Colors.yellowAccent
                                                        : Colors.green,
                                              ),
                                            ),
                                          );
                                          charIndex++;
                                          return widget;
                                        }).toList(),
                                      ),
                                    ),
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
