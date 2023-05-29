import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/models/League.dart';
import 'package:sonalysis/core/models/response/TeamsListResponseModel.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/styles.dart';
import 'package:sonalysis/core/widgets/app_gradient_text.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/features/common/dashboard/widgets/selectPlayersWidget.dart';
import 'package:sonalysis/features/common/dashboard/widgets/selectTeamsWidget.dart';
import 'package:sonalysis/features/common/models/PlayersInATeamModel.dart';
import 'package:sonalysis/features2/comparison/widgets/MatchSelector.dart';
import 'package:sonalysis/features2/comparison/widgets/PlayerSelectorGlobal.dart';
import 'package:sonalysis/widgets/player_grid_item.dart';
import 'package:sonalysis/widgets/team_grid_item.dart';

import '../../../../core/datasource/key.dart';
import '../../../../core/datasource/local_storage.dart';
import '../../../../core/models/response/UserResultModel.dart'
    as UserResultModel;
import '../../../../core/models/response/VideoListResponseModel.dart';
import '../../../../core/startup/app_startup.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/images.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/app_dropdown_modal.dart';
import '../../../../core/widgets/button.dart';
import '../../cubit/common_cubit.dart';
import '../../models/AllPlayerInUploadedVideoModel.dart' as videoModel;
import '../../models/ComparePlayersModel.dart';
import '../widgets/allPlayersModalWidget.dart';

class PvpGlobal extends StatefulWidget {
  PvpGlobal({Key? key}) : super(key: key);

  @override
  State<PvpGlobal> createState() => _PvpGlobalState();
}

class _PvpGlobalState extends State<PvpGlobal> {
  UserResultModel.UserResultData? userResultData;
  bool isLoading = false,
      showPlayerSelection = false,
      playerASelected = false,
      playerBSelected = false,
      submited = false;
  VideoListResponseModel? videoListResponseModel;
  TeamsListResponseModelData? _selectedVideo;
  String selectedTeamTitle = "";
  String selectedPlayersTitle = "";
  videoModel.AllPlayerInUploadedVideoModel? allPlayerInUploadedVideoModel;
  videoModel.Players? playerASelectedDetails, playerBSelectedDetails;
  TextEditingController playerSelectionController = TextEditingController();
  TextEditingController teamSelectionController = TextEditingController();
  ComparePlayersModel? comparePlayersModel;
  TeamsListResponseModel? teamList;
  var homeMatch = null;
  var awayMatch = null;
  var homePlayer = null;
  final Client _httpClient = Client();

  List<Leagues> leagues = [];

  var awayPlayer = null;
  bool playersLoading = false;
  PlayersInATeamModel? playersList;
  List<Players> playersSelected = [];
  List<Players> listOfPlayers = [];
  List<TeamsListResponseModelData> listOfteams = [];
  String clubId = "";
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  bool loadingLegs = true;
  List stats = [
    {
      "title": "Goals".tr(),
      "value_left": 0,
      "value_right": 0,
    },
    {
      "title": "Assists".tr(),
      "value_left": 0,
      "value_right": 0,
    },
    {
      "title": "Ball Possession".tr(),
      "value_left": 0,
      "value_right": 0,
    },
    {
      "title": "Fouls".tr(),
      "value_left": 0,
      "value_right": 0,
    },
    {
      "title": "Yellow Card".tr(),
      "value_left": 0,
      "value_right": 0,
    },
    {
      "title": "Red Card".tr(),
      "value_left": 0,
      "value_right": 0,
    },
    {
      "title": "Passes".tr(),
      "value_left": 0,
      "value_right": 0,
    },
    {
      "title": "Accuracy".tr(),
      "value_left": 0,
      "value_right": 0,
    },
    {
      "title": "Penalties".tr(),
      "value_left": 0,
      "value_right": 0,
    },
  ];

  void _onRefresh() async {
    _getData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _getData();
    _refreshController.loadComplete();
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    //load all teams
    clubId = userResultData!.user!.clubs![0].id!;
    setState(() {});
    // context.loaderOverlay.show();
  }

  @override
  void initState() {
    print("leages to fetch leageus abcd");
    _getData();
    getLeagues();
    playerSelectionController.text = "";
    teamSelectionController.text = "";
    super.initState();
  }

