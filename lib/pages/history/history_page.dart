import 'package:dzikr_tasbih/core/theme/theme_controller.dart';
import 'package:dzikr_tasbih/widgets/cards/glass_card.dart';
import 'package:dzikr_tasbih/widgets/common/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/tasbih_provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    super.key,
  });

  /// FUNGSI POP-UP DETAIL AKTIVITAS
  void _showDetailDialog(
    BuildContext context,
    String formattedDate,
    List items,
    ThemeController theme,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Detail Aktivitas",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Colors.white10),
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: theme.accentColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item.dzikir,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.accentColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${item.count}x",
                          style: TextStyle(
                            color: theme.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasbihProvider>(
      context,
    );

    final theme = Provider.of<ThemeController>(
      context,
    );

    final histories = provider.histories.reversed.toList();

    final groupedHistory = <String, List>{};

    for (var item in histories) {
      if (groupedHistory[item.date] == null) {
        groupedHistory[item.date] = [];
      }

      groupedHistory[item.date]!.add(item);
    }

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
          title: "History",
        ),
        body: histories.isEmpty

            /// EMPTY
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.accentColor.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.history_rounded,
                        size: 60,
                        color: theme.accentColor.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Belum Ada History",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "History dzikir harian akan muncul setelah kamu mulai berdzikir.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              )

            /// LIST
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                itemCount: groupedHistory.length,
                itemBuilder: (context, index) {
                  final dateKey = groupedHistory.keys.elementAt(index);

                  final items = groupedHistory[dateKey]!;

                  final formattedDate = DateFormat(
                    "EEEE, d MMMM yyyy",
                    "id_ID",
                  ).format(
                    DateTime.parse(dateKey),
                  );

                  /// TOTAL TARGET RIIL DARI DZIKIR LIST
                  int totalTarget = provider.dzikirList.fold(
                    0,
                    (sum, element) => sum + element.target,
                  );
                  if (totalTarget == 0) totalTarget = 1;

                  /// TOTAL COUNT
                  int totalCount = 0;
                  for (var item in items) {
                    totalCount += item.count as int;
                  }

                  final percentage =
                      ((totalCount / totalTarget) * 100).clamp(0, 100).toInt();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        // DIPENCET UNTUK LIHAT DETAIL ACTIVITY
                        _showDetailDialog(
                          context,
                          formattedDate,
                          items,
                          theme,
                        );
                      },
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// HEADER
                            Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.accentColor,
                                        theme.accentColor.withOpacity(0.55),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.auto_awesome_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// TANGGAL
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      /// TOTAL DZIKIR
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: theme.accentColor
                                                  .withOpacity(0.12),
                                            ),
                                            child: Text(
                                              "${items.length}/${provider.dzikirList.length} Dzikir",
                                              style: TextStyle(
                                                color: theme.accentColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          const Row(
                                            children: [
                                              Text(
                                                "Detail",
                                                style: TextStyle(
                                                  color: Colors.white54,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Icon(
                                                Icons.chevron_right_rounded,
                                                color: Colors.white54,
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            /// PROGRESS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Progress",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "$percentage%",
                                  style: TextStyle(
                                    color: theme.accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LinearProgressIndicator(
                                value: percentage / 100,
                                minHeight: 8,
                                backgroundColor: Colors.white10,
                                valueColor: AlwaysStoppedAnimation(
                                  theme.accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
