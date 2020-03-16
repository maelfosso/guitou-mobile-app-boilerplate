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

  // ServiceStatus serviceStatus 
  final PermissionStatus statusFuture = await PermissionHandler()
      .checkPermissionStatus(PermissionGroup.storage);

  print("\nCheck permission status...");
  print(statusFuture);

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
  print("\nDIRECTORY : ${directory.path}\n");

  if (await file.exists()) {
    print("\nTHE FILE EXISTS....");
    final contents = await file.readAsString();
    final parsedJson = json.decode(contents);

    Project.object = Project.fromJson(parsedJson);
    print(Project.instance.toJson());
  } else {
    print(json.encode(Project.instance.toJson()));
    await file.writeAsString(json.encode(Project.instance.toJson()));
  }

  return Future<Widget>.delayed(
    new Duration(
      seconds: 2
    ), () => GuitouApp()
  );
}
