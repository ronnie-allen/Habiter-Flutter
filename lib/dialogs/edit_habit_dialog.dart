import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habiter/database/habit_database.dart';
import 'package:habiter/models/habit.dart';

void showEditHabitDialog(BuildContext context, Habit habit) {
  final controller = TextEditingController(text: habit.name);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit habit'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new habit name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<HabitDatabase>().updateHabitName(habit.id, name);
              }
              Navigator.pop(context);
              controller.clear();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
