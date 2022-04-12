import 'package:flutter/material.dart';

class StatisticText extends StatelessWidget {
  final String value;
  final String label;

  const StatisticText({
    Key? key,
    required this.value,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value),
        Text(
          label,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
