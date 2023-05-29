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
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/models/response/CreateTeamResponseModel.dart';
import 'package:sonalysis/core/models/response/StaffListResponseModel.dart';
import 'package:sonalysis/core/models/response/TeamCategory.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart' as urm;
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/validator.dart';
import 'package:sonalysis/core/widgets/addplayers_screen.dart';
import 'package:sonalysis/core/widgets/addstaffs_screen.dart';
import 'package:sonalysis/core/widgets/app_dropdown_modal.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/core/widgets/create_team_step_2_bottom_sheet.dart';
import 'package:sonalysis/core/widgets/popup_screen.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/teams_club_management/create_team_flow/addPlayerFlow.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/teams_club_management/create_team_flow/addStaffFlow.dart';
import 'package:sonalysis/helpers/auth/shared_preferences_class.dart';
import 'package:sonalysis/model/response/UserLoginResultModel.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/custom_button.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/helpers.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/GradientProgressBar.dart';
import '../../../../../core/widgets/empty_response.dart';
import '../../../../../features/common/models/PlayersInATeamModel.dart';
import '../../../../../features/common/models/StaffInATeamModel.dart';
import '../../../../../widgets/player_grid_item.dart';
import '../../../../../widgets/staff_grid_item.dart';
import '../../../widgets/new_exsisting_staff_quiz_modal.dart';
import '../../../widgets/upload_csv_popup.dart';
import 'createPlayerFlow.dart';
import 'createStaffFlow.dart';

class CreateTeamFlowScreen extends StatefulWidget {
  const CreateTeamFlowScreen({Key? key}) : super(key: key);

  @override
  _CreateTeamFlowScreenState createState() => _CreateTeamFlowScreenState();
}

