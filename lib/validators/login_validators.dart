
//




//               OLUFEMI         ADETOLA             <bold!>JOLUGBO<bold!>




//


bool userNameValidated(String userName){
  if( userName.isEmpty || userName.length <= 3){
    return false;
  }
  return true;
}

bool validateRSA(String pin){
  pin=pin.toUpperCase().trim();
  String pattern = r'(^(PEN)[0-9]{12}$)';
  RegExp exp = new RegExp(pattern);
  return exp.hasMatch(pin);
}

bool validateMembershipNumber(String value){
  String pattern = r'(^[0-9]{7}$)';
  RegExp exp = new RegExp(pattern);
  return exp.hasMatch(value.trim());
}

bool validateMobile(String mobile) {
  String pattern = r'(^[0]\d{10}$)|(^[\+]?[234]\d{12}$)';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(mobile.trim());
}  

bool pensionUserNameValidated(String userName){
  return validateRSA(userName) || emailValidator(userName) || validateMobile(userName);
}

PasswordValidationResp passwordValidator(String password){
  PasswordValidationResp ErrorResp = PasswordValidationResp(0,'');
  if( password.isEmpty || password.length < 5) {
    ErrorResp.error = 'Invalid password input';
    ErrorResp.validated--;
  }
  return ErrorResp;
}

bool customPasswordValidator(String password){
  // 1. Must have one Upper Case
  // 2. Must have one lower case
  // 3. Must have a special character
  // 4. Must be a minimum of  6 character length
  // 5. Must not exceed a maximum of 16xters length

  password=password.trim();
  bool hasSpace = password.contains(' ');
  if(hasSpace)return false;
  bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
  bool hasDigits = password.contains(new RegExp(r'[0-9]'));
  bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
  bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}_|<>]'));
  bool hasMinLength = password.length >= 6;
  bool hasMaxLength = password.length <= 6;

  return hasUppercase && hasLowercase && hasSpecialCharacters && hasMinLength && hasMaxLength;

}

bool emailValidator(String email){
  // final String emailPattern = r"(^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+)$";
  final String emailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp exp = new RegExp(emailPattern);
  return exp.hasMatch(email.trim());
}

bool bvnValidator(String value){
  return value.length==11;
}

bool accountNumberValidator(String value){
  return value.length==10;
}

class PasswordValidationResp{
  int validated;
  String error;
  PasswordValidationResp(this.validated,this.error);
}