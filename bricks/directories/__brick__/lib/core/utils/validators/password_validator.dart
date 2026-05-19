String? passwordValidator(String? password) {
  final RegExp regex =
      RegExp(r'^(?=.*[A-Z])(?=.*[@#$%^&+=])(?=.*\d)(?!.*\s).{10,15}$');
  if (password == null) {
    return 'Password cannot be null!';
  }
  if (password.isEmpty) {
    return 'Password cannot be empty!';
  }
  if (password.contains(' ')) {
    return 'Password should not contain spaces!';
  }
  if (password.length < 10 || password.length > 15) {
    return 'Password must be between 10-15 characters long';
  } else if (regex.hasMatch(password)) {
    return null;
  } else {
    const specialCharacters = "@#\u0024%^&+=";
    return 'Password must contain at least one UPPERCASE letter, one digit and one special character($specialCharacters)';
  }
}
