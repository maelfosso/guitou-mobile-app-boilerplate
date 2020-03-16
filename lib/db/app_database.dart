import 'dart:async';
import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

import '../models/project.dart';

class AppDatabase{

  static final AppDatabase _singleton = AppDatabase._();


  static AppDatabase get instance => _singleton;

  // Completer is used for transforming synchronous code into asynchronous code.
  // Completer<Database> _dbOpenCompleter;

  Database _database;

  // A private constructor. Allows us to create instances of AppDatabase
  // only from within the AppDatabase class itself.
  AppDatabase._();

  // Database object accessor
  Future<Database> get database async {
  // Database get database async {
    // If completer is null, AppDatabaseClass is newly instantiated, so database is not yet opened
    // if (_dbOpenCompleter == null) {
    //   _dbOpenCompleter = Completer();
    //   // Calling _openDatabase will also complete the completer with database instance
    //   _openDatabase();
    // }
    if (_database == null) {
      // _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance
      _database = await _openDatabase();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    // return _dbOpenCompleter.future;
    return _database;
  }

  Future<Database> _openDatabase() async {
    // Get a platform-specific directory where persistent app data can be stored
    final externalPublicDirectory = await ExtStorage.getExternalStorageDirectory();
    var folder = Directory("$externalPublicDirectory/Guitou/Databases");
    if (await folder.exists()) {
    } else {
      folder = await folder.create(recursive: true);
    }
    // final appDocumentDir = await getApplicationDocumentsDirectory();
    // Path with the form: /platform-specific-directory/demo.db


    final dbPath = join(folder.path, 'Guitou_' + Project.instance.id + '.db');


    final database = await databaseFactoryIo.openDatabase(dbPath);


    // Any code awaiting the Completer's future will now start executing
    // _dbOpenCompleter.complete(database);
    return database;
  }
}