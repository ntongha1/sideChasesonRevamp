
//




//               OLUFEMI         ADETOLA             <bold!>JOLUGBO<bold!>




//

import 'dart:io';

bool firstNameValidator(String firstname){
  firstname=firstname.trim();
  bool valid=firstname.isNotEmpty && firstname.length > 2 && firstname.length<=30;
  String pattern = r'^[a-zA-Z-]+$';
  RegExp regExp = RegExp(pattern);

  
  return valid && regExp.hasMatch(firstname);
}

bool fullNameValidator(String fullname){
  fullname=fullname.trim();
  bool valid=fullname.isNotEmpty && fullname.length > 2 && fullname.length<=30;
  String pattern = r'^[a-zA-Z- ]+$';
  RegExp regExp = RegExp(pattern);


  return valid && regExp.hasMatch(fullname);
}

bool lastNameValidator(String lastname){
  lastname=lastname.trim();
  bool valid=lastname.isNotEmpty && lastname.length > 2 && lastname.length<=30;

    String pattern = r'^[a-zA-Z-]+$';
  RegExp regExp = RegExp(pattern);
  
  return valid && regExp.hasMatch(lastname);
}
bool middleNameValidator(String middlename){
  middlename=middlename.trim();
  bool valid=middlename.isNotEmpty && middlename.length > 2 && middlename.length<=30;

    String pattern = r'^[a-zA-Z-]+$';
  RegExp regExp = RegExp(pattern);
  
  return valid && regExp.hasMatch(middlename);
}
bool UserNameValidated(String userName){
  userName=userName.trim();
  if( userName.isEmpty || userName.length <= 6){
    return false;
  }
  return true;
}
bool phoneNumberValidator(String phoneNumber){
  String pattern = r'(^[0]\d{10}$)|(^[\+]?[234]\d{12}$)';

  if(!phoneNumber.startsWith('+234')){
    // pattern = r'(^[\+]?[234]\d{16}$)';
    // pattern = r'(^[0]\d{10}$)|(^[\+]?[234]\d{16}$)';
    return phoneNumber.length > 3 && phoneNumber.length<=16;
  }
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(phoneNumber);
}

class PasswordValidationResp{
  int validated;
  String error;
  PasswordValidationResp(this.validated,this.error);
}

bool requiredValidator(String value){
  return value!=null && value.isNotEmpty;
}

Future<bool> fileValidator(String path) async {
  return path!=null && path.isNotEmpty && await File(path).exists();
}