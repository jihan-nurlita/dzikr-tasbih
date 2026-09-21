import 'package:dzikr_tasbih/core/services/stats_data_service.dart';
import 'package:dzikr_tasbih/core/theme/theme_controller.dart';
import 'package:dzikr_tasbih/widgets/cards/glass_card.dart';
import 'package:dzikr_tasbih/widgets/common/custom_appbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/tasbih_provider.dart';

enum StatsViewType {
  weekly,
  monthly,
  yearly,
}

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({
    super.key,
  });

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  StatsViewType currentView = StatsViewType.weekly;

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasbihProvider>(
      context,
    );

    /// DATA
    List<double> chartData = [];

    List<String> labels = [];

    String periodLabel = "";

    /// WEEKLY
    if (currentView == StatsViewType.weekly) {
      chartData = StatsDataService.getWeeklyData(
        provider.histories,
        selectedDate,
      );

      labels = StatsDataService.weeklyLabels;

      periodLabel = StatsDataService.getWeekLabel(
        selectedDate,
      );
    }

    /// MONTHLY
    else if (currentView == StatsViewType.monthly) {
      chartData = StatsDataService.getMonthlyData(
        provider.histories,
        selectedDate,
      );

      labels = StatsDataService.getMonthlyLabels(
        selectedDate,
      );

      periodLabel = StatsDataService.getMonthLabel(
        selectedDate,
      );
    }

    /// YEARLY
    else {
      chartData = StatsDataService.getYearlyData(
        provider.histories,
        selectedDate,
      );

      labels = StatsDataService.yearlyLabels;

      periodLabel = StatsDataService.getYearLabel(
        selectedDate,
      );
    }

    //
    final theme = Provider.of<ThemeController>(
      context,
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF020617),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(
          title: "Statistics",
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOGGLE
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  color: theme.accentColor.withOpacity(0.15),
                ),
                child: Row(
                  children: [
                    _buildToggle(
                      title: "Minggu",
                      type: StatsViewType.weekly,
                    ),
                    _buildToggle(
                      title: "Bulan",
                      type: StatsViewType.monthly,
                    ),
                    _buildToggle(
                      title: "Tahun",
                      type: StatsViewType.yearly,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              /// PERIOD
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: previousPeriod,
                    icon: const Icon(
                      Icons.chevron_left,
                    ),
                  ),
                  Text(
                    periodLabel,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: nextPeriod,
                    icon: const Icon(
                      Icons.chevron_right,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              /// CHART
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dzikir Activity",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 300,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: SizedBox(
                          width: currentView == StatsViewType.weekly
                              ? MediaQuery.of(context).size.width - 40
                              : chartData.length * 55,
                          child: BarChart(
                            BarChartData(
                              maxY: 100,
                              alignment: BarChartAlignment.spaceAround,
                              borderData: FlBorderData(
                                show: false,
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 20,
                                getDrawingHorizontalLine: (
                                  value,
                                ) {
                                  return FlLine(
                                    color: Colors.white10,
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    interval: 20,
                                    getTitlesWidget: (
                                      value,
                                      meta,
                                    ) {
                                      if (value == 0) {
                                        return const SizedBox();
                                      }

                                      return Text(
                                        "${value.toInt()}%",
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 11,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (
                                      value,
                                      meta,
                                    ) {
                                      final index = value.toInt();

                                      if (index >= labels.length) {
                                        return const SizedBox();
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                        ),
                                        child: Text(
                                          labels[index],
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              barGroups: List.generate(
                                chartData.length,
                                (index) {
                                  final value = chartData[index];

                                  return BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        toY: value,
                                        width:
                                            currentView == StatsViewType.weekly
                                                ? 18
                                                : 22,
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            theme.accentColor,
                                            theme.accentColor.withOpacity(0.4),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              /// SUMMARY
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: "Total",
                      value: "${provider.totalDzikir}",
                      icon: Icons.auto_awesome,
                      color: theme.accentColor,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: _buildSummaryCard(
                      title: "Streak",
                      value: "${provider.streak}",
                      icon: Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// PREVIOUS
  void previousPeriod() {
    setState(() {
      if (currentView == StatsViewType.weekly) {
        selectedDate = selectedDate.subtract(
          const Duration(days: 7),
        );
      } else if (currentView == StatsViewType.monthly) {
        selectedDate = DateTime(
          selectedDate.year,
          selectedDate.month - 1,
        );
      } else {
        selectedDate = DateTime(
          selectedDate.year - 1,
        );
      }
    });
  }

  /// NEXT
  void nextPeriod() {
    setState(() {
      if (currentView == StatsViewType.weekly) {
        selectedDate = selectedDate.add(
          const Duration(days: 7),
        );
      } else if (currentView == StatsViewType.monthly) {
        selectedDate = DateTime(
          selectedDate.year,
          selectedDate.month + 1,
        );
      } else {
        selectedDate = DateTime(
          selectedDate.year + 1,
        );
      }
    });
  }

  Widget _buildToggle({
    required String title,
    required StatsViewType type,
  }) {
    final isSelected = currentView == type;

    final theme = Provider.of<ThemeController>(
      context,
    );

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentView = type;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 250,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              16,
            ),
            color: isSelected ? theme.accentColor : Colors.transparent,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return GlassCard(
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 34,
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
