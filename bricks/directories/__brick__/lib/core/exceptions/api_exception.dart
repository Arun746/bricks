class ApiException {
  final String? fullResponse;
  late String _message;
  String get message => _message;
  final int? statusCode;
  ApiException({required this.statusCode, dynamic message, this.fullResponse}) {
    if (message is Map && message.keys.isNotEmpty) {
      // Extract the first error message from the map
      _message = message[message.keys.first].toString();
    } else if (message is String) {
      _message = message;
    } else {
      _message = 'An error occurred';
    }
  } 
  @override
  String toString() => '$statusCode, $_message';
}
