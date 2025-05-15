import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habiter/database/habit_database.dart';

void showCreateHabitDialog(BuildContext context, TextEditingController controller) {
  final theme = Theme.of(context);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: theme.colorScheme.surface,
        title: const Text(
          'Create New Habit',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter habit name',
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          // Cancel button comes first now
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
              controller.clear();
            },
            child: const Text('Cancel'),
          ),
          // Save button comes second now
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            onPressed: () {
              String name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<HabitDatabase>().addHabit(name);
              }
              Navigator.pop(context);
              controller.clear();
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
