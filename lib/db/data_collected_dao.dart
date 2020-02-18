import 'package:muitou/db/app_database.dart';
import 'package:muitou/models/data_collected.dart';
import 'package:sembast/sembast.dart';

class DataCollectedDao {
  static const String folderName = "Datas";
  final _datasFolder = intMapStoreFactory.store(folderName);


  Future<Database> get  _db  async => await AppDatabase.instance.database;

  Future insertData(DataCollected data) async{

    await  _datasFolder.add(await _db, data.toJson() );
    print('Data Inserted successfully !!');
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
      return data;
    }).toList();
  }


}