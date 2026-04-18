
extension DurationExtension on Duration {
  ({int days, int hours, int minutes, int seconds}) formattedDuration() {
    final days = inDays.abs();
    final hours = inHours.remainder(24).abs();
    final minutes = inMinutes.remainder(60).abs();
    final seconds = inSeconds.remainder(60).abs();
    return (seconds: seconds, minutes: minutes, hours: hours, days: days);
  }
}
