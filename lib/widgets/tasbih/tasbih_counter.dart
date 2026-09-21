import 'package:dzikr_tasbih/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TasbihCounter extends StatelessWidget {
  final int count;

  const TasbihCounter({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.accent,
          width: 10,
        ),
      ),
      child: Center(
        child: Text(
          "$count",
          style: const TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
