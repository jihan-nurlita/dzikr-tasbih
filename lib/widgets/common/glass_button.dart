import 'package:dzikr_tasbih/core/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlassButton extends StatelessWidget {
  final String title;

  final VoidCallback onTap;

  const GlassButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(
      context,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.accentColor,
              theme.accentColor.withOpacity(0.65),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.accentColor.withOpacity(0.35),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
