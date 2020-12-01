import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:bloc/bloc.dart';
import 'package:guitou/bloc/blocs.dart';
import 'package:guitou/models/models.dart';
import 'package:guitou/data_repository/data_repository.dart';

class DataCollectedBloc extends Bloc<DataCollectedEvent, DataCollectedState> {
  final DataCollectedRepository dataRepository = GetIt.I.get<DataCollectedRepository>();

  DataCollectedBloc() : super(DataCollectedLoadInProgress()); 

  @override
  Stream<DataCollectedState> mapEventToState(DataCollectedEvent event) async* {
    if (event is DataCollectedLoad) {
      yield* _mapDataCollectedLoadedToState();
    } else if (event is DataCollectedAdded) {
      yield* _mapDataCollectedAddedToState(event);
    } else if (event is DataCollectedUpdated) {
      yield* _mapDataCollectedUpdatedToState(event);
    } else if (event is DataCollectedDeleted) {
      yield* _mapDataCollectedDeletedToState(event);
    } else if (event is ToggleAll) {
      yield* _mapToggleAllToState();
    } else if (event is ClearCompleted) {
      yield* _mapClearCompletedToState();
    }
  }

  Stream<DataCollectedState> _mapDataCollectedLoadedToState() async* {
    try {
      // print('\nLOADING DATA');
      final data = await this.dataRepository.getAllDataCollected();
      // print('\nLOADEEEDDD DATA $data');
      yield DataCollectedLoadSuccess(data);
    } catch (_) {
      yield DataCollectedLoadFailure();
    }
  }

  Stream<DataCollectedState> _mapDataCollectedAddedToState(DataCollectedAdded event) async* {
    if (state is DataCollectedLoadSuccess) {
      final result = await this.dataRepository.insertDataCollected(event.data);
      final List<DataCollected> updatedDataCollected = List.from((state as DataCollectedLoadSuccess).data)
        ..add(event.data.copyWith(id: result));

      yield DataCollectedLoadSuccess(updatedDataCollected);
    }
  }

  Stream<DataCollectedState> _mapDataCollectedUpdatedToState(DataCollectedUpdated event) async* {
    print('\n_mapDataCollectedUpdatedToState .... ${event.data} --- $state');
    if (state is DataCollectedLoadSuccess) {
      print('\nInto mapDataCollectedUpdatedToState');
      final List<DataCollected> updatedDataCollected = (state as DataCollectedLoadSuccess).data.map((data) {
        return data.id == event.data.id ? event.data : data;
      }).toList();
      print('\nLOCAL UPDATE $updatedDataCollected');
      
      this.dataRepository.updateDataCollected(event.data);
      yield DataCollectedLoadSuccess(updatedDataCollected);
    }
    print('\nEnd of mapDataCollectedUpdatedToState');
  }

  Stream<DataCollectedState> _mapDataCollectedDeletedToState(DataCollectedDeleted event) async* {
    if (state is DataCollectedLoadSuccess) {
      final updatedDataCollected = (state as DataCollectedLoadSuccess)
          .data
          .where((data) => data.id != event.data.id)
          .toList();
      this.dataRepository.deleteDataCollected(event.data.id);
      yield DataCollectedLoadSuccess(updatedDataCollected);
    }
  }

  Stream<DataCollectedState> _mapToggleAllToState() async* {

  }

  Stream<DataCollectedState> _mapClearCompletedToState() async* {
  }

}