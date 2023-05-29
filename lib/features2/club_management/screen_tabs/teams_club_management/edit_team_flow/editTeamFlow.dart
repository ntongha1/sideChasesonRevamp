import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/models/response/CreateTeamResponseModel.dart';
import 'package:sonalysis/core/models/response/TeamCategory.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart' as urm;
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/validator.dart';
import 'package:sonalysis/core/widgets/app_dropdown_modal.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/helpers/auth/shared_preferences_class.dart';
import 'package:sonalysis/model/response/UserLoginResultModel.dart';
import 'package:sonalysis/style/styles.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/helpers.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../../core/utils/styles.dart';

import '../../../../../features/common/models/PlayersInATeamModel.dart';
import '../../../../../features/common/models/StaffInATeamModel.dart';

class EditTeamFlowScreen extends StatefulWidget {
  var data;
  EditTeamFlowScreen({Key? key, this.data}) : super(key: key);

  @override
  _EditTeamFlowScreenState createState() => _EditTeamFlowScreenState();
}

class _EditTeamFlowScreenState extends State<EditTeamFlowScreen> {
  bool canProceed = false, canProceed2 = false;
  bool canSubmit = false, isLoading = true;
  String createTeamStep = "1",
      skipNext = "Skip",
      createdTeamID = "",
      createdTeamName = "";
  List<TeamCategoryData> listOfCategories = [];
  TeamCategoryData? selectedCategory;
  String? selectedCat;
  String? selectedCatId = "";
  String? oldPhoto = null;

  XFile? selectedPhoto, xFileForCropper;
  File? _croppedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _imagePicked = false, isSubmitting = false;

  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _abrivationController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  SharedPreferencesClass sharedPreferencesClass = SharedPreferencesClass();
  UserLoginResultModel? userLoginResultModel;
  CreateTeamResponseModel? createTeamResponseModel;
  late urm.UserResultData userResultData;
  PlayersInATeamModel? playersInATeamModel;
  StaffInATeamModel? staffInATeamModel;
  RefreshController _refreshPlayerController = new RefreshController();
  RefreshController _refreshStaffController = new RefreshController();
  bool isAskingPlayerstoAdd = false;
  bool isAskingStafftoAdd = false;
  List<Players> listOfPlayers = [];
  List<Staff> listOfStaff = [];

