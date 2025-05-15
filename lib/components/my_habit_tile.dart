import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatefulWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? onEdit;
  final void Function(BuildContext)? onDelete;

  const MyHabitTile({
    required Key key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<MyHabitTile> createState() => _MyHabitTileState();
}

class _MyHabitTileState extends State<MyHabitTile> {
  late bool _localCompleted;

  @override
  void initState() {
    super.initState();
    _localCompleted = widget.isCompleted;
  }

  @override
  void didUpdateWidget(covariant MyHabitTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep local state in sync when external state changes
    if (oldWidget.isCompleted != widget.isCompleted) {
      _localCompleted = widget.isCompleted;
    }
  }

  void _toggleCheckbox(bool? value) {
    if (value != null) {
      setState(() {
        _localCompleted = value;
      });
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: widget.onEdit,
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: widget.onDelete,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => _toggleCheckbox(!_localCompleted),
          child: Container(
            decoration: BoxDecoration(
              color: _localCompleted
                  ? Colors.green
                  : Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(15),
            child: ListTile(
              title: Text(
                widget.text,
                style: TextStyle(
                  color: _localCompleted
                      ? Colors.white
                      : Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              leading: Checkbox(
                activeColor: Colors.green,
                value: _localCompleted,
                onChanged: _toggleCheckbox,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
