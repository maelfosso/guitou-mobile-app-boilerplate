
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:muitou/models/data_collected.dart';

@immutable
abstract class DataCollectedState extends Equatable {
  const DataCollectedState();

  @override
  List<Object> get props => [];
}

class DataCollectedLoading extends DataCollectedState {}

class DataCollectedLoaded extends DataCollectedState {
  final List<DataCollected> datas;

  const DataCollectedLoaded({@required this.datas});

  @override
  List<Object> get props => [datas];
}

class StartUploadingLocalData extends DataCollectedState {
  final List<DataCollected> datas;

  const StartUploadingLocalData({@required this.datas});

  @override
  List<Object> get props => [datas];
}

class SuccessRemoteAddDataCollected extends DataCollectedState {
  final DataCollected data;

  const SuccessRemoteAddDataCollected({@required this.data});

  @override
  List<Object> get props => [this.data];
}

class DownloadProjectSuccess extends DataCollectedState {}
class DownloadProjectFailed extends DataCollectedState {}
