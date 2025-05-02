import 'package:flutter/material.dart';

class ActionsColumn extends StatelessWidget {
  const ActionsColumn({
    super.key,
    required this.onEdit,
    this.onDelete,
    this.width = 100,
  });

  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: onEdit,
            visualDensity: VisualDensity.compact,
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: onDelete,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
} 