  final _formKey = GlobalKey<FormState>();

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
      //_validate(context);
    }
  }

  bool showPlayerChoices = false;
  bool showStaffChoices = false;
  bool showStaffAddedSuccess = false;
  bool showStaffSuccess = false;
  bool showPlayerSuccess = false;
  bool showPlayerAddedSuccess = false;
  bool wasAdding = false;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future<void> _initData() async {
    userResultData = (await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs))!;
    await serviceLocator<CommonCubit>().fetchCategories();

    //fetchCategories

    print('data to edit: ' + widget.data.toString());

    _teamNameController.text =
        widget.data['teamName'] != null ? widget.data['teamName'] : "";
    _abrivationController.text =
        widget.data['abbreviation'] != null ? widget.data['abbreviation'] : "";

    print("abbreviation: " + widget.data['abbreviation'].toString());
    _countryController.text =
        widget.data['location'] != null ? widget.data['location'] : "";
    createdTeamID = widget.data['teamID'] != null ? widget.data['teamID'] : "";
    selectedCatId =
        widget.data['category'] != null ? widget.data['category'] : "";

    oldPhoto = widget.data['photo'] != null ? widget.data['photo'] : "";
  }

  bool canAddStaffContinue() {
    bool canadd = false;
    if (staffInATeamModel != null) {
      if (staffInATeamModel!.staffInATeamModelData != null) {
        if (staffInATeamModel!.staffInATeamModelData!.staff != null) {
          if (staffInATeamModel!.staffInATeamModelData!.staff!.length > 0) {
            canadd = true;
          }
        }
      }
    }
    return canadd;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sonaWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: BlocListener(
              bloc: serviceLocator.get<CommonCubit>(),
              listener: (_, state) {
                if (state is FetchCategoriesLoading) {
                  print(" iwas here 1");
                  setState(() {
                    isLoading = true;
                  });
                  context.loaderOverlay.show();
                }

                if (state is FetchCategoriesError) {
                  print(" iwas here 2");
                  setState(() {
                    isLoading = false;
                  });
                  context.loaderOverlay.hide();
                  ResponseMessage.showErrorSnack(
                      context: context, message: state.message);
                }

                var ss = serviceLocator.get<TeamCategory>().teamCategoryData!;
                // find index of ss with selectedCatId
                var index = ss.indexWhere((element) {
                  bool didMatch = element.categoryId.toString() ==
                      widget.data['categoryId'].toString();
                  print(" comparing: " +
                      element.id.runtimeType.toString() +
                      " with " +
                      widget.data['categoryId'].runtimeType.toString() +
                      " " +
                      didMatch.toString());
                  return didMatch;
                });

                index = 0;

                var selectionName = ss[index].name.toString();

                if (state is FetchCategoriesSuccess) {
                  print(" selection:" + selectionName.toString());
                  context.loaderOverlay.hide();
                  setState(() {
                    isLoading = false;
                    listOfCategories = ss;
                    selectedCat = selectionName;
                  });
                }
                print(" iwas here 4");

                // add players to team
              },
              child: isLoading
                  ? Container(
                      child: Text('Loading...'),
                    )
                  : Form(
                      key: _formKey,
                      onChanged: () {
                        setState(() {
                          canSubmit = _formKey.currentState!.validate();
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 50, left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: InkWell(
                                    onTap: () {
                                      serviceLocator
                                          .get<NavigationService>()
                                          .pop();
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Icon(
                                        Iconsax.arrow_circle_left4,
                                        color: AppColors.sonaBlack2,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  // margin: EdgeInsets.only(right: 60),
                                  child: Column(children: [
                                    Text(
                                      "Edit team info".tr(),
                                      textAlign: TextAlign.center,
                                      style: AppStyle.h3.copyWith(
                                          color: AppColors.sonaBlack2,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Fill the player’s details and send an invite"
                                          .tr(),
                                      textAlign: TextAlign.center,
                                      style: AppStyle.text1.copyWith(
                                          color: AppColors.sonaGrey2,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ]),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: 20,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 40.h),
                                  Container(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            handlePickPhoto();
                                          },
                                          child: CircleAvatar(
                                              backgroundColor:
                                                  AppColors.sonaGrey6,
                                              radius: 55,
                                              child: ClipOval(
                                                child: SizedBox(
                                                    width: 110.0,
                                                    height: 110.0,
                                                    child: _croppedFile != null
                                                        ? Image.file(
                                                            _croppedFile!,
                                                            fit: BoxFit.cover)
                                                        : oldPhoto != null &&
                                                                Uri.parse(
                                                                        oldPhoto!)
                                                                    .isAbsolute
                                                            ? Image.network(
                                                                oldPhoto!)
                                                            : Image.asset(
                                                                AppAssets
                                                                    .placeholder,
                                                                fit: BoxFit
                                                                    .contain,
                                                                repeat: ImageRepeat
                                                                    .noRepeat)),
                                              ))),
                                      SizedBox(height: 10),
                                      InkWell(
                                        onTap: () {
                                          handlePickPhoto();
                                        },
                                        child: Text(
                                          "Upload Your Logo".tr(),
                                          style: TextStyle(
                                              color: AppColors.sonaGreen,
                                              fontSize: 14.sp,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40.h,
                                      ),
                                      AppTextField(
                                        headerText: "team_name".tr(),
                                        hintText: "Type here".tr(),
                                        validator: Validator.requiredValidator,
                                        controller: _teamNameController,
                                        onChanged: (v) {
                                          setState(() {});
                                          // validateButton();
                                        },
                                        textInputType: TextInputType.name,
                                        textInputFormatters: [
                                          LengthLimitingTextInputFormatter(20),
                                          FilteringTextInputFormatter(
                                              RegExp("[a-zA-ZÄäÖöÜü 0-9]"),
                                              allow: true) //Only Text as input
                                        ],
                                        onSaved: (val) =>
                                            _teamNameController.text = val!,
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Row(
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
                                            child: AppTextField(
                                              controller: _abrivationController,
                                              headerText:
                                                  "Name Abbreviation".tr(),
                                              hintText: "Type here".tr(),
                                              validator:
                                                  Validator.requiredValidator,
                                              onChanged: (v) {
                                                setState(() {});
                                                // validateButton();
                                              },
                                              textInputType: TextInputType.name,
                                              textInputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    10),
                                                FilteringTextInputFormatter(
                                                    RegExp("[a-zA-ZÄäÖöÜü]"),
                                                    allow:
                                                        true) //Only Text as input
                                              ],
                                              onSaved: (val) =>
                                                  _abrivationController.text =
                                                      val!,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.44,
                                            child: AppTextField(
                                              hintText: "Type here".tr(),
                                              headerText: "location".tr(),
                                              validator:
                                                  Validator.requiredValidator,
                                              readOnly: true,
                                              suffixWidget: Container(
                                                  width: 20.w,
                                                  height: 20.h,
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  child: SvgPicture.asset(
                                                      'assets/svgs/drop_grey.svg')),
                                              controller: _countryController,
                                              onChanged: (v) {
                                                setState(() {});
                                                // validateButton();
                                              },
                                              onTap: () {
                                                showCountryPicker(
                                                    context: context,
                                                    showPhoneCode: false,
                                                    countryListTheme:
                                                        countryListThemeData(),
                                                    onSelect:
                                                        (Country country) {
                                                      setState(() {
                                                        _countryController
                                                                .text =
                                                            country
                                                                .displayNameNoCountryCode
                                                                .trim()
                                                                .replaceAll(
                                                                    RegExp(
                                                                        ' \\(.*?\\)'),
                                                                    '');
                                                      });
                                                      //print("Selected country: ${country.displayName}");
                                                    });
                                              },
                                              textInputType: TextInputType.name,
                                              //onSaved: (val) => _countryController.text = val!,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      AppDropdownModal(
                                        // hintText: "Type here".tr(),
                                        options: serviceLocator
                                            .get<TeamCategory>()
                                            .teamCategoryData!,
                                        value: selectedCat,
                                        hasSearch: true,
                                        onChanged: (val) {
                                          setState(() {
                                            selectedCategory =
                                                val as TeamCategoryData;
                                            selectedCat =
                                                selectedCategory!.name;
                                          });
                                        },
                                        validator: Validator.requiredValidator,
                                        modalHeight:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        headerText: 'team_category'.tr(),
                                      ),
                                      SizedBox(height: 40.h),
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: AppButton(
                                              buttonText: "Save changes".tr(),
                                              onPressed: canSubmit
                                                  ? () {
                                                      if (_formKey.currentState!
                                                              .validate() &&
                                                          createTeamStep ==
                                                              "1") {
                                                        _formKey.currentState!
                                                            .save();
                                                        _handleUpdateTeam();
                                                      }
                                                    }
                                                  : null)),
                                      SizedBox(height: 20.h),
                                    ],
                                  )),
                                  BlocConsumer(
                                    bloc: serviceLocator.get<CommonCubit>(),
                                    listener: (_, state) {
                                      if (state is CreateTeamLoading) {
                                        context.loaderOverlay.show();
                                      }

                                      if (state is CreateTeamError) {
                                        print("still error");
                                        context.loaderOverlay.hide();
                                        setState(() {
                                          canSubmit = true;
                                          isSubmitting = false;
                                        });
                                        ResponseMessage.showErrorSnack(
                                            context: context,
                                            message: state.message);
                                      }

                                      if (state is CreateTeamSuccess) {
                                        context.loaderOverlay.hide();
                                        // createdTeamID = state
                                        //     .createTeamResponseModelData!.id!;
                                        // createdTeamName = state
                                        //     .createTeamResponseModelData!
                                        //     .teamName!;
                                        // createTeamStep = "2";
                                        // canSubmit = false;
                                        // isSubmitting = false;
                                        // setState(() {});
                                        // TODO: success
                                        // hide bottom sheet
                                        showToast("Team updated successfully!",
                                            "success");
                                        Navigator.of(context).pop(true);
                                      }
                                    },
                                    builder: (_, state) {
                                      return const SizedBox();
                                    },
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> startAddingExistingPlayers() async {
    // formate:
    // var request = {
    //   "players": [
    //     {"player_id": playerID, "team_id": teamID}
    //   ]
    // };

    setState(() {
      isLoading = true;
      wasAdding = true;
    });
    context.loaderOverlay.show();

    var request = {"players": []};
    for (var player in listOfPlayers) {
      request["players"]!
          .add({"player_id": player.id, "team_id": createdTeamID});
    }

    await serviceLocator<CommonCubit>().addPlayerToTeamMultiple(request);
    context.loaderOverlay.hide();
  }

  Future<void> startAddingExistingStaff() async {
    // formate:
    // var request = {
    //   "staff": [
    //     {"staff_id": playerID, "team_id": teamID, "role": role}
    //   ]
    // };

    setState(() {
      isLoading = true;
      wasAdding = true;
    });
    context.loaderOverlay.show();

    var request = {"staff": []};
    for (var player in listOfStaff) {
      request["players"]!.add({
        "staff_id": player.id,
        "team_id": createdTeamID,
        "role": player.role
      });
    }

    await serviceLocator<CommonCubit>().addStaffToTeamMultiple(request);
    context.loaderOverlay.hide();
  }

  Future<void> _handleUpdateTeam() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      isSubmitting = true;
      canSubmit = false;
    });

    await serviceLocator<CommonCubit>().updateTeam(
        selectedCatId,
        _teamNameController.text,
        _abrivationController.text,
        _countryController.text,
        widget.data["teamID"],
        _croppedFile);
  }
}
