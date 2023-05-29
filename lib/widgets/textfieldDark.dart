import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/validators/login_validators.dart' as login_validators;
import 'package:sonalysis/validators/registration_validation.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/model/validation_status_model.dart';

import 'error.dart';

class MyCustomTextFieldDark extends StatefulWidget{
  final String? expected;
  final String labelText;
  final String? subtitleText;
  final bool useIcon;
  final bool obscureText;
  final bool showCountryCode;
  final FieldType fieldType;
  final String? hintText;
  final int lines;
  final bool locked, showSubtitle;
  final int? maxLength;
  final bool autoFocus;
  final SubtitlePosition subtitlePosition;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final TextEditingController? countryCodeController;
  final TextEditingController? confirmationController;
  final bool? isDarkModeEnabled;
  final List<TextInputFormatter>? inputFormatters;
  final LockPosition lockPosition;
  final Function()? onChange;

  const MyCustomTextFieldDark({Key? key, this.onChange, required this.labelText, this.hintText, this.obscureText = false, this.textInputType=TextInputType.text, this.controller, this.showCountryCode=false, this.countryCodeController, this.subtitleText, required this.fieldType, this.lines=1, this.locked=false, this.useIcon=false, this.subtitlePosition=SubtitlePosition.BOTTOM, this.isDarkModeEnabled, this.inputFormatters,this.autoFocus = false, this.confirmationController, this.maxLength, this.expected, this.lockPosition=LockPosition.TOP, this.showSubtitle=true}) : super(key: key);

  @override
  _MyCustomTextFieldDarkState createState() => _MyCustomTextFieldDarkState();
}

class _MyCustomTextFieldDarkState extends State<MyCustomTextFieldDark> {
  bool? showPassword, isValid;
  Status? status;
  String error='';

  final Map<FieldType, Function> fieldOnchangeMap={};

  @override
  void initState() { 
    super.initState();
  showPassword=widget.obscureText;

  if(widget.countryCodeController!=null){
    widget.countryCodeController!.text=widget.countryCodeController!.text!=null && widget.countryCodeController!.text.isNotEmpty ? widget.countryCodeController!.text : "+234";
  }

  fieldOnchangeMap[FieldType.EMAIL_FIELD]=emailOnchange;
  fieldOnchangeMap[FieldType.FIRST_NAME_FIELD]=firstNameOnchange;
  fieldOnchangeMap[FieldType.LAST_NAME_FIELD]=lastNameOnchange;
  fieldOnchangeMap[FieldType.MIDDLE_NAME_FIELD]=middleNameOnchange;
  fieldOnchangeMap[FieldType.PHONE_NUMBER_FIELD]=phoneNumberOnchange;
  fieldOnchangeMap[FieldType.PASSWORD_FIELD]=passwordOnchange;
  fieldOnchangeMap[FieldType.ADDRESS_FIELD]=addressOnchange;
  fieldOnchangeMap[FieldType.REQUIRED_FIELD]=requiredOnChange;
  fieldOnchangeMap[FieldType.USERNAME_FIELD]=usernameOnchange;
  fieldOnchangeMap[FieldType.NOT_REQUIRED_FIELD]=notRequiredOnChange;
  fieldOnchangeMap[FieldType.FULLNAME_FIELD]=fullnameOnchange;
  fieldOnchangeMap[FieldType.PHONE_NUMBER_EMAIL_FIELD]=phoneNumberEmailOnchange;
  fieldOnchangeMap[FieldType.PASSWORD]=customPasswordOnchange;
  fieldOnchangeMap[FieldType.PASSWORD_CONFIRMATION]=passwordConfirmationOnchange;
  fieldOnchangeMap[FieldType.BVN]=bvnOnChange;
  fieldOnchangeMap[FieldType.ACCOUNT_NUMBER]=accountNumberOnChange;
  }

