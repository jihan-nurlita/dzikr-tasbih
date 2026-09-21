import 'package:dzikr_tasbih/core/theme/theme_controller.dart';
import 'package:dzikr_tasbih/models/dzikir_modal_sheet.dart';
import 'package:dzikr_tasbih/widgets/common/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/tasbih_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasbihProvider>(context);
    final theme = Provider.of<ThemeController>(context);

    final now = DateTime.now();
    final formattedDate = DateFormat(
      "EEEE, d MMM yyyy",
      "id_ID",
    ).format(now);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
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
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Assalamu’alaikum",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Dzikr Tasbih",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.accentColor.withOpacity(0.15),
                      ),
                      child: Icon(
                        Icons.nightlight_round,
                        color: theme.accentColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                /// INFO CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: theme.accentColor.withOpacity(0.15),
                    border: Border.all(
                      color: theme.accentColor.withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Dzikir Hari Ini",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: theme.accentColor,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              formattedDate,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// DROPDOWN DZIKIR BUTTON
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: theme.accentColor.withOpacity(0.1),
                    border: Border.all(
                      color: theme.accentColor.withOpacity(0.1),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return Consumer<TasbihProvider>(
                            builder: (context, provider, child) {
                              return DzikirModalSheet(
                                provider: provider,
                                theme: theme,
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.accentColor.withOpacity(0.15),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: theme.accentColor,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider.currentDzikir.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Target ${provider.currentDzikir.target}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: theme.accentColor,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                /// COUNTER
                Stack(
                  alignment: Alignment.center,
                  children: [
                    /// GLOW
                    Container(
                      width: 330,
                      height: 330,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.accentColor.withOpacity(0.15),
                            blurRadius: 120,
                            spreadRadius: 40,
                          ),
                        ],
                      ),
                    ),

                    /// PROGRESS
                    SizedBox(
                      width: 350,
                      height: 350,
                      child: CircularProgressIndicator(
                        value: provider.progress,
                        strokeWidth: 12,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation(
                          theme.accentColor,
                        ),
                      ),
                    ),

                    /// CONTENT
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${provider.count}",
                          style: const TextStyle(
                            fontSize: 90,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ).animate().fade(duration: 400.ms).scale(),
                        const SizedBox(height: 10),
                        Text(
                          provider.currentDzikir.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.accentColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "/ ${provider.currentDzikir.target}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                /// BUTTON TAP
                SizedBox(
                  width: double.infinity,
                  child: GlassButton(
                    title: "TAP DZIKIR",
                    onTap: provider.increment,
                  ),
                ),

                const SizedBox(height: 20),

                /// RESET BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: provider.reset,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: theme.accentColor.withOpacity(0.1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reset Dzikir"),
                  ),
                ),

                const SizedBox(height: 35),

                /// STATISTICS
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: theme.accentColor.withOpacity(0.1),
                    border: Border.all(
                      color: theme.accentColor.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        icon: Icons.auto_awesome,
                        color: theme.accentColor,
                        value: "${provider.totalDzikir}",
                        title: "Total",
                      ),
                      _buildStatItem(
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                        value: "${provider.streak}",
                        title: "Streak",
                      ),
                      _buildStatItem(
                        icon: Icons.track_changes,
                        color: theme.accentColor,
                        value: "${provider.currentDzikir.target}",
                        title: "Target",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ACHIEVEMENTS PREVIEW
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: theme.accentColor.withOpacity(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Achievements",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "${provider.unlockedAchievements.length} Unlocked",
                            style: TextStyle(
                              color: theme.accentColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.unlockedAchievements.length,
                          itemBuilder: (context, index) {
                            final achievement =
                                provider.unlockedAchievements[index];
                            return Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                achievement.icon,
                                style: const TextStyle(fontSize: 32),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String value,
    required String title,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
