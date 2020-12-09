import 'dart:async';

import 'package:meta/meta.dart';
import 'package:guitou/models/data_collected.dart';
import 'package:guitou/models/project.dart';
import 'package:guitou/repository/data_api_client.dart';
import 'package:guitou/repository/project_api_client.dart';


class DataApi {
  final DataApiClient dataApiClient;
  final ProjectApiClient projectApiClient;

  DataApi({
    @required this.dataApiClient, 
    @required this.projectApiClient
  }) : assert(dataApiClient != null && projectApiClient != null);

  Future<DataCollected> postData(DataCollected data) async {
    return await dataApiClient.postData(data);
  }

  Future<Project> downloadProject() async {
    return await projectApiClient.fetchProject();
  }
}