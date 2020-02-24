import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muitou/bloc/data_collected_event.dart';
import 'package:muitou/bloc/data_collected_state.dart';
import 'package:muitou/db/data_collected_dao.dart';
import 'package:muitou/models/project.dart';
import 'package:muitou/repository/data_repository.dart';
import 'package:path_provider/path_provider.dart';

class DataCollectedBloc extends Bloc<DataCollectedEvent, DataCollectedState> {
  DataCollectedDao _dataCollectedDao = DataCollectedDao();

  final DataRepository repository;

  DataCollectedBloc({@required this.repository}) : assert(repository != null);

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
    } else if (event is UploadDataCollected) {
      final datas = await repository.getAllLocalDatas();
      yield StartUploadingLocalData(datas: datas);
    } else if (event is RemoteAddDataCollected) {
      final data = await repository.postData(event.data);
      
      await repository.updateData(data);
      yield SuccessRemoteAddDataCollected(data: data);
    }
    if (event is EndUploadingLocalData) {
      yield DataCollectedLoading();
      yield* _reloadData();
    }

    if (event is DownloadProject) {
      print("BLOC... DOWNLOAD PROJECT...");
      final project = await repository.downloadProject();
      print("\nREPOSITORY .. PROJECT... ");
      print(project.toJson());
      print("DOWNLOADED PROJECT...");
      if (project == null) {
        print("DOWNLOADED PROJECT...FAILED");
        yield DownloadProjectFailed();
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File("${directory.path}/${Project.instance.id}.json");

        Project.object = project;
        await file.writeAsString(json.encode(Project.instance.toJson()));
        
        print("DOWNLOADED PROJECT... SUCCESSSS");

        yield DownloadProjectSuccess();
      }
    }
  }

  Stream<DataCollectedState> _reloadData() async* {
    final datas = await _dataCollectedDao.getAllDatas();
    yield DataCollectedLoaded(datas: datas);
  }
  
}