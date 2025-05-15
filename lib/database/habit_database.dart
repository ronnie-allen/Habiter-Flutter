import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habiter/models/habit.dart';

class HabitDatabase extends ChangeNotifier {
  static late Box<Habit> _habitBox;
  static const String settingsBoxName = 'appSettings';

  // Save first launch date
  Future<void> saveFirstLaunchDate(DateTime date) async {
    final box = await Hive.openBox(settingsBoxName);
    // Save only if not already saved
    if (!box.containsKey('firstLaunchDate')) {
      await box.put('firstLaunchDate', date);
    }
  }

  // Get first launch date
  Future<DateTime?> getFirstLaunchDate() async {
    final box = await Hive.openBox(settingsBoxName);
    return box.get('firstLaunchDate');
  }

  List<Habit> currentHabits = [];

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HabitAdapter());

    _habitBox = await Hive.openBox<Habit>('habits');
  }

  Future<void> addHabit(String habitName) async {
    final newHabit = Habit(name: habitName);
    await _habitBox.add(newHabit);
    readHabits();
  }

  Future<void> readHabits() async {
    currentHabits = _habitBox.values.toList();
    notifyListeners();
  }

  Future<void> updateHabitCompletion(dynamic key, bool isCompleted) async {
    final habit = _habitBox.get(key);
    if (habit != null) {
      final today = DateTime.now();
      final normalizedToday = DateTime(today.year, today.month, today.day);

      if (isCompleted && !habit.completedDays.contains(normalizedToday)) {
        habit.completedDays.add(normalizedToday);
      } else {
        habit.completedDays.removeWhere(
          (date) =>
              date.year == normalizedToday.year &&
              date.month == normalizedToday.month &&
              date.day == normalizedToday.day,
        );
      }
      await habit.save();
      readHabits();
    }
  }

  Future<void> updateHabitName(int index, String newName) async {
    final habit = _habitBox.getAt(index);
    if (habit != null) {
      habit.name = newName;
      await habit.save();
      readHabits();
    }
  }

  Future<void> deleteHabit(int index) async {
    if (index >= 0 && index < _habitBox.length) {
      await _habitBox.deleteAt(index);
      readHabits();
    }
  }
}
