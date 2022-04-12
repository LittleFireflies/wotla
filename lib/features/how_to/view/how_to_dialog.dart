import 'package:flutter/material.dart';
import 'package:wotla/features/game/widgets/answer_card.dart';
import 'package:wotla/utils/const.dart';

class HowToDialog extends StatelessWidget {
  const HowToDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Cara Bermain'),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
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
            Divider(),
            Text(
              'Contoh',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            AnswerCard(answer: 'GABY', answerIdentifier: 'G+XX'),
            Text(
              'Huruf G berwarna hijau, artinya huruf tersebut telah berada pada posisi yang tepat.',
            ),
            SizedBox(height: 4),
            Text(
              'Huruf A berwarna kuning, maka huruf tersebut terdapat pada jawaban, namun posisinya belum tepat.',
            ),
            SizedBox(height: 8),
            AnswerCard(answer: 'GITA', answerIdentifier: 'GITA'),
            SizedBox(height: 4),
            Text('Jawabannya adalah GITA!'),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Text(
              'Menemukan bug, ada pertanyaan, atau saran fitur? Sampaikan ke DM @widdyjp di twitter ya :)',
            )
          ],
        ),
      ),
    );
  }
}
