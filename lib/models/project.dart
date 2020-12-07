import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:guitou/models/xorm.dart';
import 'package:guitou/models/xorm_detail.dart';

import 'xorm_detail.dart';

class Project {
  Project._privateConstructor();

  static Project _instance = Project._privateConstructor();

  static Project get instance { return _instance;}

  String id;
  String name;
  List<Xorm> xorms;
  List<XormDetails> xormsDetails;

  factory Project({String id, String name, List<Xorm> xorms, List<XormDetails> xormsDetails}) {
    _instance.id = id;
    _instance.name = name;
    _instance.xorms = xorms;
    _instance.xormsDetails = xormsDetails;

    return _instance;
  }

  factory Project.fromJson(Map<String, dynamic> parsedJson) {
    return Project(
      id: parsedJson['_id'],
      name: parsedJson['name'],
      xorms: (parsedJson['xorms'] as List)
        .map((i) => Xorm.fromJson(i))
        .toList(),
      xormsDetails: Map<String, dynamic>.from(parsedJson['xormsDetails'])
        .entries.map((entry) =>  XormDetails.fromJson(entry.key, entry.value))
        .toList()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "xorms": xorms,
      "xormsDetails": Map.fromIterable(xormsDetails, 
        key: (d) {
          // debugPrint(d.id.toString());
          return d.id;
        },
        value: (d) {
          // debugPrint(d.toJson().toString());
          return d.toJson();
        }
      )
    };
  }

  static set object(Project project) {
    // for(int i=0; i < project.xormsDetails.length; i++) {

    //   project.xormsDetails[i].sections.add();
    // }
    // project.xormsDetails[project.xormsDetails.length - 1].sections.add(_in)
    _instance = project;
  }
  
}