import 'package:wotla/data/models/answer_history.dart';

class TestModels {
  static const answer = 'GITA';

  static const AnswerHistory correctAnswer = AnswerHistory(
    answer: answer,
    answerIdentifier: answer,
  );

  static const AnswerHistory incorrectAnswer = AnswerHistory(
    answer: 'GABY',
    answerIdentifier: 'G+XX',
  );

  static List<AnswerHistory> get winOneTry => [correctAnswer];

  static List<AnswerHistory> get winTwoTries => [
        incorrectAnswer,
        correctAnswer,
      ];

  static List<AnswerHistory> get winThreeTries => [
        incorrectAnswer,
        incorrectAnswer,
        correctAnswer,
      ];

  static List<AnswerHistory> get winFourTries => [
        incorrectAnswer,
        incorrectAnswer,
        incorrectAnswer,
        correctAnswer,
      ];

  static List<AnswerHistory> get winFiveTries => [
        incorrectAnswer,
        incorrectAnswer,
        incorrectAnswer,
        incorrectAnswer,
        correctAnswer,
      ];

  static List<AnswerHistory> get failedGame => [
        incorrectAnswer,
        incorrectAnswer,
        incorrectAnswer,
        incorrectAnswer,
        incorrectAnswer,
      ];
}
