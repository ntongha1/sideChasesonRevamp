import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/models/activityType.dart';
import 'package:sonalysis/core/models/home_away.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/models/teams.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/validator.dart';
import 'package:sonalysis/core/widgets/app_drop_down.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/models/GetPlayerVerifyImageModel.dart';
import 'package:sonalysis/features/common/models/UploadVideoResponseModel.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/core/widgets/app_dropdown_modal.dart';
import '../../../../../core/models/response/TeamsListResponseModel.dart';
import '../../../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class VerifyTeamPopUpScreen extends StatefulWidget {
  String? videoID;
  Function? onSuccess;

  VerifyTeamPopUpScreen({Key? key, this.videoID, this.onSuccess})
      : super(key: key);

  @override
  _VerifyTeamPopUpScreenState createState() => _VerifyTeamPopUpScreenState();
}

class _VerifyTeamPopUpScreenState extends State<VerifyTeamPopUpScreen> {
  final TextEditingController _videoLinkController = TextEditingController();
  String? _homeTeam, _awayTeam;
  bool canSubmit = false;
//
  UserResultData? userResultData;
  bool isLoading = true;
  TeamsListResponseModel? teamsListResponseModel;
  GetPlayerVerifyImageModel? _getPlayerVerifyImageModel;
  late List<String?> teamList;
  final _formKey = GlobalKey<FormState>();
  UploadVideoResponseModel? uploadVideoResponseModel;
  TeamsDropdown? selectedTeamA;
  TeamsDropdown? selectedTeamB;

