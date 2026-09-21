import 'package:dzikr_tasbih/widgets/cards/glass_card.dart';
import 'package:dzikr_tasbih/widgets/common/custom_appbar.dart';
import 'package:flutter/material.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({
    super.key,
  });

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> themes = [
    {
      "title": "Emerald",
      "primary": const Color(0xFF74C69D),
      "secondary": const Color(0xFF2D6A4F),
    },
    {
      "title": "Ocean",
      "primary": const Color(0xFF4CC9F0),
      "secondary": const Color(0xFF4361EE),
    },
    {
      "title": "Sunset",
      "primary": const Color(0xFFFFB703),
      "secondary": const Color(0xFFFB8500),
    },
    {
      "title": "Rose",
      "primary": const Color(0xFFFF4D6D),
      "secondary": const Color(0xFFC9184A),
    },
    {
      "title": "Purple",
      "primary": const Color(0xFF9D4EDD),
      "secondary": const Color(0xFF5A189A),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CustomAppBar(
        title: "Themes",
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF031B15),
              Color(0xFF081C15),
              Color(0xFF0B2B21),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(
            20,
          ),
          physics: const BouncingScrollPhysics(),
          children: [
            /// HEADER
            const Text(
              "Customize Theme",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              "Pilih tema warna favorit untuk pengalaman dzikir yang lebih nyaman.",
              style: TextStyle(
                color: Colors.white70,
                height: 1.5,
              ),
            ),

            const SizedBox(
              height: 35,
            ),

            /// THEME LIST
            ...List.generate(
              themes.length,
              (index) {
                final item = themes[index];

                final isSelected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: GlassCard(
                      child: Row(
                        children: [
                          /// COLOR PREVIEW
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  item["primary"],
                                  item["secondary"],
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: item["primary"].withOpacity(
                                    0.45,
                                  ),
                                  blurRadius: 25,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            width: 20,
                          ),

                          /// TITLE
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"],
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  "Modern Islamic UI Theme",
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// CHECK
                          AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 300,
                            ),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  isSelected ? item["primary"] : Colors.white10,
                            ),
                            child: Icon(
                              Icons.check,
                              color: isSelected ? Colors.black : Colors.white24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(
              height: 30,
            ),

            /// PREVIEW CARD
            GlassCard(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          themes[selectedIndex]["primary"],
                          themes[selectedIndex]["secondary"],
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: themes[selectedIndex]["primary"].withOpacity(
                            0.45,
                          ),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    themes[selectedIndex]["title"],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Preview tema aktif saat ini",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}