  String getGoals(e) {
    String g = "";

    if (e['goals']['home'] != null) {
      g = e['goals']['home'].toString();
    } else {
      g = "0";
    }
    if (e['goals']['away'] != null) {
      g = g + " - " + e['goals']['away'].toString();
    } else {
      g = g + " - 0";
    }

    return g;
  }

  void doSelect(Players player) {
    if (playersSelected.contains(player)) {
      playersSelected.remove(player);
    } else {
      playersSelected.add(player);
    }
    setState(() {});
  }

  void updateLeftStats(p, side) {
    var s = p["statistics"][0];
    stats[0][side] = s["goals"]["total"] != null ? s["goals"]["total"] : 0;
    stats[1][side] =
        s["goals"]["conceded"] != null ? s["goals"]["conceded"] : 0;
    stats[2][side] = s["tackles"]["total"] != null ? s["tackles"]["total"] : 0;
    stats[3][side] = s["fouls"]["total"] != null ? s["fouls"]["total"] : 0;
    stats[4][side] = s["cards"]["yellow"] != null ? s["cards"]["yellow"] : 0;
    stats[5][side] = s["cards"]["red"] != null ? s["cards"]["red"] : 0;
    stats[6][side] = s["passes"]["total"] != null ? s["passes"]["total"] : 0;
    stats[7][side] =
        s["passes"]["accuracy"] != null ? s["passes"]["accuracy"] : 0;
    stats[7][side] =
        s["penalty"]["commited"] != null ? s["penalty"]["commited"] : 0;
  }

  List<String> getIds(List<TeamsListResponseModelData> teams) {
    List<String> ids = [];
    for (var item in teams) {
      ids.add(item.teamName!);
    }
    return ids;
  }

  List<String> getIdsToCompare(List<Players> teams) {
    List<String> ids = [];
    for (var item in teams) {
      ids.add(item.id!);
    }
    return ids;
  }

  double getLeftWidth(e) {
    int leftVal = e["value_left"];
    int rightVal = e["value_right"];

    if (leftVal == 0 && rightVal == 0) {
      return 0;
    }

    if (leftVal == 0) {
      return 0;
    }

    if (rightVal == 0) {
      return 99;
    }

    var total = leftVal + rightVal;

    return double.parse(leftVal.toString()) / total * 80;
  }

  double getRightWidth(e) {
    int leftVal = e["value_left"];
    int rightVal = e["value_right"];

    if (leftVal == 0 && rightVal == 0) {
      return 0;
    }

    if (leftVal == 0) {
      return 99;
    }

    if (rightVal == 0) {
      return 0;
    }

    var total = leftVal + rightVal;

    return double.parse(rightVal.toString()) / total * 80;
  }

  getLeagues() async {
    print("leages to fetch leageus abc");
    setState(() {
      loadingLegs = true;
    });
    String url = ApiConstants.getAllLeagues;

    Map<String, String> header = {};
    header = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'X-RapidAPI-Key': ApiConstants.rapidApiToken,
    };

    Response? res = await _httpClient.get(Uri.parse(url), headers: header);
    print('leages to fetch leageus' + res.statusCode.toString());
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      print('leages:' + data['response'].toString());
      var all = data['response'];
      List<Leagues> onlylLeageus = [];