  List<TeamsDropdown> teamsRaw = [];
  HomeAway? selectedHTAT_A;
  HomeAway? selectedHTAT_B;
  List<HomeAway> _homeAway = [
    HomeAway(name: "home".tr()),
    HomeAway(name: "away".tr())
  ];
  List<ActivityType> _activityType = [
    ActivityType(name: "friendly".tr()),
    ActivityType(name: "training".tr())
  ];
  ActivityType? _selectedActivityType;

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
        .getTeamList(userResultData!.user!.clubs![0].id!);
    await serviceLocator<CommonCubit>().getPlayerVerifyImage(widget.videoID!);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.normalRadius)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        content: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          height: 620,
          child: BlocListener(
            bloc: serviceLocator.get<CommonCubit>(),
            listener: (_, state) {
              if (state is TeamListLoading ||
                  state is GetPlayerVerifyImageLoading) {
                setState(() {
                  isLoading = true;
                });
                context.loaderOverlay.show();
              }

              if (state is TeamListError ||
                  state is GetPlayerVerifyImageError) {
                setState(() {
                  isLoading = false;
                });
                context.loaderOverlay.hide();
                ResponseMessage.showErrorSnack(
                    context: context, message: AppConstants.exceptionMessage);
              }

              if (state is TeamListSuccess) {
                //teamsListResponseModelData = serviceLocator.get<TeamsListResponseModel>().teamsListResponseModelData;

                TeamsListResponseModel tt = state.data!;
                var ttt = tt.teamsListResponseModelData!
                    .map((e) => TeamsDropdown(name: e.teamName!, id: e.id!))
                    .toList();
                teamsRaw = ttt;
                teamsListResponseModel = state.data;
                setState(() {});
              }

              if (state is GetPlayerVerifyImageSuccess) {
                isLoading = false;
                context.loaderOverlay.hide();
                _getPlayerVerifyImageModel = state.getPlayerVerifyImageModel;
                print(_getPlayerVerifyImageModel.toString());
                setState(() {});
              }
            },
            child: Form(
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
                      // const SizedBox(height: 10),
                      InkWell(
                          onTap: () {
                            widget.onSuccess!();
                            Navigator.of(context).pop(true);
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Boxicons.bx_x_circle,
                              color: AppColors.sonaBlack2,
                              size: 20,
                            ),
                          )),
                      const SizedBox(height: 10),
                      Text(
                        "verifyTeam".tr(),
                        textAlign: TextAlign.center,
                        style: AppStyle.text3.copyWith(
                            fontSize: 23.sp,
                            color: AppColors.sonaGrey2,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "verify_team_desc".tr(),
                        textAlign: TextAlign.center,
                        style: AppStyle.text1
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Team logos".tr(),
                        textAlign: TextAlign.left,
                        style: AppStyle.text2.copyWith(
                            color: AppColors.sonaBlack2,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              child: CircleAvatar(
                                backgroundColor: AppColors.sonaBlack,
                                radius: 60,
                                child: ClipOval(
                                    child: SizedBox(
                                        width: 60.0,
                                        height: 60.0,
                                        child: Image.network(
                                            _getPlayerVerifyImageModel == null
                                                ? AppConstants
                                                    .defaultProfilePictures
                                                : _getPlayerVerifyImageModel!
                                                        .getPlayerVerifyImageModelData!
                                                        .teamA!
                                                        .image ??
                                                    AppConstants
                                                        .defaultProfilePictures))),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              child: CircleAvatar(
                                backgroundColor: AppColors.sonaBlack,
                                radius: 60,
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 60.0,
                                    height: 60.0,
                                    child: Image.network(
                                        _getPlayerVerifyImageModel == null
                                            ? AppConstants
                                                .defaultProfilePictures
                                            : _getPlayerVerifyImageModel!
                                                    .getPlayerVerifyImageModelData!
                                                    .teamB!
                                                    .image ??
                                                AppConstants
                                                    .defaultProfilePictures),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: AppDropdownModal(
                                options: teamsRaw,
                                value: selectedTeamA != null
                                    ? selectedTeamA!.name
                                    : "",
                                hasSearch: false,
                                onChanged: (val) {
                                  print("starts here");
                                  print(val);
                                  setState(() {
                                    selectedTeamA = val as TeamsDropdown;
                                  });
                                },
                                validator: Validator.requiredValidator,
                                modalHeight:
                                    MediaQuery.of(context).size.height * 0.7,
                                // hint: 'Select an option',
                                headerText: "Home Team".tr(),
                                hintText: "Type here".tr(),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: AppDropdownModal(
                                options: teamsRaw,
                                value: selectedTeamB != null
                                    ? selectedTeamB!.name
                                    : "",
                                hasSearch: false,
                                onChanged: (val) {
                                  print(val);
                                  setState(() {
                                    selectedTeamB = val as TeamsDropdown;
                                  });
                                },
                                validator: Validator.requiredValidator,
                                modalHeight:
                                    MediaQuery.of(context).size.height * 0.7,
                                // hint: 'Select an option',
                                headerText: "Away Team".tr(),
                                hintText: "Type here".tr(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 10),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       SizedBox(
                      //         width: MediaQuery.of(context).size.width * 0.4,
                      //         child: AppDropdown<HomeAway>(
                      //           context: context,
                      //           options: _homeAway,
                      //           label: "ht_at".tr(),
                      //           hint: "Select an option",
                      //           value: selectedHTAT_A,
                      //           onChanged: (val) {
                      //             setState(() {
                      //               selectedHTAT_A = val as HomeAway;
                      //             });
                      //           },
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: MediaQuery.of(context).size.width * 0.4,
                      //         child: AppDropdown<HomeAway>(
                      //           context: context,
                      //           options: _homeAway,
                      //           label: "ht_at".tr(),
                      //           hint: "Select an option",
                      //           value: selectedHTAT_B,
                      //           onChanged: (val) {
                      //             setState(() {
                      //               selectedHTAT_B = val as HomeAway;
                      //             });
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: AppDropdownModal(
                                options: _activityType,
                                value: _selectedActivityType != null
                                    ? _selectedActivityType!.name
                                    : "",
                                hasSearch: false,
                                onChanged: (val) {
                                  setState(() {
                                    _selectedActivityType = val as ActivityType;
                                  });
                                },
                                validator: Validator.requiredValidator,
                                modalHeight:
                                    MediaQuery.of(context).size.height * 0.7,
                                // hint: 'Select an option',
                                headerText: "Activity Type".tr(),
                                hintText: "Type here".tr(),
                              ),

                              // AppDropdown<ActivityType>(
                              //   context: context,
                              //   options: _activityType,
                              //   label: "Activity Type".tr(),
                              //   hint: "Select an option",
                              //   value: _selectedActivityType,
                              //   onChanged: (val) {
                              //     setState(() {
                              //       _selectedActivityType = val as ActivityType;
                              //     });
                              //   },
                              // ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      AppButton(
                          buttonText: "Continue".tr(),
                          onPressed: canSubmit
                              ? () {
                                  _formKey.currentState!.save();
                                  _handleSubmit();
                                }
                              : null),
                      BlocConsumer(
                        bloc: serviceLocator.get<CommonCubit>(),
                        listener: (_, state) {
                          if (state is VerifyTeamLoading) {
                            context.loaderOverlay.show();
                          }

                          if (state is VerifyTeamError) {
                            context.loaderOverlay.hide();
                            setState(() {
                              canSubmit = true;
                            });
                            ResponseMessage.showErrorSnack(
                                context: context, message: state.message);
                          }

                          if (state is VerifyTeamSuccess) {
                            context.loaderOverlay.hide();
                            Navigator.of(context).pop(true);
                            widget.onSuccess!();
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
    if (selectedTeamA!.name == selectedTeamB!.name) {
      ResponseMessage.showErrorSnack(
          context: context, message: "same_team_error".tr());
      return;
    } else if (_getPlayerVerifyImageModel!
            .getPlayerVerifyImageModelData!.teamA!.teamName! ==
        _getPlayerVerifyImageModel!
            .getPlayerVerifyImageModelData!.teamB!.teamName!) {
      ResponseMessage.showErrorSnack(
          context: context, message: "same_ht_at_error".tr());
      return;
    } else {
      _formKey.currentState!.save();
      await serviceLocator<CommonCubit>().verifyTeam(
          selectedTeamA!.name,
          selectedTeamB!.name,
          _getPlayerVerifyImageModel!
              .getPlayerVerifyImageModelData!.teamA!.teamName!,
          _getPlayerVerifyImageModel!
              .getPlayerVerifyImageModelData!.teamB!.teamName!,
          widget.videoID
          /////
          // selectedHTAT_A!.name,
          // selectedHTAT_B!.name,
          // _selectedActivityType!.name
          );
    }
  }
}
