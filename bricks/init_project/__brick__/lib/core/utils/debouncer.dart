
/// A utility class for debouncing function calls.
///
/// Debouncing ensures that a function is only called after a certain period
/// of inactivity. This is useful for scenarios like search-as-you-type,
/// where you want to wait until the user has stopped typing before making
/// an API call or updating the UI.
///
/// Example usage:
/// ```dart
/// final debouncer = Debouncer(milliseconds: 300);
///
/// // Call this in your onChanged or similar callback
/// debouncer.run(() => print('Action triggered!'));
/// ```
import 'dart:async';

import 'package:flutter/material.dart';

/// Debounces function calls to ensure the action is only called after a period of inactivity.
class Debouncer {

  /// The debounce interval in milliseconds.
  final int milliseconds;

  /// The timer used to track the debounce interval.
  Timer? _timer;

  /// Creates a [Debouncer] with the given debounce interval.
  Debouncer({this.milliseconds = 500});

  /// Runs the provided [action] after the debounce interval has elapsed.
  ///
  /// If called again before the interval ends, the previous call is cancelled.
  void run(VoidCallback action) {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels any pending debounced action.
  void cancel() {
    if (_timer != null) {
      _timer?.cancel();
    }
  }
}
