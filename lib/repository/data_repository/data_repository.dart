import 'dart:async';
import 'dart:core';

import 'package:guitou/models/models.dart';

abstract class DataRepository {

  Future<int> insertData(DataCollected data);

  Future updateData(DataCollected data);

  Future deleteData(int dataId);

  Future<List<DataCollected>> getAllData();
}