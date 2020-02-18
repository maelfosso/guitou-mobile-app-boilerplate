class DataCollected {
  int id;
  String remoteId;
  
  DateTime savedRemotelyAt;
  DateTime createdAt;
  DateTime updatedAt;

  String provider = 'mobile';
  String dataLocation = 'local';

  String form;
  Map<String, dynamic> values;

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

  factory DataCollected.fromJson(Map<String, dynamic> parsedJson) => DataCollected(
    form: parsedJson['form'],
    values: parsedJson['values'],
    id: parsedJson['id'],
    remoteId: parsedJson['remoteId'],
    savedRemotelyAt: parsedJson['savedRemotelyAt'],
    createdAt: parsedJson['createdAt'],
    provider: parsedJson['provider'],
    dataLocation: parsedJson['dataLocation'],
  );

  Map<String, dynamic> toJson() => {
    "form": this.form,
    "values": this.values,
    "id": this.id,
    "remoteId": this.remoteId,
    "savedRemotelyAt": this.savedRemotelyAt,
    "createdAt": this.createdAt,
    "provider": this.provider,
    "dataLocation": this.dataLocation,
  };


  @override
  String toString() {
    // TODO: implement toString
    return """
    "form": $form,
    "values": $values,
    "id": $id,
    "remoteId": $remoteId,
    "savedRemotelyAt": $savedRemotelyAt,
    "createdAt": $createdAt,
    "provider": $provider,
    "dataLocation": $dataLocation,
    ----------------------------------
    """;
  }
}