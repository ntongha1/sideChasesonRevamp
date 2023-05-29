import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/style/styles.dart';

import '../../../../features2/club_management/ClubManagementScreen.dart';
import '../../../../features/common/messages/MessagesScreen.dart';

class CoachDashboardScreen extends StatefulWidget {
  final BuildContext? menuScreenContext;
  const CoachDashboardScreen({Key? key, this.menuScreenContext}) : super(key: key);

  @override
  _CoachDashboardScreenState createState() => _CoachDashboardScreenState();
}

class _CoachDashboardScreenState extends State<CoachDashboardScreen> {

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
      Container(
          margin: const EdgeInsets.only(bottom: 50),
      child: Container()
      ),
      MessagesScreen(),
      // ComingSoonScreen(
      //   menuScreenContext: widget.menuScreenContext,
      //   hideStatus: _hideNavBar,
      //   onScreenHideButtonPressed: () {
      //     setState(() {
      //       _hideNavBar = !_hideNavBar;
      //     });
      //   },
      // ),
      Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: ClubManagementScreen()),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.chartPie),
        title: "Analytics",
        activeColorPrimary: sonaPurple2,
        inactiveColorPrimary: Colors.white,
        inactiveColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.comment),
        title: ("Chat"),
        activeColorPrimary: sonaPurple2,
        inactiveColorPrimary: Colors.white,
        inactiveColorSecondary: Colors.white,
      ),
      // PersistentBottomNavBarItem(
      //     icon: const FaIcon(FontAwesomeIcons.box),
      //     title: ("Add"),
      //     activeColorPrimary: sonaPurple2,
      //     inactiveColorPrimary: Colors.white,
      //     inactiveColorSecondary: Colors.white
      // ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.userAlt),
        title: ("Profile"),
        activeColorPrimary: sonaPurple2,
        inactiveColorPrimary: Colors.white,
        inactiveColorSecondary: Colors.white,
      ),
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
          await onBackPressed(context!, "Exit Sonalysis", "You sure you want to exit!\nSure to Proceed?");
          return false;
        },
        selectedTabScreenContext: (context) {
          //testContext = context;
        },
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(colorBehindNavBar: sonaBlack, borderRadius: BorderRadius.circular(0.0)),
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
        navBarStyle: NavBarStyle.style12, // Choose the nav bar style with this property
      ),
    );
  }
}