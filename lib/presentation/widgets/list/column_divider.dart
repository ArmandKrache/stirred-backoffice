import 'package:flutter/material.dart';

class ColumnDivider extends StatelessWidget {
  const ColumnDivider({
    super.key,
    this.height = 24,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: height,
      color: Colors.grey.shade200,
    );
  }
} 