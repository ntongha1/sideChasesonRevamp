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
import 'package:sonalysis/features/common/models/PlayersInATeamModel.dart'
    as pit;
import 'package:sonalysis/features/common/models/SinglePlayerModel.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/model/response/CreatePlayerResponseModel.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/custom_button.dart';
import 'package:sonalysis/widgets/custom_dropdown_outline.dart';
import 'package:sonalysis/widgets/popup_page.dart';
import 'package:sonalysis/widgets/textfield.dart';

import '../../../../../../core/models/response/AddPlayerToTeamResponseModel.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/images.dart';
import '../../../../../core/datasource/key.dart';
import '../../../../../core/datasource/local_storage.dart';
import '../../../../../core/models/position.dart';
import '../../../../../core/models/response/TeamsListResponseModel.dart';
import '../../../../../core/models/response/UserResultModel.dart' as um;
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../../core/startup/app_startup.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/utils/validator.dart';
import '../../../../../core/widgets/app_drop_down.dart';
import '../../../../../core/widgets/app_textfield.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../features/common/cubit/common_cubit.dart';

class AddEditPlayerScreen extends StatefulWidget {
  final String? type;
  final String? playerID;
  final Player? player;
  final String? clubId;

  AddEditPlayerScreen(
      {Key? key, this.type, this.playerID, this.player, this.clubId})
      : super(key: key);

  @override
  _AddEditPlayerScreenState createState() => _AddEditPlayerScreenState();
}

class _AddEditPlayerScreenState extends State<AddEditPlayerScreen> {
  String? _selectedPosition;
  bool canProceed = false, canProceed2 = false;
  bool canSubmit = false;

  XFile? selectedPhoto, xFileForCropper;
  File? _croppedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _imagePicked = false, isSubmitting = false;
  int loadCount = 0;
  var focusNode = FocusNode();
  List<String> _teamListIDs = [];
  List<String> _teamListIDsSelected = [];
  List<Positions> _rolesPositions = [
    Positions(name: "Forward"),
    Positions(name: "Midfield"),
    Positions(name: "Defence"),
    Positions(name: "Keeper"),
  ];
  List<TeamsDropdown> teamsRaw = [];
  Positions? selectedPositions;
  TeamsDropdown selectedTeam = TeamsDropdown(name: "", id: "");

  bool loading = true;

  final TextEditingController _oFirstNameController = TextEditingController();
  final TextEditingController _oFirstNameController2 = TextEditingController();
  final TextEditingController _oLastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jerseyNumberController = TextEditingController();
  String? role = null;
  String? currentTeamId = "";
  String? selectedTeamName = "";
  String? oldPhoto = null;

