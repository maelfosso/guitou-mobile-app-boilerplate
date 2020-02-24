import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:muitou/models/project.dart';

class ProjectApiClient {
  final _baseUrl =  'http://791e9c16.ngrok.io/api';
  
  var headers = {
    "Content-Type": "application/json; charset=utf-8",
    "Accept": "application/json"
  };

  final http.Client httpClient;

  ProjectApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<Project> fetchProject() async {
    final url = '$_baseUrl/projects/${Project.instance.id}/download';

    final response = await this.httpClient.get(url, headers: headers);
    print("\nRESPONSE");
    print(response.body);
    if (response.statusCode != 200) {
      // throw new Exception('error getting quotes');
      return null;
    }
    final json = jsonDecode(response.body);
    print("\nJSON BODY");
    print(json);
    print(Project.fromJson(json["data"]));
    print("\nRETURN ... EN PROJECT API.......");
    return Project.fromJson(json["data"]);
  }

}
