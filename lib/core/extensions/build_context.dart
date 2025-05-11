import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;
}
