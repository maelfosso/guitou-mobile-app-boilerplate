
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:guitou/models/project.dart';
import 'package:location/location.dart';
import 'package:guitou/db/app_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:sembast/sembast.dart';
import 'package:guitou/repository/repository.dart';

class Init {
  static Future initialize() async {
    debugPrint('\nInit initialize....\n');

    await loadProject();
    debugPrint("loadProject()"); // : ${json.encode(Project.instance.xormsDetails)}");
    
    await _initSembast();
    debugPrint('\n_initSembast()');
    _registerRepositories();
    debugPrint('\nregisterRepositories()');
    await _enabledLocationService();
    debugPrint('\n_enabledLocationService()');

    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('\nWidgetFlutterBinding.ensureInitialized()');

    // bool permissionGranted = await requestWritePermission();
    // if (!permissionGranted) {
    //   return null;
    // }


    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/${Project.instance.id}.json");

    if (await file.exists()) {
      final contents = await file.readAsString();
      final parsedJson = json.decode(contents);

      Project.object = Project.fromJson(parsedJson);
    } else {
      await file.writeAsString(json.encode(Project.instance.toJson()));
    }
  }

  static Future _initSembast() async {
    final database = await AppDatabase.instance.database;
    debugPrint("\nAppDatabase.instance.database...$database");
    GetIt.I.registerSingleton<Database>(database);
    debugPrint("_initSembast is OK");
  }

  static _registerRepositories(){
    debugPrint("starting registering repositories");
    GetIt.I.registerLazySingleton<DataRepository>(() => LocalDataRepository()); 
    debugPrint("finished registering repositories");
  }

  static _enabledLocationService() async {
    Location location = Location();

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

  }

  static Future<bool> requestWritePermission() async {
    // final List<ph.PermissionGroup> permissions = <ph.PermissionGroup>[ph.PermissionGroup.storage];

    // final ph.PermissionStatus statusFuture = await ph.PermissionHandler()
    //     .checkPermissionStatus(ph.PermissionGroup.storage); 
    
    // if (statusFuture == ph.PermissionStatus.granted) {
    //   return true;
    // } else {
    //   final Map<ph.PermissionGroup, ph.PermissionStatus> permissionRequestResult =
    //     await ph.PermissionHandler().requestPermissions(permissions);

    //   return permissionRequestResult[ph.PermissionGroup.storage] == ph.PermissionStatus.granted;
    // }

  }

  static Future<String> _loadProjectAsset() async {
    return await rootBundle.loadString('assets/project.json');
  }

  static Future loadProject() async {
    String jsonString = await _loadProjectAsset();
    final jsonResponse = json.decode(jsonString);
    // debugPrint("\nLOAD PROJECT FROM ASSET ... $jsonResponse");
    // Project.instance.
    return Project.fromJson(jsonResponse);
  }  

  // Future<Widget> start() async {
  //   // WidgetsFlutterBinding.ensureInitialized();

  //   // bool permissionGranted = await requestWritePermission();
  //   // if (!permissionGranted) {
  //   //   return null;
  //   // }

  //   // await loadProject();
  //   // debugPrint("\nLOAD PROJECT...\n");
  //   // debugPrint(json.encode(Project.instance.xormsDetails));
  //   // debugPrint("\nCHECK IT");

  //   // final directory = await getApplicationDocumentsDirectory();
  //   // final file = File("${directory.path}/${Project.instance.id}.json");

  //   // if (await file.exists()) {
  //   //   final contents = await file.readAsString();
  //   //   final parsedJson = json.decode(contents);

  //   //   Project.object = Project.fromJson(parsedJson);
  //   // } else {
  //   //   await file.writeAsString(json.encode(Project.instance.toJson()));
  //   // }

  //   return Future<Widget>.delayed(
  //     new Duration(
  //       seconds: 2
  //     ), () => GuitouApp()
  //   );
  // }

}
