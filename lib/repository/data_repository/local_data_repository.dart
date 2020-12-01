import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:guitou/models/models.dart';
import 'package:guitou/repository/data_repository/data_repository.dart';

class LocalDataRepository extends DataRepository {
  final Database _database = GetIt.I.get();
  final StoreRef _store = intMapStoreFactory.store("data_store");

  @override
  Future<int> insertData(DataCollected data) async {
    return await _store.add(_database, data.toJson());
  }

  @override
  Future updateData(DataCollected data) async {
    await _store.record(data.id).update(_database, data.toJson());
  }

  @override
  Future deleteData(int dataId) async {
    await _store.record(dataId).delete(_database);
  }

  @override
  Future<List<DataCollected>> getAllData() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) => DataCollected.fromJson(snapshot.key, snapshot.value))
        .toList(growable: false);
  }
}