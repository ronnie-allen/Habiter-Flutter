import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habiter/models/habit.dart';

class HabitDatabase extends ChangeNotifier {
  static late Box<Habit> _habitBox;
  static const String settingsBoxName = 'appSettings';

  List<Habit> currentHabits = [];

  // Call this once in your app startup before using HabitDatabase
  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HabitAdapter());
    _habitBox = await Hive.openBox<Habit>('habits');
  }

  Future<void> saveFirstLaunchDate(DateTime date) async {
    final box = await Hive.openBox(settingsBoxName);
    if (!box.containsKey('firstLaunchDate')) {
      await box.put('firstLaunchDate', date);
    }
  }

  Future<DateTime?> getFirstLaunchDate() async {
    final box = await Hive.openBox(settingsBoxName);
    return box.get('firstLaunchDate');
  }

  // Initial load habits from box, update local list, then notify
  Future<void> readHabits() async {
    currentHabits = _habitBox.values.toList();
    notifyListeners();
  }

  // Add habit and update local list without reloading full list from Hive
  Future<void> addHabit(String habitName) async {
    if (!_habitBox.isOpen) return;
    final newHabit = Habit(name: habitName);
    await _habitBox.add(newHabit);
    await readHabits(); 
  // Reload list to get updated keys properly
  }

  // Update completion for habit without reloading full list from Hive
  Future<void> updateHabitCompletion(dynamic key, bool isCompleted) async {
    if (!_habitBox.isOpen) return;
    final habit = _habitBox.get(key);
    if (habit == null) return;

    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    if (isCompleted &&
        !habit.completedDays.any(
          (date) =>
              date.year == normalizedToday.year &&
              date.month == normalizedToday.month &&
              date.day == normalizedToday.day,
        )) {
      habit.completedDays.add(normalizedToday);
    } else if (!isCompleted) {
      habit.completedDays.removeWhere(
        (date) =>
            date.year == normalizedToday.year &&
            date.month == normalizedToday.month &&
            date.day == normalizedToday.day,
      );
    }

    await habit.save();

    // Update local list habit reference
    final index = currentHabits.indexWhere((h) => h.key == key);
    if (index != -1) {
      currentHabits[index] = habit;
      notifyListeners();
    }
  }

  // Update habit name and notify
  Future<void> updateHabitName(dynamic key, String newName) async {
    if (!_habitBox.isOpen) return;
    final habit = _habitBox.get(key);
    if (habit == null) return;

    habit.name = newName;
    await habit.save();

    final index = currentHabits.indexWhere((h) => h.key == key);
    if (index != -1) {
      currentHabits[index] = habit;
      notifyListeners();
    }
  }

  // Delete habit and update local list without full reload
  Future<void> deleteHabit(dynamic key) async {
    if (!_habitBox.isOpen) return;

    if (_habitBox.containsKey(key)) {
      await _habitBox.delete(key);
      currentHabits.removeWhere((habit) => habit.key == key);
      notifyListeners();
    }
  }
}
