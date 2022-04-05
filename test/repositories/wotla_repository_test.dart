import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wotla/data/models/answer_history.dart';
import 'package:wotla/data/models/user_daily_record.dart';
import 'package:wotla/data/models/user_records.dart';
import 'package:wotla/data/repositories/date_repository.dart';
import 'package:wotla/data/repositories/wotla_repository.dart';

class MockSharedPrefs extends Mock implements WotlaSharedPreferences {}

class MockDateRepository extends Mock implements DateRepository {}

class FakeUserRecords extends Fake implements UserRecords {}

void main() {
  group('WotlaRepository', () {
    late WotlaSharedPreferences sharedPreferences;
    late DateRepository dateRepository;
    late WotlaRepository repository;

    final today = DateTime(2022, 4, 4);
    final UserDailyRecord dailyRecord = UserDailyRecord(
      date: today,
      histories: const [
        AnswerHistory(
          answer: 'GITA',
          answerIdentifier: 'GITA',
        ),
      ],
      correct: true,
      correctAnswer: 'GITA',
    );
    final UserDailyRecord yesterdayDailyRecord = UserDailyRecord(
      date: today.subtract(const Duration(days: 1)),
      histories: const [
        AnswerHistory(
          answer: 'GITA',
          answerIdentifier: 'GITA',
        ),
      ],
      correct: true,
      correctAnswer: 'GITA',
    );
    final UserRecords userRecords = UserRecords({
      yesterdayDailyRecord.date.toIso8601String(): yesterdayDailyRecord,
      dailyRecord.date.toIso8601String(): dailyRecord,
    });

    setUp(() {
      sharedPreferences = MockSharedPrefs();
      dateRepository = MockDateRepository();
      repository = WotlaRepository(sharedPreferences, dateRepository);

      when(() => dateRepository.today).thenReturn(today);
    });

    setUpAll(() {
      registerFallbackValue(FakeUserRecords());
    });

    test(
      'read user records '
      'when readUserRecords '
      'and returns null',
      () async {
        // arrange
        when(() => sharedPreferences.readUserRecords())
            .thenAnswer((_) async => null);
        // act
        final result = await repository.readUserRecords();
        // assert
        verify(() => sharedPreferences.readUserRecords()).called(1);
        expect(result, null);
      },
    );

    test(
      'read user records '
      'when readUserRecords '
      'and returns data',
      () async {
        // arrange
        when(() => sharedPreferences.readUserRecords())
            .thenAnswer((_) async => userRecords);
        // act
        final result = await repository.readUserRecords();
        // assert
        verify(() => sharedPreferences.readUserRecords()).called(1);
        expect(result, userRecords);
      },
    );

    test(
      'read user today records '
      'when readTodayRecord '
      'and returns null',
      () async {
        // arrange
        when(() => sharedPreferences.readUserRecords())
            .thenAnswer((_) async => null);
        // act
        final result = await repository.readTodayRecord();
        // assert
        verify(() => sharedPreferences.readUserRecords()).called(1);
        expect(result, null);
      },
    );

    test(
      'read user today records '
      'when readTodayRecord '
      'and returns data',
      () async {
        // arrange
        when(() => sharedPreferences.readUserRecords())
            .thenAnswer((_) async => userRecords);
        // act
        final result = await repository.readTodayRecord();
        // assert
        verify(() => sharedPreferences.readUserRecords()).called(1);
        expect(result, dailyRecord);
      },
    );

    test(
      'read user today records '
      'when readTodayRecord '
      'and returns data without today record',
      () async {
        // arrange
        when(() => sharedPreferences.readUserRecords()).thenAnswer((_) async =>
            UserRecords({
              yesterdayDailyRecord.date.toIso8601String(): yesterdayDailyRecord
            }));
        // act
        final result = await repository.readTodayRecord();
        // assert
        verify(() => sharedPreferences.readUserRecords()).called(1);
        expect(result, null);
      },
    );

    test(
      'save user records for the first time '
      'when saveTodayRecord called '
      'and first answer is correct',
      () async {
        // arrange
        when(() => sharedPreferences.readUserRecords())
            .thenAnswer((_) async => null);
        when(() => sharedPreferences.saveTodayRecord(
                UserRecords({dailyRecord.date.toIso8601String(): dailyRecord})))
            .thenAnswer((invocation) => Future.value());
        // act
        await repository.saveTodayRecord(dailyRecord);
        // assert
        verify(() => sharedPreferences.readUserRecords()).called(1);
        verify(() => sharedPreferences.saveTodayRecord(
                UserRecords({dailyRecord.date.toIso8601String(): dailyRecord})))
            .called(1);
      },
    );

    test(
      'save user records '
      'when saveTodayRecord called '
      'and second answer is correct',
      () async {
        // arrange
        final secondAttempt = UserDailyRecord(
          date: today,
          histories: const [
            AnswerHistory(
              answer: 'GABY',
              answerIdentifier: 'G+XX',
            ),
            AnswerHistory(
              answer: 'GITA',
              answerIdentifier: 'GITA',
            ),
          ],
          correct: true,
          correctAnswer: 'GITA',
        );
        when(() => sharedPreferences.readUserRecords())
            .thenAnswer((_) async => userRecords);
        when(() => sharedPreferences.saveTodayRecord(any()))
            .thenAnswer((invocation) => Future.value());
        // act
        await repository.saveTodayRecord(secondAttempt);
        // assert
        verify(() => sharedPreferences.readUserRecords()).called(1);
        verify(
          () => sharedPreferences.saveTodayRecord(
            UserRecords({
              yesterdayDailyRecord.date.toIso8601String(): yesterdayDailyRecord,
              secondAttempt.date.toIso8601String(): secondAttempt,
            }),
          ),
        ).called(1);
      },
    );

    test(
      'save user records '
      'when saveTodayRecord called '
      'and this is the second day',
      () async {
        // arrange
        final secondAttempt = UserDailyRecord(
          date: today,
          histories: const [
            AnswerHistory(
              answer: 'GABY',
              answerIdentifier: 'G+XX',
            ),
            AnswerHistory(
              answer: 'GITA',
              answerIdentifier: 'GITA',
            ),
          ],
          correct: true,
          correctAnswer: 'GITA',
        );
        when(() => sharedPreferences.readUserRecords())
            .thenAnswer((_) async => userRecords);
        when(() => sharedPreferences.saveTodayRecord(any()))
            .thenAnswer((invocation) => Future.value());
        // act
        await repository.saveTodayRecord(secondAttempt);
        // assert
        verify(() => sharedPreferences.readUserRecords()).called(1);
        verify(
          () => sharedPreferences.saveTodayRecord(
            UserRecords({
              yesterdayDailyRecord.date.toIso8601String(): yesterdayDailyRecord,
              dailyRecord.date.toIso8601String(): dailyRecord,
              secondAttempt.date.toIso8601String(): secondAttempt,
            }),
          ),
        ).called(1);
      },
    );
  });
}
