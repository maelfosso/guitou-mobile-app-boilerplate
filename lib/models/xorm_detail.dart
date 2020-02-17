class XormDetails {
  final String id;
  final List<XormSection> sections;

  XormDetails({this.id, this.sections});

  factory XormDetails.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormDetails(
      id: id,
      sections: parsedJson.entries.map((entry) => XormSection.fromJson(entry.key, entry.value)).toList()
    );
  }
}

class XormSection {
  final String id;
  final XormSectionParams params;
  final List<XormQuestion> questions;
  
  XormSection({this.id, this.params, this.questions});

  factory XormSection.fromJson(String id, Map<String, dynamic> json) {
    return new XormSection(
      id: id,
      params: XormSectionParams.fromJson(json['_params']),
      questions: [] 
    );
  }
}

class XormSectionParams {
  final String title;
  final String description;
  final String key;

  XormSectionParams({this.title, this.key, this.description});

  factory XormSectionParams.fromJson(Map<String, dynamic> json) {
    return new XormSectionParams(
      title: json['title'] as String,
      description: json['description'] as String,
      key: json['key'] as String,
    );
  }
}

class XormQuestion {

}