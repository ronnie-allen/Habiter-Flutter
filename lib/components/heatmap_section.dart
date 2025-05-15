import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habiter/database/habit_database.dart';
import 'package:habiter/models/habit.dart';
import 'package:habiter/components/my_heat_map.dart';
import 'package:habiter/utils/habit_utils.dart';

class HeatMapSection extends StatelessWidget {
  const HeatMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    final habitDatabase = context.watch<HabitDatabase>();
    final List<Habit> currentHabits = habitDatabase.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(), // Now defined in Hive version
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepareHeatMapData(currentHabits),
          );
        } else {
          return const Center(
            child: Text('No heatmap data available'),
          );
        }
      },
    );
  }
}
