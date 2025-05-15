// given habit list of Comp days
// is completed today 

import 'package:habiter/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any((date) =>
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day);
}

// prepare data for heatmap
Map<DateTime, int> prepareHeatMapData(List<Habit> habits) {
  Map<DateTime, int> dataset = {};
  for (var habit in habits) {
    for (var date in habit.completedDays) {
// normalize date to avoid time mismatch
final normalizeDate = DateTime(date.year, date.month, date.day);

      if (dataset.containsKey(normalizeDate)) {
        dataset[normalizeDate] = dataset[normalizeDate]! + 1;
      } else {
        dataset[normalizeDate] = 1;
      }
    }
  }
  return dataset;
}