class ReminderModel {
  String title;

  String time;

  bool enabled;

  ReminderModel({
    required this.title,
    required this.time,
    this.enabled = true,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "time": time,
      "enabled": enabled,
    };
  }

  factory ReminderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReminderModel(
      title: json["title"],
      time: json["time"],
      enabled: json["enabled"],
    );
  }
}