class _CreateTeamFlowScreenState extends State<CreateTeamFlowScreen> {
  bool canProceed = false, canProceed2 = false;
  bool canSubmit = false, isLoading = true;
  String createTeamStep = "1",
      skipNext = "Skip",
      createdTeamID = "",
      createdTeamName = "";
  List<TeamCategoryData> listOfCategories = [];
  TeamCategoryData? selectedCategory;
  String? selectedCategoryName;

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
  List<StaffListResponseModelData> listOfStaff = [];

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
  }

  Future<void> _initData() async {
    userResultData = (await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs))!;
    //fetchCategories

    // _teamNameController.text = "abc team";
    // _abrivationController.text = "abc";

    await serviceLocator<CommonCubit>().fetchCategories();
  }

  Future<void> _getData() async {
    //getPlayerInATeamList
    await serviceLocator<CommonCubit>().getPlayersInATeamList(createdTeamName);
    //getStaffInATeamList
    await serviceLocator<CommonCubit>().getStaffInATeamList(createdTeamName);
  }

  void _onRefresh() async {
    _getData();
    _refreshPlayerController.refreshCompleted();
    _refreshStaffController.refreshCompleted();
  }

  void _onLoading() async {
    _getData();
    _refreshPlayerController.loadComplete();
    _refreshStaffController.loadComplete();
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
                  setState(() {
                    isLoading = true;
                  });
                  context.loaderOverlay.show();
                }

                if (state is FetchCategoriesError) {
                  setState(() {
                    isLoading = false;
                  });
                  context.loaderOverlay.hide();
                  ResponseMessage.showErrorSnack(
                      context: context, message: state.message);
                }

                if (state is FetchCategoriesSuccess) {
                  context.loaderOverlay.hide();
                  print("loaded categories");
                  setState(() {
                    isLoading = false;
                    listOfCategories =
                        serviceLocator.get<TeamCategory>().teamCategoryData!;
                  });
                }

                // add players to team

                if (state is CreatePlayerError) {
                  setState(() {
                    isLoading = false;
                  });
                  context.loaderOverlay.hide();
                  ResponseMessage.showErrorSnack(
                      context: context, message: state.message);
                }

                if (state is CreatePlayerSuccess) {
                  if (wasAdding) {
                    setState(() {
                      showPlayerAddedSuccess = true;
                    });
                  }
                }

                if (state is CreateStaffSuccess) {
                  if (wasAdding) {
                    setState(() {
                      showStaffAddedSuccess = true;
                    });
                  }
                }

                if (state is PlayerListLoading) {
                  // setState(() {
                  //   isLoading = true;
                  // });
                  context.loaderOverlay.show();
                }

                if (state is StaffListLoading && !isLoading) {
                  // setState(() {
                  //   isLoading = true;
                  // });
                  context.loaderOverlay.show();
                }

                if (state is PlayerListError) {
                  setState(() {
                    isLoading = false;
                  });
                  context.loaderOverlay.hide();
                  ResponseMessage.showErrorSnack(
                      context: context, message: state.message);
                }

                if (state is StaffListError) {
                  setState(() {
                    isLoading = false;
                  });
                  context.loaderOverlay.hide();
                  ResponseMessage.showErrorSnack(
                      context: context, message: state.message);
                }

                if (state is PlayerListSuccess) {
                  context.loaderOverlay.hide();
                  setState(() {
                    print('did call::ff');
                    isLoading = false;
                    playersInATeamModel =
                        serviceLocator.get<PlayersInATeamModel>();
                    staffInATeamModel = serviceLocator.get<StaffInATeamModel>();
                  });
                }

                if (state is StaffInATeamListSuccess) {
                  context.loaderOverlay.hide();
                  setState(() {
                    print('did call::ff22');
                    isLoading = false;
                    staffInATeamModel = serviceLocator.get<StaffInATeamModel>();
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
                                  child: Text(
                                    "create_new_team".tr(),
                                    textAlign: TextAlign.center,
                                    style: AppStyle.h3.copyWith(
                                        color: AppColors.sonaBlack2,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                )
                              ],
                            ),
                          ),
                          createTeamStep == "1"
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20, top: 40),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Team information".tr(namedArgs: {
                                          "this": "1",
                                          "that": "3"
                                        }),
                                        textAlign: TextAlign.left,
                                        style: AppStyle.text2.copyWith(
                                            color: AppColors.sonaGrey3,
                                            fontWeight: FontWeight.w400),
                                      ).tr(),
                                      SizedBox(height: 10.h),
                                      GradientProgressBar(
                                        percent: 33,
                                        gradient: AppColors.sonalysisGradient,
                                        backgroundColor: AppColors.sonaGrey6,
                                      ),
                                      SizedBox(height: 40.h),
                                      Container(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                        child: _croppedFile !=
                                                                null
                                                            ? Image.file(
                                                                _croppedFile!,
                                                                fit: BoxFit
                                                                    .cover)
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
                                            controller: _teamNameController,
                                            headerText: "team_name".tr(),
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
                                                  20),
                                              FilteringTextInputFormatter(
                                                  RegExp("[a-zA-ZÄäÖöÜü 0-9]"),
                                                  allow:
                                                      true) //Only Text as input
                                            ],
                                            // onSaved: (val) =>
                                            //     _teamNameController.text = val!,
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
                                                  headerText:
                                                      "Name Abbreviation".tr(),
                                                  hintText: "Type here".tr(),
                                                  validator: Validator
                                                      .requiredValidator,
                                                  onChanged: (v) {
                                                    setState(() {});
                                                    // validateButton();
                                                  },
                                                  textInputType:
                                                      TextInputType.name,
                                                  textInputFormatters: [
                                                    LengthLimitingTextInputFormatter(
                                                        10),
                                                    FilteringTextInputFormatter(
                                                        RegExp(
                                                            "[a-zA-ZÄäÖöÜü]"),
                                                        allow:
                                                            true) //Only Text as input
                                                  ],
                                                  // onSaved: (val) =>
                                                  //     _abrivationController
                                                  //         .text = val!,
                                                  controller:
                                                      _abrivationController,
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
                                                  validator: Validator
                                                      .requiredValidator,
                                                  readOnly: true,
                                                  suffixWidget: Container(
                                                      width: 20.w,
                                                      height: 20.h,
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      child: SvgPicture.asset(
                                                          'assets/svgs/drop_grey.svg')),
                                                  controller:
                                                      _countryController,
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
                                                  textInputType:
                                                      TextInputType.name,
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
                                            value: selectedCategoryName,
                                            hasSearch: true,
                                            onChanged: (val) {
                                              setState(() {
                                                selectedCategory =
                                                    val as TeamCategoryData;
                                                selectedCategoryName =
                                                    val.name!;
                                              });
                                            },
                                            validator:
                                                Validator.requiredValidator,
                                            modalHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            headerText: 'team_category'.tr(),
                                          ),
                                          SizedBox(height: 40.h),
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: AppButton(
                                                  buttonText: "Continue".tr(),
                                                  onPressed: canSubmit
                                                      ? () {
                                                          if (_formKey
                                                                  .currentState!
                                                                  .validate() &&
                                                              createTeamStep ==
                                                                  "1") {
                                                            _formKey
                                                                .currentState!
                                                                .save();
                                                            _handleCreateTeam();
                                                          }
                                                        }
                                                      : null)),
                                          SizedBox(height: 20.h),
                                        ],
                                      )),
                                      BlocConsumer(
                                        bloc: serviceLocator.get<CommonCubit>(),
                                        listener: (_, state) {
                                          print("what is here " +
                                              state.toString());
                                          if (state is CreateTeamLoading) {
                                            context.loaderOverlay.show();
                                          }

                                          if (state is CreateTeamError) {
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
                                            print("what is here");
                                            context.loaderOverlay.hide();
                                            createdTeamID = state
                                                .createTeamResponseModelData!
                                                .id!;
                                            createdTeamName = state
                                                .createTeamResponseModelData!
                                                .teamName!;
                                            createTeamStep = "2";
                                            canSubmit = false;
                                            isSubmitting = false;
                                            setState(() {});
                                          }
                                        },
                                        builder: (_, state) {
                                          return const SizedBox();
                                        },
                                      ),
                                    ],
                                  ))
                              : createTeamStep == "2"
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          top: 40,
                                          left: 20,
                                          bottom: 20,
                                          right: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Add your players".tr(
                                                    namedArgs: {
                                                      "this": "2",
                                                      "that": "3"
                                                    }),
                                                textAlign: TextAlign.left,
                                                style: AppStyle.text2.copyWith(
                                                    color: AppColors.sonaGrey3,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ).tr(),
                                              InkWell(
                                                onTap: () {
                                                  createTeamStep = "3";
                                                  canSubmit = false;
                                                  isSubmitting = false;
                                                  setState(() {});
                                                },
                                                child: Text(
                                                  "Skip this step".tr(),
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.sonaGreen,
                                                      fontSize: 14.sp,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          GradientProgressBar(
                                            percent: 66,
                                            gradient:
                                                AppColors.sonalysisGradient,
                                            backgroundColor:
                                                AppColors.sonaGrey6,
                                          ),
                                          SizedBox(height: 40.h),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.44,
                                                      child: AppButton(
                                                          buttonText:
                                                              "Add a PLayer"
                                                                  .tr(),
                                                          onPressed: () async {
                                                            setState(() {
                                                              showPlayerChoices =
                                                                  true;
                                                            });

                                                            setState(() {});
                                                          })),
                                                  // SizedBox(
                                                  //   width:
                                                  //       MediaQuery.of(context)
                                                  //               .size
                                                  //               .width *
                                                  //           0.44,
                                                  //   child: AppButton(
                                                  //       buttonText:
                                                  //           "upload_csv".tr(),
                                                  //       buttonType: ButtonType
                                                  //           .secondary,
                                                  //       onPressed: () async {
                                                  //         showDialog(
                                                  //             context: context,
                                                  //             barrierDismissible:
                                                  //                 false,
                                                  //             builder: (BuildContext
                                                  //                     context) =>
                                                  //                 UploadCSVPopUpScreen(
                                                  //                     teamId:
                                                  //                         createdTeamID,
                                                  //                     userType:
                                                  //                         "PLAYER")).then(
                                                  //             (value) {
                                                  //           if (value != null &&
                                                  //               value) {
                                                  //             showSnackSuccess(
                                                  //                 context,
                                                  //                 "Player Created successfully");
                                                  //             skipNext = "Next";
                                                  //             createTeamStep =
                                                  //                 "3";
                                                  //             canSubmit = false;
                                                  //             isSubmitting =
                                                  //                 false;
                                                  //           }
                                                  //         });
                                                  //         setState(() {});
                                                  //       }),
                                                  // ),
                                                ],
                                              ),
                                              //load list of players
                                              Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: Container(
                                                    child: BlocListener(
                                                        bloc: serviceLocator
                                                            .get<CommonCubit>(),
                                                        listener: (_, state) {},
                                                        child: isLoading
                                                            ? Container()
                                                            : Column(children: [
                                                                Container(
                                                                    margin: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            0,
                                                                        vertical:
                                                                            10),
                                                                    child: playersInATeamModel ==
                                                                            null
                                                                        ? EmptyResponseWidget(
                                                                            msg:
                                                                                "Added players will appear here",
                                                                            iconData: Iconsax
                                                                                .menu_board5)
                                                                        : Container(
                                                                            height: MediaQuery.of(context).size.height *
                                                                                0.5,
                                                                            child:
                                                                                GridView.count(
                                                                              shrinkWrap: true,
                                                                              physics: NeverScrollableScrollPhysics(),
                                                                              crossAxisCount: 2,
                                                                              padding: const EdgeInsets.symmetric(vertical: 4),
                                                                              childAspectRatio: 8.0 / 9.0,
                                                                              children: List.generate(playersInATeamModel!.playersInATeamModelData!.players!.length, (index) {
                                                                                return PlayerGridItem(players: playersInATeamModel!.playersInATeamModelData!.players!.elementAt(index));
                                                                              }),
                                                                            ))),
                                                                SizedBox(
                                                                    height:
                                                                        40.h),
                                                                Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child: AppButton(
                                                                        buttonText: "Continue".tr(),
                                                                        onPressed: playersInATeamModel != null && playersInATeamModel!.playersInATeamModelData!.players!.length > 0
                                                                            ? () {
                                                                                createTeamStep = "3";
                                                                                canSubmit = false;
                                                                                isSubmitting = false;
                                                                                setState(() {});
                                                                              }
                                                                            : null)),
                                                              ]))),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ))
                                  : Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Add your staff".tr(namedArgs: {
                                                  "this": "3",
                                                  "that": "3"
                                                }),
                                                textAlign: TextAlign.left,
                                                style: AppStyle.text2.copyWith(
                                                    color: AppColors.sonaGrey4,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ).tr(),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: Text(
                                                  "Done".tr(),
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.sonaGreen,
                                                      fontSize: 12.sp,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 7.h),
                                          GradientProgressBar(
                                            percent: 100,
                                            gradient:
                                                AppColors.sonalysisGradient,
                                            backgroundColor:
                                                AppColors.sonaGrey6,
                                          ),
                                          SizedBox(height: 20.h),
                                          SizedBox(height: 20.h),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.44,
                                                      child: AppButton(
                                                          buttonText:
                                                              "Add a Staff"
                                                                  .tr(),
                                                          onPressed: () async {
                                                            setState(() {
                                                              showStaffChoices =
                                                                  true;
                                                            });

                                                            setState(() {});
                                                          })),
                                                  // SizedBox(
                                                  //   width:
                                                  //       MediaQuery.of(context)
                                                  //               .size
                                                  //               .width *
                                                  //           0.44,
                                                  //   child: AppButton(
                                                  //       buttonText:
                                                  //           "upload_csv".tr(),
                                                  //       buttonType: ButtonType
                                                  //           .secondary,
                                                  //       onPressed: () async {
                                                  //         bottomSheet(
                                                  //                 context,
                                                  //                 NewExistingStaffModalQuiz(
                                                  //                     teamId:
                                                  //                         createdTeamID))
                                                  //             .then((value) {
                                                  //           if (value != null &&
                                                  //               value) {
                                                  //             showSnackSuccess(
                                                  //                 context,
                                                  //                 "Staff Created successfully");
                                                  //             Navigator.of(
                                                  //                     context)
                                                  //                 .pop(true);
                                                  //           }
                                                  //         });
                                                  //         setState(() {});
                                                  //       }),
                                                  // ),
                                                ],
                                              ),
                                              //load list of staff
                                              Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: Container(
                                                  child: BlocListener(
                                                    bloc: serviceLocator
                                                        .get<CommonCubit>(),
                                                    listener: (_, state) {},
                                                    child: isLoading
                                                        ? Container()
                                                        : Column(children: [
                                                            Container(
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 0,
                                                                  vertical: 10),
                                                              child: staffInATeamModel ==
                                                                          null ||
                                                                      staffInATeamModel!
                                                                              .staffInATeamModelData!
                                                                              .staff!
                                                                              .length ==
                                                                          0
                                                                  ? EmptyResponseWidget(
                                                                      msg:
                                                                          "Added staff will appear here",
                                                                      iconData:
                                                                          Iconsax
                                                                              .menu_board5)
                                                                  : Container(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.5,
                                                                      child: GridView
                                                                          .count(
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        crossAxisCount:
                                                                            2,
                                                                        padding:
                                                                            const EdgeInsets.symmetric(vertical: 4),
                                                                        childAspectRatio:
                                                                            8.0 /
                                                                                9.0,
                                                                        children: List.generate(
                                                                            staffInATeamModel!.staffInATeamModelData!.staff!.length,
                                                                            (index) {
                                                                          return StaffGridItem(
                                                                              staffInATeamModelData: staffInATeamModel!.staffInATeamModelData!.staff!.elementAt(index));
                                                                        }),
                                                                      ),
                                                                    ),
                                                            ),
                                                            SizedBox(
                                                                height: 40.h),
                                                            Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child: AppButton(
                                                                    buttonText: "Continue".tr(),
                                                                    onPressed: canAddStaffContinue()
                                                                        ? () {
                                                                            createTeamStep =
                                                                                "3";
                                                                            canSubmit =
                                                                                false;
                                                                            isSubmitting =
                                                                                false;
                                                                            // pop
                                                                            Navigator.of(context).pop(true);
                                                                            setState(() {});
                                                                          }
                                                                        : null)),
                                                          ]),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              child: CustomButton(
                                                text: "Done",
                                                color: sonaPurple1,
                                                action: () async {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                              )),
                                        ],
                                      )),
                        ],
                      ),
                    ),
            ),
          ),
          Positioned(
              child: showPlayerChoices
                  ? AddPlayerChoices({
                      "title": "Add player".tr(),
                      "subTitle": "Choose how you’d like to add a player".tr(),
                      "buttons": [
                        {
                          "onPressed": () {
                            setState(() {
                              showPlayerChoices = false;
                              wasAdding = false;
                            });
                            // Navigator.of(context).pop();
                            bottomSheet(
                                context,
                                CreatePlayerFlowScreen(
                                  teamId: createdTeamID,
                                  onPlayerCreated: () {
                                    setState(() {
                                      showPlayerSuccess = true;
                                    });
                                  },
                                )).then((value) {
                              //_onRefresh();
                            });
                          },
                          "buttonText": "Create new player".tr(),
                          "buttonType": ButtonType.primary
                        },
                        {
                          "onPressed": () {
                            setState(() {
                              showPlayerChoices = false;
                            });
                            bottomSheet(
                                context,
                                AddPlayerFlowScreen(
                                  teamId: createdTeamID,
                                  clubId: userResultData.user!.clubs![0].id,
                                  onPlayersAdded: (List<Players> players) {
                                    print("I was herelrerlere");
                                    print("I was herelrerlere " +
                                        players.length.toString());
                                    setState(() {
                                      showPlayerChoices = false;
                                      isAskingPlayerstoAdd = true;
                                      listOfPlayers = players;
                                    });
                                  },
                                )).then((value) {
                              setState(() {
                                print("I was herelrerlere 22");
                                showPlayerChoices = false;
                                // isAskingPlayerstoAdd = false;
                              });
                              //_onRefresh();
                            });
                          },
                          "buttonText": "Add existing player".tr(),
                          "buttonType": ButtonType.secondary
                        },
                      ]
                    }, context, () {
                      setState(() {
                        showPlayerChoices = false;
                      });
                    })
                  : Container()),
          Positioned(
              child: showStaffChoices
                  ? AddPlayerChoices({
                      "title": "Add staff".tr(),
                      "subTitle": "Choose how you’d like to add a staff".tr(),
                      "buttons": [
                        {
                          "onPressed": () {
                            setState(() {
                              showStaffChoices = false;
                            });
                            bottomSheet(
                                context,
                                CreateStaffFlowScreen(
                                  teamId: createdTeamID,
                                  onPlayerCreated: () {
                                    setState(() {
                                      showStaffSuccess = true;
                                    });
                                    // TODO: show success mahev
                                  },
                                )).then((value) {
                              //_onRefresh();
                            });
                          },
                          "buttonText": "Create new staff".tr(),
                          "buttonType": ButtonType.primary
                        },
                        {
                          "onPressed": () => setState(() {
                                setState(() {
                                  showStaffChoices = false;
                                });
                                bottomSheet(
                                    context,
                                    AddStaffFlowScreen(
                                      teamId: createdTeamID,
                                      clubId: userResultData.user!.clubs![0].id,
                                      onPlayersAdded:
                                          (List<StaffListResponseModelData>
                                              players) {
                                        setState(() {
                                          showStaffChoices = false;
                                          isAskingStafftoAdd = true;
                                          listOfStaff = players;
                                        });
                                      },
                                    )).then((value) {
                                  setState(() {
                                    showStaffChoices = false;
                                    isAskingStafftoAdd = false;
                                  });
                                  //_onRefresh();
                                });
                              }),
                          "buttonText": "Add existing staff".tr(),
                          "buttonType": ButtonType.secondary
                        },
                      ]
                    }, context, () {
                      setState(() {
                        showStaffChoices = false;
                      });
                    })
                  : Container()),
          Positioned(
              child: showPlayerSuccess
                  ? PopUpPageScreen(data: {
                      "title": "new_player_created".tr(),
                      "subTitle": "new_player_created_desc".tr(),
                      "route": null,
                      "routeType": "callback",
                      "callback": () {
                        _getData();
                        setState(() {
                          showPlayerSuccess = false;
                        });
                      },
                      "buttonText": "okay_thank_you".tr()
                    })
                  : Container()),
          Positioned(
              child: showPlayerAddedSuccess
                  ? PopUpPageScreen(data: {
                      "title": "Players added".tr(),
                      "subTitle":
                          "${listOfPlayers.length} Players added successfully! "
                              .tr(),
                      "route": null,
                      "routeType": "callback",
                      "callback": () {
                        _getData();
                        setState(() {
                          showPlayerAddedSuccess = false;
                        });
                      },
                      "buttonText": "okay_thank_you".tr()
                    })
                  : Container()),
          Positioned(
              child: showStaffAddedSuccess
                  ? PopUpPageScreen(data: {
                      "title": "Staff added".tr(),
                      "subTitle":
                          "${listOfPlayers.length} Staff added successfully! "
                              .tr(),
                      "route": null,
                      "routeType": "callback",
                      "callback": () {
                        _getData();
                        setState(() {
                          showStaffAddedSuccess = false;
                        });
                      },
                      "buttonText": "okay_thank_you".tr()
                    })
                  : Container()),
          Positioned(
              child: showStaffSuccess
                  ? PopUpPageScreen(data: {
                      "title": "new_staff_created".tr(),
                      "subTitle": "new_staff_created_desc".tr(),
                      "route": null,
                      "routeType": "callback",
                      "callback": () {
                        _getData();

                        setState(() {
                          showStaffSuccess = false;
                        });
                      },
                      "buttonText": "okay_thank_you".tr()
                    })
                  : Container()),
          Positioned(
              child: isAskingPlayerstoAdd
                  ? AddPlayersScreen(data: {
                      "players": listOfPlayers,
                      "yes": () {
                        setState(() {
                          isAskingPlayerstoAdd = false;
                          startAddingExistingPlayers();
                        });
                        // Navigator.of(context).pop();
                      },
                      "no": () {}
                    })
                  : Container()),
          Positioned(
              child: isAskingStafftoAdd
                  ? AddStaffsScreen(data: {
                      "players": listOfStaff,
                      "yes": () {
                        setState(() {
                          isAskingStafftoAdd = false;
                          startAddingExistingStaff();
                        });
                        // Navigator.of(context).pop();
                      },
                      "no": () {}
                    })
                  : Container()),
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
    for (StaffListResponseModelData player in listOfStaff) {
      request["staff"]!.add({
        "staff_id": player.id,
        "team_id": createdTeamID,
        "role": player.role
      });
    }

    print(request);

    await serviceLocator<CommonCubit>().addStaffToTeamMultiple(request);
    context.loaderOverlay.hide();
  }

  Future<void> _handleCreateTeam() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await serviceLocator<CommonCubit>().createTeam(
        selectedCategory!.id,
        _teamNameController.text,
        _abrivationController.text,
        userResultData.user!.clubs![0].id,
        _countryController.text,
        _croppedFile);
  }
}
