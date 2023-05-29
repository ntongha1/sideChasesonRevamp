import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/helpers.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/validator.dart';
import 'package:sonalysis/core/widgets/app_datefield.dart';
import 'package:sonalysis/core/widgets/app_phone_field.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/core/widgets/button.dart';

import '../../../../../../core/datasource/local_storage.dart';
import '../../../core/enums/user_type.dart';
import '../../../core/utils/styles.dart';
import '../cubit/settings_cubit.dart';

class PersonalInfoModalWidget extends StatefulWidget {
  const PersonalInfoModalWidget({Key? key}) : super(key: key);

  @override
  _PersonalInfoModalWidgetState createState() =>
      _PersonalInfoModalWidgetState();
}

class _PersonalInfoModalWidgetState extends State<PersonalInfoModalWidget> {
  bool canSubmit = false;
  final _formKey = GlobalKey<FormState>();

  XFile? selectedPhoto, xFileForCropper;
  File? _croppedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _imagePicked = false, isSubmitting = false;

  TextEditingController? _oFirstNameController;
  TextEditingController? _oLastNameController;
  TextEditingController? _dobController;
  TextEditingController? _ageController;
  TextEditingController? _emailController;
  TextEditingController? _countryController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _ePhoneNumberController;
  TextEditingController? _jerseyNumberController;
  TextEditingController? _yearsOfExperienceController;
  TextEditingController? _employmentStartDateController;
  TextEditingController? _employmentEndDateController;
  TextEditingController? _linkToPortfolioController;
  String? myId;
  UserResultData? userResultData;
  bool isLoading = true;

