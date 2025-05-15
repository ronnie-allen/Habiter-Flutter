import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habiter/components/heatmap_section.dart';
import 'package:habiter/components/habit_list_section.dart';
import 'package:habiter/dialogs/create_habit_dialog.dart';
import 'package:habiter/theme/theme_provider.dart';
import 'package:habiter/database/habit_database.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HabitDatabase>(context, listen: false).readHabits();
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void createNewHabit() {
    showCreateHabitDialog(context, textController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'H A B I T E R',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).toggleTheme();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor:
            Theme.of(
              context,
            ).colorScheme.inversePrimary, // ensures icon color contrasts
        child: const Icon(Icons.add),
      ),

      body: ListView(children: [HeatMapSection(), HabitListSection()]),
    );
  }
}
