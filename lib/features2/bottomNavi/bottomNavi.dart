import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/core/utils/styles.dart';

import '../../../core/utils/helpers.dart';
import '../../core/datasource/key.dart';
import '../../core/datasource/local_storage.dart';
import '../../core/enums/user_type.dart';
import '../../core/models/response/UserResultModel.dart';
import '../../core/startup/app_startup.dart';
import '../../core/utils/colors.dart';
import '../analytics/analytics.dart';
import '../club_management/ClubManagementScreen.dart';
import '../comparison/root.dart';
import '../dashboard/dashboard.dart';

class BottomNaviScreen extends StatefulWidget {
  final BuildContext? menuScreenContext;

  const BottomNaviScreen({Key? key, this.menuScreenContext}) : super(key: key);

  @override
  _BottomNaviScreenState createState() => _BottomNaviScreenState();
}

class _BottomNaviScreenState extends State<BottomNaviScreen> {
  PersistentTabController? _controller;
  bool? _hideNavBar;
  UserResultData? userResultData;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
    _data();
  }

  _data() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    setState(() {});
  }

  List<Widget> _clubManagerScreens() {
    return [
      DashBoardScreen(),
      ClubManagementScreen(),
      Analytics(),
      Comparison(),
      // Center(
      //   child: Text("Just Text", style: AppStyle.text2),
      // )
      //MessagesScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _clubManagerNavBarsItems() {
    return [
      persistentBottomNavBarItem(
          "Dashboard", "assets/svgs/b_dash_a.svg", "assets/svgs/b_dash.svg"),
      persistentBottomNavBarItem(
          "Management", "assets/svgs/b_man_a.svg", "assets/svgs/b_man.svg"),
      persistentBottomNavBarItem(
          "Analytics", "assets/svgs/b_ana_a.svg", "assets/svgs/b_ana.svg"),
      persistentBottomNavBarItem(
          "Comparison", "assets/svgs/b_comp_a.svg", "assets/svgs/b_comp.svg"),
      // persistentBottomNavBarItem(
      //     "Messages", "assets/svgs/b_msg_a.svg", "assets/svgs/b_msg.svg"),
    ];
  }

  List<Widget> _playerScreens() {
    return [
      DashBoardScreen(),
      Analytics(),
      Comparison(),
      // Center(
      //   child: Text("Just Text", style: AppStyle.text2),
      // )
      //MessagesScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _playerNavBarsItems() {
    return [
      persistentBottomNavBarItem(
          "Dashboard", "assets/svgs/b_dash_a.svg", "assets/svgs/b_dash.svg"),
      persistentBottomNavBarItem(
          "Analytics", "assets/svgs/b_ana_a.svg", "assets/svgs/b_ana.svg"),
      persistentBottomNavBarItem(
          "Comparison", "assets/svgs/b_comp_a.svg", "assets/svgs/b_comp.svg"),
      // persistentBottomNavBarItem(
      //     "Messages", "assets/svgs/b_msg_a.svg", "assets/svgs/b_msg.svg"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (userResultData == null) {
      context.loaderOverlay.show();
    } else {
      context.loaderOverlay.hide();
    }

    return Scaffold(
      body: userResultData != null
          ? PersistentTabView(
              context,
              controller: _controller,
              screens: userResultData!.user!.role!.toLowerCase() ==
                          UserType.owner.type ||
                      userResultData!.user!.role!.toLowerCase() ==
                          UserType.coach.type ||
                      userResultData!.user!.role!.toLowerCase() ==
                          UserType.manager.type
                  ? _clubManagerScreens()
                  : _playerScreens(),
              items: userResultData!.user!.role!.toLowerCase() ==
                          UserType.owner.type ||
                      userResultData!.user!.role!.toLowerCase() ==
                          UserType.coach.type ||
                      userResultData!.user!.role!.toLowerCase() ==
                          UserType.manager.type
                  ? _clubManagerNavBarsItems()
                  : _playerNavBarsItems(),
              confineInSafeArea: true,
              backgroundColor: AppColors.sonaGrey6,
              handleAndroidBackButtonPress: true,
              resizeToAvoidBottomInset: true,

              stateManagement: true,
              navBarHeight:
                  MediaQuery.of(context).viewInsets.bottom > 0 ? 0.0 : 104,
              hideNavigationBarWhenKeyboardShows: true,
              margin: const EdgeInsets.symmetric(vertical: 0),
              padding: const NavBarPadding.only(top: 20, bottom: 30),
              popActionScreens: PopActionScreensType.all,
              bottomScreenMargin: 50,
              onWillPop: (context) async {
                await onBackPressed(context!, "Exit Sonalysis",
                    "You sure you want to exit!\nSure to Proceed?");
                return false;
              },
              selectedTabScreenContext: (context) {
                //testContext = context;
              },
              hideNavigationBar: _hideNavBar,
              decoration: NavBarDecoration(
                  colorBehindNavBar: AppColors.sonaBlack4,
                  borderRadius: BorderRadius.circular(0.0)),
              popAllScreensOnTapOfSelectedTab: true,
              itemAnimationProperties: const ItemAnimationProperties(
                duration: Duration(milliseconds: 0),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: const ScreenTransitionAnimation(
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle
                  .simple, // Choose the nav bar style with this property
            )
          : Container(),
    );
  }
}