  @override
  Widget build(BuildContext context) {

    TextStyle editTextStyle = TextStyle(
      color: Colors.white,
      //fontFamily: generalFont,
      fontSize: 14.0.sp,
      height: 1.3,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: widget.labelText.replaceAll('*', '').replaceAll('(Optional)', '').toUpperCase(),
                  style: TextStyle(
                    color: getColorHexFromStr("C9D0CD"),
                    //fontFamily: generalFont,
                    fontSize: 12.0.sp,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    if(widget.labelText.trim().endsWith('(Optional)'))
                      const TextSpan(
                        text: '(Optional)',
                        style: TextStyle(
                          color: Color.fromRGBO(190, 169, 149, 1),
                        ),
                      ),
                    if(widget.labelText.trim().endsWith('*'))
                      const TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // if(widget.locked && widget.lockPosition==LockPosition.TOP)
            //   Image.asset(
            //     "assets/images/lock.png",
            //     height: 14.w,
            //     width: 14.w,
            //   ),
          ],
        ),
        if(widget.showSubtitle && widget.subtitlePosition==SubtitlePosition.TOP)
        Text(
            widget.subtitleText!,
            // maxLines: 2,
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFFAA9B8E),//.withOpacity(.7),
              //fontFamily: generalFont,
              fontSize: 12.0.sp,
              height: 1.2,
              letterSpacing: -.7,
              fontWeight: FontWeight.w500,
            ),
          ),
        SizedBox(height: 3.h),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.w),
            border: Border.all(color: getColorHexFromStr("5E5E5E")),
            color: sonaBlack,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            children: [
              widget.showCountryCode ? CountryCodePicker(
                    onChanged: (countryCode){
                      widget.countryCodeController!.text = countryCode.dialCode!;
                    },
                    initialSelection: '+234',//widget.countryCodeController?.text,
                    showCountryOnly: false,
                    hideMainText: false,
                    alignLeft: true,
                    textStyle: editTextStyle,
                    showDropDownButton: true,
                    enabled: !widget.locked,
                    flagWidth: 23.w,
                  ) : const SizedBox.shrink(),
              Expanded(
                //child: TextField( //this does not allow text copy, cut, past, select all
                //had to create a custom CustomTextField to override flutter behaviour
                //https://stackoverflow.com/questions/63501492/flutter-cannot-select-copy-or-paste-in-editabletext
                child: TextField(
                  cursorColor: Colors.white,
                  autofocus: widget.autoFocus,
                  inputFormatters: widget.inputFormatters,
                  minLines: widget.lines,
                  maxLines: widget.lines,
                  maxLength: widget.maxLength,
                  keyboardType: widget.textInputType,
                  style: editTextStyle,
                  obscureText: showPassword!,
                  enabled: !widget.locked,
                  onChanged: (String value){
                    fieldOnchangeMap[widget.fieldType]!(value);
                    if(widget.onChange != null) widget.onChange!();
                  },
                  controller: widget.controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: sonaBlack,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: sonaBlack, width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: sonaBlack, width: 0.0),
                    ),
                    hintText: widget.hintText ?? widget.labelText,
                    hintStyle: editTextStyle.copyWith(color: getColorHexFromStr("5E5E5E")),
                    suffixIcon:  widget.obscureText ? Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            showPassword=!showPassword!;
                          });
                        },
                        child: widget.useIcon ? Icon(
                          showPassword! ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xFFFFFFFF),
                          size: 20.w,
                        ) : Text(
                          !showPassword! ? "Hide" : "Show",
                          style: TextStyle(
                            color: const Color(0xFF4C6174),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),

                        ),
                      ),
                    ) : const SizedBox.shrink(),
                  ),

                  // decoration: const InputDecoration(
                  //   isDense: true,
                  //   contentPadding: EdgeInsets.all(0),
                  //   border: InputBorder.none,
                  // ),
                ),
              ),
              // if(widget.locked && widget.lockPosition==LockPosition.CENTER)
              //   Image.asset(
              //     "assets/images/lock.png",
              //     height: 14.w,
              //     width: 14.w,
              //   ),

            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: CustomError(error: error),
        ),
        if(widget.showSubtitle && widget.subtitlePosition==SubtitlePosition.BOTTOM)
          widget.subtitleText!=null && widget.subtitleText!.isNotEmpty ? Text(
            widget.subtitleText!,
            // maxLines: 2,
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFFBEA995),
              fontSize: 12.sp,
              height: 1.4,
              fontWeight: FontWeight.normal
            ),
          ) : const SizedBox.shrink()
      ],
    );
  }

  emailOnchange(value){
   setState(() {
      isValid = login_validators.emailValidator(value);
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        if (!isValid!) {
        error = email_error;
        } else {
          error='';
        }
      }
    }); 
  }

  usernameOnchange(value){
   setState(() {
      isValid = UserNameValidated(value);
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        if (!isValid!) {
          error=userName_error;
        } else {
          error='';
        }
      }
    }); 
  }

  pensionUsernameOnchange(value){
   setState(() {
      isValid = login_validators.pensionUserNameValidated(value);
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        if (!isValid!) {
          error="${widget.labelText} is not valid";
        } else {
          error='';
        }
      }
    }); 
  }

  rsaOnchange(value){
   setState(() {
      isValid = login_validators.validateRSA(value);
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        if (!isValid!) {
          error="${widget.labelText} is not valid";
        } else {
          error='';
        }
      }
    }); 
  }

  membershipOnchange(value){
   setState(() {
      isValid = login_validators.validateMembershipNumber(value);
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        if (!isValid!) {
          error="${widget.labelText} is not valid";
        } else {
          error='';
        }
      }
    }); 
  }

  addressOnchange(String value){
   setState(() {
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        error='';
      }
    }); 
  }

  firstNameOnchange(value){
   setState(() {
      isValid = firstNameValidator(value);
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        if (!isValid!) {
          error=firstName_error;
        } else {
          error='';
        }
      }
    }); 
  }

  fullnameOnchange(value){
   setState(() {
      isValid = fullNameValidator(value);
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        if (!isValid!) {
          error=firstName_error;
        } else {
          error='';
        }
      }
    });
  }

  lastNameOnchange(value){
   setState(() {
      isValid = lastNameValidator(value);
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        if (!isValid!) {
          error=lastName_error;
        } else {
          error='';
        }
      }
    }); 
  }

  middleNameOnchange(value){
   setState(() {
      isValid = middleNameValidator(value);
      if(value==null || value.isEmpty){
        error='';
        // error='This field is required';
      }else {
        if (!isValid!) {
          error=middleName_error;
        } else {
          error='';
        }
      }
    }); 
  }

  phoneNumberOnchange(value){
    if(widget.countryCodeController!=null)value=widget.countryCodeController!.text+value;
   setState(() {
      isValid = phoneNumberValidator(value);
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        if (!isValid!) {
          error=phoneNumber_error;
        } else {
          error='';
        }
      }
    }); 
  }

  phoneNumberEmailOnchange(value){
   setState(() {
      isValid = phoneNumberValidator(value) || login_validators.emailValidator(value);
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        if (!isValid!) {
          error="${widget.labelText} is not valid";
        } else {
          error='';
        }
      }
    }); 
  }

  customPasswordOnchange(value){
   setState(() {
      isValid= login_validators.customPasswordValidator(value);
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        if (!isValid!) {
          if(widget.subtitleText!=null && widget.subtitleText!.isNotEmpty) {
            error=widget.subtitleText!.toLowerCase();
          } else {
            error='${widget.labelText} is not valid';
          }
        } else {
          error='';
        }
      }
    }); 
  }

  passwordConfirmationOnchange(value){
   setState(() {
      isValid= widget.confirmationController!.text.compareTo(value)==0;
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        if (!isValid!) {
          error="Passwords do not match";
        } else {
          error='';
        }
      }
    }); 
  }

  passwordOnchange(value){
   setState(() {
      isValid = login_validators.customPasswordValidator(value);
      if(value==null || value.isEmpty){
        error='This field is required';
      }else {
        if (!isValid!) {
          if(widget.subtitleText!=null && widget.subtitleText!.isNotEmpty) {
            error = widget.subtitleText!.toLowerCase();
          } else {
            error='${widget.labelText} is not valid';
          }
        } else {
          error='';
        }
      }
    }); 
  }

  requiredOnChange(String value){
    setState(() {
      if (value==null || value.isEmpty) {
        error="${widget.labelText} is required";
      }else{
        if(widget.expected!=null && widget.expected!.isNotEmpty){
          if(value!=widget.expected){
            error='${widget.labelText} is not valid';
          }else {
            error='';
          }
        } else{
          error='';
        }
      }
    }); 
  }

  notRequiredOnChange(String value){
    return true;
  }

  bvnOnChange(String value){
    bool res=login_validators.bvnValidator(value);
    if(res){
      error='';
    }else{
      error=bvn_error;
    }
    setState(() {});
  }

  accountNumberOnChange(String value){
    bool res=login_validators.accountNumberValidator(value);
    if(res){
      error='';
    }else{
      error=account_number_error;
    }
    setState(() {});
  }

}

enum FieldType {
  FULLNAME_FIELD, EMAIL_FIELD, USERNAME_FIELD, FIRST_NAME_FIELD, LAST_NAME_FIELD, MIDDLE_NAME_FIELD, PHONE_NUMBER_FIELD, PASSWORD_FIELD, ADDRESS_FIELD, REQUIRED_FIELD, NOT_REQUIRED_FIELD, PHONE_NUMBER_EMAIL_FIELD, PASSWORD, PASSWORD_CONFIRMATION, BVN, ACCOUNT_NUMBER, RESET_TOKEN
}

enum SubtitlePosition{
  TOP, BOTTOM
}

enum LockPosition{
  TOP, CENTER, BOTTOM
}