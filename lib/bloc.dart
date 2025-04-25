import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_counter_app/event.dart';
import 'package:space_counter_app/state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<LaunchRocket>((event, emit) {
      emit(CounterState(state.rocketCount + 1));
    });
    
    on<LandRocket>((event, emit) {
      if (state.rocketCount > 0) {
        emit(CounterState(state.rocketCount - 1));
      }
    });
    
    on<ResetRockets>((event, emit) {
      emit(const CounterState(0));
    });
  }
}