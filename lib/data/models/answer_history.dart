import 'package:equatable/equatable.dart';

class AnswerHistory extends Equatable {
  final String answer;
  final String answerIdentifier;

  const AnswerHistory({
    required this.answer,
    required this.answerIdentifier,
  });

  @override
  List<Object?> get props => [answer, answerIdentifier];
}
