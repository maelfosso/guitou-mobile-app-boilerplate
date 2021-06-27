import 'package:flutter/cupertino.dart';
import 'package:guitou/db/app_database.dart';
import 'package:guitou/models/data.dart';
import 'package:sembast/sembast.dart';

class DataModel extends ChangeNotifier {

  static const String DATA_STORE_NAME = 'data';
  final _dataStore = intMapStoreFactory.store(DATA_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  List<Data> _datas = [];

  Future<List<Data>> getAllData() async {
    final finder = Finder(sortOrders: [SortOrder('createdAt')]);

    final dataSnapshots = await _dataStore.find(
      await _db,
      finder: finder
    );

    List<Data> datas = dataSnapshots.map((snapshot) {
      final data = Data.fromJson(snapshot.key, snapshot.value);
      return data;
    }).toList();

    _datas = datas;
    notifyListeners();

    return datas;
  }

  Future<Data> getData(int id) async {
    var record = await _dataStore.record(id).get(await _db);
    Data data = Data.fromJson(id, record);

    return data;
  }

  int get datasCount {
    return _datas.length;
  }

  List<Data> get datasList {
    return _datas;
  }
  
}