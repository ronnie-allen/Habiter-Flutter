import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habiter/database/habit_database.dart';

void showCreateHabitDialog(BuildContext context, TextEditingController controller) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Create new habit'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter habit name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<HabitDatabase>().addHabit(name);
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
