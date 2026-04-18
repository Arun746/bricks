import 'package:email_validator/email_validator.dart';

String? emailValidator(String? email) {
  if (email != null) {
    if (email.isEmpty) {
      return 'Email can not be empty';
    }
    if (email.contains(' ')) {
      return 'Email should not contain empty spaces!';
    }
    if (EmailValidator.validate(email) != true) {
      return 'Please enter a valid email';
    }
  }
  return null;
}
