import 'dart:async';

import 'package:meta/meta.dart';
import 'package:guitou/db/data_collected_dao.dart';
import 'package:guitou/models/data_collected.dart';
import 'package:guitou/models/project.dart';
import 'package:guitou/repository/data_api_client.dart';
import 'package:guitou/repository/project_api_client.dart';


class DataRepository {
  final DataApiClient dataApiClient;
  final DataCollectedDao dataCollectedDao;
  final ProjectApiClient projectApiClient;

  DataRepository({
    @required this.dataApiClient, 
    @required this.dataCollectedDao,
    @required this.projectApiClient
  }) : assert(dataApiClient != null && dataCollectedDao != null && projectApiClient != null);

  Future updateData(DataCollected data) async {
    await dataCollectedDao.updateData(data);
  }
  
  Future<List<DataCollected>> getAllLocalDatas() async {
    return await dataCollectedDao.getAllLocalDatas();
  }

  Future<DataCollected> postData(DataCollected data) async {
    return await dataApiClient.postData(data);
  }

  Future<Project> downloadProject() async {
    return await projectApiClient.fetchProject();
  }
}