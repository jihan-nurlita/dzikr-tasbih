import 'package:flutter/material.dart';

class StatisticItem extends StatelessWidget {
  final IconData icon;

  final String value;

  final String title;

  final Color color;

  const StatisticItem({
    super.key,
    required this.icon,
    required this.value,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 28,
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