  handlePickPhoto() async {
    XFile? _imagePickerResult = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 675,
        maxWidth: 960,
        preferredCameraDevice: CameraDevice.front);
    if (_imagePickerResult != null) {
      setState(() {
        selectedPhoto = _imagePickerResult;
      });
      cropImage(selectedPhoto!);
    }
  }

  cropImage(XFile documentImages) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: documentImages.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop selected image',
            toolbarColor: AppColors.sonaBlack,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.white.withOpacity(0.4),
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedFile != null) {
      setState(() {
        _croppedFile = croppedFile;
        _imagePicked = true;
      });
    }
    //_validate(context);
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    userResultData = await serviceLocator.get<LocalStorage>().readSecureObject(LocalStorageKeys.kUserPrefs);
    if (userResultData!.user!.role!.toLowerCase() == UserType.player.type) {
      //print(userResultData!.user!.players![0].id.toString());
      myId = userResultData!.user!.players![0].id;
    } else {
      myId = userResultData!.user!.staff![0].id;
    }
    _oFirstNameController = TextEditingController(text: userResultData!.user!.firstName);
    _oLastNameController = TextEditingController(text: userResultData!.user!.lastName);
    _emailController = TextEditingController(text: userResultData!.user!.email);
    _dobController = TextEditingController(text: userResultData!.user!.dob.toString());
    _ageController = TextEditingController();
    _countryController = TextEditingController();
    _phoneNumberController = TextEditingController();
    //
    if (userResultData!.user!.role!.toLowerCase() == UserType.player.type) {
      _jerseyNumberController = TextEditingController(text: userResultData!.user!.players![0].jerseyNo.toString());
      _yearsOfExperienceController = TextEditingController(text: userResultData!.user!.players![0].yearsOfExperience.toString());
      _employmentStartDateController = TextEditingController(text: userResultData!.user!.players![0].employmentStartDate.toString());
      _employmentEndDateController = TextEditingController(text: userResultData!.user!.players![0].employmentEndDate.toString());
      _linkToPortfolioController = TextEditingController(text: userResultData!.user!.players![0].linkToPortfolio.toString());
      _ePhoneNumberController = TextEditingController(text: userResultData!.user!.players![0].emergencyContactNumber.toString());
    } else {
      _jerseyNumberController = TextEditingController(text: userResultData!.user!.staff![0].jerseyNo.toString());
      _yearsOfExperienceController = TextEditingController(text: userResultData!.user!.staff![0].yearsOfExperience.toString());
      _employmentStartDateController = TextEditingController(text: userResultData!.user!.staff![0].employmentStartDate.toString());
      _employmentEndDateController = TextEditingController(text: userResultData!.user!.staff![0].employmentEndDate.toString());
      _linkToPortfolioController = TextEditingController(text: userResultData!.user!.staff![0].linkToPortfolio.toString());
      _ePhoneNumberController = TextEditingController(text: userResultData!.user!.staff![0].emergencyContactNumber.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      backgroundColor: AppColors.sonaWhite,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: AppColors.sonaWhite,
            borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        )),
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                onChanged: () {
                  setState(() {
                    canSubmit = _formKey.currentState!.validate();
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "personal_information".tr(),
                            textAlign: TextAlign.center,
                            style: AppStyle.h3.copyWith(color: AppColors.sonaBlack2, fontWeight: FontWeight.w400, fontSize: 20.sp),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () => serviceLocator
                                .get<NavigationService>()
                                .pop(),
                            icon: const Icon(
                              Boxicons.bx_x,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              handlePickPhoto();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin:
                                const EdgeInsets.symmetric(
                                    vertical: 5),
                                height: 110,
                                child: _croppedFile != null
                                    ? CircleAvatar(
                                    radius: 110,
                                    backgroundImage:
                                    FileImage(
                                        _croppedFile!))
                                    : userResultData != null &&
                                    userResultData!
                                        .user!
                                        .photo
                                        ?.length !=
                                        0
                                    ? CircleAvatar(
                                    radius: 110,
                                    backgroundImage:
                                    NetworkImage(userResultData!.user!.photo == null ? AppConstants.defaultProfilePictures : userResultData!.user!.photo!))
                                    : Image.asset(
                                    AppAssets.placeholder,
                                    fit: BoxFit.contain,
                                    repeat: ImageRepeat
                                        .noRepeat,
                                    width: 60))),
                        const SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            handlePickPhoto();
                          },
                          child: Text(
                            "Please use the league’s official portrait picture".tr(),
                            style: AppStyle.text2.copyWith(color: AppColors.sonaBlack2, fontWeight: FontWeight.w400, fontSize: 12.sp),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.45,
                                child: AppTextField(
                                  headerText: "first_name".tr(),
                                  hintText: "eg_first_name".tr(),
                                  validator:
                                  Validator.firstnameValidator,
                                  onChanged: (v) {
                                    setState(() {});
                                    // validateButton();
                                  },
                                  textInputType: TextInputType.name,
                                  textInputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        10),
                                  ],
                                  controller: _oFirstNameController,
                                  //onSaved: (val) => _oFirstNameController.text = val!,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.45,
                                child: AppTextField(
                                  headerText: "last_name".tr(),
                                  hintText: "eg_last_name".tr(),
                                  validator:
                                  Validator.lastnameValidator,
                                  onChanged: (v) {
                                    setState(() {});
                                    // validateButton();
                                  },
                                  textInputType: TextInputType.name,
                                  textInputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        10),
                                  ],
                                  controller: _oLastNameController,
                                  //onSaved: (val) => _oLastNameController.text = val!,
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
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.44,
                                  child: AppDateField(
                                    headerText: "date_of_birth".tr(),
                                    hintText: "date_of_birth".tr(),
                                    onChanged: (DateTime value) {
                                      _dobController!.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(value);
                                      setState(() {
                                        _ageController!.text =
                                            calculateAge(value)
                                                .toString();
                                        print(calculateAge(value)
                                            .toString());
                                      });
                                    },
                                    validator: Validator.requiredValidator,
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.44,
                                child: AppTextField(
                                  headerText: "age".tr(),
                                  hintText: "enter_your_age".tr(),
                                  controller: _ageController,
                                  readOnly: true,
                                  validator: Validator.validateAge,
                                  onChanged: (v) {
                                    setState(() {});
                                  },
                                  textInputType: TextInputType.number,
                                  textInputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        10),
                                  ],
                                  onSaved: (val) =>
                                  _ageController!.text = val!,
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
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.45,
                                child: AppTextField(
                                  headerText: "jersey_number".tr(),
                                  hintText: "18",
                                  validator:
                                  Validator.requiredValidator,
                                  onChanged: (v) {
                                    setState(() {});
                                    // validateButton();
                                  },
                                  textInputType: TextInputType.number,
                                  textInputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                                  ],
                                  controller: _jerseyNumberController,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.45,
                                child: AppTextField(
                                  headerText: "years_of_experience".tr(),
                                  hintText: "12",
                                  validator:
                                  Validator.requiredValidator,
                                  onChanged: (v) {
                                    setState(() {});
                                    // validateButton();
                                  },
                                  textInputType: TextInputType.number,
                                  textInputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                                  ],
                                  controller: _yearsOfExperienceController,
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
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.44,
                                  child: AppDateField(
                                    headerText: "employment_start_date".tr(),
                                    hintText: "yyyy-MM-dd",
                                    onChanged: (DateTime value) {
                                      _employmentStartDateController!.text = DateFormat('yyyy-MM-dd').format(value);
                                    },
                                    validator: Validator.requiredValidator,
                                  )),
                              SizedBox(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.44,
                                  child: AppDateField(
                                    headerText: "employment_end_date".tr(),
                                    hintText: "yyyy-MM-dd",
                                    maxDate: 2050,
                                    onChanged: (DateTime value) {
                                      _employmentEndDateController!.text = DateFormat('yyyy-MM-dd').format(value);
                                    },
                                    validator: Validator.requiredValidator,
                                  )),
                            ],
                          ),
                        ),
                        AppTextField(
                          headerText: "country".tr(),
                          validator: Validator.requiredValidator,
                          readOnly: true,
                          controller: _countryController,
                          onChanged: (v) {
                            setState(() {});
                            // validateButton();
                          },
                          onTap: () {
                            showCountryPicker(
                                context: context,
                                showPhoneCode: false,
                                countryListTheme: countryListThemeData(),
                                onSelect: (Country country) {
                                  //print("Selected country: ${country.displayName}");
                                  setState(() {
                                    _countryController!.text = country.displayNameNoCountryCode.trim().replaceAll(RegExp(' \\(.*?\\)'), '');
                                  });
                                });
                          },
                          textInputType: TextInputType.name,
                          //onSaved: (val) => _countryController.text = val!,
                        ),
                        AppPhoneTextField(
                          enabled: true,
                          controller: _phoneNumberController,
                          headerText: 'phone_number'.tr(),
                          validator: Validator.validateMobile,
                          onChanged: (String? value) {},
                        ),
                        AppPhoneTextField(
                          enabled: true,
                          controller: _ePhoneNumberController,
                          headerText: 'emergency_phone_number'.tr(),
                          validator: Validator.validateMobile,
                          onChanged: (String? value) {},
                        ),
                        AppTextField(
                          headerText: "email".tr(),
                          hintText: "email".tr(),
                          enabled: false,
                          //validator: Validator.validateLink,
                          textInputType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                        AppTextField(
                          headerText: "link_to_portfolio".tr(),
                          hintText: "link_to_portfolio".tr(),
                          //validator: Validator.validateLink,
                          textInputType: TextInputType.url,
                          controller: _linkToPortfolioController,
                        )
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10),
                        child: Text(
                          "your_team_manager_will_be".tr(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: const Color(0xFFFFFFFF),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400),
                        )),
                    SizedBox(height: 10),
                    AppButton(
                        buttonText: isSubmitting
                            ? "submitting".tr()
                            : "submit".tr(),
                        onPressed: canSubmit
                            ? () {
                          if (_formKey.currentState!
                              .validate()) {
                            _formKey.currentState!.save();
                            _handleUpdateProfile();
                          }
                        }
                            : null),
                    SizedBox(height: 70),
                    BlocConsumer(
                      bloc: serviceLocator.get<SettingsCubit>(),
                      listener: (_, state) {
                        if (state is PersonalInfoLoading) {
                          context.loaderOverlay.show();
                        }

                        if (state is PersonalInfoError) {
                          context.loaderOverlay.hide();
                          setState(() {
                            isSubmitting = false;
                            canSubmit = true;
                          });
                          ResponseMessage.showErrorSnack(
                              context: context,
                              message: state.message);
                        }

                        if (state is PersonalInfoSuccess) {
                          context.loaderOverlay.hide();
                          //do local db update
                          userResultData = serviceLocator.get<UserResultData>();
                          // print("loginCount: "+userResultData.toString());
                          // print("loginCount2: "+userResultData!.authToken.toString());
                          //store user details
                          serviceLocator.get<LocalStorage>().writeSecureObject(key: LocalStorageKeys.kUserPrefs, value: userResultData);
                          //store user email
                          serviceLocator.get<LocalStorage>().writeString(key: LocalStorageKeys.kLoginEmailPrefs, value: userResultData!.user!.email!);

                          serviceLocator.get<NavigationService>().pop();

                          serviceLocator
                              .get<NavigationService>()
                              .toWithPameter(
                              routeName:
                              RouteKeys.routePopUpPageScreen,
                              data: {
                                "title": "changes_saved".tr(),
                                "subTitle": "your_changes_have_been_made".tr(),
                                "route": null,
                                "routeType": "pop",
                                "buttonText": "okay_thank_you".tr()
                              }).then((value) {
                            setState(() {});
                          });
                        }
                      },
                      builder: (_, state) {
                        return const SizedBox();
                      },
                    ),
                  ],
                ))),
      ),
    ));
  }

  Future<void> _handleUpdateProfile() async {
    if (myId != null) {
      if (!_formKey.currentState!.validate()) return;
      _formKey.currentState!.save();
      await serviceLocator<SettingsCubit>().updatePersonalInfo(
          myId!,
          _croppedFile,
          userResultData!.user!.photo == null ? AppConstants.defaultProfilePictures : userResultData!.user!.photo,
          _oFirstNameController!.text.trim(),
          _oLastNameController!.text.trim(),
          int.parse(_yearsOfExperienceController!.text.trim()),
          _employmentStartDateController!.text.trim(),
          _employmentEndDateController!.text.trim(),
          int.parse(_ageController!.text.trim()),
          _linkToPortfolioController!.text.trim(),
          _ePhoneNumberController!.text.trim(),
          _dobController!.text.trim(),
          _jerseyNumberController!.text.trim(),
          _countryController!.text.trim(),
          _phoneNumberController!.text.trim());
    } else {
      ResponseMessage.showErrorSnack(context: context, message: "not_associated_to_club".tr());
    }
  }
}
