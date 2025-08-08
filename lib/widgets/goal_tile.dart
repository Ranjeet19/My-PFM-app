import 'package:flutter/material.dart';

class GoalTile extends StatelessWidget {
  final String title;
  final double current;
  final double target;
  final VoidCallback onDelete;

  const GoalTile({
    super.key,
    required this.title,
    required this.current,
    required this.target,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (current / target).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            )
          ]),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            color: Colors.green,
          ),
          const SizedBox(height: 3),
          Text("Saved: \£${current.toStringAsFixed(2)} / \£${target.toStringAsFixed(2)}"),
        ],
      ),
    );
  }
}
