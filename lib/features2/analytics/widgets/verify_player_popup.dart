import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/style/styles.dart';

import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/custom_dropdown_outline.dart';
import '../../club_management/screen_tabs/players_club_management/singleton/player_line_up_singleton.dart';
import '../../../lang/strings.dart';
import '../../../validators/registration_validation.dart';
import '../../../widgets/textfield.dart';
import '../../../features/common/models/SinglePlayerModel.dart';

class VerifyPlayerPopUpScreen extends StatefulWidget {
  String? playerID;

  VerifyPlayerPopUpScreen({Key? key, this.playerID}) : super(key: key);

  @override
  _VerifyPlayerPopUpScreenState createState() =>
      _VerifyPlayerPopUpScreenState();
}

class _VerifyPlayerPopUpScreenState extends State<VerifyPlayerPopUpScreen> {
  final TextEditingController _videoLinkController = TextEditingController();
  bool canSubmit = false;
  //
  UserResultData? userResultData;
  bool isLoading = true;
  SinglePlayerModel? singlePlayerModel;
  final _formKey = GlobalKey<FormState>();
  String? _selectedPosition;
  final TextEditingController _oFirstNameController = TextEditingController();
  final TextEditingController _oLastNameController = TextEditingController();
  //final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jerseyNumberController = TextEditingController();
  XFile? selectedPhoto, xFileForCropper;
  File? _croppedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _imagePicked = false, isSubmitting = false;

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
            toolbarColor: sonaBlack,
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
    _validate(context);
  }

  Future<void> _validate(context, [bool isSubmit = false]) async {
    String firstName = _oFirstNameController.text.trim();
    String lastName = _oLastNameController.text.trim();
    String jerseyNumber = _jerseyNumberController.text.trim();
    String selectedPosition = _selectedPosition!;

    //print(email);

    if (!requiredValidator(selectedPosition)) {
      setState(() {
        canSubmit = false;
      });
      return;
    }

    if (!requiredValidator(lastName)) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, lastName_error);
      return;
    }

    if (!requiredValidator(firstName)) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, firstName_error);
      return;
    }

    if (!requiredValidator(jerseyNumber)) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, jerseyNumber_error);
      return;
    }

    if (!requiredValidator(_croppedFile!.path)) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, abbrClubName_error);
      return;
    }

    if (!_imagePicked) {
      setState(() {
        canSubmit = false;
      });
      return;
    }

    setState(() {
      canSubmit = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    await serviceLocator<CommonCubit>()
        .getSinglePlayerProfile(widget.playerID!);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: sonaBlack,
        content: Container(
          decoration: BoxDecoration(
              color: sonaBlack,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          width: MediaQuery.of(context).size.width,
          height: 620,
          child: BlocListener(
            bloc: serviceLocator.get<CommonCubit>(),
            listener: (_, state) {
              if (state is GetSinglePlayerProfileLoading) {
                setState(() {
                  isLoading = true;
                });
                context.loaderOverlay.show();
              }

              if (state is GetSinglePlayerProfileError) {
                setState(() {
                  isLoading = false;
                });
                context.loaderOverlay.hide();
                ResponseMessage.showErrorSnack(
                    context: context, message: AppConstants.exceptionMessage);
              }

              if (state is GetSinglePlayerProfileSuccess) {
                //singlePlayerModel = serviceLocator.get<SinglePlayerModel>();
                singlePlayerModel = state.singlePlayerModel;
                _oFirstNameController.text =
                    singlePlayerModel!.data!.player!.firstName!;
                _oLastNameController.text =
                    singlePlayerModel!.data!.player!.lastName!;
                _jerseyNumberController.text =
                    singlePlayerModel!.data!.player!.jerseyNo!;
                _selectedPosition = "Right Mid.";
                context.loaderOverlay.hide();
                setState(() {
                  isLoading = false;
                });
              }
            },
            child: isLoading
                ? Container()
                : Form(
                    key: _formKey,
                    onChanged: () {
                      setState(() {
                        canSubmit = _formKey.currentState!.validate();
                      });
                    },
                    child: ListView(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "please_confirm_player_info".tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: const Color(0xFFFFFFFF),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                                height: 1.2),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "confirm_the_information".tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: const Color(0xFFFFFFFF),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal,
                                height: 1.2),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "players_picture".tr(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: const Color(0xFFFFFFFF),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                                height: 1.2),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                              onTap: () {
                                handlePickPhoto();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      radius: 60,
                                      backgroundColor: AppColors.sonaBlack,
                                      child: ClipOval(
                                          child: _croppedFile != null
                                              ? Image.file(_croppedFile!,
                                                  fit: BoxFit.contain,
                                                  repeat: ImageRepeat.noRepeat,
                                                  width: 200.w)
                                              : Image.network(
                                                  singlePlayerModel!.data!
                                                              .player!.photo ==
                                                          null
                                                      ? AppConstants
                                                          .defaultProfilePictures
                                                      : singlePlayerModel!
                                                          .data!.player!.photo!,
                                                  fit: BoxFit.contain,
                                                  repeat: ImageRepeat.noRepeat,
                                                  width: 200.w))),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Text(
                                      "change_image".tr(),
                                      style: TextStyle(
                                          color: const Color(0xFFFFFFFF),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.normal,
                                          height: 1.2),
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: MyCustomTextField(
                                  fieldType: FieldType.REQUIRED_FIELD,
                                  labelText: "First Name",
                                  onChange: () {
                                    //_validate(context);
                                  },
                                  textInputType: TextInputType.text,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter(
                                        RegExp("[a-zA-ZÄäÖöÜü]"),
                                        allow: true) //Only Text as input
                                  ],
                                  controller: _oFirstNameController,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: MyCustomTextField(
                                  fieldType: FieldType.REQUIRED_FIELD,
                                  labelText: "Last Name",
                                  onChange: () {
                                    //_validate(context);
                                  },
                                  textInputType: TextInputType.text,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter(
                                        RegExp("[a-zA-ZÄäÖöÜü]"),
                                        allow: true) //Only Text as input
                                  ],
                                  controller: _oLastNameController,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: MyCustomTextField(
                                  fieldType: FieldType.PHONE_NUMBER_FIELD,
                                  labelText: "Jersey Number",
                                  onChange: () {
                                    //_validate(context);
                                  },
                                  textInputType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ],
                                  controller: _jerseyNumberController,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: CustomDropdownOutline(
                                  locked: false,
                                  items: const [
                                    "Forward",
                                    "Midfield",
                                    "Defence",
                                    "Keeper"
                                  ],
                                  labelText: "Position",
                                  error: '',
                                  hint: 'Choose',
                                  selected: _selectedPosition,
                                  textStyle: TextStyle(
                                    color: getColorHexFromStr("C9D0CD"),
                                    //fontFamily: generalFont,
                                    fontSize: 13.0.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  onChange: (selected) {
                                    //_validate(context);
                                    setState(() {
                                      _selectedPosition = selected;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: AppButton(
                                    buttonText: "submit".tr(),
                                    onPressed: () {
                                      _formKey.currentState!.save();
                                      _handleSubmit();
                                    }),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: AppButton(
                                      buttonText: "cancel".tr(),
                                      buttonType: ButtonType.tertiary,
                                      onPressed: () {
                                        serviceLocator
                                            .get<NavigationService>()
                                            .pop();
                                      })),
                            ],
                          ),
                          BlocConsumer(
                            bloc: serviceLocator.get<CommonCubit>(),
                            listener: (_, state) {
                              if (state is UpdatePlayerLoading) {
                                context.loaderOverlay.show();
                              }

                              if (state is UpdatePlayerError) {
                                context.loaderOverlay.hide();
                                setState(() {
                                  canSubmit = true;
                                });
                                ResponseMessage.showErrorSnack(
                                    context: context, message: state.message);
                              }

                              if (state is UpdatePlayerSuccess) {
                                context.loaderOverlay.hide();
                                Navigator.of(context).pop(true);
                                pushNewScreen(
                                  context,
                                  screen: PlayerLineUpSingletonScreen(
                                      playerID: widget.playerID!),
                                  withNavBar:
                                      false, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                                ResponseMessage.showSuccessSnack(
                                    context: context, message: state.message);
                              }
                            },
                            builder: (_, state) {
                              return const SizedBox();
                            },
                          ),
                        ])),
          ),
        ));
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_croppedFile == null) {
      ResponseMessage.showErrorSnack(
          context: context, message: "select_image".tr());
      return;
    }

    _formKey.currentState!.save();
    await serviceLocator<CommonCubit>().updatePlayer(
        _croppedFile,
        widget.playerID,
        _oFirstNameController.text.trim(),
        _oLastNameController.text.trim(),
        _selectedPosition!,
        _jerseyNumberController.text.trim());
  }
}
