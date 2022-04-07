import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wotla/bloc/game_bloc.dart';
import 'package:wotla/bloc/game_event.dart';
import 'package:wotla/bloc/game_state.dart';
import 'package:wotla/features/statistic/bloc/statistic_bloc.dart';
import 'package:wotla/features/statistic/bloc/statistic_event.dart';
import 'package:wotla/features/statistic/bloc/statistic_state.dart';
import 'package:wotla/data/data_source.dart';
import 'package:wotla/data/models/answer_history.dart';
import 'package:wotla/data/providers/date_provider.dart';
import 'package:wotla/data/repositories/wotla_repository.dart';
import 'package:wotla/features/statistic/view/statistic_dialog.dart';
import 'package:wotla/utils/const.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WOTLA',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.red,
          onPrimary: Colors.white,
          secondary: Colors.red,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: RepositoryProvider(
        create: (context) => WotlaRepository(
          WotlaSharedPreferences(
            SharedPreferences.getInstance(),
          ),
          DateProvider(),
        ),
        child: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

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
        child: const MainView(),
      ),
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

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
                            'Tebak WOTLA dalam ${WotlaConst.maxAttempt} kesempatan.'),
                        SizedBox(height: 8),
                        Text(
                            'Jawaban merupakan nama panggilan member JKT48 yang terdaftar pada web jkt48.com.'),
                        SizedBox(height: 8),
                        Text(
                            'Setelah jawaban dikirimkan, warna huruf akan berubah untuk menunjukkan seberapa dekat tebakanmu dengan jawabannya.'),
                        SizedBox(height: 8),
                        Text(
                            'Jika huruf berwarna hijau, maka huruf tersebut telah berada pada posisi yang tepat.'),
                        Text(
                            'Jika huruf berwarna kuning, maka huruf tersebut terdapat pada jawaban, namun posisinya belum tepat.'),
                      ],
                    ),
                  );
                });
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
                      ..showSnackBar(SnackBar(
                        content: Text(error),
                        dismissDirection: DismissDirection.horizontal,
                      ));
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
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
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
                              }, childCount: state.history.length),
                            ),
                          ],
                        ),
                      ),
                      const _WotlaInput(),
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

class _WotlaInput extends StatefulWidget {
  const _WotlaInput({
    Key? key,
  }) : super(key: key);

  @override
  State<_WotlaInput> createState() => _WotlaInputState();
}

class _WotlaInputState extends State<_WotlaInput> {
  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state.attempts < WotlaConst.maxAttempt && !state.correct) {
          return Column(
            children: [
              TextField(
                controller: _inputController,
                onSubmitted: (answer) {
                  context.read<GameBloc>().add(const InputSubmitted());
                  _inputController.text = '';
                },
                onChanged: (answer) {
                  context.read<GameBloc>().add(InputChanged(answer));
                },
                decoration: const InputDecoration(
                  hintText: 'Tebak di sini',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  context.read<GameBloc>().add(const InputSubmitted());
                  _inputController.text = '';
                  FocusScope.of(context).unfocus();
                },
                child: const Text('Tebak'),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(36)),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Text(
                '${state.correct ? "Kamu Benar 🎉🎉" : "Kesempatanmu habis 😔😔"}\nJawabannya: ${state.correctAnswer}',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              CountdownTimer(
                endTime: state.nextGameTime?.millisecondsSinceEpoch ??
                    DateProvider().tomorrow.millisecondsSinceEpoch,
                widgetBuilder: (context, time) {
                  if (time == null) {
                    return const Text(
                        'Silakan ulang dengan me-restart halaman web');
                  }
                  return Text(
                      'Member baru akan muncul lagi dalam: ${time.hours.toString().padLeft(2, '0')} : ${time.min.toString().padLeft(2, '0')} : ${time.sec.toString().padLeft(2, '0')}');
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  Share.share(_getShareText(state.history, state.correct));
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ],
          );
        }
      },
    );
  }

  String _getShareText(List<AnswerHistory> history, bool correct) {
    var text =
        'WOTLA ${!correct ? 'X' : history.length}/${WotlaConst.maxAttempt}\n';
    text += '\n';

    for (int i = 0; i < history.length; i++) {
      final whiteRegex = RegExp(r'X');
      final yellowRegex = RegExp(r'\+');
      final greenRegex = RegExp(r'[a-zA-Z]');

      var line = history[i].answerIdentifier.replaceAll(whiteRegex, '⬜️');
      line = line.replaceAll(yellowRegex, '🟨');
      line = line.replaceAll(greenRegex, '🟩');
      line += '\n';

      text += line;
    }

    text += '\n';
    text += 'https://wotla.widdyjp.dev';

    return text;
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
