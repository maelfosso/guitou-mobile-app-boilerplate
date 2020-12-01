import 'dart:math';
import 'package:equatable/equatable.dart';

class Data extends Equatable {
  final String name;
  final String sex;
  final int age;
  final double longitude;
  final double latitude;
  final double altitude;
  final int id;
  int state; // = VisibilityFilter.notsynchronized.index.toInt();

  Data(
    this.name, 
    this.sex, 
    this.age, 
    this.longitude,
    this.latitude,
    this.altitude, 
    this.id,
    { this.state }
  );
  
  factory Data.fromMap(int id, Map<String, dynamic> map) {
    return Data(
      map['name'],
      map['sex'],
      map['age'],
      map['longitude'],
      map['latitude'],
      map['altitude'],
      id,
      state: map['state']
    );
  }

  Data copyWith({String name, String sex, int id, int age, 
      double longitude, double latitude, double altitude, 
      String state
  }) {
    return Data(
      name ?? this.name,
      sex ?? this.sex,
      age ?? this.age,
      longitude ?? this.longitude,
      latitude ?? this.latitude,
      altitude ?? this.latitude,
      id ?? this.id,
      state: state ?? this.state
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^ sex.hashCode ^ age.hashCode ^ longitude.hashCode ^ latitude.hashCode ^ altitude.hashCode;

  @override
  List<Object> get props => [id, name, age, sex, longitude, latitude, altitude];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Data &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          sex == other.sex &&
          age == other.age &&
          longitude == other.longitude &&
          latitude == other.latitude &&
          altitude == other.altitude &&
          id == other.id;

  Map<String, Object> toMap() {
    return {
      'name': name,
      'sex': sex,
      'age': age,
      'longitude': longitude,
      'latitude': latitude,
      'altitude': altitude,
      'id': id,
      'state': state
    };
  }

  @override
  String toString() {
    return 'Data{name: $name, sex: $sex, age: $age, longitude: $longitude, latitude: $latitude, altitude: $altitude, id: $id, state: $state}';
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
