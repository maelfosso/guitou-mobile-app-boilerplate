import 'package:muitou/models/xorm.dart';
import 'package:muitou/models/xorm_detail.dart';

import 'xorm_detail.dart';

class Project {
  Project._privateConstructor();

  static final Project _instance = Project._privateConstructor();

  static Project get instance { return _instance;}

  List<Xorm> xorms;
  List<XormDetails> xormsDetails;

  factory Project({List<Xorm> xorms, List<XormDetails> xormsDetails}) {
    _instance.xorms = xorms;
    _instance.xormsDetails = xormsDetails;
    return _instance;
  }

  factory Project.fromJson(Map<String, dynamic> parsedJson) {
    return Project(
      xorms: (parsedJson['xorms'] as List)
        .map((i) => Xorm.fromJson(i))
        .toList(),
      xormsDetails: Map<String, dynamic>.from(parsedJson['xormsDetails'])
        .entries.map((entry) =>  XormDetails.fromJson(entry.key, entry.value))
        .toList()
    );
  }
  
}