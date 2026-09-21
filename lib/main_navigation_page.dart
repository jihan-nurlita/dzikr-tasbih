import 'package:dzikr_tasbih/core/theme/theme_controller.dart';
import 'package:dzikr_tasbih/pages/history/history_page.dart';
import 'package:dzikr_tasbih/pages/home/home_page.dart';
import 'package:dzikr_tasbih/pages/reminder/reminder_page.dart';
import 'package:dzikr_tasbih/pages/settings/settings_page.dart';
import 'package:dzikr_tasbih/pages/statistics/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const StatisticsPage(),
    const HistoryPage(),
    const ReminderPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(
      context,
    );

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: theme.accentColor.withOpacity(0.15),
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            height: 75,
            selectedIndex: currentIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            indicatorColor: Colors.transparent,
            onDestinationSelected: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(
                  Icons.home_outlined,
                  color: Colors.white54,
                ),
                selectedIcon: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.accentColor.withOpacity(0.2),
                    border: Border.all(
                      color: theme.accentColor.withOpacity(0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.accentColor.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                ),
                label: "Home",
              ),
              NavigationDestination(
                icon: const Icon(
                  Icons.bar_chart_outlined,
                  color: Colors.white54,
                ),
                selectedIcon: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.accentColor.withOpacity(0.2),
                    border: Border.all(
                      color: theme.accentColor.withOpacity(0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.accentColor.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bar_chart,
                    color: Colors.white,
                  ),
                ),
                label: "Stats",
              ),
              NavigationDestination(
                icon: const Icon(
                  Icons.history_rounded,
                  color: Colors.white54,
                ),
                selectedIcon: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.accentColor.withOpacity(0.2),
                    border: Border.all(
                      color: theme.accentColor.withOpacity(0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.accentColor.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                ),
                label: "History",
              ),
              NavigationDestination(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white54,
                ),
                selectedIcon: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.accentColor.withOpacity(0.2),
                    border: Border.all(
                      color: theme.accentColor.withOpacity(0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.accentColor.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),
                label: "Notification",
              ),
              NavigationDestination(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.white54,
                ),
                selectedIcon: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.accentColor.withOpacity(0.2),
                    border: Border.all(
                      color: theme.accentColor.withOpacity(0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.accentColor.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                ),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
