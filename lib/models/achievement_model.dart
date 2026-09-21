class AchievementModel {
  final String title;

  final String description;

  final int target;

  final String icon;

  bool unlocked;

  AchievementModel({
    required this.title,
    required this.description,
    required this.target,
    required this.icon,
    this.unlocked = false,
  });
}
