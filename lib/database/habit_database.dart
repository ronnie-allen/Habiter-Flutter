import 'package:flutter/cupertino.dart';
import 'package:habiter/models/app_settings.dart';
import 'package:habiter/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart'; // <-- needed for getApplicationDocumentsDirectory

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // INIT DB
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  // Save first date
  Future<void> saveFirstLaunchDate(DateTime date) async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = date;
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get first date
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  // List of habits
  List<Habit> currentHabits = [];

  // CRUD methods can go here
  // Create
  Future<void> addHabit(String habitName) async {
    // create new habit
    final newHabit = Habit()..name = habitName;
    // save to database
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // read from db
    readHabits();
  }

  // Read
  Future<void> readHabits() async {
    // fetch all habits
    List<Habit> fetchedHabits = await isar.habits.where().findAll();
    // give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // update UI
    notifyListeners();
  }

  // Update
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // fetch habit
    final habit = await isar.habits.get(id);

    if (habit != null) {
      // update completion status
      if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
        final today = DateTime.now();

        habit.completedDays.add(DateTime(today.year, today.month, today.day));
      } else {
        habit.completedDays.removeWhere(
          (date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day,
        );
      }
      // save to database
      await isar.writeTxn(() => isar.habits.put(habit));
    }
  }

  // UPDATE edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    // fetch habit
    final habit = await isar.habits.get(id);

    if (habit != null) {
      // update name
      habit.name = newName;
      // save to database
      await isar.writeTxn(() => isar.habits.put(habit));
    }
    // re-read from db
    readHabits();
  }

  // Delete
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
  }
}
