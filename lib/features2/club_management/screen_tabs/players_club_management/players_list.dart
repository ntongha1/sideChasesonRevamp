import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/helpers.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/styles.dart';
import 'package:sonalysis/core/widgets/create_team_step_2_bottom_sheet.dart';
import 'package:sonalysis/core/widgets/player_on_tap_sheet.dart';
import 'package:sonalysis/core/widgets/popup_screen.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/teams_club_management/create_team_flow/createStaffFlow.dart';
import 'package:sonalysis/widgets/player_grid_item.dart';

import '../../../../../core/datasource/key.dart';
import '../../../../../core/datasource/local_storage.dart';
import '../../../../../core/models/response/PlayerListResponseModel.dart';
import '../../../../../core/models/response/TeamsListResponseModel.dart';
import '../../../../../core/models/response/UserResultModel.dart';
import '../../../../../core/startup/app_startup.dart';
import '../../../../../core/utils/response_message.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/widgets/empty_response.dart';
import '../../../../features/common/cubit/common_cubit.dart';

class PlayersList extends StatefulWidget {
  final TeamsListResponseModelData? teamsListResponseModelItem;
  final bool isSingleton;
  const PlayersList(
      {Key? key, this.teamsListResponseModelItem, required this.isSingleton})
      : super(key: key);

  @override
  State<PlayersList> createState() => _PlayersListState();
}

class _PlayersListState extends State<PlayersList> {
  bool isLoading = true;
  PlayerListResponseModel? playerListResponseModel;
  List<PlayerListResponseModelData?>? playerListFiltered = [];
  //List<String?> searchableList = [];
  late UserResultData userResultData;
  String? myId, myClubId;
  bool noData = false;
  final TextEditingController searchController = TextEditingController();

  bool showPlayerEdit = false;
  bool showStaffEdit = false;
  bool showPlayerRemoveSure = false;
  bool playerRemoved = false;
  String? contextPlayerId = "";
  String? contextStaffId = "";
  bool showStaffRemoveSure = false;
  bool staffRemoved = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() async {
    _getData();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    context.loaderOverlay.show();
    _getData();
    print('players state init');
    super.initState();
  }

  void _onLoading() async {
    _getData();
    _refreshController.loadComplete();
  }

  Future<void> _getData() async {
    userResultData = (await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs))!;

    if (userResultData.user!.role!.toLowerCase() == UserType.player.type) {
      //print(userResultData!.user!.players![0].id.toString());
      myId = userResultData.user!.players![0].id;
      myClubId = userResultData.user!.players![0].clubId;
    } else if (userResultData.user!.role!.toLowerCase() ==
        UserType.owner.type) {
      myId = userResultData.user!.id;
      myClubId = userResultData.user!.clubs![0].id;
    } else {
      myId = userResultData.user!.staff![0].id;
      myClubId = userResultData.user!.staff![0].clubId;
    }

