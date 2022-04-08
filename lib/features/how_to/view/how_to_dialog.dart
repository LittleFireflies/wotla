import 'package:flutter/material.dart';
import 'package:wotla/utils/const.dart';

class HowToDialog extends StatelessWidget {
  const HowToDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}
