import 'package:equatable/equatable.dart';
import 'package:tracer/blocs/upload_data/upload_data.dart';

abstract class UploadDataEvent extends Equatable {
  const UploadDataEvent();

  @override
  List<Object> get props => [];
}

class StartDataUpload extends UploadDataEvent {}

class DataUpload extends UploadDataEvent {}


