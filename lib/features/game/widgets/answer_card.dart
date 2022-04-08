import 'package:flutter/material.dart';
import 'package:wotla/utils/string_extension.dart';

class AnswerCard extends StatelessWidget {
  final String answer;
  final String answerIdentifier;

  const AnswerCard({
    Key? key,
    required this.answer,
    required this.answerIdentifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var charIndex = 0;

    return Card(
      color: const Color(0xFFFF99BB),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: answerIdentifier.toChars().map((char) {
            final widget = Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                answer[charIndex],
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
  }
}
