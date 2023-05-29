import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/controller/club_mgt_controller.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/enums/user_type.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart' as user;
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/widgets/addplayers_screen.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/core/widgets/create_team_step_2_bottom_sheet.dart';
import 'package:sonalysis/core/widgets/player_on_tap_sheet.dart';
import 'package:sonalysis/core/widgets/popup_screen.dart';
import 'package:sonalysis/features/common/models/SinglePlayerModel.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/players_club_management/add_edit_player/addEditPlayer.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/teams_club_management/create_team_flow/addPlayerFlow.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/teams_club_management/create_team_flow/addStaffFlow.dart';
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

class PlayerSingletonScreen extends StatefulWidget {
  const PlayerSingletonScreen({Key? key, this.data}) : super(key: key);

  final Map? data;

  @override
  _PlayerSingletonScreenState createState() => _PlayerSingletonScreenState();
}

class _PlayerSingletonScreenState extends State<PlayerSingletonScreen>
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

  bool showStaffAddedSuccess = false;
  bool showPlayerAddedSuccess = false;
  bool wasAdding = false;
  bool isAskingPlayerstoAdd = false;
  bool isAskingStafftoAdd = false;
  bool shownFloating = true;
  List<Players> listOfPlayers = [];
  List<Staff> listOfStaff = [];
  bool showPlayerEdit = false;
  bool showStaffEdit = false;
  bool showPlayerRemoveSure = false;
  bool showPlayerDeleteSure = false;
  bool playerRemoved = false;
  String? contextPlayerId = "";
  Players? contextPlayer;
  Player? singlePlayer;
  Analysis? analysis;
  Staff? contextStaff;
  String? contextStaffId = "";
  bool showStaffRemoveSure = false;
  bool staffRemoved = false;
  user.UserResultData? userResultData;

  @override
  void initState() {
    _getData();
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
    context.loaderOverlay.show();
    //getPlayerInATeamList
    await serviceLocator<CommonCubit>()
        .getSinglePlayerProfile(widget.data!["playerId"]!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        BlocListener(
          bloc: serviceLocator.get<CommonCubit>(),
          listener: (_, state) {
            if (state is GetSinglePlayerProfileInitial) {
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
                  context: context, message: state.message);
            }

            if (state is GetSinglePlayerProfileSuccess) {
              context.loaderOverlay.hide();

              setState(() {
                isLoading = false;
                shownFloating = true;
                singlePlayer =
                    serviceLocator.get<SinglePlayerModel>().data!.player!;
                analysis =
                    serviceLocator.get<SinglePlayerModel>().data!.analysis!;
              });
            }
          },
          child: isLoading || singlePlayer == null
              ? Container(
                  child: Text(""),
                )
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
                                Navigator.of(context).pop();
                                // serviceLocator.get<NavigationService>().pop();
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
                              "Player stats".tr(),
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
                          height: 40,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                  singlePlayer!.photo != null &&
                                          singlePlayer!.photo != "null"
                                      ? singlePlayer!.photo!
                                      : AppConstants.defaultProfilePictures,
                                  fit: BoxFit.cover,
                                  repeat: ImageRepeat.noRepeat,
                                  width: 40))),
                      SizedBox(height: 10.h),
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                              child: Text(
                            singlePlayer!.firstName! +
                                " " +
                                singlePlayer!.lastName!,
                            style: AppStyle.text2.copyWith(
                                color: AppColors.sonaBlack2,
                                fontWeight: FontWeight.w400),
                          ))),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            singlePlayer!.jerseyNumber != null
                                ? singlePlayer!.jerseyNumber!
                                : "N/A",
                            style: AppStyle.text1.copyWith(
                                color: AppColors.sonaGrey2,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: AppColors.sonaWhite,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.44,
                                        child: AppButton(
                                            buttonText: "Send message".tr(),
                                            onPressed: () async {
                                              setState(() {});
                                            })),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.44,
                                      child: AppButton(
                                          buttonText: "More options".tr(),
                                          buttonType: ButtonType.secondary,
                                          onPressed: () async {
                                            setState(() {
                                              contextPlayerId =
                                                  singlePlayer!.id!;
                                              showPlayerEdit = true;
                                            });
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "Analyzed Videos".tr(),
                                  style: AppStyle.text3.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.sonaBlack2),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
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
                                        borderRadius: BorderRadius.circular(
                                            AppConstants.normalRadius),
                                        borderSide: BorderSide(
                                            color: AppColors.sonaGrey6)),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.h, horizontal: 12.w),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
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
                              SizedBox(height: 20.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                  child: Text(
                                    "No vidoes yet".tr(),
                                    style: AppStyle.text2.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.sonaGrey3),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                            ]),
                      )
                    ],
                  ),
                ),
        ),
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
                          //   //_onRefresh();
                          // });
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
                              )).then((value) {});
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
                ? AddPlayersScreen(data: {
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
                          // bottomSheet(
                          //     context,
                          //     CreateStaffFlowScreen(
                          //       teamId: widget.data!["teamID"]!,
                          //       onPlayerCreated: () {
                          //         setState(() {
                          //           showStaffSuccess = true;
                          //         });
                          //         // TODO: show success mahev
                          //       },
                          //     )).then((value) {
                          //   //_onRefresh();
                          // });
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
                                    onPlayersAdded: (List<Staff> players) {
                                      setState(() {
                                        showStaffChoices = false;
                                        isAskingStafftoAdd = true;
                                        listOfStaff = players;
                                      });
                                    },
                                  )).then((value) {
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
                    "title": "Player Removed".tr(),
                    "subTitle": "Player has been removed successfully!".tr(),
                    "routeType": "callback",
                    "route": null,
                    "buttonText": "okay_thank_you".tr(),
                    "callback": () {
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
                          print(singlePlayer!.toJson().toString());
                          setState(() {
                            showPlayerEdit = false;
                          });
                          print(singlePlayer!.teamNameNew);
                          print("editplayerdata 0");
                          bottomSheet(
                                  context,
                                  AddEditPlayerScreen(
                                      type: "edit",
                                      playerID: widget.data!["playerId"],
                                      clubId: widget.data!["clubId"]!,
                                      player: singlePlayer))
                              .then((value) => {_getData()});
                        },
                        "buttonText": "Edit player".tr(),
                        "buttonType": ButtonType.primary
                      },
                      {
                        "onPressed": () => setState(() {
                              setState(() {
                                showPlayerEdit = false;
                              });
                            }),
                        "buttonText": "Share player".tr(),
                        "buttonType": ButtonType.secondary
                      },
                      if (widget.data!["teamID"] != "NULL")
                        {
                          "onPressed": () => setState(() {
                                setState(() {
                                  showPlayerEdit = false;
                                  showPlayerRemoveSure = true;
                                });
                              }),
                          "buttonText": "Remove player from team".tr(),
                          "buttonType": ButtonType.deleteButton
                        },
                      userResultData!.user!.role!.toLowerCase() ==
                              UserType.owner.type
                          ? {
                              "onPressed": () => setState(() {
                                    setState(() {
                                      showPlayerEdit = false;
                                      showPlayerDeleteSure = true;
                                    });
                                  }),
                              "buttonText": "Delete player".tr(),
                              "buttonType": ButtonType.deleteButton
                            }
                          : null,
                    ]
                  }, context, () {
                    setState(() {
                      showPlayerEdit = false;
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
                          // bottomSheet(
                          //     context,
                          //     CreateStaffFlowScreen(
                          //       teamId: widget.data!["teamID"]!,
                          //       onPlayerCreated: () {
                          //         setState(() {
                          //           showStaffSuccess = true;
                          //         });
                          //         // TODO: show success mahev
                          //       },
                          //     )).then((value) {
                          //   //_onRefresh();
                          // });
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
                    "title": "Remove Player".tr(),
                    "subTitle":
                        "Are you sure you want to remove this player from team? This won't delete the player from club"
                            .tr(),
                    "buttons": [
                      {
                        "onPressed": () {
                          setState(() {
                            showPlayerRemoveSure = false;
                          });
                          removePlayer(contextPlayerId);
                          // TODO: remove player
                        },
                        "buttonText": "Remove".tr(),
                        "buttonType": ButtonType.primary
                      },
                      {
                        "onPressed": () => setState(() {
                              setState(() {
                                showPlayerRemoveSure = false;
                              });
                            }),
                        "buttonText": "Cancel".tr(),
                        "buttonType": ButtonType.secondary
                      }
                    ]
                  }, context, () {
                    setState(() {
                      showPlayerRemoveSure = false;
                    });
                  })
                : Container()),
        Positioned(
            child: showPlayerDeleteSure
                ? AddPlayerChoices({
                    "title": "Delete Player".tr(),
                    "subTitle":
                        "Are you sure you want to delete this player from club permanently? This will also remove this player from all teams"
                            .tr(),
                    "buttons": [
                      {
                        "onPressed": () {
                          setState(() {
                            showPlayerRemoveSure = false;
                          });
                          deletePlayer(contextPlayerId);
                          // TODO: remove player
                        },
                        "buttonText": "Delete".tr(),
                        "buttonType": ButtonType.primary
                      },
                      {
                        "onPressed": () => setState(() {
                              setState(() {
                                showPlayerRemoveSure = false;
                              });
                            }),
                        "buttonText": "Cancel".tr(),
                        "buttonType": ButtonType.secondary
                      }
                    ]
                  }, context, () {
                    setState(() {
                      showPlayerRemoveSure = false;
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
                          deleteStaff(contextStaffId);
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
      // bottomSheet: Padding(padding: EdgeInsets.only(bottom: 50.h)),
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

  Future<void> deletePlayer(String? contextId) async {
    setState(() {
      isLoading = true;
    });
    context.loaderOverlay.show();

    bool doneUpdate =
        await ClubManagementController().doDeletePlayer(context, contextId!);
    context.loaderOverlay.hide();
    setState(() {
      isLoading = false;
      playerRemoved = true;
    });
    if (doneUpdate) {
      showToast("Player removed successfully".tr(), "success");
      // go back
      Navigator.pop(context);
    } else {
      showToast("Something went wrong".tr(), "error");
    }
  }

  Future<void> removePlayer(String? contextId) async {
    setState(() {
      isLoading = true;
    });
    context.loaderOverlay.show();

    var request = {"players": []};
    request["players"]!.add({
      "player_id": contextId,
      "team_id": widget.data!["teamID"]!,
    });

    bool doneUpdate =
        await ClubManagementController().doRemovePlayer(context, request);
    context.loaderOverlay.hide();
    setState(() {
      isLoading = false;
      playerRemoved = true;
    });
    if (doneUpdate) {
      showToast("Player removed successfully".tr(), "success");
      // go back
      Navigator.pop(context);
    } else {
      showToast("Something went wrong".tr(), "error");
    }
  }

  Future<void> deleteStaff(String? contextId) async {
    setState(() {
      isLoading = true;
    });
    context.loaderOverlay.show();

    await serviceLocator<CommonCubit>()
        .removeStaff(contextId, widget.data!["teamID"]!, "coach");
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
      request["players"]!.add({
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
