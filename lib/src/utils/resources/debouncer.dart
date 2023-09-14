import 'dart:async';
import 'package:flutter/foundation.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void debounce(VoidCallback callback) {
    action = callback;
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), () {
      if (action != null) {
        action!();
      }
    });
  }
}