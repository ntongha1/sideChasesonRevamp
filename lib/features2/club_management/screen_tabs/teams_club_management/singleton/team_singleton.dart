import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/controller/club_mgt_controller.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/enums/user_type.dart';
import 'package:sonalysis/core/models/response/StaffListResponseModel.dart';
import 'package:sonalysis/core/models/response/TeamsListResponseModel.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart' as user;
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/widgets/addplayers_screen.dart';
import 'package:sonalysis/core/widgets/addstaffs_screen.dart';
import 'package:sonalysis/core/widgets/app_dropdown_modal.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/core/widgets/create_team_step_2_bottom_sheet.dart';
import 'package:sonalysis/core/widgets/player_on_tap_sheet.dart';
import 'package:sonalysis/core/widgets/popup_screen.dart';
import 'package:sonalysis/features/common/dashboard/widgets/selectPillsWidget.dart';
import 'package:sonalysis/features/common/models/ComparePVPModel.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/staff_club_management/add_edit_staff/addEditStaff.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/teams_club_management/create_team_flow/addPlayerFlow.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/teams_club_management/create_team_flow/addStaffFlow.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/teams_club_management/edit_team_flow/editTeamFlow.dart';
import 'package:sonalysis/lang/strings.dart';

import '../../../../../../core/utils/colors.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../../core/startup/app_startup.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/utils/response_message.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/empty_response.dart';
import '../../../../../features/common/cubit/common_cubit.dart';
import '../../../../../features/common/models/PlayersInATeamModel.dart';
import '../../../../../features/common/models/StaffInATeamModel.dart';
import '../../../../../widgets/player_grid_item.dart';
import '../../../../../widgets/staff_grid_item.dart';
import '../create_team_flow/createPlayerFlow.dart';
import '../create_team_flow/createStaffFlow.dart';

class TeamSingletonScreen extends StatefulWidget {
  const TeamSingletonScreen({Key? key, this.data}) : super(key: key);

  final Map? data;

  @override
  _TeamSingletonScreenState createState() => _TeamSingletonScreenState();
}

