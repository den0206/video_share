String valideName(String value) {
  if (value.isEmpty) {
    return "Your Name";
  } else if (value.length < 3) {
    return "more 3";
  } else {
    return null;
  }
}

bool _isValidEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

String validateEmail(String value) {
  if (value.isEmpty) {
    return "Please add in a email";
  } else if (!_isValidEmail(value)) {
    return "No email Regex";
  } else {
    return null;
  }
}

String validPassword(String value) {
  if (value.isEmpty) {
    return "Please add in a Passwrod";
  } else if (value.length < 6) {
    return "More Long Password(6)";
  } else {
    return null;
  }
}

String validPhone(String value) {
  if (value.isEmpty) {
    return "Fill";
  } else {
    return null;
  }
}

String validVehilcle(String value) {
  if (value.isEmpty) {
    return "Please add in a Vehiclde";
  } else if (value.length < 3) {
    return "More Long 3";
  } else {
    return null;
  }
}
