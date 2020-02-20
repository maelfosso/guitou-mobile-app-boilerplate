import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muitou/bloc/data_collected_event.dart';
import 'package:muitou/bloc/data_collected_state.dart';
import 'package:muitou/db/data_collected_dao.dart';

class DataCollectedBloc extends Bloc<DataCollectedEvent, DataCollectedState> {
  DataCollectedDao _dataCollectedDao = DataCollectedDao();

  @override
  DataCollectedState get initialState => DataCollectedLoading();

  @override
  Stream<DataCollectedState> mapEventToState(DataCollectedEvent event) async* {
    // TODO: implement mapEventToState
    if (event is LoadDataCollected) {
      yield DataCollectedLoading();
      yield* _reloadData();
    } else if (event is AddDataCollected) {
      await _dataCollectedDao.insertData(event.data);
      yield* _reloadData();
    } else if (event is UpdateDataCollected) {
      await _dataCollectedDao.updateData(event.data);
      yield* _reloadData();
    } else if (event is DeleteDataCollected) {
      await _dataCollectedDao.delete(event.data);
      yield* _reloadData();
    } else if (event is QueryDataCollected) {
      final data = await _dataCollectedDao.query(event.id);
      yield DataCollectedLoaded(datas: [data]);
    }
  }

  Stream<DataCollectedState> _reloadData() async* {
    final datas = await _dataCollectedDao.getAllDatas();
    yield DataCollectedLoaded(datas: datas);
  }
  
}