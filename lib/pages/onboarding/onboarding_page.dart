import 'package:dzikr_tasbih/core/theme/theme_controller.dart';
import 'package:dzikr_tasbih/main_navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    super.key,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController controller = PageController();

  int currentIndex = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      "title": "Dzikir Lebih Modern",
      "subtitle":
          "Nikmati pengalaman berdzikir dengan tampilan premium dan nyaman.",
      "icon": Icons.auto_awesome,
    },
    {
      "title": "Pantau Statistik",
      "subtitle":
          "Lihat progress harian, mingguan, bulanan hingga tahunan secara realtime.",
      "icon": Icons.bar_chart_rounded,
    },
    {
      "title": "Reminder Otomatis",
      "subtitle": "Aktifkan pengingat dzikir sesuai waktu ibadah setiap hari.",
      "icon": Icons.notifications_active_rounded,
    },
  ];

  void nextPage() {
    if (currentIndex < onboardingData.length - 1) {
      controller.nextPage(
        duration: const Duration(
          milliseconds: 350,
        ),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigationPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);

    return Scaffold(
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
          child: Column(
            children: [
              /// SKIP
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    top: 10,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainNavigationPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),

              /// PAGEVIEW
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (
                    index,
                  ) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    final item = onboardingData[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// ICON
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  theme.accentColor,
                                  theme.accentColor.withOpacity(0.55),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.accentColor.withOpacity(
                                    0.35,
                                  ),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              item["icon"],
                              color: Colors.white,
                              size: 100,
                            ),
                          ),

                          const SizedBox(
                            height: 60,
                          ),

                          /// TITLE
                          Text(
                            item["title"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          /// SUBTITLE
                          Text(
                            item["subtitle"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// INDICATOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) {
                    final isActive = currentIndex == index;

                    return AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      width: isActive ? 30 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        color: isActive ? theme.accentColor : Colors.white24,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              /// BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),
                    child: Text(
                      currentIndex == onboardingData.length - 1
                          ? "Mulai"
                          : "Lanjut",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
