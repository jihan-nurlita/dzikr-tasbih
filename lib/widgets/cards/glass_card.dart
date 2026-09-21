import 'package:dzikr_tasbih/core/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlassCard extends StatelessWidget {
  final Widget child;

  const GlassCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(
      context,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: theme.accentColor.withOpacity(0.1),
        border: Border.all(
          color: theme.accentColor.withOpacity(0.1),
        ),
      ),
      child: child,
    );
  }
}
