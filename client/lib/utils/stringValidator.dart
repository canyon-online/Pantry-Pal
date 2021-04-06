// This file adds methods to strings (that may be null) in order to check if they
// are valid emails, names, or passwords.

extension StringValidator on String? {
  bool isValidEmail() {
    if (this == null) return false;
    // Regex for a standard email found on StackOverflow.
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this!);
  }

  bool isValidName() {
    if (this == null) return false;
    // Regex for a standard name found on StackOverflow.
    return RegExp(r'^[A-Za-z0-9]+(?:[_-][A-Za-z0-9]+)*$').hasMatch(this!);
    // Old version to allow the inclusion of spaces in a name:
    // return RegExp(r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$').hasMatch(this!);
  }

  bool isValidPassword() {
    if (this == null) return false;
    return this!.length >= 8 && this!.length <= 32;
  }
}
