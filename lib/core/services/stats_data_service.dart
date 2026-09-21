import 'package:dzikr_tasbih/models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatsDataService {
  /// =========================
  /// WEEKLY DATA
  /// =========================
  static List<double> getWeeklyData(
    List<HistoryModel> histories,
    DateTime selectedDate,
  ) {
    final startWeek = selectedDate.subtract(
      Duration(
        days: selectedDate.weekday - 1,
      ),
    );

    List<double> result = List.generate(7, (index) => 0);

    for (var item in histories) {
      final date = item.parsedDate;

      final isSameWeek = date.isAfter(
            startWeek.subtract(
              const Duration(days: 1),
            ),
          ) &&
          date.isBefore(
            startWeek.add(
              const Duration(days: 7),
            ),
          );

      if (isSameWeek) {
        final dayIndex = date.weekday - 1;

        result[dayIndex] += item.count.toDouble();
      }
    }

    return result;
  }

  /// =========================
  /// MONTHLY DATA
  /// =========================
  static List<double> getMonthlyData(
    List<HistoryModel> histories,
    DateTime selectedDate,
  ) {
    final daysInMonth = DateUtils.getDaysInMonth(
      selectedDate.year,
      selectedDate.month,
    );

    List<double> result = List.generate(
      daysInMonth,
      (index) => 0,
    );

    for (var item in histories) {
      final date = item.parsedDate;

      final isSameMonth =
          date.year == selectedDate.year && date.month == selectedDate.month;

      if (isSameMonth) {
        result[date.day - 1] += item.count.toDouble();
      }
    }

    return result;
  }

  /// =========================
  /// YEARLY DATA
  /// =========================
  static List<double> getYearlyData(
    List<HistoryModel> histories,
    DateTime selectedDate,
  ) {
    List<double> result = List.generate(
      12,
      (index) => 0,
    );

    for (var item in histories) {
      final date = item.parsedDate;

      final isSameYear = date.year == selectedDate.year;

      if (isSameYear) {
        result[date.month - 1] += item.count.toDouble();
      }
    }

    return result;
  }

  /// =========================
  /// WEEK LABEL
  /// =========================
  static String getWeekLabel(
    DateTime date,
  ) {
    final start = date.subtract(
      Duration(
        days: date.weekday - 1,
      ),
    );

    final end = start.add(
      const Duration(days: 6),
    );

    return "${DateFormat("d MMM").format(start)} - ${DateFormat("d MMM yyyy").format(end)}";
  }

  /// =========================
  /// MONTH LABEL
  /// =========================
  static String getMonthLabel(
    DateTime date,
  ) {
    return DateFormat(
      "MMMM yyyy",
      "id_ID",
    ).format(date);
  }

  /// =========================
  /// YEAR LABEL
  /// =========================
  static String getYearLabel(
    DateTime date,
  ) {
    return DateFormat(
      "yyyy",
    ).format(date);
  }

  /// =========================
  /// WEEK LABELS
  /// =========================
  static List<String> weeklyLabels = [
    "Sen",
    "Sel",
    "Rab",
    "Kam",
    "Jum",
    "Sab",
    "Min",
  ];

  /// =========================
  /// MONTH LABELS
  /// =========================
  static List<String> getMonthlyLabels(
    DateTime selectedDate,
  ) {
    final daysInMonth = DateUtils.getDaysInMonth(
      selectedDate.year,
      selectedDate.month,
    );

    return List.generate(
      daysInMonth,
      (index) => "${index + 1}",
    );
  }

  /// =========================
  /// YEAR LABELS
  /// =========================
  static List<String> yearlyLabels = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "Mei",
    "Jun",
    "Jul",
    "Agu",
    "Sep",
    "Okt",
    "Nov",
    "Des",
  ];
}
