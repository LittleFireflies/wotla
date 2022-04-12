import 'package:flutter/material.dart';

class AnswerDistributionBar extends StatelessWidget {
  final double ratio;
  final String label;
  final String value;

  const AnswerDistributionBar({
    Key? key,
    required this.ratio,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label),
          const SizedBox(width: 8),
          Expanded(
            child: FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: ratio,
              child: Container(
                color: Colors.blueGrey,
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
