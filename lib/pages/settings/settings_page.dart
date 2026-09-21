import 'package:dzikr_tasbih/core/theme/theme_controller.dart';
import 'package:dzikr_tasbih/pages/achievement/achievement_page.dart';
import 'package:dzikr_tasbih/widgets/cards/glass_card.dart';
import 'package:dzikr_tasbih/widgets/common/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../providers/tasbih_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasbihProvider>(context);
    final theme = Provider.of<ThemeController>(context);

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
          title: "Settings",
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// PROFILE CARD
              Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.accentColor,
                          theme.accentColor.withOpacity(0.4),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Dzikr Tasbih",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Modern Islamic Tasbih App",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// THEME COLOR
              GlassCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.accentColor.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.palette,
                      color: theme.accentColor,
                    ),
                  ),
                  title: const Text(
                    "Theme Color",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    "Customize application color",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  trailing: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.accentColor,
                      border: Border.all(
                        color: Colors.white24,
                      ),
                    ),
                  ),
                  onTap: () {
                    Color selectedColor = theme.accentColor;

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          title: const Text(
                            "Choose Theme Color",
                          ),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: selectedColor,
                              onColorChanged: (color) {
                                selectedColor = color;
                              },
                              enableAlpha: false,
                              displayThumbColor: true,
                              pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                theme.changeColor(selectedColor);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Apply",
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// VIBRATION
              GlassCard(
                child: SwitchListTile(
                  value: provider.vibrationEnabled,
                  onChanged: provider.toggleVibration,
                  activeTrackColor: theme.accentColor,
                  thumbColor: WidgetStateProperty.all(
                    Colors.white,
                  ),
                  contentPadding: EdgeInsets.zero,
                  secondary: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.accentColor.withOpacity(0.15),
                    ),
                    child: Icon(
                      Icons.vibration,
                      color: theme.accentColor,
                    ),
                  ),
                  title: const Text(
                    "Vibration",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    "Enable tap vibration feedback",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// CURRENT DZIKIR
              GlassCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.accentColor.withOpacity(0.15),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: theme.accentColor,
                    ),
                  ),
                  title: const Text(
                    "Current Dzikir",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    provider.currentDzikir.title,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: theme.accentColor.withOpacity(0.15),
                    ),
                    child: Text(
                      "${provider.currentDzikir.target}",
                      style: TextStyle(
                        color: theme.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// TOTAL DZIKIR
              GlassCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.accentColor.withOpacity(0.15),
                    ),
                    child: Icon(
                      Icons.bar_chart_rounded,
                      color: theme.accentColor,
                    ),
                  ),
                  title: const Text(
                    "Total Dzikir",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    "All dzikir completed",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  trailing: Text(
                    "${provider.totalDzikir}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ACHIEVEMENTS
              GlassCard(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AchievementPage(),
                      ),
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.accentColor.withOpacity(0.15),
                    ),
                    child: Icon(
                      Icons.workspace_premium,
                      color: theme.accentColor,
                    ),
                  ),
                  title: const Text(
                    "Achievements",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    "See unlocked badges",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.accentColor.withOpacity(0.15),
                    ),
                    child: Text(
                      "${provider.unlockedAchievements.length}",
                      style: TextStyle(
                        color: theme.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// STREAK
              GlassCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.accentColor.withOpacity(0.15),
                    ),
                    child: Icon(
                      Icons.local_fire_department,
                      color: theme.accentColor,
                    ),
                  ),
                  title: const Text(
                    "Current Streak",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    "Daily consistency",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  trailing: Text(
                    "${provider.streak}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// RESET BUTTON
              GlassCard(
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          title: const Text("Reset Progress"),
                          content: const Text(
                            "Apakah kamu yakin ingin mereset progress hitungan dzikir?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Batal"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                provider.reset();
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Progress dzikir berhasil direset!"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text(
                                "Reset",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.accentColor.withOpacity(0.15),
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: theme.accentColor,
                    ),
                  ),
                  title: const Text(
                    "Reset Progress",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    "Delete current dzikir progress",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// VERSION
              const Text(
                "Dzikr Tasbih",
                style: TextStyle(
                  color: Colors.white38,
                ),
              ),

              const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}
