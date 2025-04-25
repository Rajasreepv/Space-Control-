import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  final int rocketCount;
  
  const CounterState(this.rocketCount);
  
  @override
  List<Object> get props => [rocketCount];
}