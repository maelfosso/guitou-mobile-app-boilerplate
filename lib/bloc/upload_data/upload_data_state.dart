import 'package:equatable/equatable.dart';
import 'package:tracer/blocs/upload_data/upload_data.dart';
import 'package:tracer/data_repository/data_entity.dart';
import 'package:tracer/models/data.dart';

abstract class UploadDataState extends Equatable {
  const UploadDataState();

  @override
  List<Object> get props => [];
}

class DataUploadInProgress extends UploadDataState {}

class DataUploadStarted extends UploadDataState {
  final int total;

  const DataUploadStarted([this.total = 0]);
  
  @override
  List<Object> get props => [total];

  @override
  String toString() => 'DataUploadStarted { data: $total }';
}

class DataUploadEnded extends UploadDataState {}

class DataUploadedSuccess extends UploadDataState {
  final DataEntity data;

  const DataUploadedSuccess(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'DataUploadedSuccess { data: $data }';
}

class DataUploadedFailure extends UploadDataState {}