  late um.UserResultData userResultData;
  TeamsListResponseModel? teamsListResponseModel;

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
  }

  @override
  void initState() {
    _getData();
  }

  Future<void> _getData() async {
    print("editplayerdata 1");
    loadCount = 0;
    userResultData = (await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs))!;
    print("editplayerdata 12" + userResultData.user!.clubs![0].id!);

    await serviceLocator<CommonCubit>()
        .getTeamList(userResultData.user!.clubs![0].id!);
    print("editplayerdata 13");

    if (widget.type == "edit") {
      print("editplayerdata 2");

      print("all before" + widget.player!.toJson().toString());
      _jerseyNumberController.text = widget.player!.jerseyNumber!;
      print("all before 1" + widget.player!.teamNameNew!);

      // _jerseyNumberController.text = widget.player!.firstName!;

      _oFirstNameController.text =
          widget.player!.firstName != null ? widget.player!.firstName! : "";
      _oLastNameController.text =
          widget.player!.lastName != null ? widget.player!.lastName! : "";
      _emailController.text =
          widget.player!.email != null ? widget.player!.email! : "";

      _selectedPosition =
          widget.player!.position != null ? widget.player!.position! : "";
      print("_selectedPosition" + _selectedPosition.toString());
      role = widget.player!.position != null ? widget.player!.position! : "";

      currentTeamId =
          widget.player!.teamId != null ? widget.player!.teamId! : "";
      selectedTeamName =
          widget.player!.teamNameNew != null ? widget.player!.teamNameNew! : "";
      print('team debug: ' + selectedTeamName!);

      // _teamListIDs = widget.player!.teams!;
      // _imagePicked = true;
      // _croppedFile =
      //     File(widget.player!.photo != null ? widget.player!.photo! : "");
      oldPhoto = widget.player!.photo != null ? widget.player!.photo! : "";

      setState(() {});
    } else {
      print("editplayerdata 3");
      print("editplayerdata 2" + widget.type.toString());
    }

    _oFirstNameController2.text = 'Loleeo';
  }

  Future<void> _handleCreatePlayer(BuildContext context) async {
    // // pop create new player screen
    //    Navigator.of(context).pop(true);
    setState(() {
      canSubmit = false;
      isSubmitting = true;
    });
    CreatePlayerResponseModel createPlayerResponseModel =
        await ClubManagementController().doCreatePlayer(
            context,
            _oLastNameController.text.trim(),
            _oFirstNameController.text.trim(),
            _emailController.text.toLowerCase().trim(),
            _selectedPosition!,
            _jerseyNumberController.text.trim());
    // //add player to team
    AddPlayerToTeamResponseModel addPlayerToTeamResponseModel =
        await ClubManagementController().doAddPlayerToTeam(
            context, _teamListIDs, createPlayerResponseModel.data!.userId!);

    if (createPlayerResponseModel.status == "success") {
      showToast(createPlayerResponseModel.message!, "success");
      Navigator.of(context).pop();
    } else {
      showToast(createPlayerResponseModel.message!, "error");
      setState(() {
        canSubmit = false;
        isSubmitting = false;
      });
      return;
    }
  }

  bool canSubmitfun() {
    return _oFirstNameController.text.isNotEmpty &&
        _oLastNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _selectedPosition != null &&
        _jerseyNumberController.text.isNotEmpty &&
        !isSubmitting;
  }

  Future<void> _handleUpdatePlayer(BuildContext context) async {
    print("looool upload: starting");
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
    bool doneUpdate = await ClubManagementController().doUpdatePlayer(
        context,
        _oLastNameController.text.trim(),
        _oFirstNameController.text.trim(),
        _emailController.text.toLowerCase().trim(),
        _selectedPosition!,
        _jerseyNumberController.text.trim(),
        selectedTeam.id,
        widget.player!.id!,
        _croppedFile,
        oldPhoto != null ? oldPhoto : "",
        len);
    if (doneUpdate) {
      showToast("Player updated succesfully!", "success");
      Navigator.of(context).pop();
    } else {
      showToast("Error updating player", "error");
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
                loadCount++;
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
            child: loading
                ? Container()
                : Container(
                    child: ListView(
                    children: [
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
                              child: Text(
                            widget.type == "add"
                                ? "Create New Player"
                                : "Edit Player",
                            style: AppStyle.h3.copyWith(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.sonaBlack2),
                          ))),
                      widget.type == "add"
                          ? Align(
                              alignment: Alignment.center,
                              child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 10, bottom: 0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    "Fill in a player’s details and send an invite",
                                    style: AppStyle.text1.copyWith(
                                      color: AppColors.sonaBlack2,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 10, bottom: 0),
                                  child: Text(
                                    "Fill in a player’s details and send an invite",
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
                          Stack(
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
                                                            oldPhoto != "null"
                                                        ? Image.network(
                                                            oldPhoto!,
                                                            fit: BoxFit.contain,
                                                            repeat: ImageRepeat
                                                                .noRepeat)
                                                        : Image.asset(
                                                            AppAssets
                                                                .placeholder,
                                                            fit: BoxFit.contain,
                                                            repeat: ImageRepeat
                                                                .noRepeat)),
                                          ))))
                            ],
                          ),
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
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.44,
                            child: AppTextField(
                              headerText: "first_name".tr(),
                              hintText: "Type here".tr(),
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
                            width: MediaQuery.of(context).size.width * 0.44,
                            child: AppTextField(
                              headerText: "last_name".tr(),
                              hintText: "Type here".tr(),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.44,
                            child: AppDropdownModal(
                              options: _rolesPositions,
                              value: _selectedPosition,
                              hasSearch: false,
                              onChanged: (val) {
                                selectedPositions = val as Positions;
                                _selectedPosition = selectedPositions!.name;
                                setState(() {});
                              },
                              validator: Validator.requiredValidator,
                              modalHeight:
                                  MediaQuery.of(context).size.height * 0.7,
                              // hint: 'Select an option',
                              headerText: "position".tr(),
                              hintText: "Type here".tr(),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.44,
                            child: AppTextField(
                              headerText: "Jersey Number".tr(),
                              hintText: "Type here".tr(),
                              validator: Validator.requiredValidator,
                              controller: _jerseyNumberController,
                              // onChanged: (val) =>
                              //     _jerseyNumberController.text = val,
                              textInputType: TextInputType.number,
                              textInputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                          ),
                        ],
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

                          //  SmartSelect<String>.multiple(
                          //     title: 'Assign Team(s)'.tr(),
                          //     selectedValue: _teamListIDs,
                          //     onChange: (selected) {
                          //       setState(() => _teamListIDs = selected.value);
                          //     },
                          //     choiceType: S2ChoiceType.chips,
                          //     choiceItems: S2Choice.listFrom<String, Map>(
                          //       source: teamsRaw,
                          //       value: (index, item) => item['id'],
                          //       title: (index, item) => item['name'],
                          //     ),
                          //     modalConfig: const S2ModalConfig(
                          //       type: S2ModalType.bottomSheet,
                          //       useFilter: true,
                          //     ),
                          //     modalStyle: S2ModalStyle(
                          //         backgroundColor: AppColors.sonaWhite),
                          //     modalHeaderStyle: S2ModalHeaderStyle(
                          //         backgroundColor: AppColors.sonaWhite,
                          //         textStyle: AppStyle.text3.copyWith(
                          //           color: AppColors.sonaBlack2,
                          //         ),
                          //         iconTheme: IconThemeData(
                          //             color: AppColors.sonaBlack2),
                          //         actionsIconTheme: IconThemeData(
                          //             color: AppColors.sonaBlack2)),
                          //     tileBuilder: (context, state) {
                          //       return Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Container(
                          //             margin: const EdgeInsets.only(
                          //                 bottom: 7, left: 14),
                          //             child: Text(
                          //               state.title!,
                          //               textAlign: TextAlign.start,
                          //               style: AppStyle.text2.copyWith(
                          //                 color: AppColors.sonaGrey3,
                          //               ),
                          //             ),
                          //           ),
                          //           Container(
                          //               decoration: BoxDecoration(
                          //                   color: AppColors.sonaGrey6,
                          //                   borderRadius:
                          //                       const BorderRadius.only(
                          //                     topLeft: Radius.circular(10.0),
                          //                     topRight: Radius.circular(10.0),
                          //                   )),
                          //               padding: const EdgeInsets.symmetric(
                          //                   horizontal: 10, vertical: 7),
                          //               margin: const EdgeInsets.symmetric(
                          //                   horizontal: 14),
                          //               child: InkWell(
                          //                 onTap: () => state.showModal(),
                          //                 child: Row(
                          //                   children: [
                          //                     Expanded(
                          //                       child: Text("",
                          //                           style: AppStyle.text2),
                          //                       //state.selection.map((e) => e.title).join(', ')
                          //                     ),
                          //                     state.selected.length == 0
                          //                         ? Text("Select team(s)",
                          //                             style: AppStyle.text2
                          //                                 .copyWith(
                          //                               color:
                          //                                   AppColors.sonaGrey3,
                          //                             ))
                          //                         : const SizedBox.shrink(),
                          //                     Icon(Icons.arrow_drop_down,
                          //                         size: 30,
                          //                         color: AppColors.sonaGrey3)
                          //                   ],
                          //                 ),
                          //               ))
                          //         ],
                          //       );
                          //     },
                          //   )
                          : const SizedBox.shrink(),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: AppTextField(
                        headerText: "email".tr(),
                        hintText: "Type here",
                        validator: Validator.emailValidator,
                        readOnly: false,
                        // onChanged: (val) => _emailController.text = val,
                        textInputType: TextInputType.emailAddress,
                        controller: _emailController,
                      )),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 20.h),
                          child: AppButton(
                            buttonText: widget.type == "add"
                                ? "Next"
                                : "Update Changes",
                            onPressed: canSubmitfun()
                                ? () async {
                                    if (canSubmit && widget.type == "add") {
                                      _handleCreatePlayer(context);
                                    } else if (canSubmitfun() &&
                                        widget.type == "edit") {
                                      _handleUpdatePlayer(context);
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
                      const SizedBox(height: 100),
                    ],
                  ))),
      ),
    ));
  }
}
