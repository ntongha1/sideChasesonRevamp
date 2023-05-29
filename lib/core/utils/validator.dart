const String _emailPattern =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
final RegExp _emailRegExp = RegExp(_emailPattern);

final RegExp _hasUppercaseExp = RegExp(r'[A-Z]');
final RegExp _hasLowercaseExp = RegExp(r'[a-z]');
final RegExp _hasSpecialCharactersRegExp = RegExp(r'[!@#$%^&*(),.?":{}_|<>]');

const String _pinPattern = r'(^(PEN)[0-9]{12}$)';
final RegExp pinExp = RegExp(_pinPattern);

const String _membershipNumberPattern = r'(^[0-9]{7}$)';
final RegExp _membershipExp = RegExp(_membershipNumberPattern);

const String _phoneNumberPattern = r'(^[0-9]{10}$)';
final RegExp _phoneNumberRegExp = RegExp(_phoneNumberPattern);

const String _agePattern = r'(^[0-9]{2}$)';
final RegExp _ageRegExp = RegExp(_agePattern);

String namePattern = r'^[a-zA-Z-]+$';
RegExp regExp = RegExp(namePattern);

class Validator {
  static String? emailValidator(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    if (!_emailRegExp.hasMatch(email.trim())) return 'Email is not valid.';
    return null;
  }

  static String emailValidatorString(String? email, bool force) {
    var r = emailValidator(email);
    if (email == '' && !force) return '';
    return r != null ? r : '';
  }

  static String? passwordValidator(String? value) {
    // 1. Must have at least one Upper Case
    // 2. Must have at least one lower case
    // 3. Must have a special character
    // 4. Must be a minimum of  8 character length
    // 5. Must not exceed a maximum of 16xters length
    if (value == null) return 'password is required';
    value = value.trim();
    bool hasSpace = value.contains(' ');
    if (hasSpace) return 'password cannot contain space';
    bool hasUppercase = value.contains(_hasUppercaseExp);
    // bool hasDigits = value.contains(_hasDigitsExp);
    bool hasLowercase = value.contains(_hasLowercaseExp);
    bool hasSpecialCharacters = value.contains(_hasSpecialCharactersRegExp);
    bool hasMinLength = value.length >= 6;
    bool hasMaxLength = value.length <= 18;

    if (hasUppercase &&
        hasLowercase &&
        hasSpecialCharacters &&
        (hasMinLength || hasMaxLength)) return null;
    //return "Password length must be between 6 and 8 characters and include  upper case and special characters.";
    return "Invalid password";
  }

  // passwordValidatorString
  static String passwordValidatorString(String? value, bool force) {
    var r = passwordValidator(value);
    if (value == '' && !force) return '';

    return r != null ? r : '';
  }

  static String? validateMembershipNumber(String? value) {
    if (value == null) return '';
    if (_membershipExp.hasMatch(value.trim())) return null;
    return 'Membership Number is not valid';
  }

  //validateMembershipNumberString
  static String validateMembershipNumberString(String? value, bool force) {
    var r = validateMembershipNumber(value);
    if (value == '' && !force) return '';

    return r != null ? r : '';
  }

  static String? validateMobile(String? value) {
    if (value == null) return '';
    if (_phoneNumberRegExp.hasMatch(value.trim())) return null;
    return 'Phone number is not valid';
  }

  // validateMobileString
  static String validateMobileString(String? value, bool force) {
    var r = validateMobile(value);
    if (value == '' && !force) return '';

    return r != null ? r : '';
  }

  static String? validateAge(String? value) {
    if (value == null) return '';
    if (_ageRegExp.hasMatch(value.trim())) return null;
    return 'Age is not valid';
  }

  // validateAgeString
  static String validateAgeString(String? value, bool force) {
    var r = validateAge(value);
    if (value == '' && !force) return '';

    return r != null ? r : '';
  }

  static String? validateLink(String? value) {
    if (value == null) return '';
    if (Uri.parse(value).isAbsolute) return null;
    return 'URL is not valid';
  }

  // validateLinkString
  static String validateLinkString(String? value, bool force) {
    var r = validateLink(value);
    if (value == '' && !force) return '';

    return r != null ? r : '';
  }

  static String? firstnameValidator(String? value) {
    // if (value == null ) return '';
    bool valid = value!.isNotEmpty && value.length > 2 && value.length <= 30;
    if (valid && regExp.hasMatch(value)) {
      return null;
    }
    return 'Invalid First Name';
  }

  static String? leaguenameValidator(String? value) {
    // if (value == null ) return '';
    bool valid = value!.isNotEmpty && value.length > 2 && value.length <= 30;
    if (valid && regExp.hasMatch(value)) {
      return null;
    }
    return 'Invalid League Name';
  }

  static String? seasonnameValidator(String? value) {
    // if (value == null ) return '';
    bool valid = value!.isNotEmpty;
    if (valid && regExp.hasMatch(value)) {
      return null;
    }
    return 'Season is required';
  }

  // firstnameValidatorString
  static String firstnameValidatorString(String? value, bool force) {
    var r = firstnameValidator(value);
    if (value == '' && !force) return '';

    return r != null ? r : '';
  }

  static String? lastnameValidator(String? value) {
    if (value == null) return '';
    bool valid = value.isNotEmpty && value.length > 2 && value.length <= 30;
    if (valid && regExp.hasMatch(value)) {
      return null;
    }
    return 'Invalid Last Name';
  }

  static String leageunameValidatorString(String? value, bool force) {
    var r = leaguenameValidator(value);
    if (value == '' && !force) return '';

    return r != null ? r : '';
  }

  //  lastnameValidatorString
  static String lastnameValidatorString(String? value, bool force) {
    var r = lastnameValidator(value);
    if (value == '' && !force) return '';

    return r != null ? r : '';
  }

  static String seasonnameValidatorString(String? value, bool force) {
    var r = seasonnameValidator(value);
    if (value == '' && !force) return '';

    return r != null ? r : '';
  }

  static String? phoneEmailValidator(String? value) {
    if (emailValidator(value) == null || validateMobile(value) == null) {
      return null;
    }
    return 'Phone Number / Email Address is not valid';
  }

  // phoneEmailValidatorString
  static String phoneEmailValidatorString(String? value, bool force) {
    var r = phoneEmailValidator(value);
    if (value == '' && !force) return '';

    return r != null ? r : '';
  }

  static String? requiredValidator(String? value) {
    if (value != null && value.isNotEmpty) return null;
    return 'This field is required';
  }

  // requiredValidatorString
  static String requiredValidatorString(String? value, bool force) {
    var r = requiredValidator(value);
    if (value == '' && !force) return '';

    return r != null ? r : '';
  }
}
