import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:guitou/models/project.dart';

class ProjectApiClient {
  final String baseUrl;
  
  var headers = {
    "Content-Type": "application/json; charset=utf-8",
    "Accept": "application/json"
  };

  final http.Client httpClient;

  ProjectApiClient({
    @required this.baseUrl,
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<Project> fetchProject() async {
    final url = '$baseUrl/xorms/${Project.instance.id}/download';
    debugPrint("\nFETCH PROJECT.... $url");
    final response = await this.httpClient.get(Uri.parse(url), headers: headers);
    debugPrint(response.toString());
    final statusCode = response.statusCode;
    debugPrint("STATUS CODE ... $statusCode");

    if (statusCode < 200 || statusCode > 400) { //} || body == null || body['success'] != true) {
      debugPrint("EXCEPTION ... ");
      // throw new Exception("Error while fetching data");
      return null;
    }

    // final body = jsonDecode(response.body);

    debugPrint("\nRESPONSE");
    debugPrint(response.body);
    // if (response.statusCode != 200) {
    //   // throw new Exception('error getting quotes');
    //   return null;
    // }
    final json = jsonDecode(response.body);
    debugPrint("\nJSON BODY");
    debugPrint(json);
    debugPrint(Project.fromJson(json["data"]).toString());
    debugPrint("\nRETURN ... EN PROJECT API.......");
    return Project.fromJson(json["data"]);
  }

}
