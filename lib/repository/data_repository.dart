import 'dart:async';

import 'package:meta/meta.dart';
import 'package:muitou/db/data_collected_dao.dart';
import 'package:muitou/models/data_collected.dart';
import 'package:muitou/models/project.dart';
import 'package:muitou/repository/data_api_client.dart';
import 'package:muitou/repository/project_api_client.dart';


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