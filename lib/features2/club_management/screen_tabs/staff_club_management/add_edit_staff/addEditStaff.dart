import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/controller/club_mgt_controller.dart';
import 'package:sonalysis/core/models/teams.dart';
import 'package:sonalysis/core/widgets/app_dropdown_modal.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/model/response/CreateStaffResponseModel.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/popup_page.dart';

import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/images.dart';
import '../../../../../core/datasource/key.dart';
import '../../../../../core/datasource/local_storage.dart';
import '../../../../../core/models/response/TeamsListResponseModel.dart';
import '../../../../../core/models/response/UserResultModel.dart';
import '../../../../../core/models/roles.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../../core/startup/app_startup.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/utils/validator.dart';
import '../../../../../core/widgets/app_drop_down.dart';
import '../../../../../core/widgets/app_textfield.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../features/common/cubit/common_cubit.dart';
import '../../../../../features/common/models/StaffInATeamModel.dart' as sit;

class AddEditStaffScreen extends StatefulWidget {
  final String? type;
  final String? playerID;
  final sit.Staff? staff;
  final TeamsSingleModel? team;

  AddEditStaffScreen(
      {Key? key, this.type, this.playerID, this.staff, this.team})
      : super(key: key);

  @override
  _AddEditStaffScreenState createState() => _AddEditStaffScreenState();
}

class _AddEditStaffScreenState extends State<AddEditStaffScreen> {
  bool canProceed = false, canProceed2 = false;
  bool canSubmit = false;

  final List<Roles>? role = [
    Roles(name: "manager".tr()),
    Roles(name: "coach".tr()),
  ];

  XFile? selectedPhoto, xFileForCropper;
  File? _croppedFile;
  String? oldPhoto = null;

  final ImagePicker _imagePicker = ImagePicker();
  bool _imagePicked = false, isSubmitting = false;
  List<String> _teamListIDs = [];
  TeamsListResponseModel? teamsListResponseModel;
  List<Roles> _rolesList = [
    Roles(name: "Manager".tr()),
    Roles(name: "Coach".tr())
  ];
  List<TeamsDropdown> teamsRaw = [];

  Roles? selectedRole;
  String? _selectedRole;
  bool loading = true;
  String? currentTeamId = "";
  String? selectedTeamName = "";
  TeamsDropdown selectedTeam = TeamsDropdown(name: "", id: "");

  final TextEditingController _oFirstNameController = TextEditingController();
  final TextEditingController _oLastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  var focusNode = FocusNode();

  late UserResultData userResultData;

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

  bool canSubmitfun() {
    return _oFirstNameController.text.isNotEmpty &&
        _oLastNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        role != "" &&
        !isSubmitting;
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
  }

  @override
  void initState() {
    _getData();

    super.initState();
  }

