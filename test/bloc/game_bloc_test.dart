import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wotla/bloc/game_bloc.dart';
import 'package:wotla/bloc/game_event.dart';
import 'package:wotla/bloc/game_state.dart';
import 'package:wotla/data/data_source.dart';

class MockDataSource extends Mock implements DataSource {}

void main() {
  late DataSource dataSource;
  late GameBloc bloc;

  setUp(() {
    dataSource = MockDataSource();
    bloc = GameBloc(dataSource);
  });

  blocTest<GameBloc, GameState>(
    'emit valid state '
    'when InputChanged event is added',
    build: () => bloc,
    act: (bloc) => bloc.add(const InputChanged('answer')),
    expect: () => [
      const GameState(answer: 'ANSWER'),
    ],
  );
}
