import 'dart:convert';
import 'package:equatable/equatable.dart';

class DataCollected extends Equatable {
  int id;
  String remoteId;
  
  DateTime savedRemotelyAt;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt;

  String provider = 'mobile';
  String dataLocation = 'local';

  String form;
  Map<String, Object> values = {};

  DataCollected({
    this.form,
    this.values,
    this.id,
    this.createdAt,
    this.remoteId,
    this.savedRemotelyAt,
    this.provider,
    this.dataLocation,
  });

  factory DataCollected.fromJson(int id, Map<String, dynamic> parsedJson) {
    
    return DataCollected(
      form: parsedJson['form'],
      values: parsedJson['values'],
      id: id,
      createdAt: DateTime.tryParse(parsedJson['createdAt'].toString()),
      remoteId: parsedJson['remoteId'],
      savedRemotelyAt: DateTime.tryParse(parsedJson['savedRemotelyAt'].toString()),
      provider: parsedJson['provider'],
      dataLocation: parsedJson['dataLocation'],
    );
  }

  Map<String, dynamic> toSave() => {
    "form": this.form,
    "values": this.values,
    "createdAt": DateTime.now().toString(),
    "provider": "mobile",
    "dataLocation": "local"
  };

  Map<String, dynamic> toJson() => {
    "id": this.id,
    "form": this.form,
    "values": this.values,
    "createdAt": this.createdAt.toString(),
    "remoteId": this.remoteId,
    "savedRemotelyAt": this.savedRemotelyAt.toString(),
    "provider": this.provider,
    "dataLocation": this.dataLocation,
  };

  DataCollected copyWith({
    int id,
    String form,
    Map values,
    String createdAt,
    String remoteId,
    String savedRemotelyAt,
    String provider,
    String dataLocation
  }) {
    return DataCollected(
      id: id ?? this.id,
      form: form ?? this.form,
      values: values ?? this.values,
      remoteId: remoteId ?? this.remoteId,
      savedRemotelyAt: savedRemotelyAt ?? this.savedRemotelyAt,
      createdAt: createdAt ?? this.createdAt,
      provider: provider ?? this.provider,
      dataLocation: dataLocation ?? this.dataLocation
    );
  }

  @override
  List<Object> get props => [id, form, values];

  @override
  int get hashCode => id.hashCode ^ form.hashCode ^ values.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataCollected &&
          runtimeType == other.runtimeType &&
          values == other.values &&
          form == other.form &&
          id == other.id;
}