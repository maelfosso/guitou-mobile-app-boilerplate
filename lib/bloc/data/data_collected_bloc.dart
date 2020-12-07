import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:bloc/bloc.dart';
import 'package:guitou/bloc/blocs.dart';
import 'package:guitou/models/models.dart';
import 'package:guitou/repository/repository.dart';

class DataCollectedBloc extends Bloc<DataCollectedEvent, DataCollectedState> {
  final DataRepository dataRepository = GetIt.I.get<DataRepository>();

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
    }
  }

  Stream<DataCollectedState> _mapDataCollectedLoadedToState() async* {
    try {
      // debugPrint('\nLOADING DATA');
      final data = await this.dataRepository.getAllData();
      // debugPrint('\nLOADEEEDDD DATA $data');
      yield DataCollectedLoadSuccess(data);
    } catch (_) {
      yield DataCollectedLoadFailure();
    }
  }

  Stream<DataCollectedState> _mapDataCollectedAddedToState(DataCollectedAdded event) async* {
    if (state is DataCollectedLoadSuccess) {
      final result = await this.dataRepository.insertData(event.data);
      final List<DataCollected> updatedDataCollected = List.from((state as DataCollectedLoadSuccess).data)
        ..add(event.data.copyWith(id: result));

      yield DataCollectedLoadSuccess(updatedDataCollected);
    }
  }

  Stream<DataCollectedState> _mapDataCollectedUpdatedToState(DataCollectedUpdated event) async* {
    debugPrint('\n_mapDataCollectedUpdatedToState .... ${event.data} --- $state');
    if (state is DataCollectedLoadSuccess) {
      debugPrint('\nInto mapDataCollectedUpdatedToState');
      final List<DataCollected> updatedDataCollected = (state as DataCollectedLoadSuccess).data.map((data) {
        return data.id == event.data.id ? event.data : data;
      }).toList();
      debugPrint('\nLOCAL UPDATE $updatedDataCollected');
      
      this.dataRepository.updateData(event.data);
      yield DataCollectedLoadSuccess(updatedDataCollected);
    }
    debugPrint('\nEnd of mapDataCollectedUpdatedToState');
  }

  Stream<DataCollectedState> _mapDataCollectedDeletedToState(DataCollectedDeleted event) async* {
    if (state is DataCollectedLoadSuccess) {
      final updatedDataCollected = (state as DataCollectedLoadSuccess)
          .data
          .where((data) => data.id != event.data.id)
          .toList();
      this.dataRepository.deleteData(event.data.id);
      yield DataCollectedLoadSuccess(updatedDataCollected);
    }
  }

}