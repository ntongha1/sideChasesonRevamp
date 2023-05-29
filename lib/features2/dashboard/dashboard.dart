import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/models/response/DashboardStatsModel.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/features2/dashboard/widget/player_stat_card.dart';

import '../../core/datasource/key.dart';
import '../../core/datasource/local_storage.dart';
import '../../core/enums/user_type.dart';
import '../../core/models/response/PlayerListResponseModel.dart';
import '../../core/models/response/StaffListResponseModel.dart';
import '../../core/models/response/TeamsListResponseModel.dart';
import '../../core/models/response/UserResultModel.dart';
import '../../core/startup/app_startup.dart';
import '../../core/utils/styles.dart';
import '../../core/widgets/appBar/appbarAuth.dart';
import '../../features/common/cubit/common_cubit.dart';
import 'widget/dashboard_card.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  bool? isLoading1 = true, isLoading2 = true, isLoading3 = true;

  UserResultData? userResultData;
  TeamsListResponseModel? teamsListResponseModel;
  PlayerListResponseModel? playerListResponseModel;
  StaffListResponseModel? staffListResponseModel;
  DashboarStatsModel? dashboardStats;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  String? myId, myClubId;

  @override
  void initState() {
    super.initState();
    _keepGettingData();
  }

  void _keepGettingData() {
    _getData();
    // Future.delayed(Duration(seconds: 3), () {
    //   _keepGettingData();
    // });
  }

  void _onRefresh() async {
    _getData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _getData();
    _refreshController.loadComplete();
  }

  Future<void> _getData() async {
    userResultData = (await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs))!;

    if (userResultData!.user!.role!.toLowerCase() == UserType.player.type) {
      //print(userResultData!.user!.players![0].id.toString());
      myId = userResultData!.user!.players![0].id;
      myClubId = userResultData!.user!.players![0].clubId;
    } else if (userResultData!.user!.role!.toLowerCase() ==
        UserType.owner.type) {
      myId = userResultData!.user!.id;
      myClubId = userResultData!.user!.clubs![0].id;
    } else {
      myId = userResultData!.user!.staff![0].id;
      myClubId = userResultData!.user!.staff![0].clubId;
    }

    // await serviceLocator<CommonCubit>().getTeamList(myClubId!);
    // await serviceLocator<CommonCubit>().getPlayerList(myClubId!);
    // await serviceLocator<CommonCubit>().getStaffList(myClubId!);
    await serviceLocator<CommonCubit>().getDashboardStats(myClubId!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAuth(
          titleText: "Dashboard".tr(), userResultData: userResultData),
      backgroundColor: AppColors.sonaWhite,
      body: userResultData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SmartRefresher(
              enablePullDown: true,
              header: WaterDropHeader(
                  waterDropColor: AppColors.sonalysisMediumPurple),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: userResultData!.user!.role!.toLowerCase() ==
                      UserType.player.type
                  ? BlocListener(
                      bloc: serviceLocator.get<CommonCubit>(),
                      listener: (_, state) {
                        if (state is DashboardStatsLoading) {
                          // isLoading1 = true;
                          // isLoading2 = true;
                          // isLoading3 = true;
                          // setState(() {});
                        }
                        if (state is DashboardStatsSuccess) {
                          isLoading1 = false;
                          isLoading2 = false;
                          isLoading3 = false;
                          dashboardStats =
                              serviceLocator.get<DashboarStatsModel>();
                          setState(() {});
                        }

                        // if (state is TeamListError) {
                        //   isLoading1 = false;
                        //   setState(() {});
                        // }

                        // if (state is TeamListSuccess) {
                        //   isLoading1 = false;
                        //   teamsListResponseModel =
                        //       serviceLocator.get<TeamsListResponseModel>();
                        //   setState(() {});
                        // }
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 20.h, horizontal: 20.w),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DashboardCard(
                                    headingText: "Total videos".tr(),
                                    counterText: isLoading1! ||
                                            teamsListResponseModel == null
                                        ? "0"
                                        : "0",
                                    subText: "0 added this week".tr(),
                                    image: AppAssets.tVideos,
                                    bgColor: AppColors.sonalysisBabyBlue,
                                    isLoading: isLoading1),
                                SizedBox(height: 30),
                                Text(
                                  "Your stats",
                                  style: AppStyle.text2.copyWith(
                                      color: AppColors.sonaBlack2,
                                      fontSize: 20.sp),
                                ),
                                SizedBox(height: 10.h),
                                PlayerStatCard(
                                  headingText: "Attack".tr(),
                                  height: 170.h,
                                  myList: [
                                    {"leading": "Goals".tr(), "trailing": 0},
                                    {"leading": "Assists".tr(), "trailing": 0},
                                    {"leading": "Shots".tr(), "trailing": 0},
                                    {"leading": "Passes".tr(), "trailing": 0}
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                PlayerStatCard(
                                  headingText: "Defence".tr(),
                                  height: 40.h,
                                  myList: [
                                    {"leading": "Tackles".tr(), "trailing": 0}
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                PlayerStatCard(
                                  headingText: "Others".tr(),
                                  height: 130.h,
                                  myList: [
                                    {
                                      "leading": "Yellow cards".tr(),
                                      "trailing": 4
                                    },
                                    {
                                      "leading": "Red cards".tr(),
                                      "trailing": 0
                                    },
                                    {
                                      "leading": "Red cards".tr(),
                                      "trailing": 23588
                                    },
                                  ],
                                ),
                                SizedBox(height: 50.h),
                              ],
                            ),
                          )))
                  : BlocListener(
                      bloc: serviceLocator.get<CommonCubit>(),
                      listener: (_, state) {
                        if (state is DashboardStatsSuccess) {
                          isLoading1 = false;
                          isLoading2 = false;
                          isLoading3 = false;
                          dashboardStats =
                              serviceLocator.get<DashboarStatsModel>();
                          setState(() {});
                        }
                        // if (state is TeamListLoading) {
                        //   isLoading1 = true;
                        //   setState(() {});
                        // }

                        // if (state is PlayerListLoading) {
                        //   isLoading2 = true;
                        //   setState(() {});
                        // }

                        // if (state is StaffListLoading) {
                        //   isLoading3 = true;
                        //   setState(() {});
                        // }

                        // if (state is TeamListError) {
                        //   isLoading1 = false;
                        //   setState(() {});
                        // }

                        // if (state is PlayerListError) {
                        //   isLoading2 = false;
                        //   setState(() {});
                        // }

                        // if (state is StaffListError) {
                        //   isLoading3 = false;
                        //   setState(() {});
                        // }

                        // if (state is TeamListSuccess) {
                        //   isLoading1 = false;
                        //   teamsListResponseModel =
                        //       serviceLocator.get<TeamsListResponseModel>();
                        //   setState(() {});
                        // }

                        // if (state is PlayerListSuccess) {
                        //   isLoading2 = false;
                        //   playerListResponseModel =
                        //       serviceLocator.get<PlayerListResponseModel>();
                        //   setState(() {});
                        // }

                        // if (state is StaffListSuccess) {
                        //   isLoading3 = false;
                        //   staffListResponseModel =
                        //       serviceLocator.get<StaffListResponseModel>();
                        //   setState(() {});
                        // }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 20.w),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DashboardCard(
                                  headingText: "Total teams".tr(),
                                  counterText: isLoading1! ||
                                          dashboardStats == null
                                      ? "0"
                                      : dashboardStats!.total_teams.toString(),
                                  subText: dashboardStats == null
                                      ? ""
                                      : dashboardStats!.teams_activity,
                                  image: AppAssets.tTeam,
                                  bgColor: AppColors.sonalysisMediumPurple,
                                  isLoading: isLoading1),
                              SizedBox(height: 20),
                              DashboardCard(
                                  headingText: "Total players".tr(),
                                  counterText:
                                      isLoading2! || dashboardStats == null
                                          ? "0"
                                          : dashboardStats!.total_players
                                              .toString(),
                                  subText: dashboardStats == null
                                      ? ""
                                      : dashboardStats!.players_activity,
                                  image: AppAssets.tPlayers,
                                  bgColor: AppColors.sonalysisBabyBlue,
                                  isLoading: isLoading2),
                              SizedBox(height: 20),
                              DashboardCard(
                                  headingText: "Total staff".tr(),
                                  counterText: isLoading3! ||
                                          dashboardStats == null
                                      ? "0"
                                      : dashboardStats!.total_staffs.toString(),
                                  subText: dashboardStats == null
                                      ? ""
                                      : dashboardStats!.staffs_activity,
                                  image: AppAssets.tStaff,
                                  bgColor: AppColors.sonalysisMediumSlateBlue,
                                  isLoading: isLoading3),
                              SizedBox(height: 60),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
    );
  }
}
