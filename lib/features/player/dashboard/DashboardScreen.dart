import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/features2/settings/root.dart';
import 'package:sonalysis/style/styles.dart';

import '../../../core/utils/helpers.dart';

class PlayerDashboardScreen extends StatefulWidget {
  final BuildContext? menuScreenContext;
  const PlayerDashboardScreen({Key? key, this.menuScreenContext})
      : super(key: key);

  @override
  _PlayerDashboardScreenState createState() => _PlayerDashboardScreenState();
}

class _PlayerDashboardScreenState extends State<PlayerDashboardScreen> {
  PersistentTabController? _controller;
  bool? _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [
      Container(),
      //AnalyticsScreen(),
      MySettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      persistentBottomNavBarItem(
          "Analytics", "assets/svgs/b_dash_a.svg", "assets/svgs/b_dash.svg"),
      persistentBottomNavBarItem(
          "Profile", "assets/svgs/b_dash_a.svg", "assets/svgs/b_dash.svg"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: sonaLightBlack,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        margin: const EdgeInsets.symmetric(vertical: 0),
        padding: const NavBarPadding.symmetric(vertical: 10),
        popActionScreens: PopActionScreensType.all,
        bottomScreenMargin: 0.0,
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
            colorBehindNavBar: sonaBlack,
            borderRadius: BorderRadius.circular(0.0)),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style10, // Choose the nav bar style with this property
      ),
    );
  }
}
