import 'package:flutter/material.dart';

class CustomGenericDataTableWidget<T> extends StatelessWidget {
  final List<T> data;
  final List<DataColumn> columns;
  final DataRow Function(T item) buildRow;

  const CustomGenericDataTableWidget({
    super.key,
    required this.data,
    required this.columns,
    required this.buildRow,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns,
          rows: data.map((item) => buildRow(item)).toList(),
        ),
      ),
    );
  }
}