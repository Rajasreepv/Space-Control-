// counter_event.dart
import 'package:equatable/equatable.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();
  
  @override
  List<Object> get props => [];
}

class LaunchRocket extends CounterEvent {}
class LandRocket extends CounterEvent {}
class ResetRockets extends CounterEvent {}