//TODO change page reload logic on new player or staff created
class _TeamSingletonScreenState extends State<TeamSingletonScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int _selectedIndex = 0;
  bool isLoading = true;
  PlayersInATeamModel? playersInATeamModel;
  List<Players>? playersInATeamModelFiltered;
  List<Staff>? staffInATeamModelFiltered;
  StaffInATeamModel? staffInATeamModel;
  bool showStaffSuccess = false;
  bool showPlayerSuccess = false;
  final TextEditingController searchController = TextEditingController();
  bool showPlayerChoices = false;
  bool showStaffChoices = false;
  user.UserResultData? userResultData;

  bool showingFilter = false;

  TextEditingController filterController = TextEditingController();

  bool showStaffAddedSuccess = false;
  bool showPlayerAddedSuccess = false;
  bool wasAdding = false;
  bool isAskingPlayerstoAdd = false;
  bool isAskingStafftoAdd = false;
  bool shownFloating = true;
  List<Players> listOfPlayers = [];
  List<StaffListResponseModelData> listOfStaff = [];
  bool showPlayerEdit = false;
  bool showStaffEdit = false;
  bool showPlayerRemoveSure = false;
  bool playerRemoved = false;
  String? contextPlayerId = "";
  Players? contextPlayer;
  Staff? contextStaff;
  String? contextStaffId = "";
  bool showStaffRemoveSure = false;
  bool staffRemoved = false;
  List<PillModel> pills = [
    PillModel(title: "All", key: "all", value: ""),
    PillModel(title: "Forward", key: "forward", value: ""),
    PillModel(title: "Midfield", key: "midfield", value: ""),
    PillModel(title: "Defence", key: "defence", value: ""),
    PillModel(title: "Keeper", key: "keeper", value: "")
  ];
  PillModel currentPill = PillModel(title: "All", key: "all", value: "");
  TeamsSingleModel? teamData;

  @override
  void initState() {
    _getData();
    context.loaderOverlay.show();
    // Create TabController for getting the index of current tab
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      setState(() {
        _selectedIndex = tabController!.index;
      });
      //print("Selected Index: " + tabController!.index.toString());
    });
    super.initState();
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    await serviceLocator<CommonCubit>().getTeamSingle(widget.data!["teamID"]!);
  }

  void searchNow(String? v) {
    List<Players> all = playersInATeamModel!.playersInATeamModelData!.players!;
    String value = "f";
    if (v == null || v == "")
      value = "";
    else
      value = v.trim().toLowerCase();
    if (v == "") {
      setState(() {
        playersInATeamModelFiltered = all;
      });
      return;
    }

    List<Players> temp = all.where((element) {
      String fname =
          element.firstName == null ? "" : element.firstName!.toLowerCase();
      String lname =
          element.lastName == null ? "" : element.lastName!.toLowerCase();
      String jersy =
          element.jerseyNo == null ? "" : element.jerseyNo!.toLowerCase();
      return fname.contains(value) ||
          lname.contains(value) ||
          jersy.contains(value);
    }).toList();
    setState(() {
      playersInATeamModelFiltered = temp;
    });
  }

  void searchNowStaff(String? v) {
    List<Staff> all = staffInATeamModel!.staffInATeamModelData!.staff!;
    String value = "f";
    if (v == null || v == "")
      value = "";
    else
      value = v.trim().toLowerCase();
    if (v == "") {
      setState(() {
        staffInATeamModelFiltered = all;
      });
      return;
    }

    List<Staff> temp = all.where((element) {
      String fname = element.user!.firstName == null
          ? ""
          : element.user!.firstName!.toLowerCase();
      String lname = element.user!.lastName == null
          ? ""
          : element.user!.lastName!.toLowerCase();

      return fname.contains(value) || lname.contains(value);
    }).toList();
    setState(() {
      staffInATeamModelFiltered = temp;
    });
  }

  void changePill(PillModel pill) {
    filterTypePill(pill);
    setState(() {
      currentPill = pill;
    });
  }

  void filterTypePill(PillModel pill) {
    List<Players> all = playersInATeamModel!.playersInATeamModelData!.players!;
    if (pill.key == "all") {
      setState(() {
        playersInATeamModelFiltered = all;
      });
      return;
    }
    List<Players> temp = all.where((element) {
      String position =
          element.position == null ? "" : element.position!.toLowerCase();
      return position == pill.key;
    }).toList();
    setState(() {
      playersInATeamModelFiltered = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        BlocListener(
            bloc: serviceLocator.get<CommonCubit>(),
            listener: (_, state) {
              if (state is PlayerListLoading ||
                  state is StaffInATeamListLoading) {
                setState(() {
                  isLoading = true;
                });
              }

              if (state is PlayerListError) {
                setState(() {
                  isLoading = false;
                });
                context.loaderOverlay.hide();
                ResponseMessage.showErrorSnack(
                    context: context, message: state.message);
              }

              if (state is StaffInATeamListError) {
                // isLoading = false;
                setState(() {});
                context.loaderOverlay.hide();
                ResponseMessage.showErrorSnack(
                    context: context, message: state.message);
              }

              if (state is TeamSingleError) {
                // isLoading = false;
                setState(() {});
                context.loaderOverlay.hide();
                ResponseMessage.showErrorSnack(
                    context: context, message: state.message);
              }

              if (state is TeamSingleSuccess) {
                TeamsSingleModel tt = serviceLocator.get<TeamsSingleModel>();
                teamData = tt;
                print("team photo" + (tt.photo ?? "null"));
                print("team photo" + (tt.id ?? "null"));
                serviceLocator<CommonCubit>()
                    .getPlayersInATeamList(tt.teamName!);

                serviceLocator<CommonCubit>().getStaffInATeamList(tt.teamName!);
              }

              if (state is PlayerListSuccess) {
                context.loaderOverlay.hide();
                PlayersInATeamModel temp =
                    serviceLocator.get<PlayersInATeamModel>();
                setState(() {
                  playersInATeamModel = temp;
                  playersInATeamModelFiltered =
                      temp.playersInATeamModelData!.players!;
                });
              }

              StaffInATeamModel temp = serviceLocator.get<StaffInATeamModel>();

              if (state is StaffInATeamListSuccess) {
                context.loaderOverlay.hide();
                staffInATeamModel = temp;
                staffInATeamModelFiltered = temp.staffInATeamModelData!.staff!;
                isLoading = false;
                shownFloating = true;
                setState(() {});
              }
            },
            child: isLoading
                ? Container()
                : Container(
                    color: AppColors.sonaGrey6,
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: InkWell(
                                onTap: () {
                                  serviceLocator.get<NavigationService>().pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(
                                    Iconsax.arrow_circle_left4,
                                    color: AppColors.sonaBlack2,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              // margin: EdgeInsets.only(right: 60),
                              child: Text(
                                "Team".tr(),
                                textAlign: TextAlign.center,
                                style: AppStyle.h3.copyWith(
                                    color: AppColors.sonaBlack2,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                            )
                          ],
                        ),
                        SizedBox(height: 40.h),
                        Container(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.sonaBlack,
                            child: ClipOval(
                              child: Image.network(
                                teamData!.photo == null ||
                                        teamData!.photo == "null" ||
                                        teamData!.photo == ""
                                    ? AppConstants.defaultProfilePictures
                                    : teamData!.photo!,
                                fit: BoxFit.cover,
                                repeat: ImageRepeat.noRepeat,
                                width: 40.w,
                                height: 40.h,
                              ),
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 0),
                                child: Text(
                                  teamData != null ? teamData!.teamName! : "",
                                  style: AppStyle.text2.copyWith(
                                      color: AppColors.sonaBlack2,
                                      fontWeight: FontWeight.w400),
                                ))),
                        SizedBox(height: 20.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            countWidget("Players".tr(),
                                teamData!.totalPlayers!.toString()),
                            SizedBox(width: 40.w),
                            countWidget(
                                "Staff".tr(), teamData!.totalStaff!.toString())
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                            child: TabBar(
                          controller: tabController,
                          indicatorWeight: 2,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: AppColors.sonalysisMediumPurple,
                          onTap: (index) {
                            // Tab index when user select it, it start from zero
                          },
                          tabs: [
                            Tab(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 0),
                                child: Text("Players",
                                    style: AppStyle.text3.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: _selectedIndex == 0
                                          ? AppColors.sonalysisMediumPurple
                                          : AppColors.sonaGrey2,
                                    )),
                              ),
                            ),
                            Tab(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 0),
                                child: Text("Staffs",
                                    style: AppStyle.text3.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: _selectedIndex == 1
                                          ? AppColors.sonalysisMediumPurple
                                          : AppColors.sonaGrey2,
                                    )),
                              ),
                            )
                          ],
                        )),
                        Flexible(
                            child: TabBarView(
                          controller: tabController,
                          children: [
                            SingleChildScrollView(
                              child: Container(
                                color: AppColors.sonaWhite,
                                child: Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      margin:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                      child: TextField(
                                        controller: searchController,
                                        onChanged: (value) {
                                          searchNow(value);
                                        },
                                        style: AppStyle.text2,
                                        decoration: InputDecoration(
                                          fillColor: AppColors.sonaGrey6,
                                          isDense: true,
                                          filled: true,
                                          prefixIcon: Icon(
                                            Boxicons.bx_search,
                                            color: AppColors.sonaGrey3,
                                            size: 30,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppConstants
                                                          .normalRadius),
                                              borderSide: BorderSide(
                                                  color: AppColors.sonaGrey6)),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15.h, horizontal: 12.w),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          hintText: "Search here",
                                          hintStyle: AppStyle.text2,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
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
                                            child: AppTextField(
                                              onTap: () {
                                                if (showingFilter) {
                                                  changePill(pills[0]);
                                                  setState(() {
                                                    showingFilter = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    showingFilter = true;
                                                  });
                                                }
                                              },
                                              readOnly: true,
                                              suffixWidget: Container(
                                                  width: 20.w,
                                                  height: 20.h,
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  child: SvgPicture.asset(
                                                      'assets/svgs/drop_grey.svg')),
                                              controller: filterController,
                                              hintText: "Filter".tr(),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.44,
                                            child: AppButton(
                                                buttonText:
                                                    "Edit team info".tr(),
                                                buttonType: ButtonType.primary,
                                                onPressed: () async {
                                                  setState(() {
                                                    shownFloating = false;
                                                    showPlayerEdit = true;
                                                  });
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    playersInATeamModel!
                                                .playersInATeamModelData!
                                                .players!
                                                .length ==
                                            0
                                        ? EmptyResponseWidget(
                                            msg:
                                                "Added players will appear here",
                                            iconData: Iconsax.menu_board5)
                                        : Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            child: Column(
                                              children: [
                                                showingFilter
                                                    ? Column(
                                                        children: [
                                                          SelectPillsWidget(
                                                            pills: pills,
                                                            onSelect: (v) {
                                                              changePill(v);
                                                            },
                                                            horizontal: true,
                                                          ),
                                                          SizedBox(height: 20),
                                                        ],
                                                      )
                                                    : Container(),
                                                GridView.count(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  crossAxisCount: 2,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4, bottom: 80),
                                                  childAspectRatio: 8.0 / 9.0,
                                                  children: List.generate(
                                                      playersInATeamModelFiltered!
                                                          .length, (index) {
                                                    return PlayerGridItem(
                                                        players:
                                                            playersInATeamModelFiltered!
                                                                .elementAt(
                                                                    index),
                                                        onTap: () async {
                                                          await serviceLocator
                                                              .get<
                                                                  NavigationService>()
                                                              .toWithPameter(
                                                                  routeName:
                                                                      RouteKeys
                                                                          .routePlayerSingletonScreen,
                                                                  data: {
                                                                "playerId":
                                                                    playersInATeamModelFiltered!
                                                                        .elementAt(
                                                                            index)
                                                                        .id,
                                                                "teamID":
                                                                    teamData!
                                                                        .id,
                                                                "clubId":
                                                                    playersInATeamModelFiltered!
                                                                        .elementAt(
                                                                            index)
                                                                        .clubId,
                                                                "playerListResponseModelData":
                                                                    playersInATeamModelFiltered!
                                                                        .elementAt(
                                                                            index),
                                                              }).then(
                                                                  (value) => {
                                                                        _getData(),
                                                                      });
                                                        });
                                                  }),
                                                )
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                                child: Container(
                                    color: AppColors.sonaWhite,
                                    child: Column(children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        margin: EdgeInsets.only(
                                            top: 20, bottom: 20),
                                        child: TextField(
                                          controller: searchController,
                                          onChanged: (value) {
                                            searchNowStaff(value);
                                          },
                                          style: AppStyle.text2,
                                          decoration: InputDecoration(
                                            fillColor: AppColors.sonaGrey6,
                                            isDense: true,
                                            filled: true,
                                            prefixIcon: Icon(
                                              Boxicons.bx_search,
                                              color: AppColors.sonaGrey3,
                                              size: 30,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppConstants
                                                            .normalRadius),
                                                borderSide: BorderSide(
                                                    color:
                                                        AppColors.sonaGrey6)),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 15.h,
                                                    horizontal: 12.w),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            hintText: "Search here",
                                            hintStyle: AppStyle.text2,
                                          ),
                                        ),
                                      ),
                                      staffInATeamModel!.staffInATeamModelData!
                                                  .staff!.length ==
                                              0
                                          ? EmptyResponseWidget(
                                              msg:
                                                  "Added staff will appear here",
                                              iconData: Iconsax.menu_board5)
                                          : Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: GridView.count(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                crossAxisCount: 2,
                                                padding: const EdgeInsets.only(
                                                    top: 4, bottom: 80),
                                                childAspectRatio: 8.0 / 9.0,
                                                children: List.generate(
                                                    staffInATeamModelFiltered!
                                                        .length, (index) {
                                                  return StaffGridItem(
                                                      staffInATeamModelData:
                                                          staffInATeamModelFiltered!
                                                              .elementAt(index),
                                                      teams: teamData,
                                                      onTap: () {
                                                        contextStaffId =
                                                            staffInATeamModelFiltered!
                                                                .elementAt(
                                                                    index)
                                                                .id;
                                                        contextStaff =
                                                            staffInATeamModelFiltered!
                                                                .elementAt(
                                                                    index);
                                                        setState(() {
                                                          showStaffEdit = true;
                                                        });
                                                      });
                                                }),
                                              ))
                                    ]))),
                          ],
                        )),
                      ],
                    ),
                  )),
        Positioned(
            child: showPlayerSuccess
                ? PopUpPageScreen(data: {
                    "title": "new_player_created".tr(),
                    "subTitle": "new_player_created_desc".tr(),
                    "route": null,
                    "routeType": "callback",
                    "callback": () {
                      setState(() {
                        showPlayerSuccess = false;
                        shownFloating = true;
                      });
                      _getData();
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
                                teamId: widget.data!["teamID"]!,
                                onPlayerCreated: () {
                                  setState(() {
                                    showPlayerSuccess = true;
                                  });
                                },
                              )).then((value) {
                            _getData();
                          });
                        },
                        "buttonText": "Create new player".tr(),
                        "buttonType": ButtonType.primary
                      },
                      {
                        "onPressed": () {
                          print("was herere---------------");
                          setState(() {
                            showPlayerChoices = false;
                          });
                          print("was herere---------------");
                          bottomSheet(
                              context,
                              AddPlayerFlowScreen(
                                teamId: widget.data!["teamID"]!,
                                clubId: widget.data!["clubId"]!,
                                onPlayersAdded: (List<Players> players) {
                                  setState(() {
                                    showPlayerChoices = false;
                                    isAskingPlayerstoAdd = true;
                                    listOfPlayers = players;
                                  });
                                },
                              )).then((value) {
                            _getData();
                          });
                        },
                        "buttonText": "Add existing player".tr(),
                        "buttonType": ButtonType.secondary
                      },
                    ]
                  }, context, () {
                    setState(() {
                      showPlayerChoices = false;
                      shownFloating = true;
                    });
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
                    "no": () {
                      setState(() {
                        shownFloating = true;
                      });
                    }
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
                    "no": () {
                      setState(() {
                        shownFloating = true;
                      });
                    }
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
                                teamId: widget.data!["teamID"]!,
                                onPlayerCreated: () {
                                  setState(() {
                                    showStaffSuccess = true;
                                  });
                                  // TODO: show success mahev
                                },
                              )).then((value) {
                            _getData();
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
                                    teamId: widget.data!["teamID"]!,
                                    clubId: widget.data!["clubId"]!,
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
                                _getData();
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
            child: playerRemoved
                ? PopUpPageScreen(data: {
                    "title": "Team Removed".tr(),
                    "subTitle": "Team has been removed successfully!".tr(),
                    "routeType": "callback",
                    "route": null,
                    "buttonText": "okay_thank_you".tr(),
                    "callback": () {
                      _getData();
                      setState(() {
                        playerRemoved = false;
                      });
                    }
                  })
                : Container()),
        Positioned(
            child: staffRemoved
                ? PopUpPageScreen(data: {
                    "title": "Staff Removed".tr(),
                    "subTitle": "Staff has been removed successfully!".tr(),
                    "routeType": "callback",
                    "route": null,
                    "buttonText": "okay_thank_you".tr(),
                    "callback": () {
                      _getData();
                      setState(() {
                        staffRemoved = false;
                      });
                    }
                  })
                : Container()),
        Positioned(
            child: showPlayerEdit
                ? PlayerOnTapSheet({
                    "buttons": [
                      {
                        "onPressed": () {
                          setState(() {
                            showPlayerEdit = false;
                            shownFloating = true;
                          });
                          bottomSheet(
                              context,
                              EditTeamFlowScreen(
                                data: {
                                  "teamID": teamData!.teamName != null
                                      ? teamData!.id!
                                      : "",
                                  "teamName": teamData != null
                                      ? teamData!.teamName!
                                      : "",
                                  "abbreviation":
                                      teamData!.abbreviation != null &&
                                              teamData!.abbreviation!.isNotEmpty
                                          ? teamData!.abbreviation!
                                          : "",
                                  "categoryId": teamData!.categoryId != null
                                      ? teamData!.categoryId!
                                      : "",
                                  "location": teamData!.location != null
                                      ? teamData!.location!
                                      : "",
                                  "photo": teamData!.photo != null
                                      ? teamData!.photo!
                                      : "",
                                  "clubId": teamData!.clubId != null
                                      ? teamData!.clubId!
                                      : "",
                                },
                              )).then((value) => {
                                _getData(),
                              });
                        },
                        "buttonText": "Edit Team".tr(),
                        "buttonType": ButtonType.primary
                      },
                      userResultData!.user!.role!.toLowerCase() ==
                              UserType.owner.type
                          ? {
                              "onPressed": () => setState(() {
                                    setState(() {
                                      showPlayerEdit = false;
                                      showPlayerRemoveSure = true;
                                    });
                                  }),
                              "buttonText": "Delete Team".tr(),
                              "buttonType": ButtonType.deleteButton
                            }
                          : null,
                    ]
                  }, context, () {
                    setState(() {
                      showPlayerEdit = false;
                      shownFloating = true;
                    });
                  })
                : Container()),
        Positioned(
            child: showStaffEdit
                ? PlayerOnTapSheet({
                    "buttons": [
                      {
                        "onPressed": () {
                          setState(() {
                            showStaffEdit = false;
                          });
                          bottomSheet(
                                  context,
                                  AddEditStaffScreen(
                                      type: "edit",
                                      playerID: contextStaffId,
                                      staff: contextStaff,
                                      team: teamData))
                              .then((value) {
                            serviceLocator<CommonCubit>()
                                .getStaffInATeamList(widget.data!["teamName"]!);
                          });
                        },
                        "buttonText": "Edit Staff".tr(),
                        "buttonType": ButtonType.primary
                      },
                      {
                        "onPressed": () => setState(() {
                              setState(() {
                                showStaffEdit = false;
                              });
                            }),
                        "buttonText": "Share Staff".tr(),
                        "buttonType": ButtonType.secondary
                      },
                      {
                        "onPressed": () => setState(() {
                              setState(() {
                                showStaffEdit = false;
                                showStaffRemoveSure = true;
                              });
                            }),
                        "buttonText": "Remove Staff".tr(),
                        "buttonType": ButtonType.deleteButton
                      },
                    ]
                  }, context, () {
                    setState(() {
                      showStaffEdit = false;
                    });
                  })
                : Container()),
        Positioned(
            child: showPlayerRemoveSure
                ? AddPlayerChoices({
                    "title": "Delete".tr(),
                    "subTitle":
                        "Are you sure you want to delete this team permanently?"
                            .tr(),
                    "buttons": [
                      {
                        "onPressed": () {
                          setState(() {
                            showPlayerRemoveSure = false;
                            shownFloating = true;
                          });
                          deleteTeam(contextPlayerId);
                          // TODO: remove player
                        },
                        "buttonText": "Delete".tr(),
                        "buttonType": ButtonType.primary
                      },
                      {
                        "onPressed": () => setState(() {
                              setState(() {
                                showPlayerRemoveSure = false;
                                shownFloating = true;
                              });
                            }),
                        "buttonText": "Cancel".tr(),
                        "buttonType": ButtonType.secondary
                      }
                    ]
                  }, context, () {
                    setState(() {
                      showPlayerRemoveSure = false;
                      shownFloating = true;
                    });
                  })
                : Container()),
        Positioned(
            child: showStaffRemoveSure
                ? AddPlayerChoices({
                    "title": "Remove Staff".tr(),
                    "subTitle":
                        "Are you sure you want to remove this staff from this team? This won't delete staff from the club"
                            .tr(),
                    "buttons": [
                      {
                        "onPressed": () {
                          setState(() {
                            showStaffRemoveSure = false;
                          });
                          deleteStaff(contextStaffId, contextStaff!);
                          // TODO: remove player
                        },
                        "buttonText": "Remove".tr(),
                        "buttonType": ButtonType.primary
                      },
                      {
                        "onPressed": () => setState(() {
                              setState(() {
                                showStaffRemoveSure = false;
                              });
                            }),
                        "buttonText": "Cancel".tr(),
                        "buttonType": ButtonType.secondary
                      }
                    ]
                  }, context, () {
                    setState(() {
                      showStaffRemoveSure = false;
                    });
                  })
                : Container()),
      ]),
      floatingActionButton: shownFloating
          ? FloatingActionButton.extended(
              onPressed: () {
                if (_selectedIndex == 0) {
                  setState(() {
                    showPlayerChoices = true;
                    shownFloating = false;
                  });
                  // bottomSheet(
                  //     context,
                  //     CreatePlayerFlowScreen(
                  //       teamId: widget.data!["teamID"]!,
                  //       onPlayerCreated: () {
                  //         setState(() {
                  //           showPlayerSuccess = true;
                  //         });
                  //       },
                  //     )).then((value) {
                  //   _getData();
                  // });
                } else if (_selectedIndex == 1) {
                  setState(() {
                    showStaffChoices = true;
                    // shownFloating = false;
                  });
                  // bottomSheet(
                  //     context,
                  //     CreateStaffFlowScreen(
                  //       teamId: widget.data!["teamID"]!,
                  //       onPlayerCreated: () {
                  //         setState(() {
                  //           showStaffSuccess = true;
                  //         });
                  //       },
                  //     )).then((value) {
                  //   _getData();
                  // });
                }
              },
              icon: Icon(_selectedIndex == 0
                  ? Iconsax.note_favorite
                  : _selectedIndex == 1
                      ? Iconsax.note_favorite
                      : Iconsax.note_favorite),
              backgroundColor: AppColors.sonaBlack2,
              heroTag: _selectedIndex == 0 ? "cplayers" : "cstaff",
              label: Text(
                  _selectedIndex == 0 ? "Add player".tr() : "Add staff".tr(),
                  style: AppStyle.text2.copyWith(color: Colors.white)),
            )
          : Container(),
      bottomSheet: Padding(padding: EdgeInsets.only(bottom: 50.h)),
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
          .add({"player_id": player.id, "team_id": widget.data!["teamID"]!});
    }

    await serviceLocator<CommonCubit>().addPlayerToTeamMultiple(request);
    context.loaderOverlay.hide();
    setState(() {
      isLoading = false;
    });
    _getData();
  }

  Future<void> deleteTeam(String? contextId) async {
    // setState(() {
    //   isLoading = true;
    // });
    // context.loaderOverlay.show();

    bool doneUpdate = await ClubManagementController()
        .doDeleteTeam(context, widget.data!["teamID"]!);
    context.loaderOverlay.hide();
    setState(() {
      isLoading = false;
      playerRemoved = true;
    });
    if (doneUpdate) {
      showToast("Team removed successfully".tr(), "success");
      // go back
      Navigator.pop(context);
    } else {
      showToast("Something went wrong".tr(), "error");
    }
  }

  Future<void> deleteStaff(String? contextId, Staff contextStaff) async {
    setState(() {
      isLoading = true;
    });
    context.loaderOverlay.show();

    await serviceLocator<CommonCubit>()
        .removeStaff(contextId, widget.data!["teamID"]!, contextStaff.role!);
    context.loaderOverlay.hide();
    setState(() {
      isLoading = false;
      staffRemoved = true;
    });
    _getData();
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
      request["staff"]!.add({
        "staff_id": player.id,
        "team_id": widget.data!["teamID"]!,
        "role": player.role
      });
    }

    await serviceLocator<CommonCubit>().addStaffToTeamMultiple(request);
    context.loaderOverlay.hide();
    setState(() {
      isLoading = false;
    });
    _getData();
  }

  Widget countWidget(String title, String count) {
    return Column(
      children: [
        Text(title,
            style: AppStyle.text1.copyWith(
                color: AppColors.sonaGrey3, fontWeight: FontWeight.w400)),
        SizedBox(height: 10.h),
        Text(count,
            style: AppStyle.text3.copyWith(
                color: AppColors.sonaBlack2, fontWeight: FontWeight.w400)),
      ],
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
