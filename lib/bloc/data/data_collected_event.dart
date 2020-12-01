import 'package:equatable/equatable.dart';
import 'package:guitou/models/models.dart';

abstract class DataCollectedEvent extends Equatable {
  const DataCollectedEvent();

  @override
  List<Object> get props => [];
}

class DataCollectedLoad extends DataCollectedEvent {}

class DataCollectedAdded extends DataCollectedEvent {
  final DataCollected data;

  const DataCollectedAdded(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'DataCollectedAdded { data: $data }';
}

class DataCollectedUpdated extends DataCollectedEvent {
  final DataCollected data;

  const DataCollectedUpdated(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'DataCollectedUpdated { data: $data }';
}

class DataCollectedDeleted extends DataCollectedEvent {
  final DataCollected data;

  const DataCollectedDeleted(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'DataCollectedDeleted { data: $data }';
}

class ClearCompleted extends DataCollectedEvent {}

class ToggleAll extends DataCollectedEvent {}
