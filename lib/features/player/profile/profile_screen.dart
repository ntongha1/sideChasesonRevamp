import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/controller/users_controller.dart';
import 'package:sonalysis/core/widgets/profile_pic.dart';
import 'package:sonalysis/helpers/auth/shared_preferences_class.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/model/response/UserLoginResultModel.dart';
import 'package:sonalysis/model/response/UserRegisterResultModel.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/validators/registration_validation.dart';
import 'package:sonalysis/widgets/custom_button.dart';
import 'package:sonalysis/widgets/custom_date_field.dart';
import 'package:sonalysis/widgets/loader_widget.dart';
import 'package:sonalysis/widgets/textfield.dart';
import 'package:sonalysis/validators/login_validators.dart' as validator;

import '../../../core/utils/helpers.dart';
import '../dashboard/DashboardScreen.dart';

class ProfileScreenPlayer extends StatefulWidget {
  const ProfileScreenPlayer({Key? key}) : super(key: key);

  @override
  _ProfileScreenPlayerState createState() => _ProfileScreenPlayerState();
}

class _ProfileScreenPlayerState extends State<ProfileScreenPlayer> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _linkToBioController = TextEditingController();

  bool canSubmit = false, isSubmitting = false;
  SharedPreferencesClass sharedPreferencesClass = SharedPreferencesClass();

  bool isEditMode = false;
  UserLoginResultModel? userLoginResultModel;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    await sharedPreferencesClass.getUserModel().then((value) async {
      setState(() {
        userLoginResultModel = value;
        _firstNameController.text =
            userLoginResultModel!.data!.user!.firstname!;
        _lastNameController.text = userLoginResultModel!.data!.user!.lastname!;
        _countryController.text = userLoginResultModel!.data!.user!.country!;
        _emailController.text =
            userLoginResultModel!.data!.user!.email!.toLowerCase();
      });
    });
  }

  Future<void> _validate(context, [bool isSubmit = false]) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String dob = _dobController.text.trim().isEmpty
        ? DateTime.now().toString()
        : _dobController.text.trim();
    String age = _ageController.text.trim();
    String country = _countryController.text.trim();
    String companyEmail = _emailController.text.trim();
    String phoneNumber =
        _countryCodeController.text.trim() + _phoneNumberController.text.trim();

    //print(email);

    if (!requiredValidator(firstName)) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, firstName_error);
      return;
    }

    if (!requiredValidator(lastName)) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, lastName_error);
      return;
    }

    if (!requiredValidator(dob)) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, clubName_error);
      return;
    }

    if (!requiredValidator(age)) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, clubName_error);
      return;
    }

    if (dob == null || dob.isEmpty) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, date_of_birth_error);
      return;
    }

    if (!requiredValidator(country)) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, country_error);
      return;
    }

    if (!validator.emailValidator(companyEmail)) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, email_error);
      return;
    }

    if (!requiredValidator(phoneNumber)) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, phoneNumber_error);
      return;
    }

    setState(() {
      canSubmit = true;
    });
  }

  Future<void> _handleEditProfile(BuildContext context) async {
    UserRegisterResultModel clubRegisterResultModel = await UsersController()
        .doPlayerProfileUpdate(
            context,
            userLoginResultModel!.data!.user!.sId!,
            "",
            _emailController.text.trim(),
            "",
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _countryController.text.trim());

    if (clubRegisterResultModel.status == "success") {
      //store token
      sharedPreferencesClass
          .setToken(clubRegisterResultModel.userRegisterResultData!.authToken!);
      //move to next page
      Navigator.pushReplacementNamed(context, routePopUpPageScreen, arguments: {
        "image": "/requestIsProcessing.png",
        "route": routeOnboarding
      });
    } else {
      showSnackError(context, clubRegisterResultModel.message!);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    //sharedPreferencesClass.clearAll();
    return userLoginResultModel == null
        ? LoaderWidget()
        : Scaffold(
            backgroundColor: sonaBlack,
            appBar: AppBar(
              backgroundColor: sonaBlack,
              centerTitle: true,
              title: Text("Set up profile",
                  style: TextStyle(
                    color: Colors.white,
                    //fontFamily: generalFont,
                    fontSize: 14.sp,
                    fontStyle: FontStyle.normal,
                  )),
              elevation: 0,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              actions: const [
                // InkWell(
                //     onTap: () => {
                //           Navigator.pushReplacementNamed(
                //               context, routePopUpPageScreen, arguments: {
                //             "image": "/nowExplore.png",
                //             "route": routeCoachDashboardScreen
                //           })
                //         },
                //     child: Center(
                //       child: Container(
                //         padding: const EdgeInsets.only(right: 20),
                //         child: Text("Save",
                //             style: TextStyle(
                //               color: Colors.white,
                //               //fontFamily: generalFont,
                //               fontSize: 14.sp,
                //               fontStyle: FontStyle.normal,
                //             )),
                //       ),
                //     ))
              ],
            ),
            body: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Container(
                    color: sonaBlack,
                    child: userLoginResultModel == null
                        ? LoaderWidget()
                        : Column(
                            children: [
                              const ProfilePic(),
                              const SizedBox(height: 20),
                              Text(
                                userLoginResultModel!.data!.user!.firstname ??
                                    "",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                userLoginResultModel!.data!.user!.role ?? "",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.44,
                                      child: MyCustomTextField(
                                        fieldType: FieldType.REQUIRED_FIELD,
                                        labelText: "first name",
                                        hintText: "eg. John",
                                        onChange: () {
                                          _validate(context);
                                        },
                                        textInputType: TextInputType.name,
                                        controller: _firstNameController,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.44,
                                      child: MyCustomTextField(
                                        fieldType: FieldType.REQUIRED_FIELD,
                                        labelText: "last name",
                                        hintText: "eg. Doe",
                                        onChange: () {
                                          _validate(context);
                                        },
                                        textInputType: TextInputType.name,
                                        controller: _lastNameController,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.44,
                                        child: CustomDateField(
                                            locked: false,
                                            labelText: "date of birth",
                                            controller: _dobController,
                                            onChange: () {
                                              _validate(context);
                                            },
                                            maxDateTime: DateTime.now()
                                                .subtract(const Duration(
                                                    days: 365 * 18)),
                                            icon: const Icon(
                                              Icons.date_range,
                                              color: Colors.white,
                                            ))),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.44,
                                      child: MyCustomTextField(
                                        fieldType: FieldType.REQUIRED_FIELD,
                                        labelText: "Age",
                                        hintText: "Enter your age",
                                        onChange: () {
                                          _validate(context);
                                        },
                                        textInputType: TextInputType.number,
                                        controller: _ageController,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              MyCustomTextField(
                                fieldType: FieldType.EMAIL_FIELD,
                                labelText: "email",
                                hintText: "example@gmail.com",
                                onChange: () {
                                  _validate(context);
                                },
                                textInputType: TextInputType.emailAddress,
                                controller: _emailController,
                              ),
                              InkWell(
                                onTap: () {
                                  showCountryPicker(
                                      context: context,
                                      showPhoneCode: false,
                                      countryListTheme: countryListThemeData(),
                                      onSelect: (Country country) {
                                        setState(() {
                                          _countryController.text = country
                                              .displayNameNoCountryCode
                                              .trim()
                                              .replaceAll(
                                                  RegExp(' \\(.*?\\)'), '');
                                        });
                                        //print("Selected country: ${country.displayName}");
                                      });
                                },
                                child: MyCustomTextField(
                                  fieldType: FieldType.REQUIRED_FIELD,
                                  labelText: "Country",
                                  locked: true,
                                  textInputType: TextInputType.text,
                                  controller: _countryController,
                                ),
                              ),
                              MyCustomTextField(
                                fieldType: FieldType.REQUIRED_FIELD,
                                labelText: "phone number",
                                hintText: "901-912-35646",
                                textInputType: TextInputType.phone,
                                controller: _phoneNumberController,
                                countryCodeController: _countryCodeController,
                                showCountryCode: true,
                                onChange: () {
                                  _validate(context);
                                },
                              ),
                              MyCustomTextField(
                                fieldType: FieldType.REQUIRED_FIELD,
                                labelText: "link to portfolio",
                                hintText: "Paste link here",
                                controller: _linkToBioController,
                                onChange: () {
                                  _validate(context);
                                },
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              CustomButton(
                                text: isSubmitting ? "Submitting" : "Submit",
                                showLoader: isSubmitting,
                                color: canSubmit
                                    ? sonaPurple1
                                    : sonaPurpleDisabled,
                                action: () async {
                                  if (canSubmit) {
                                    //_handleEditProfile(context);
                                    pushNewScreen(
                                      context,
                                      screen: PlayerDashboardScreen(),
                                      withNavBar:
                                          true, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                    );
                                  }
                                },
                              ),
                            ],
                          ))),
            //bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
          );
  }
}
