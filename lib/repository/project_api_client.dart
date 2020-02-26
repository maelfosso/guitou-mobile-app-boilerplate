import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:muitou/models/project.dart';

class ProjectApiClient {
  final _baseUrl =  'http://ef76c6d0.ngrok.io/api';
  
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
    print("\nFETCH PROJECT.... $url");
    final response = await this.httpClient.get(url, headers: headers);
    print(response);
    final statusCode = response.statusCode;
    print("STATUS CODE ... $statusCode");

    if (statusCode < 200 || statusCode > 400) { //} || body == null || body['success'] != true) {
      print("EXCEPTION ... ");
      // throw new Exception("Error while fetching data");
      return null;
    }

    // final body = jsonDecode(response.body);

    print("\nRESPONSE");
    print(response.body);
    // if (response.statusCode != 200) {
    //   // throw new Exception('error getting quotes');
    //   return null;
    // }
    final json = jsonDecode(response.body);
    print("\nJSON BODY");
    print(json);
    print(Project.fromJson(json["data"]));
    print("\nRETURN ... EN PROJECT API.......");
    return Project.fromJson(json["data"]);
  }

}
