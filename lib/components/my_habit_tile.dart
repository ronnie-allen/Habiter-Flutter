import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? onEdit;
  final void Function(BuildContext)? onDelete;

  const MyHabitTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onEdit,
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: onDelete,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => onChanged?.call(!isCompleted),
          // hbabit tile
          child: Container(
            decoration: BoxDecoration(
              color:
                  isCompleted
                      ? Colors.green
                      : Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(15),
            child: ListTile(
              title: Text(
                text,
                style: TextStyle(
                  color:isCompleted
                          ? Colors.white
                          : Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              leading: Checkbox(
                activeColor: Colors.green,
                value: isCompleted,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