  Future<void> _getData() async {
    userResultData = (await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs))!;
    await serviceLocator<CommonCubit>()
        .getTeamList(userResultData.user!.clubs![0].id!);
    _oFirstNameController.text = widget.staff!.user!.firstName != null
        ? widget.staff!.user!.firstName!
        : "";
    _oLastNameController.text = widget.staff!.user!.lastName != null
        ? widget.staff!.user!.lastName!
        : "";
    _emailController.text =
        widget.staff!.user!.email != null ? widget.staff!.user!.email! : "";
    _selectedRole =
        widget.staff!.user!.role != null ? widget.staff!.user!.role! : "";
    if (widget.team != null) selectedTeamName = widget.team!.teamName;
    oldPhoto =
        widget.staff!.user!.photo != null ? widget.staff!.user!.photo : null;
  }

  Future<void> _handleUpdateStaff(BuildContext context) async {
    // // pop create new player screen
    //    Navigator.of(context).pop(true);
    setState(() {
      canSubmit = false;
      isSubmitting = true;
    });

    int len = 0;

    if (_croppedFile != null) {
      len = await _croppedFile!.length();
    }
    bool doneUpdate = await ClubManagementController().doUpdateStaff(
        context,
        _oLastNameController.text.trim(),
        _oFirstNameController.text.trim(),
        _emailController.text.toLowerCase().trim(),
        _selectedRole!,
        selectedTeam.id,
        widget.staff!.id!,
        _croppedFile);
    if (doneUpdate) {
      showToast("Staff updated succesfully!", "success");
      Navigator.of(context).pop();
    } else {
      showToast("Error updating staff", "error");
      setState(() {
        canSubmit = false;
        isSubmitting = false;
      });
      return;
    }
  }

  Future<void> _handleCreateStaff(BuildContext context) async {
    setState(() {
      canSubmit = false;
      isSubmitting = true;
    });
    CreateStaffResponseModel createStaffResponseModel =
        await ClubManagementController().doCreateStaff(
            context,
            _oLastNameController.text.trim(),
            _oFirstNameController.text.trim(),
            _emailController.text.trim(),
            selectedRole!.name);

    if (createStaffResponseModel.status == "success") {
      showToast(createStaffResponseModel.message!, "success");
      setState(() {
        _oLastNameController.clear();
        _oFirstNameController.clear();
        _emailController.clear();
        _croppedFile = null;
        _imagePicked = false;
        canSubmit = false;
        isSubmitting = false;
        focusNode.requestFocus();
      });
    } else {
      showToast(createStaffResponseModel.message!, "success");
      setState(() {
        canSubmit = false;
        isSubmitting = false;
      });
      return;
    }
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
              child: BlocListener(
                bloc: serviceLocator.get<CommonCubit>(),
                listener: (_, state) {
                  if (state is TeamListLoading) {
                    setState(() {});
                    context.loaderOverlay.show();
                  }

                  if (state is TeamListError) {
                    setState(() {});
                    context.loaderOverlay.hide();
                  }

                  if (state is TeamListSuccess) {
                    TeamsListResponseModel tt =
                        serviceLocator.get<TeamsListResponseModel>();
                    var ttt = tt.teamsListResponseModelData!
                        .map((e) => TeamsDropdown(name: e.teamName!, id: e.id!))
                        .toList();
                    print("teams list" + ttt.toString());
                    context.loaderOverlay.hide();

                    setState(() {
                      loading = false;
                      teamsRaw = ttt;
                      teamsListResponseModel = tt;
                    });
                    setState(() {
                      _teamListIDs = tt.teamsListResponseModelData!
                          .map((e) => e.teamName)
                          .toList() as List<String>;
                    });
                  }
                },
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
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
                            size: 30,
                          ),
                        )),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            widget.type == "add"
                                ? "Add a Staff"
                                : "Edit Staff Details",
                            style: AppStyle.h3.copyWith(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.sonaBlack2),
                          )),
                    ),
                    widget.type == "add"
                        ? Align(
                            alignment: Alignment.center,
                            child: Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  "Fill in a coach’s details and send an invite",
                                  style: AppStyle.text1.copyWith(
                                    color: AppColors.sonaBlack2,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                          )
                        : const SizedBox.shrink(),
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
                                              : oldPhoto != null &&
                                                      Uri.parse(oldPhoto!)
                                                          .isAbsolute
                                                  ? Image.network(oldPhoto!)
                                                  : Image.asset(
                                                      AppAssets.placeholder,
                                                      fit: BoxFit.contain,
                                                      repeat: ImageRepeat
                                                          .noRepeat)),
                                    )))),
                        const SizedBox(height: 5),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.43,
                              child: AppTextField(
                                headerText: "first_name".tr(),
                                hintText: "eg_first_name".tr(),
                                validator: Validator.firstnameValidator,
                                // onChanged: (val) =>
                                //     _oFirstNameController.text = val,
                                textInputType: TextInputType.text,
                                textInputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                controller: _oFirstNameController,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.43,
                              child: AppTextField(
                                headerText: "last_name".tr(),
                                hintText: "eg_last_name".tr(),
                                validator: Validator.lastnameValidator,
                                // onChanged: (val) =>
                                //     _oLastNameController.text = val,
                                textInputType: TextInputType.name,
                                textInputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                controller: _oLastNameController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          child: AppDropdownModal(
                            hintText: "Type here".tr(),
                            options: role!,
                            value: _selectedRole,
                            hasSearch: false,
                            onChanged: (val) {
                              var r = val as Roles;
                              _selectedRole = r.name;
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
                        widget.type != "add"
                            ? AppDropdownModal(
                                options: teamsRaw,
                                value: selectedTeamName,
                                hasSearch: false,
                                onChanged: (val) {
                                  selectedTeam = val as TeamsDropdown;
                                  selectedTeamName = selectedTeam.name;
                                  setState(() {});
                                },
                                validator: Validator.requiredValidator,
                                modalHeight:
                                    MediaQuery.of(context).size.height * 0.7,
                                // hint: 'Select an option',
                                headerText: "Team".tr(),
                                hintText: "Type here".tr(),
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                            child: AppTextField(
                          headerText: "email".tr(),
                          hintText: "Type here",
                          controller: _emailController,
                          validator: Validator.emailValidator,
                          readOnly: false,
                          // onChanged: (val) => _emailController.text = val!,
                          textInputType: TextInputType.emailAddress,
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Container(
                        child: AppButton(
                      buttonText:
                          widget.type == "add" ? "Next" : "Update Changes",
                      onPressed: canSubmitfun()
                          ? () async {
                              if (canSubmit && widget.type == "add") {
                                _handleCreateStaff(context);
                              } else if (canSubmitfun() &&
                                  widget.type == "edit") {
                                _handleUpdateStaff(context);
                                // showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) =>
                                //         const PopUpPageScreen(data: {
                                //           "image": "/save_successful.png",
                                //           "route": "playerEditedCreated",
                                //           "buttonText": "Okay, thank you"
                                //         })).then((value) {
                                //   Navigator.of(context).pop(true);
                                // });
                              }
                            }
                          : null,
                    )),
                    SizedBox(
                      height: 40.h,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            )));
  }
}
