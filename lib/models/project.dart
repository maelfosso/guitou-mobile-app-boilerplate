import 'dart:convert';
import 'package:muitou/models/xorm.dart';
import 'package:muitou/models/xorm_detail.dart';

class Project {
  Project._privateConstructor();

  static final Project _instance = Project._privateConstructor();

  static Project get instance { return _instance;}

  List<Xorm> xorms;
  List<XormDetail> xormsDetails;

  factory Project({List<Xorm> xorms}) { // }, List<XormDetails> xormsDetails}) {
    _instance.xorms = xorms;
    // _instance.xormsDetails = xormsDetails;
    return _instance;
  }

  factory Project.fromJson(Map<String, dynamic> parsedJson) {
    return Project(
      xorms: (parsedJson['xorms'] as List)
        .map((i) => Xorm.fromJson(i))
        .toList()
      // json.decode(parsedJson['xorms'].toString())
        // .cast<Map<String, dynamic>>()
        // .cast<String>()
        // .map<Xorm>((json) => new Xorm.fromJson(json))
        // .toList(), // Xorm.fromJson(parsedJson['xorms']),
      // xormsDetails: parsedJson['xormsDetails']
    );
  }
  
}