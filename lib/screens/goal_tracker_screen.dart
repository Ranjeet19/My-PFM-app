import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/goal.dart';

class GoalTrackerScreen extends StatefulWidget {
  const GoalTrackerScreen({super.key});

  @override
  State<GoalTrackerScreen> createState() => _GoalTrackerScreenState();
}

class _GoalTrackerScreenState extends State<GoalTrackerScreen> {
  late Box<Goal> _goalBox;

  @override
  void initState() {
    super.initState();
    _goalBox = Hive.box<Goal>('goals');
  }

  void _showAddOrEditGoalDialog({Goal? goal, int? index}) {
    final titleController = TextEditingController(text: goal?.title ?? '');
    final targetController = TextEditingController(
        text: goal != null ? goal.targetAmount.toString() : '');
    final savedController = TextEditingController(
        text: goal != null ? goal.savedAmount.toString() : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(goal == null ? 'Add Goal' : 'Edit Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Goal Title'),
            ),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Amount'),
            ),
            TextField(
              controller: savedController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Saved Amount'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () {
              final title = titleController.text.trim();
              final target =
                  double.tryParse(targetController.text.trim()) ?? 0;
              final saved = double.tryParse(savedController.text.trim()) ?? 0;

              if (title.isEmpty || target <= 0) return;

              final newGoal = Goal(
                title: title,
                targetAmount: target,
                savedAmount: saved,
              );

              if (goal == null) {
                _goalBox.add(newGoal);
              } else if (index != null) {
                _goalBox.putAt(index, newGoal);
              }
              Navigator.pop(context);
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final goals = _goalBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("🎯 Goal Tracker"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: const Color(0xFFE8FCEF),
      body: goals.isEmpty
          ? const Center(child: Text("No financial goals yet."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final percent =
                    (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(goal.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: percent,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.green,
                          minHeight: 10,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "\$${goal.savedAmount.toStringAsFixed(2)} / \$${goal.targetAmount.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showAddOrEditGoalDialog(
                                  goal: goal, index: index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _goalBox.deleteAt(index);
                                setState(() {});
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddOrEditGoalDialog(),
        label: const Text("Add Goal"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
