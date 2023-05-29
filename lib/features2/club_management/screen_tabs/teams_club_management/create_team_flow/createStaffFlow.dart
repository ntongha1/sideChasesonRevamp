import 'dart:io';

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
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/validator.dart';
import 'package:sonalysis/core/widgets/app_dropdown_modal.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/style/styles.dart';

import '../../../../../core/models/roles.dart';
import '../../../../../core/navigation/keys.dart';
import '../../../../../core/utils/styles.dart';

class CreateStaffFlowScreen extends StatefulWidget {
  String? teamId;
  Function onPlayerCreated;

  CreateStaffFlowScreen({Key? key, this.teamId, required this.onPlayerCreated})
      : super(key: key);
  @override
  _CreateStaffFlowScreenState createState() => _CreateStaffFlowScreenState();
}

class _CreateStaffFlowScreenState extends State<CreateStaffFlowScreen> {
  Roles? _selectedRole;
  String? _selectedRoleName;
  bool canProceed = false, canProceed2 = false;
  bool canSubmit = false;
  final _formKey = GlobalKey<FormState>();

  XFile? selectedPhoto, xFileForCropper;
  File? _croppedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _imagePicked = false, isSubmitting = false;
  var focusNode = FocusNode();

  final List<Roles>? role = [
    Roles(name: "manager".tr()),
    Roles(name: "coach".tr()),
  ];

  final TextEditingController _oFirstNameController = TextEditingController();
  final TextEditingController _oLastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  late UserResultData userResultData;
  bool isLoading = true;
  //late List<String?> searchableList;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    userResultData = (await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs))!;
    setState(() {});
  }

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
    //_validate(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      backgroundColor: Colors.transparent.withOpacity(0.9),
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
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
                    // const SizedBox(height: 10),
                    InkWell(
                        onTap: () {
                          serviceLocator.get<NavigationService>().pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Boxicons.bx_x_circle,
                            color: AppColors.sonaBlack2,
                            size: 24,
                          ),
                        )),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: const EdgeInsets.only(top: 0, bottom: 0),
                          // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "add_a_staff".tr(),
                            style: AppStyle.h3.copyWith(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.sonaBlack2),
                          )),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "fill_in_coachs_details".tr(),
                            style: AppStyle.text1.copyWith(
                              color: AppColors.sonaGrey2,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    ),
                    const SizedBox(height: 40),
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
                                height: 80,
                                child: CircleAvatar(
                                    backgroundColor: AppColors.sonaBlack,
                                    radius: 80,
                                    child: ClipOval(
                                      child: SizedBox(
                                          width: 80.0,
                                          height: 80.0,
                                          child: _croppedFile != null
                                              ? Image.file(_croppedFile!,
                                                  fit: BoxFit.cover)
                                              : Image.asset(
                                                  AppAssets.placeholder,
                                                  fit: BoxFit.contain,
                                                  repeat:
                                                      ImageRepeat.noRepeat)),
                                    )))),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            handlePickPhoto();
                          },
                          child: Text(
                            "Upload Image",
                            style: AppStyle.text1.copyWith(
                              color: AppColors.sonaGreen,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          // margin: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: AppTextField(
                                  headerText: "first_name".tr(),
                                  hintText: "Type here".tr(),
                                  controller: _oFirstNameController,
                                  validator: Validator.firstnameValidator,
                                  textInputType: TextInputType.name,
                                  textInputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: AppTextField(
                                  headerText: "last_name".tr(),
                                  hintText: "Type here".tr(),
                                  validator: Validator.lastnameValidator,
                                  controller: _oLastNameController,
                                  textInputType: TextInputType.name,
                                  textInputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: AppDropdownModal(
                            hintText: "Type here".tr(),
                            options: role!,
                            value: _selectedRoleName,
                            hasSearch: false,
                            onChanged: (val) {
                              _selectedRole = val as Roles;
                              _selectedRoleName = val.name;
                              setState(() {});
                            },
                            validator: Validator.requiredValidator,
                            modalHeight:
                                MediaQuery.of(context).size.height * 0.7,
                            // hint: 'Select an option',
                            headerText: "position".tr(),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            child: AppTextField(
                              headerText: "email".tr(),
                              hintText: "Type here",
                              validator: Validator.emailValidator,
                              controller: _emailController,
                              textInputType: TextInputType.emailAddress,
                            )),
                      ],
                    ),
                    // Container(
                    //     margin: EdgeInsets.symmetric(
                    //         horizontal: 20.w, vertical: 20.h),
                    //     child: Text(
                    //       "after_this_staff_has".tr(),
                    //       textAlign: TextAlign.start,
                    //       style: AppStyle.text1.copyWith(
                    //         color: AppColors.sonaBlack2,
                    //         fontWeight: FontWeight.w400,
                    //       ),
                    //     )),
                    SizedBox(height: 40),
                    Container(
                        margin: EdgeInsets.only(bottom: 20.w),
                        child: AppButton(
                            buttonText: isSubmitting
                                ? "submitting".tr()
                                : "submit".tr(),
                            onPressed: canSubmit
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      _handleCreateStaff();
                                    }
                                  }
                                : null)),
                    BlocConsumer(
                      bloc: serviceLocator.get<CommonCubit>(),
                      listener: (_, state) {
                        if (state is CreateStaffLoading) {
                          context.loaderOverlay.show();
                        }

                        if (state is CreateStaffError) {
                          context.loaderOverlay.hide();
                          setState(() {
                            isSubmitting = false;
                            canSubmit = true;
                          });
                          ResponseMessage.showErrorSnack(
                              context: context, message: state.message);
                        }

                        if (state is CreateStaffSuccess) {
                          context.loaderOverlay.hide();
                          widget.onPlayerCreated();
                          serviceLocator.get<NavigationService>().pop();
                          // serviceLocator.get<NavigationService>().toWithPameter(
                          //     routeName: RouteKeys.routePopUpPageScreen,
                          //     data: {
                          //       "title": "new_staff_created".tr(),
                          //       "subTitle": "new_staff_created_desc".tr(),
                          //       "route": null,
                          //       "routeType": "pop",
                          //       "buttonText": "okay_thank_you".tr()
                          //     });
                          setState(() {
                            _oLastNameController.clear();
                            _oFirstNameController.clear();
                            _emailController.clear();
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

  Future<void> _handleCreateStaff() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    int len = 0;

    if (_croppedFile != null) {
      len = await _croppedFile!.length();
    }

    await serviceLocator<CommonCubit>().createStaff(
        userResultData.user!.clubs![0].id,
        widget.teamId,
        _oFirstNameController.text.trim(),
        _oLastNameController.text.trim(),
        _selectedRole!.displayName,
        _emailController.text.toLowerCase().trim(),
        _croppedFile,
        len);
  }
}
