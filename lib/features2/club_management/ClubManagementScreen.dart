import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/helpers.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/players_club_management/players_list.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/teams_club_management/create_team_flow/createPlayerFlow.dart';

import '../../core/utils/styles.dart';
import '../../core/widgets/appBar/appbarAuth.dart';
import 'screen_tabs/staff_club_management/staff_club_management.dart';
import 'screen_tabs/teams_club_management/create_team_flow/createStaffFlow.dart';
import 'screen_tabs/teams_club_management/teams_list.dart';
import 'package:tabbar_gradient_indicator/tabbar_gradient_indicator.dart';

class ClubManagementScreen extends StatefulWidget {
  const ClubManagementScreen({Key? key}) : super(key: key);

  @override
  _ClubManagementScreenState createState() => _ClubManagementScreenState();
}

class _ClubManagementScreenState extends State<ClubManagementScreen>
    with SingleTickerProviderStateMixin {
  UserResultData? userResultData;
  TabController? tabController;
  int _selectedIndex = 0;
  bool playersLoading = false;
  bool staffsLoading = false;
  bool teamsLoading = false;

  @override
  void initState() {
    super.initState();
    // Create TabController for getting the index of current tab
    tabController = TabController(length: 3, vsync: this);
    tabController!.addListener(() {
      setState(() {
        _selectedIndex = tabController!.index;
      });
      //print("Selected Index: " + tabController!.index.toString());
    });
    _getData();
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    setState(() {});
    //print("Token::: "+userResultData!.authToken.toString());
  }

  @override
  Widget build(BuildContext context) {
    //print(userResultData!.user!.firstName.toString());
    return Scaffold(
      appBar: AppBarAuth(
          titleText: "Management".tr(), userResultData: userResultData),
      backgroundColor: AppColors.sonaGrey6,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 56,
            ),
            Container(
              child: TabBar(
                controller: tabController,
                indicatorPadding: EdgeInsets.all(0.0),
                labelPadding: EdgeInsets.only(left: 0.0, right: 0.0),

                indicatorWeight: 4,
                indicatorSize: TabBarIndicatorSize.label,
                // indicatorColor: AppColors.sonalysisMediumPurple,
                indicator: ShapeDecoration(
                  shape: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.sonalysisMediumPurple,
                      width: 4.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                onTap: (index) {
                  // Tab index when user select it, it start from zero
                },
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 0),
                      child: Text(
                        "teams".tr(),
                        style: AppStyle.text2.copyWith(
                          fontWeight: FontWeight.w400,
                          color: _selectedIndex == 0
                              ? AppColors.sonalysisMediumPurple
                              : AppColors.sonaGrey2,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: Text("players".tr(),
                          style: AppStyle.text2.copyWith(
                            fontWeight: FontWeight.w400,
                            color: _selectedIndex == 1
                                ? AppColors.sonalysisMediumPurple
                                : AppColors.sonaGrey2,
                          )),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: Text("staff".tr(),
                          style: AppStyle.text2.copyWith(
                            fontWeight: FontWeight.w400,
                            color: _selectedIndex == 2
                                ? AppColors.sonalysisMediumPurple
                                : AppColors.sonaGrey2,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                color: AppColors.sonaWhite,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    teamsLoading
                        ? Container(
                            child: Center(child: Text("Loading")),
                          )
                        : TeamsList(),
                    playersLoading
                        ? Container(
                            child: Center(child: Text("Loading")),
                          )
                        : PlayersList(isSingleton: false),
                    staffsLoading
                        ? Container(
                            child: Center(child: Text("Loading")),
                          )
                        : StaffClubManagement(isSingleton: false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_selectedIndex == 0) {
            serviceLocator<NavigationService>()
                .to(RouteKeys.routeCreateTeamFlowScreen)
                .then((value) {
              setState(() {
                teamsLoading = true;
              });
              // wait for 2 seconds to simulate loading of data
              Future.delayed(const Duration(milliseconds: 100), () {
                setState(() {
                  teamsLoading = false;
                });
              });
              // if (value != null && value) {
              //   print("back");
              //   final TeamsClubManagement _teamsClubManagement = new TeamsClubManagement();
              //   _teamsClubManagement.getData();
              // setState(() {});
              // }
            });
          } else if (_selectedIndex == 1) {
            bottomSheet(
                context,
                CreatePlayerFlowScreen(
                  // TODO: show success mahev
                  onPlayerCreated: () {},
                )).then((value) {
              setState(() {
                playersLoading = true;
              });
              // wait for 2 seconds to simulate loading of data
              Future.delayed(const Duration(milliseconds: 100), () {
                setState(() {
                  playersLoading = false;
                });
              });
            });
          } else if (_selectedIndex == 2) {
            bottomSheet(context, CreateStaffFlowScreen(
              onPlayerCreated: () {
                // TODO: show success mahev
              },
            )).then((value) {
              setState(() {
                staffsLoading = true;
              });
              // wait for 2 seconds to simulate loading of data
              Future.delayed(const Duration(milliseconds: 100), () {
                setState(() {
                  staffsLoading = false;
                });
              });
            });
          }
        },
        icon: Icon(
          _selectedIndex == 0
              ? Iconsax.note_favorite
              : _selectedIndex == 1
                  ? Iconsax.note_favorite
                  : Iconsax.note_favorite,
          size: 20,
        ),
        backgroundColor: AppColors.sonaBlack2,
        heroTag: _selectedIndex == 0
            ? "cteam"
            : _selectedIndex == 1
                ? "cplayers"
                : "cstaff",
        label: Text(
          _selectedIndex == 0
              ? "create_new_team".tr()
              : _selectedIndex == 1
                  ? "Create new players".tr()
                  : "Create new staff".tr(),
          style: AppStyle.text2
              .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ),
      bottomSheet: const Padding(padding: EdgeInsets.only(bottom: 100)),
    );
  }
}