      for (var item in all) {
        onlylLeageus.add(new Leagues(
            name: item['league']['name'], id: item['league']['id']));
      }
      setState(() {
        leagues = onlylLeageus;
        loadingLegs = false;
      });
      return data['data'];
    } else {
      setState(() {
        loadingLegs = true;
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(children: [
                          GestureDetector(
                            onTap: () {
                              if (loadingLegs) {
                                showSnackBar(
                                    "Please wait, we are loading leagues",
                                    context);
                                return;
                              }
                              bottomSheet(
                                  context,
                                  MatchSelectorScreen(
                                    leagues: leagues,
                                    onMatchSelected: (e) {
                                      setState(() {
                                        homeMatch = e;
                                      });
                                    },
                                  )).then((value) {
                                setState(() {});
                              });
                            },
                            child: homeMatch == null
                                ? GradientText("Select match +",
                                    gradient: AppColors.sonalysisGradient,
                                    style: AppStyle.text2.copyWith(
                                        color: AppColors.sonaBlack2,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400))
                                : Container(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                // convert timestamp to date
                                                homeMatch["fixture"]["date"]
                                                    .split("T")[0],
                                                style: AppStyle.text0.copyWith(
                                                    color: AppColors.sonaBlack2,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              SizedBox(
                                                width: 5.h,
                                              ),
                                              Text(
                                                homeMatch["league"]["name"]
                                                            .toString()
                                                            .length >
                                                        15
                                                    ? homeMatch["league"]
                                                                ["name"]
                                                            .toString()
                                                            .substring(0, 15) +
                                                        "..."
                                                    : homeMatch["league"]
                                                        ["name"],
                                                style: AppStyle.text0.copyWith(
                                                    color: AppColors.sonaGrey3,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    // convert timestamp to date
                                                    homeMatch["teams"]["home"]
                                                                    ["name"]
                                                                .toString()
                                                                .length >
                                                            7
                                                        ? homeMatch["teams"]
                                                                        ["home"]
                                                                    ["name"]
                                                                .toString()
                                                                .substring(
                                                                    0, 7) +
                                                            "..."
                                                        : homeMatch["teams"]
                                                            ["home"]["name"],

                                                    style: AppStyle.text0
                                                        .copyWith(
                                                            color: AppColors
                                                                .sonaBlack2,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                  SizedBox(
                                                    width: 2.h,
                                                  ),
                                                  Image.network(
                                                      homeMatch["teams"]["home"]
                                                          ["logo"],
                                                      width: 10,
                                                      height: 10)
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10.h,
                                              ),
                                              Text(
                                                getGoals(homeMatch),
                                                style: AppStyle.text0.copyWith(
                                                    color: AppColors.sonaBlack2,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              SizedBox(
                                                width: 10.h,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.network(
                                                      homeMatch["teams"]["away"]
                                                          ["logo"],
                                                      width: 10,
                                                      height: 10),
                                                  SizedBox(
                                                    width: 2.h,
                                                  ),
                                                  Text(
                                                    // convert timestamp to date
                                                    homeMatch["teams"]["away"]
                                                                    ["name"]
                                                                .toString()
                                                                .length >
                                                            7
                                                        ? homeMatch["teams"]
                                                                        ["away"]
                                                                    ["name"]
                                                                .toString()
                                                                .substring(
                                                                    0, 7) +
                                                            "..."
                                                        : homeMatch["teams"]
                                                            ["away"]["name"],

                                                    style: AppStyle.text0
                                                        .copyWith(
                                                            color: AppColors
                                                                .sonaBlack2,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            child: Text("Change Match",
                                                style: AppStyle.text1.copyWith(
                                                    color: AppColors.sonaGrey2,
                                                    fontSize: 12.sp,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          )
                                        ]),
                                  ),
                          ),
                          SizedBox(height: 20.h),
                          GestureDetector(
                            onTap: () {
                              if (homeMatch == null) {
                                showSnackBar(
                                    "Please select match first", context);
                                return;
                              }

                              bottomSheet(
                                  context,
                                  PlayerSelectorGlobalScreen(
                                    match: homeMatch,
                                    onMatchSelected: (e) {
                                      setState(() {
                                        homePlayer = e;
                                        updateLeftStats(e, "value_left");
                                      });
                                    },
                                  )).then((value) {
                                setState(() {});
                              });
                            },
                            child: homePlayer == null
                                ? Column(children: [
                                    Container(
                                      child: SvgPicture.asset(
                                          'assets/svgs/adduser.svg'),
                                      width: 40,
                                      height: 40,
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      "Choose player to compare".tr(),
                                      style: AppStyle.text0.copyWith(
                                          color: AppColors.sonaBlack,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ])
                                : Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                              child: CircleAvatar(
                                                  radius: 20,
                                                  // backgroundColor: AppColors.sonaBlack,
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      homePlayer["player"]
                                                                  ["photo"] !=
                                                              null
                                                          ? homePlayer["player"]
                                                              ["photo"]
                                                          : AppConstants
                                                              .defaultProfilePictures,
                                                      fit: BoxFit.cover,
                                                      repeat:
                                                          ImageRepeat.noRepeat,
                                                      width: 40.w,
                                                      height: 40.h,
                                                    ),
                                                  ))),
                                          Positioned(
                                            child: SvgPicture.asset(
                                              'assets/svgs/changeuser2.svg',
                                              width: 20,
                                              height: 20,
                                            ),
                                            right: -2,
                                            bottom: -2,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        homePlayer["player"]["name"],
                                        style: AppStyle.text1.copyWith(
                                            color: AppColors.sonaBlack,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                          ),
                        ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(children: [
                          GestureDetector(
                            onTap: () {
                              if (loadingLegs) {
                                showSnackBar(
                                    "Please wait, we are loading leagues",
                                    context);
                                return;
                              }
                              bottomSheet(
                                  context,
                                  MatchSelectorScreen(
                                    leagues: leagues,
                                    onMatchSelected: (e) {
                                      setState(() {
                                        awayMatch = e;
                                      });
                                    },
                                  )).then((value) {
                                setState(() {});
                              });
                            },
                            child: awayMatch == null
                                ? GradientText("Select match +",
                                    gradient: AppColors.sonalysisGradient,
                                    style: AppStyle.text2.copyWith(
                                        color: AppColors.sonaBlack2,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400))
                                : Container(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                // convert timestamp to date
                                                awayMatch["fixture"]["date"]
                                                    .split("T")[0],
                                                style: AppStyle.text0.copyWith(
                                                    color: AppColors.sonaBlack2,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              SizedBox(
                                                width: 5.h,
                                              ),
                                              Text(
                                                awayMatch["league"]["name"]
                                                            .toString()
                                                            .length >
                                                        15
                                                    ? awayMatch["league"]
                                                                ["name"]
                                                            .toString()
                                                            .substring(0, 15) +
                                                        "..."
                                                    : awayMatch["league"]
                                                        ["name"],
                                                style: AppStyle.text0.copyWith(
                                                    color: AppColors.sonaGrey3,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    // convert timestamp to date
                                                    awayMatch["teams"]["home"]
                                                                    ["name"]
                                                                .toString()
                                                                .length >
                                                            7
                                                        ? awayMatch["teams"]
                                                                        ["home"]
                                                                    ["name"]
                                                                .toString()
                                                                .substring(
                                                                    0, 7) +
                                                            "..."
                                                        : awayMatch["teams"]
                                                            ["home"]["name"],

                                                    style: AppStyle.text0
                                                        .copyWith(
                                                            color: AppColors
                                                                .sonaBlack2,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                  SizedBox(
                                                    width: 2.h,
                                                  ),
                                                  Image.network(
                                                      awayMatch["teams"]["home"]
                                                          ["logo"],
                                                      width: 10,
                                                      height: 10)
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10.h,
                                              ),
                                              Text(
                                                getGoals(awayMatch),
                                                style: AppStyle.text0.copyWith(
                                                    color: AppColors.sonaBlack2,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              SizedBox(
                                                width: 10.h,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.network(
                                                      awayMatch["teams"]["away"]
                                                          ["logo"],
                                                      width: 10,
                                                      height: 10),
                                                  SizedBox(
                                                    width: 2.h,
                                                  ),
                                                  Text(
                                                    // convert timestamp to date
                                                    awayMatch["teams"]["away"]
                                                                    ["name"]
                                                                .toString()
                                                                .length >
                                                            7
                                                        ? awayMatch["teams"]
                                                                        ["away"]
                                                                    ["name"]
                                                                .toString()
                                                                .substring(
                                                                    0, 7) +
                                                            "..."
                                                        : awayMatch["teams"]
                                                            ["away"]["name"],

                                                    style: AppStyle.text0
                                                        .copyWith(
                                                            color: AppColors
                                                                .sonaBlack2,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            child: Text("Change Match",
                                                style: AppStyle.text1.copyWith(
                                                    color: AppColors.sonaGrey2,
                                                    fontSize: 12.sp,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          )
                                        ]),
                                  ),
                          ),
                          SizedBox(height: 20.h),
                          GestureDetector(
                            onTap: () {
                              if (awayMatch == null) {
                                showSnackBar(
                                    "Please select match first", context);
                                return;
                              }

                              bottomSheet(
                                  context,
                                  PlayerSelectorGlobalScreen(
                                    match: awayMatch,
                                    onMatchSelected: (e) {
                                      setState(() {
                                        awayPlayer = e;
                                        updateLeftStats(e, "value_right");
                                      });
                                    },
                                  )).then((value) {
                                setState(() {});
                              });
                            },
                            child: awayPlayer == null
                                ? Column(
                                    children: [
                                      Container(
                                        child: SvgPicture.asset(
                                            'assets/svgs/adduser.svg'),
                                        width: 40,
                                        height: 40,
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        "Choose player to compare".tr(),
                                        style: AppStyle.text0.copyWith(
                                            color: AppColors.sonaBlack,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                              child: CircleAvatar(
                                                  radius: 20,
                                                  // backgroundColor: AppColors.sonaBlack,
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      awayPlayer["player"]
                                                                  ["photo"] !=
                                                              null
                                                          ? awayPlayer["player"]
                                                              ["photo"]
                                                          : AppConstants
                                                              .defaultProfilePictures,
                                                      fit: BoxFit.cover,
                                                      repeat:
                                                          ImageRepeat.noRepeat,
                                                      width: 40.w,
                                                      height: 40.h,
                                                    ),
                                                  ))),
                                          Positioned(
                                            child: SvgPicture.asset(
                                              'assets/svgs/changeuser2.svg',
                                              width: 20,
                                              height: 20,
                                            ),
                                            right: -2,
                                            bottom: -2,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        awayPlayer["player"]["name"],
                                        style: AppStyle.text1.copyWith(
                                            color: AppColors.sonaBlack,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),

                    // border radius 15 border width 1 border color grey
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: AppColors.sonaGrey3, width: 1)),
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        Text(
                          "Compared Stats".tr(),
                          style: AppStyle.text3.copyWith(
                              color: AppColors.sonaBlack,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 40.h),
                        Column(
                          children: stats
                              .map((e) => Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              child: Text(
                                                e["value_left"].toString(),
                                                style: AppStyle.text1.copyWith(
                                                    color: AppColors.sonaBlack,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Container(
                                              width: 65,
                                              height: 10,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    color: AppColors.sonaGrey6,
                                                    width: 65,
                                                    height: 10,
                                                  ),
                                                  Positioned(
                                                    right: 0,
                                                    child: Container(
                                                      color: getLeftWidth(e) >
                                                              getRightWidth(e)
                                                          ? AppColors.sonaGreen
                                                          : AppColors.sonaGrey3,
                                                      width: getLeftWidth(e),
                                                      height: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Container(
                                              width: 80,
                                              child: Text(e["title"],
                                                  textAlign: TextAlign.center,
                                                  style: AppStyle.text0
                                                      .copyWith(
                                                          color: AppColors
                                                              .sonaGrey2,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                            ),
                                            SizedBox(width: 10.w),
                                            Container(
                                              width: 65,
                                              height: 10,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    color: AppColors.sonaGrey6,
                                                    width: 65,
                                                    height: 10,
                                                  ),
                                                  Positioned(
                                                    left: 0,
                                                    child: Container(
                                                      color: getLeftWidth(e) <
                                                              getRightWidth(e)
                                                          ? AppColors.sonaGreen
                                                          : AppColors.sonaGrey3,
                                                      width: getRightWidth(e),
                                                      height: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              e["value_right"].toString(),
                                              style: AppStyle.text1.copyWith(
                                                  color: AppColors.sonaBlack,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                      ]),
                                    ),
                                  ))
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                SizedBox(height: 40.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget playerAnalytics(dynamic value, String text) {
    return SizedBox(
        width: 90,
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 8.0,
              percent: value / 100,
              center: Text(value.toString() + "%",
                  style: const TextStyle(color: Colors.white)),
              progressColor: AppColors.sonaPurple1,
            ),
            const SizedBox(height: 10),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: getColorHexFromStr("C4C4C4"), fontSize: 13.sp)),
          ],
        ));
  }

  Widget playerFeatures(String firstText, String secondText, String text,
      {String? image}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
      decoration: BoxDecoration(
          color: AppColors.sonaBlack,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(firstText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13.sp)),
          image != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(image,
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.noRepeat,
                        width: 15),
                    const SizedBox(width: 5),
                    Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold)),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 25),
                    Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
          Text(secondText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13.sp)),
        ],
      ),
    );
  }
}
