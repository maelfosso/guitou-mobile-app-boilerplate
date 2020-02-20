import 'dart:convert';

class DataCollected {
  int id;
  String remoteId;
  
  DateTime savedRemotelyAt;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt;

  String provider = 'mobile';
  String dataLocation = 'local';

  String form;
  Map values;

  DataCollected({
    this.form,
    this.values,
    this.id,
    this.remoteId,
    this.savedRemotelyAt,
    this.createdAt,
    this.provider,
    this.dataLocation,
  });

  factory DataCollected.fromJson(Map<String, dynamic> parsedJson) {
    print("\nIT'S ME");
    print(parsedJson['createdAt']);
    print(DateTime.tryParse(parsedJson['createdAt'].toString()));
    print(Map.from(parsedJson['values']));
    print("\nEND..");

    return DataCollected(
      form: parsedJson['form'],
      values: parsedJson['values'],
      id: parsedJson['id'],
      remoteId: parsedJson['remoteId'],
      savedRemotelyAt: parsedJson['savedRemotelyAt'],
      createdAt: DateTime.tryParse(parsedJson['createdAt'].toString()),
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
    "form": this.form,
    "values": this.values,
    "id": this.id,
    "remoteId": this.remoteId,
    "savedRemotelyAt": this.savedRemotelyAt,
    "createdAt": this.createdAt, //.toString(),
    "provider": this.provider,
    "dataLocation": this.dataLocation,
  };


  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return """
  //   "form": $form,
  //   "values": $values,
  //   "id": $id,
  //   "remoteId": $remoteId,
  //   "savedRemotelyAt": $savedRemotelyAt,
  //   "createdAt": $createdAt,
  //   "provider": $provider,
  //   "dataLocation": $dataLocation,
  //   ----------------------------------
  //   """;
  // }
}