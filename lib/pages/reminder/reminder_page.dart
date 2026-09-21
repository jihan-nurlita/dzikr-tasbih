import 'package:dzikr_tasbih/core/theme/theme_controller.dart';
import 'package:dzikr_tasbih/pages/reminder/add_reminder.dart';
import 'package:dzikr_tasbih/providers/tasbih_provider.dart';
import 'package:dzikr_tasbih/widgets/cards/glass_card.dart';
import 'package:dzikr_tasbih/widgets/common/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({
    super.key,
  });

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  /// Fungsi helper untuk parse jam secara aman tanpa bikin crash/pause debugger
  TimeOfDay _parseTimeOfDay(String timeString) {
    try {
      final cleanTime = timeString.trim().toUpperCase();
      final isPM = cleanTime.contains("PM");
      final isAM = cleanTime.contains("AM");

      // Hilangkan teks AM / PM jika ada
      final sanitized = cleanTime.replaceAll(RegExp(r'[^\d:]'), '');
      final parts = sanitized.split(":");

      int hour = int.parse(parts[0].trim());
      int minute = int.parse(parts[1].trim());

      if (isPM && hour < 12) {
        hour += 12;
      } else if (isAM && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      // Return jam bawaan (08:00) jika string jam tidak valid
      return const TimeOfDay(hour: 8, minute: 0);
    }
  }

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
          title: "Reminders",
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: theme.accentColor,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFF0F172A),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              builder: (context) {
                return const AddReminder();
              },
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: provider.reminders.isEmpty
            ? _buildEmptyState(theme)
            : _buildReminderList(provider, theme),
      ),
    );
  }

  /// WIDGET KETIKA BELUM ADA REMINDER (EMPTY STATE)
  Widget _buildEmptyState(ThemeController theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.accentColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.notifications_off_rounded,
                size: 60,
                color: theme.accentColor.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Belum Ada Reminder",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Atur pengingat dzikir harianmu di sini agar tetap istiqomah.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// WIDGET TAMPILAN LIST REMINDER
  Widget _buildReminderList(TasbihProvider provider, ThemeController theme) {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      children: [
        const Text(
          "Smart Reminder",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "Atur pengingat dzikir harian agar tetap istiqomah setiap waktu.",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 35),
        ...List.generate(
          provider.reminders.length,
          (index) {
            final item = provider.reminders[index];

            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 25),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.red.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              onDismissed: (_) {
                provider.deleteReminder(index);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  onTap: () async {
                    final controller = TextEditingController(
                      text: item.title,
                    );

                    // Panggil fungsi safe parsing di sini
                    TimeOfDay selectedTime = _parseTimeOfDay(item.time);

                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          title: const Text("Edit Reminder"),
                          content: StatefulBuilder(
                            builder: (context, setStateDialog) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: controller,
                                    decoration: InputDecoration(
                                      hintText: "Reminder Name",
                                      filled: true,
                                      fillColor: Colors.white10,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () async {
                                      final picked = await showTimePicker(
                                        context: context,
                                        initialTime: selectedTime,
                                      );

                                      if (picked != null) {
                                        setStateDialog(() {
                                          selectedTime = picked;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: Colors.white10,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: theme.accentColor,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            selectedTime.format(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                provider.reminders[index].title =
                                    controller.text;
                                provider.reminders[index].time =
                                    selectedTime.format(context);
                                provider.saveData();
                                Navigator.pop(context);
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: GlassCard(
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.accentColor.withOpacity(0.15),
                          ),
                          child: Icon(
                            Icons.notifications_active_rounded,
                            color: theme.accentColor,
                            size: 34,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.time,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: item.enabled,
                          activeColor: Colors.white,
                          activeTrackColor: theme.accentColor,
                          inactiveThumbColor: Colors.white70,
                          inactiveTrackColor: Colors.white12,
                          onChanged: (value) {
                            provider.toggleReminder(
                              index,
                              value,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 120),
      ],
    );
  }
}
