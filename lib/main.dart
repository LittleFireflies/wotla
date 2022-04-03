import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wotla/bloc/game_bloc.dart';
import 'package:wotla/bloc/game_event.dart';
import 'package:wotla/bloc/game_state.dart';
import 'package:wotla/data/data_source.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.red,
          onPrimary: Colors.white,
          secondary: Colors.blue,
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
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(DataSource()),
      child: const MainView(),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: 480,
            child: BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Image.network(
                      'https://jkt48.com/images/oglogo.png',
                      width: 200,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
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
                        itemCount: state.history.length,
                      ),
                    ),
                    _WotlaInput(),
                  ],
                );
              },
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
        if (state.attempts < 5 && !state.correct) {
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
                },
                child: const Text('Tebak'),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(36)),
              ),
            ],
          );
        } else {
          return Text(
            '${state.correct ? "Kamu Benar" : "Kesempatanmu habis"}!!! \nJawabannya: ${state.correctAnswer}',
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