    // print("Token::: "+userResultData!.user!.clubs!.length.toString());
    // print("Token2::: "+userResultData!.user!.clubs![0].id.toString());
    await serviceLocator<CommonCubit>().getPlayerList(myClubId!);
    setState(() {});
  }

  void onRefresh(v) async {
    print("refreshing step 1");
    _getData();
  }

  void searchNow(String? v) {
    List<PlayerListResponseModelData> all =
        playerListResponseModel!.playerListResponseModelData!;
    String value = "f";
    if (v == null || v == "")
      value = "";
    else
      value = v.trim().toLowerCase();
    if (v == "") {
      setState(() {
        playerListFiltered = all;
      });
      return;
    }

    List<PlayerListResponseModelData> temp = all.where((element) {
      String fname =
          element.firstName == null ? "" : element.firstName!.toLowerCase();
      String lname =
          element.lastName == null ? "" : element.lastName!.toLowerCase();
      String jersy = element.jerseyNumber == null
          ? ""
          : element.jerseyNumber!.toLowerCase();
      return fname.contains(value) ||
          lname.contains(value) ||
          jersy.contains(value);
    }).toList();
    setState(() {
      playerListFiltered = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSingleton) {
      // not from singleton
      return Stack(children: [
        SingleChildScrollView(
          child: BlocListener(
            bloc: serviceLocator.get<CommonCubit>(),
            listener: (_, state) {
              if (state is PlayerListLoading) {
                setState(() {
                  isLoading = true;
                });
              }

              if (state is PlayerListError) {
                setState(() {
                  isLoading = false;
                  noData = true;
                });
                context.loaderOverlay.hide();
                ResponseMessage.showErrorSnack(
                    context: context, message: state.message);
              }

              if (state is PlayerListSuccess) {
                context.loaderOverlay.hide();
                List<PlayerListResponseModelData> pp = serviceLocator
                            .get<PlayerListResponseModel>()
                            .playerListResponseModelData !=
                        null
                    ? serviceLocator
                        .get<PlayerListResponseModel>()
                        .playerListResponseModelData!
                    : [];
                setState(() {
                  isLoading = false;
                  playerListResponseModel =
                      serviceLocator.get<PlayerListResponseModel>();
                  playerListFiltered = pp;
                });
              }
            },
            child: isLoading
                ? Container()
                : noData
                    ? Container(
                        child: EmptyResponseWidget(
                            msg: "Added players will appear here",
                            iconData: Iconsax.menu_board5),
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: playerListResponseModel!
                                .playerListResponseModelData!.isEmpty
                            ? EmptyResponseWidget(
                                msg: "Added players will appear here",
                                iconData: Iconsax.menu_board5)
                            : Column(
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
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.normalRadius),
                                            borderSide: BorderSide(
                                                color: AppColors.sonaGrey6)),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 12),
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
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: GridView.count(
                                      shrinkWrap: true,
                                      crossAxisCount: 2,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.only(
                                          top: 4, bottom: 80),
                                      //childAspectRatio: 8.0 / 9.0,
                                      children: List.generate(
                                          playerListFiltered!.length, (index) {
                                        return PlayerGridItem(
                                            playerListResponseModelData:
                                                playerListFiltered!
                                                    .elementAt(index),
                                            onTap: () {
                                              serviceLocator
                                                  .get<NavigationService>()
                                                  .toWithPameter(
                                                      routeName: RouteKeys
                                                          .routePlayerSingletonScreen,
                                                      data: {
                                                    "playerId":
                                                        playerListFiltered!
                                                            .elementAt(index)!
                                                            .id,
                                                    "clubId":
                                                        playerListFiltered!
                                                            .elementAt(index)!
                                                            .clubId,
                                                    "teamID": "NULL",
                                                    "playerListResponseModelData":
                                                        playerListFiltered!
                                                            .elementAt(index),
                                                  }).then((value) => {
                                                        onRefresh(false),
                                                      });
                                            });
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                      ),
          ),
        ),
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
                          setState(() {
                            showPlayerEdit = false;
                          });
                        },
                        "buttonText": "Edit Player".tr(),
                        "buttonType": ButtonType.primary
                      },
                      {
                        "onPressed": () => setState(() {
                              setState(() {
                                showPlayerEdit = false;
                              });
                            }),
                        "buttonText": "Share Player".tr(),
                        "buttonType": ButtonType.secondary
                      },
                      {
                        "onPressed": () => setState(() {
                              setState(() {
                                showPlayerEdit = false;
                                showPlayerRemoveSure = true;
                              });
                              // bottomSheet(
                              //     context,
                              //     AddStaffFlowScreen(
                              //       teamId: widget.data!["teamID"]!,
                              //       clubId: widget.data!["clubId"]!,
                              //       onPlayersAdded: (List<Staff> players) {
                              //         setState(() {
                              //           showStaffChoices = false;
                              //           isAskingStafftoAdd = true;
                              //           listOfStaff = players;
                              //         });
                              //       },
                              //     )).then((value) {
                              //   //_onRefresh();
                              // });
                            }),
                        "buttonText": "Remove Player".tr(),
                        "buttonType": ButtonType.deleteButton
                      },
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
                        "Are you sure you want to remove this player from this team? This won't delete player from the club"
                            .tr(),
                    "buttons": [
                      {
                        "onPressed": () {
                          setState(() {
                            showPlayerRemoveSure = false;
                          });
                          deletePlayer(contextPlayerId!);
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
                          deleteStaff(contextStaffId!);
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
      ]);
    } else {
      if (widget.teamsListResponseModelItem == null)
        return EmptyResponseWidget(
            msg: "Added players will appear here",
            iconData: Iconsax.menu_board5);
      else
        return SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ));
    }
  }

  Future<void> deletePlayer(String contextId) async {
    setState(() {
      isLoading = true;
    });
    context.loaderOverlay.show();

    await serviceLocator<CommonCubit>().deletePlayer(contextId);
    context.loaderOverlay.hide();
    setState(() {
      isLoading = false;
      playerRemoved = true;
    });
    _getData();
  }

  Future<void> deleteStaff(String contextId) async {
    setState(() {
      isLoading = true;
    });
    context.loaderOverlay.show();

    await serviceLocator<CommonCubit>().deleteStaff(contextId);
    context.loaderOverlay.hide();
    setState(() {
      isLoading = false;
      staffRemoved = true;
    });
    _getData();
  }
}
