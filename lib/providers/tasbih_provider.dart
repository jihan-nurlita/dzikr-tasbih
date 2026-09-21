import 'dart:convert';

import 'package:dzikr_tasbih/data/dummy/achievement_data.dart';
import 'package:dzikr_tasbih/pages/reminder/models/reminder_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../models/dzikir_model.dart';
import '../models/history_model.dart';

class TasbihProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  int selectedDzikirIndex = 0;

  // DEKLARASIKAN DZIKIR LIST DI SINI
  List<DzikirModel> dzikirList = [
    DzikirModel(title: "Subhanallah", target: 33),
    DzikirModel(title: "Alhamdulillah", target: 33),
    DzikirModel(title: "Allahu Akbar", target: 33),
  ];

  /// Getter dengan validasi agar tidak terjadi RangeError
  DzikirModel get currentDzikir {
    if (selectedDzikirIndex >= dzikirList.length || selectedDzikirIndex < 0) {
      selectedDzikirIndex = 0;
    }
    return dzikirList[selectedDzikirIndex];
  }

  int totalDzikir = 0;

  int streak = 1;

  bool vibrationEnabled = true;

  List<HistoryModel> histories = [];

  List<ReminderModel> reminders = [];

  double get progress => _count / currentDzikir.target;

  TasbihProvider() {
    loadData();
  }

  /// ADD DZIKIR
  void addDzikir(String title, int target) async {
    dzikirList.add(
      DzikirModel(
        title: title,
        target: target,
      ),
    );

    // Otomatis berpindah ke dzikir yang baru ditambahkan
    selectedDzikirIndex = dzikirList.length - 1;
    _count = 0;

    await saveData();
    notifyListeners();
  }

  /// LOAD DATA
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    /// 1. Load Dzikir List yang tersimpan
    final dzikirString = prefs.getString("customDzikirList");
    if (dzikirString != null) {
      final List decoded = jsonDecode(dzikirString);
      dzikirList = decoded.map((e) => DzikirModel.fromJson(e)).toList();
    }

    _count = prefs.getInt("count") ?? 0;

    totalDzikir = prefs.getInt("totalDzikir") ?? 0;

    /// 2. Load Indeks Terpilih dengan Proteksi Batas Indeks
    final savedIndex = prefs.getInt("selectedDzikirIndex") ?? 0;
    if (savedIndex < dzikirList.length && savedIndex >= 0) {
      selectedDzikirIndex = savedIndex;
    } else {
      selectedDzikirIndex = 0;
    }

    final savedTarget = prefs.getInt("customTarget");

    if (savedTarget != null && selectedDzikirIndex < dzikirList.length) {
      currentDzikir.target = savedTarget;
    }

    streak = prefs.getInt("streak") ?? 1;

    vibrationEnabled = prefs.getBool(
          "vibrationEnabled",
        ) ??
        true;

    final historyString = prefs.getString("histories");

    if (historyString != null) {
      final List decoded = jsonDecode(historyString);

      histories = decoded
          .map(
            (e) => HistoryModel.fromJson(e),
          )
          .toList();
    }

    final reminderString = prefs.getString("reminders");

    if (reminderString != null) {
      final List decoded = jsonDecode(reminderString);

      reminders = decoded
          .map(
            (e) => ReminderModel.fromJson(e),
          )
          .toList();
    }

    /// 3. Cek Reset Harian & Load Achievements
    await _checkDailyResetAndLoadAchievements(prefs);

    notifyListeners();
  }

  /// SAVE DATA
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    /// Simpan Dzikir List ke SharedPreferences
    final encodedDzikir = jsonEncode(
      dzikirList.map((e) => e.toJson()).toList(),
    );
    await prefs.setString("customDzikirList", encodedDzikir);

    await prefs.setInt("count", _count);

    await prefs.setInt(
      "totalDzikir",
      totalDzikir,
    );

    await prefs.setInt(
      "customTarget",
      currentDzikir.target,
    );

    await prefs.setInt("streak", streak);

    await prefs.setBool(
      "vibrationEnabled",
      vibrationEnabled,
    );

    await prefs.setInt(
      "selectedDzikirIndex",
      selectedDzikirIndex,
    );

    final encoded = jsonEncode(
      histories.map((e) => e.toJson()).toList(),
    );

    await prefs.setString(
      "histories",
      encoded,
    );

    final encodedReminder = jsonEncode(
      reminders.map((e) => e.toJson()).toList(),
    );

    await prefs.setString(
      "reminders",
      encodedReminder,
    );

    /// Simpan status Achievements
    await _saveAchievementsState(prefs);
  }

  /// INCREMENT
  void increment() async {
    if (_count < currentDzikir.target) {
      _count++;

      /// total semua tap dzikir
      totalDzikir++;

      checkAchievements();

      /// vibrate
      if (vibrationEnabled) {
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(
            duration: 40,
          );
        }
      }

      /// simpan progress realtime
      saveTodayProgress();

      /// kalau target selesai
      if (_count >= currentDzikir.target) {
        streak++;
      }

      await saveData();

      notifyListeners();
    }
  }

  /// SAVE TODAY
  void saveTodayProgress() {
    final today = DateFormat(
      "yyyy-MM-dd",
    ).format(DateTime.now());

    /// cari history berdasarkan tanggal + nama dzikir
    final index = histories.indexWhere(
      (e) => e.date == today && e.dzikir == currentDzikir.title,
    );

    /// kalau sudah ada -> update count terbaru
    if (index != -1) {
      histories[index] = HistoryModel(
        date: today,
        count: _count,
        dzikir: currentDzikir.title,
      );
    }

    /// kalau belum ada -> tambah baru
    else {
      histories.add(
        HistoryModel(
          date: today,
          count: _count,
          dzikir: currentDzikir.title,
        ),
      );
    }
  }

  /// CHANGE DZIKIR
  void changeDzikir(
    int index,
  ) async {
    selectedDzikirIndex = index;

    _count = 0;

    await saveData();

    notifyListeners();
  }

  /// EDIT DZIKIR
  void editDzikir(int index, String newTitle, int newTarget) async {
    if (index >= 0 && index < dzikirList.length) {
      dzikirList[index] = DzikirModel(
        title: newTitle,
        target: newTarget,
      );

      // Jika dzikir yang sedang aktif yang diedit, reset hitungan atau update target
      if (selectedDzikirIndex == index) {
        _count = 0;
      }

      await saveData();
      notifyListeners();
    }
  }

  /// DELETE DZIKIR
  void deleteDzikir(int index) async {
    // Pengaman: Jangan hapus jika item tinggal 1
    if (dzikirList.length <= 1) return;

    if (index >= 0 && index < dzikirList.length) {
      dzikirList.removeAt(index);

      // Sesuaikan selectedDzikirIndex agar tidak out of range
      if (selectedDzikirIndex >= dzikirList.length) {
        selectedDzikirIndex = dzikirList.length - 1;
      } else if (selectedDzikirIndex == index) {
        selectedDzikirIndex = 0;
      }

      _count = 0;

      await saveData();
      notifyListeners();
    }
  }

  /// CHANGE TARGET
  void changeTarget(int value) async {
    currentDzikir.target = value;

    _count = 0;

    await saveData();

    notifyListeners();
  }

  /// RESET
  void reset() async {
    _count = 0;

    await saveData();

    notifyListeners();
  }

  /// VIBRATION
  void toggleVibration(
    bool value,
  ) async {
    vibrationEnabled = value;

    await saveData();

    notifyListeners();
  }

  // ACHIEVEMENTS
  List get unlockedAchievements {
    return achievements
        .where(
          (e) => e.unlocked,
        )
        .toList();
  }

  void checkAchievements() {
    for (var achievement in achievements) {
      if (totalDzikir >= achievement.target) {
        achievement.unlocked = true;
      }
    }
  }

  /// FUNGSI LOGIKA RESET HARIAN & LOAD ACHIEVEMENTS
  Future<void> _checkDailyResetAndLoadAchievements(
      SharedPreferences prefs) async {
    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final lastDate = prefs.getString("lastDate");

    if (lastDate == null || lastDate != today) {
      // 🔄 HARi BARU: Reset Achievements dan simpan tanggal hari ini
      for (var item in achievements) {
        item.unlocked = false;
      }
      await prefs.setString("lastDate", today);
      await _saveAchievementsState(prefs);
    } else {
      // ⏩ MASIH HARI YANG SAMA: Load status unlocked yang tersimpan
      final unlockedTitles =
          prefs.getStringList("unlockedAchievementTitles") ?? [];
      for (var item in achievements) {
        item.unlocked = unlockedTitles.contains(item.title);
      }
    }
  }

  /// FUNGSI SIMPAN UNLOCKED ACHIEVEMENTS KE PREFERENCES
  Future<void> _saveAchievementsState(SharedPreferences prefs) async {
    final unlockedTitles =
        achievements.where((e) => e.unlocked).map((e) => e.title).toList();

    await prefs.setStringList("unlockedAchievementTitles", unlockedTitles);
  }

  /// WEEKLY
  List<double> getWeeklyProgress() {
    final now = DateTime.now();

    final start = now.subtract(
      Duration(
        days: now.weekday - 1,
      ),
    );

    List<double> result = [];

    for (int i = 0; i < 7; i++) {
      final day = start.add(Duration(days: i));

      final formatted = DateFormat(
        "yyyy-MM-dd",
      ).format(day);

      final history = histories.where(
        (e) => e.date == formatted,
      );

      if (history.isNotEmpty) {
        final count = history.first.count;

        final percent = (count / currentDzikir.target) * 100;

        result.add(
          percent > 100 ? 100 : percent,
        );
      } else {
        result.add(0);
      }
    }

    return result;
  }

  /// ADD REMINDER
  void addReminder(ReminderModel reminder) async {
    reminders.add(reminder);

    await saveData();

    notifyListeners();
  }

  /// TOGGLE REMINDER
  void toggleReminder(
    int index,
    bool value,
  ) async {
    reminders[index].enabled = value;

    await saveData();

    notifyListeners();
  }

  /// DELETE REMINDER
  void deleteReminder(int index) async {
    reminders.removeAt(index);

    await saveData();

    notifyListeners();
  }
}
