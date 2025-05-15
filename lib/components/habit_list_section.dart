import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habiter/database/habit_database.dart';
import 'package:habiter/components/my_habit_tile.dart';
import 'package:habiter/utils/habit_utils.dart';
import 'package:habiter/dialogs/edit_habit_dialog.dart';
import 'package:habiter/dialogs/delete_habit_dialog.dart';

class HabitListSection extends StatelessWidget {
  const HabitListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitDatabase>(
      builder: (context, habitDatabase, child) {
        final currentHabits = habitDatabase.currentHabits;

        return ListView.builder(
          itemCount: currentHabits.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final habit = currentHabits[index];
            final isCompleted = isHabitCompletedToday(habit.completedDays);

            return Container(
              key: ValueKey(habit.key),
              margin: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 6.0,
              ),
              child: MyHabitTile(
                key: ValueKey(habit.key),  // key is optional now but good to pass
                text: habit.name,
                isCompleted: isCompleted,
                onChanged: (value) {
                  if (value != null) {
                    Provider.of<HabitDatabase>(
                      context,
                      listen: false,
                    ).updateHabitCompletion(habit.key, value);
                  }
                },
                onEdit: (ctx) => showEditHabitDialog(ctx, habit),
                onDelete: (ctx) => showDeleteHabitDialog(ctx, habit),
              ),
            );
          },
        );
      },
    );
  }
}
