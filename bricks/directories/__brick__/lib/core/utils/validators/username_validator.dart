String? usernameValidator(String? username) {
  if (username != null) {
    if (username.length < 4 || username.length > 10) {
      return 'Username must be 4-10 alphanumeric characters.';
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username)) {
      return 'Username must contain only alphanumeric characters.';
    }
  }
  return null;
}
