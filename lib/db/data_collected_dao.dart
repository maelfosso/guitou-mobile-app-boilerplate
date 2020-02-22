import 'dart:core';
import 'dart:convert';

import 'package:muitou/db/app_database.dart';
import 'package:muitou/models/data_collected.dart';
import 'package:sembast/sembast.dart';

class DataCollectedDao {
  static const String folderName = "Datas";
  final _datasFolder = intMapStoreFactory.store(folderName);

  Future<Database> get  _db  async => await AppDatabase.instance.database;

  Future insertData(DataCollected data) async {
    print("\nIN DATA - DAO - INSERT....");
    print(data.toSave());
    print(data.toJson());
    await  _datasFolder.add(await _db, data.toSave() );
  }

  Future updateData(DataCollected data) async{
    final finder = Finder(filter: Filter.byKey(data.id));
    print("\nIN DATA - DAO ... " + finder.toString()); 
    print(data.toJson());
    await _datasFolder.update(await _db, data.toJson(), finder: finder);
  }

  Future delete(DataCollected data) async{
    final finder = Finder(filter: Filter.byKey(data.id) );
    await _datasFolder.delete(await _db, finder: finder);
  }

  Future<List<DataCollected>> getAllLocalDatas()async{
    final finder = Finder(filter: Filter.equals("dataLocation", "local") );
    final recordSnapshot = await _datasFolder.find(await _db, finder: finder);
    return recordSnapshot.map((snapshot){

      final data = DataCollected.fromJson(snapshot.value);
      data.id = snapshot.key;

      return data;
    }).toList();
  }

  Future<List<DataCollected>> getAllDatas()async{

    final recordSnapshot = await _datasFolder.find(await _db);
    return recordSnapshot.map((snapshot){

      final data = DataCollected.fromJson(snapshot.value);
      data.id = snapshot.key;

      return data;
    }).toList();
  }

  Future<DataCollected> query(int id) async {
    final finder = Finder(filter: Filter.byKey(id));
    final recordSnapshot = await _datasFolder.findFirst(await _db, finder: finder);

    final data = DataCollected.fromJson(recordSnapshot.value);
    data.id = recordSnapshot.key;

    return data;
  }

}