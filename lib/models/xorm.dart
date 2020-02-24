class Xorm {
  final String id;
  final String title;

  Xorm({this.id, this.title});

  factory Xorm.fromJson(Map<String, dynamic> json) {
    return new Xorm(
      id: json['id'] as String,
      title: json['title'] as String
    );
  }

  Map<String, String> toJson() {
    return {
      "id": id,
      "title": title
    };
  }
}