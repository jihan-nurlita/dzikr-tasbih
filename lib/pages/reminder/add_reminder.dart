import 'package:dzikr_tasbih/core/theme/theme_controller.dart';
import 'package:dzikr_tasbih/pages/reminder/models/reminder_model.dart';
import 'package:dzikr_tasbih/providers/tasbih_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddReminder extends StatefulWidget {
  const AddReminder();

  @override
  State<AddReminder> createState() => AddReminderState();
}

class AddReminderState extends State<AddReminder> {
  final TextEditingController titleController = TextEditingController();

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(
      context,
    );

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tambah Reminder",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          /// TITLE
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Nama Reminder",
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// TIME PICKER
          GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: selectedTime,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: theme.accentColor,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                setState(() {
                  selectedTime = picked;
                });
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
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
                  const SizedBox(width: 14),
                  Text(
                    selectedTime.format(
                      context,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white54,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// BUTTON
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.accentColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () {
                final provider = Provider.of<TasbihProvider>(
                  context,
                  listen: false,
                );

                provider.addReminder(
                  ReminderModel(
                    title: titleController.text,
                    time: selectedTime.format(context),
                    enabled: true,
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text(
                "Simpan",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
