import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart';
import 'package:guitou/app.dart';
import 'package:guitou/models/project.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

requestWritePermission() async {
  final List<PermissionGroup> permissions = <PermissionGroup>[PermissionGroup.storage];

  final PermissionStatus statusFuture = await PermissionHandler()
      .checkPermissionStatus(PermissionGroup.storage); 
  
  if (statusFuture == PermissionStatus.granted) {
    return;
  }

  final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
      await PermissionHandler().requestPermissions(permissions);

}


Future<String> _loadProjectAsset() async {
  return await rootBundle.loadString('assets/project.json');
}

Future<Project> loadProject() async {
  String jsonString = await _loadProjectAsset();
  final jsonResponse = json.decode(jsonString);
  return new Project.fromJson(jsonResponse);
}  

Future<Widget> start() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadProject();
  print("\nLOAD PROJECT...\n");
  print(json.encode(Project.instance.xormsDetails));
  print("\nCHECK IT");

  final directory = await getApplicationDocumentsDirectory();
  final file = File("${directory.path}/${Project.instance.id}.json");

  if (await file.exists()) {
    final contents = await file.readAsString();
    final parsedJson = json.decode(contents);

    Project.object = Project.fromJson(parsedJson);
  } else {
    await file.writeAsString(json.encode(Project.instance.toJson()));
  }

  return Future<Widget>.delayed(
    new Duration(
      seconds: 2
    ), () => GuitouApp()
  );
}
