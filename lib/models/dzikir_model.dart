class DzikirModel {
  String title;
  int target;

  DzikirModel({
    required this.title,
    required this.target,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'target': target,
    };
  }

  factory DzikirModel.fromJson(Map<String, dynamic> json) {
    return DzikirModel(
      title: json['title'] ?? '',
      target: json['target'] ?? 33,
    );
  }
}
