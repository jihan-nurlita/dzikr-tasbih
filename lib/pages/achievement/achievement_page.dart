import 'package:dzikr_tasbih/core/theme/theme_controller.dart';
import 'package:dzikr_tasbih/widgets/cards/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tasbih_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AchievementPage extends StatelessWidget {
  const AchievementPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasbihProvider>(
      context,
    );

    final theme = Provider.of<ThemeController>(
      context,
    );

    final achievements = [
      {
        "title": "Langkah Awal Kebaikan",
        "target": 100,
        "icon": Icons.auto_awesome,
      },
      {
        "title": "Istiqomah",
        "target": 500,
        "icon": Icons.volunteer_activism,
      },
      {
        "title": "Penyejuk Hati",
        "target": 1000,
        "icon": Icons.favorite,
      },
      {
        "title": "Cahaya Istiqomah",
        "target": 3000,
        "icon": Icons.light_mode,
      },
      {
        "title": "Mutiara Istiqomah",
        "target": 5000,
        "icon": Icons.star_rounded,
      },
      {
        "title": "Mahkota Istiqomah",
        "target": 7000,
        "icon": FontAwesomeIcons.solidChessQueen,
      },
      {
        "title": "Puncak Istiqomah",
        "target": 10000,
        "icon": FontAwesomeIcons.crown,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          "Achievements",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(
            20,
          ),
          physics: const BouncingScrollPhysics(),
          itemCount: achievements.length,
          itemBuilder: (
            context,
            index,
          ) {
            final item = achievements[index];

            final target = item["target"] as int;

            final unlocked = provider.totalDzikir >= target;

            final progress = provider.totalDzikir / target;

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: GlassCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        /// ICON
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: unlocked
                                ? theme.accentColor.withOpacity(
                                    0.15,
                                  )
                                : Colors.white10,
                          ),
                          child: Icon(
                            item["icon"] as IconData,
                            color:
                                unlocked ? theme.accentColor : Colors.white38,
                            size: 34,
                          ),
                        ),

                        const SizedBox(
                          width: 20,
                        ),

                        /// CONTENT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"] as String,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              Text(
                                "$target Dzikir",
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              /// PROGRESS
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                                child: LinearProgressIndicator(
                                  value: progress > 1 ? 1 : progress,
                                  minHeight: 10,
                                  backgroundColor: Colors.white10,
                                  color: theme.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          width: 20,
                        ),

                        /// STATUS
                        Icon(
                          unlocked
                              ? Icons.verified_rounded
                              : Icons.lock_outline,
                          color: unlocked ? theme.accentColor : Colors.white38,
                          size: 32,
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    /// TEXT STATUS
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        unlocked
                            ? "Unlocked"
                            : "${provider.totalDzikir}/$target",
                        style: TextStyle(
                          color: unlocked ? theme.accentColor : Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
