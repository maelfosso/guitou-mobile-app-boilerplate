import 'dart:core';
import 'dart:convert';

import 'package:muitou/db/app_database.dart';
import 'package:muitou/models/data_collected.dart';
import 'package:sembast/sembast.dart';

class DataCollectedDao {
  static const String folderName = "Datas";
  // final _datasFolder = StoreRef<int, Map<String, Map<String, dynamic>>>.main(); // intMapStoreFactory.store(folderName);
  final _datasFolder = intMapStoreFactory.store(folderName);

  Future<Database> get  _db  async => await AppDatabase.instance.database;

  Future insertData(DataCollected data) async {
    print('Data Insert start... !! \n' + data.toJson().toString());

    int key = await  _datasFolder.add(await _db, data.toSave() );
    print('Data Inserted successfully !! $key');
  }

  Future updateData(DataCollected data) async{
    final finder = Finder(filter: Filter.byKey(data.id));
    await _datasFolder.update(await _db, data.toJson(), finder: finder);
  }

  Future delete(DataCollected data) async{
    final finder = Finder(filter: Filter.byKey(data.id));
    await _datasFolder.delete(await _db, finder: finder);
  }

  Future<List<DataCollected>> getAllDatas()async{
    final recordSnapshot = await _datasFolder.find(await _db);
    return recordSnapshot.map((snapshot){
      final data = DataCollected.fromJson(snapshot.value);
      data.id = snapshot.key;

      return data;
    }).toList();
  }

}