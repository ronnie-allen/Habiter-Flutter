import 'package:flutter/material.dart';
import 'package:habiter/components/my_habit_tile.dart';
import 'package:provider/provider.dart';
import 'package:habiter/components/my_drawer.dart';
import 'package:habiter/database/habit_database.dart';
import 'package:habiter/models/habit.dart';
import 'package:habiter/utils/habit_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HabitDatabase>(context, listen: false).readHabits();
    });
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create new habit'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Enter habit name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String newHabitName = textController.text.trim();
                if (newHabitName.isNotEmpty) {
                  context.read<HabitDatabase>().addHabit(newHabitName);
                }
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    // update completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

// Edit habit box
  void editHabit(BuildContext context, Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit habit'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Enter new habit name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String newHabitName = textController.text.trim();
              if (newHabitName.isNotEmpty) {
                context.read<HabitDatabase>().updateHabitName(habit.id, newHabitName);
              }
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
// Delete habit box
void deleteHabit(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete habit'),
        content: const Text('Are you sure you want to delete this habit?'),
        actions: [
          TextButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor: Colors.transparent,foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Habiter', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
      body: _buildHabitList(),
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        bool isCompleted = isHabitCompletedToday(habit.completedDays);

        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompleted,
          onChanged: (value) => checkHabitOnOff(value, habit),
          onEdit: (context) => editHabit(context, habit),
          onDelete: (context) => deleteHabit(context, habit),
        );
      },
    );
  }
}
