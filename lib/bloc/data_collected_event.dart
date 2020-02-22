
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:muitou/models/data_collected.dart';

@immutable
abstract class DataCollectedEvent extends Equatable {
  const DataCollectedEvent();

  @override
  List<Object> get props => [];
}

class LoadDataCollected extends DataCollectedEvent {}

class AddDataCollected extends DataCollectedEvent {
  final DataCollected data;

  const AddDataCollected({@required this.data});

  @override
  List<Object> get props => [this.data];
}

class UpdateDataCollected extends DataCollectedEvent {
  final DataCollected data;

  const UpdateDataCollected({@required this.data});

  @override
  List<Object> get props => [this.data];
}

class DeleteDataCollected extends DataCollectedEvent {
  final DataCollected data;

  const DeleteDataCollected({@required this.data});

  @override
  List<Object> get props => [this.data];
}

class QueryDataCollected extends DataCollectedEvent {
  final int id;

  const QueryDataCollected({@required this.id});

  @override
  List<Object> get props => [this.id];
}

class UploadDataCollected extends DataCollectedEvent {}

class RemoteUpdateDataCollected extends DataCollectedEvent {
  final DataCollected data;

  const RemoteUpdateDataCollected({@required this.data});

  @override
  List<Object> get props => [this.data];
}

class RemoteAddDataCollected extends DataCollectedEvent {
  final DataCollected data;

  const RemoteAddDataCollected({@required this.data});

  @override
  List<Object> get props => [this.data];
}

class EndUploadingLocalData extends DataCollectedEvent {}


