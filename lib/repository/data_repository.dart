import 'dart:async';

import 'package:meta/meta.dart';
import 'package:muitou/db/data_collected_dao.dart';
import 'package:muitou/models/data_collected.dart';
import 'package:muitou/repository/data_api_client.dart';


class DataRepository {
  final DataApiClient dataApiClient;
  final DataCollectedDao dataCollectedDao;

  DataRepository({
    @required this.dataApiClient, 
    @required this.dataCollectedDao
  }) : assert(dataApiClient != null && dataCollectedDao != null);

  Future updateData(DataCollected data) async {
    await dataCollectedDao.updateData(data);
  }
  
  Future<List<DataCollected>> getAllLocalDatas() async {
    return await dataCollectedDao.getAllLocalDatas();
  }

  Future<DataCollected> postData(DataCollected data) async {
    return await dataApiClient.postData(data);
  }

}