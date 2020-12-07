import 'package:equatable/equatable.dart';

abstract class UploadDataEvent extends Equatable {
  const UploadDataEvent();

  @override
  List<Object> get props => [];
}

class StartDataUpload extends UploadDataEvent {}

class DataUpload extends UploadDataEvent {}


