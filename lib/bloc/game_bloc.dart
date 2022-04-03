import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wotla/bloc/game_event.dart';
import 'package:wotla/bloc/game_state.dart';
import 'package:wotla/data/data_source.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final DataSource _dataSource;

  GameBloc(DataSource dataSource)
      : _dataSource = dataSource,
        super(const GameState()) {
    on<InputChanged>((event, emit) {
      emit(state.copyWith(answer: event.answer.toUpperCase()));
    });
  }
}
