class HistoryModel {
  final String date;

  final int count;

  final String dzikir;

  HistoryModel({
    required this.date,
    required this.count,
    required this.dzikir,
  });

  /// FORMAT DATE
  DateTime get parsedDate => DateTime.parse(date);

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "count": count,
      "dzikir": dzikir,
    };
  }

  /// FROM JSON
  factory HistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return HistoryModel(
      date: json["date"] ?? "",
      count: json["count"] ?? 0,
      dzikir: json["dzikir"] ?? "Subhanallah",
    );
  }
}
