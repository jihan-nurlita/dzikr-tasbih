import 'package:dzikr_tasbih/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

class DzikrTasbih extends StatelessWidget {
  const DzikrTasbih({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dzikr Tasbih',
      theme: AppTheme.darkTheme,
      home: const SplashPage(),
    );
  }
}
