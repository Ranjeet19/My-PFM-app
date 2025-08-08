import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/goal.dart';
import 'goal_tile.dart';

class GoalSection extends StatefulWidget {
  const GoalSection({super.key});

  @override
  State<GoalSection> createState() => _GoalSectionState();
}

class _GoalSectionState extends State<GoalSection> {
  late Box<Goal> _goalBox;

  @override
  void initState() {
    super.initState();
    _goalBox = Hive.box<Goal>('goals');
  }

  void _showAddGoalDialog() {
    final titleController = TextEditingController();
    final currentController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Goal Title'),
            ),
            TextField(
              controller: currentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Current Amount'),
            ),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Amount'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final current = double.tryParse(currentController.text) ?? 0;
                final target = double.tryParse(targetController.text) ?? 0;

                if (title.isNotEmpty && target > 0) {
                  _goalBox.add(Goal(title: title, current: current, target: target));
                }
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Add')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final goals = _goalBox.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Your Goals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              onPressed: _showAddGoalDialog,
              icon: const Icon(Icons.add_circle, color: Colors.green, size: 28),
            )
          ],
        ),
        const SizedBox(height: 8),
        ...goals.map((goal) => GoalTile(
              title: goal.title,
              current: goal.current,
              target: goal.target,
              onDelete: () {
                goal.delete();
                setState(() {});
              },
            )),
      ],
    );
  }
}
