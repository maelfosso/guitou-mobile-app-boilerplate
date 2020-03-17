import 'dart:core';

import 'package:guitou/db/app_database.dart';
import 'package:guitou/models/data_collected.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';

class DataCollectedDao {
  static const String folderName = "Datas";
  final _datasFolder = intMapStoreFactory.store(folderName);

  Future<Database> get  _db  async => await AppDatabase.instance.database;

  Future insertData(DataCollected data) async {
    await  _datasFolder.add(await _db, data.toSave() );
  }

  Future updateData(DataCollected data) async{
    final finder = Finder(filter: Filter.byKey(data.id));
    await _datasFolder.update(await _db, data.toJson(), finder: finder);
  }

  Future delete(DataCollected data) async{
    data.dataLocation = "local";
    final finder = Finder(filter: Filter.byKey(data.id) );
    await _datasFolder.delete(await _db, finder: finder);
  }

  Future<List<DataCollected>> getAllLocalDatas()async{
    final finder = Finder(filter: Filter.equals("dataLocation", "local") );
    final recordSnapshot = await _datasFolder.find(await _db, finder: finder);
    return recordSnapshot.map((snapshot){

      final data = DataCollected.fromJson(cloneMap(snapshot.value));
      data.id = snapshot.key;

      return data;
    }).toList();
  }

  Future<List<DataCollected>> getAllDatas()async{

    final recordSnapshot = await _datasFolder.find(await _db);
    return recordSnapshot.map((snapshot){

      final data = DataCollected.fromJson(cloneMap(snapshot.value));
      data.id = snapshot.key;

      return data;
    }).toList();
  }

  Future<DataCollected> query(int id) async {
    final finder = Finder(filter: Filter.byKey(id));
    final recordSnapshot = await _datasFolder.findFirst(await _db, finder: finder);

    final data = DataCollected.fromJson(cloneMap(recordSnapshot.value));
    data.id = recordSnapshot.key;

    return data;
  }

}