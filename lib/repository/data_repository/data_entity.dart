import 'package:guitou/models/models.dart';

class DataEntity {
  final String _id;
  final int originalId;
  final String name;
  final String sex;
  final int age;
  final double longitude;
  final double latitude;
  final double altitude;

  DataEntity(
    this._id,
    this.originalId,
    this.name, 
    this.sex, 
    this.age, 
    this.longitude,
    this.latitude,
    this.altitude
  );

  @override
  int get hashCode =>
    _id.hashCode ^ name.hashCode ^ sex.hashCode ^ age.hashCode ^ longitude.hashCode ^ latitude.hashCode ^ altitude.hashCode;

  factory DataEntity.fromMap(int _id, Map<String, dynamic> map) {
    return DataEntity(
      map['_id'],
      map['originalId'],
      map['name'],
      map['sex'],
      map['age'],
      map['longitude'],
      map['latitude'],
      map['altitude'],
    );
  }

  Map<String, Object> toMap() {
    return {
      'originalId': 'originalId',
      'name': name,
      'sex': sex,
      'age': age,
      'longitude': longitude,
      'latitude': latitude,
      'altitude': altitude,
      '_id': _id,
    };
  }

  // Data toData() {
  //   print('\ntoDATA -- $originalId -- ${this._id.isNotEmpty ? VisibilityFilter.synchronized.index.toInt() : VisibilityFilter.notsynchronized.index.toInt()}');
    
  //   return Data(
  //     name,
  //     sex,
  //     age,
  //     longitude,
  //     latitude,
  //     altitude,
  //     originalId,
  //     state: this._id.isNotEmpty ? VisibilityFilter.synchronized.index.toInt() : VisibilityFilter.notsynchronized.index.toInt()
  //   );
  // }

  static DataEntity fromJson(Map<String, dynamic> json) {

    return DataEntity(
      json['_id'] as String,
      json['originalId'] as int,
      json['name'] as String,
      json['sex'] as String,
      json['age'] as int,
      double.parse(json['longitude'].toString()),
      double.parse(json['latitude'].toString()),
      double.parse(json['altitude'].toString()),
    );
  }

  @override
  String toString() {
    return 'DataEntity{originalId: $originalId, name: $name, sex: $sex, age: $age, longitude: $longitude, latitude: $latitude, altitude: $altitude, _id: $_id}';
  }
}