import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wotla/data/models/answer_history.dart';
import 'package:wotla/data/providers/date_provider.dart';
import 'package:wotla/features/game/bloc/game_bloc.dart';
import 'package:wotla/features/game/bloc/game_event.dart';
import 'package:wotla/features/game/bloc/game_state.dart';
import 'package:wotla/utils/const.dart';

class WotlaInput extends StatefulWidget {
  const WotlaInput({
    Key? key,
  }) : super(key: key);

  @override
  State<WotlaInput> createState() => _WotlaInputState();
}

class _WotlaInputState extends State<WotlaInput> {
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
