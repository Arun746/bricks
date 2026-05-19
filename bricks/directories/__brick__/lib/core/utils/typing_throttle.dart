
/// A utility to throttle function calls, typically used for typing events.
///
/// This class ensures that the [onTriggered] callback is not called more than
/// once within the specified [interval]. Useful for reducing the frequency of
/// actions like API calls or UI updates in response to rapid user input.
///
/// Example usage:
/// ```dart
/// final throttle = TypingThrottle(
///   interval: Duration(milliseconds: 500),
///   onTriggered: () => print('Triggered!'),
/// );
///
/// // Call this in your onChanged or similar callback
/// throttle.call();
/// ```
import 'dart:async';

/// Throttles function calls to ensure [onTriggered] is not called more than once per [interval].
class TypingThrottle {

  /// The minimum duration between allowed triggers.
  final Duration interval;

  /// The callback to invoke when the throttle allows.
  final void Function() onTriggered;


  /// The last time the callback was triggered.
  DateTime? _lastTriggered;

  /// Timer to reset the throttle state.
  Timer? _resetTimer;


  /// Creates a [TypingThrottle] with the given [interval] and [onTriggered] callback.
  TypingThrottle({
    required this.interval,
    required this.onTriggered,
  });

  /// Attempts to trigger the [onTriggered] callback if the interval has elapsed.
  void call() {
    final now = DateTime.now();
    if (_lastTriggered == null || now.difference(_lastTriggered!) >= interval) {
      _lastTriggered = now;
      onTriggered();
    }

    _resetTimer?.cancel();
    _resetTimer = Timer(interval, () {
      _lastTriggered = null;
    });
  }

  /// Cancels any pending timers and cleans up resources.
  void dispose() {
    _resetTimer?.cancel();
  }
}
