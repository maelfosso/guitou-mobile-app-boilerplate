import 'package:equatable/equatable.dart';
import 'package:guitou/models/models.dart';

abstract class DataCollectedState extends Equatable {
  const DataCollectedState();

  @override
  List<Object> get props => [];
}

class DataCollectedLoadInProgress extends DataCollectedState {}

class DataCollectedLoadSuccess extends DataCollectedState {
  final List<DataCollected> data;

  const DataCollectedLoadSuccess([this.data = const []]);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'DataCollectedLoadSuccess { data: $data }';
}

class DataCollectedLoadFailure extends DataCollectedState {}
