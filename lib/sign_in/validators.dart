abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator extends StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidator {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = "Email can't be emtpy";
  final String invalidPasswordErrorText = "Password can't be empty";
}
