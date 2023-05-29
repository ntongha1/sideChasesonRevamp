import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/features/common/dashboard/player_comparison/pvp_global.dart';
import 'package:sonalysis/features/common/dashboard/player_comparison/tvt.dart';
import 'package:sonalysis/features/common/dashboard/player_comparison/tvt_global.dart';
import 'package:sonalysis/features/common/dashboard/player_comparison/vvv.dart';

import '../../core/enums/user_type.dart';
import '../../core/startup/app_startup.dart';
import '../../core/utils/styles.dart';
import '../../core/widgets/appBar/appbarAuth.dart';
import '../../features/common/dashboard/player_comparison/pvp.dart';

class Comparison extends StatefulWidget {
  const Comparison({Key? key}) : super(key: key);

  @override
  _ComparisonState createState() => _ComparisonState();
}

class _ComparisonState extends State<Comparison>
    with SingleTickerProviderStateMixin {
  UserResultData? userResultData;
  TabController? tabController;
  int _selectedIndex = 0;
  bool canComparePVP = false;
  bool canCompareTVT = false;
  bool canCompareVVV = false;
  String type = "PVP";
  List<String> ids = [];

  var video_comp_data;

  List<String> types = ["PVP", "TVT", "VTV"];

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

  bool canCompareReally() {
    if (tabController!.index == 0)
      return canComparePVP;
    else if (tabController!.index == 1)
      return canCompareTVT;
    else if (tabController!.index == 2)
      return canCompareVVV;
    else
      return false;
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
          titleText: "Comparison".tr(), userResultData: userResultData),
      backgroundColor: AppColors.sonaGrey6,
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: TabBar(
              controller: tabController,
              indicatorWeight: 1,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: AppColors.sonalysisMediumPurple,
              onTap: (index) {
                // Tab index when user select it, it start from zero
              },
              tabs: [
                Tab(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    child: Text("Player".tr(),
                        style: AppStyle.text2.copyWith(
                          fontWeight: FontWeight.w400,
                          color: _selectedIndex == 0
                              ? AppColors.sonalysisMediumPurple
                              : AppColors.sonaGrey2,
                        )),
                  ),
                ),
                Tab(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Text("Team".tr(),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Text("Video".tr(),
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
                      PvpGlobal(),
                      TvtGlobal(),
                      // Tvt(canCompare: (v, t, i) {
                      //   print("type: " + t);
                      //   setState(() {
                      //     canCompareTVT = v;
                      //     type = t;
                      //     ids = i;
                      //   });
                      // }),
                      Vvv(canCompare: (v, data) {
                        print("canCompareVVV: " + v.toString());
                        setState(() {
                          canCompareVVV = v;
                          video_comp_data = data;
                        });
                      })
                    ],
                  ))),
        ],
      )),
      floatingActionButton:
          userResultData!.user!.role!.toLowerCase() == UserType.player.type ||
                  (_selectedIndex != 2)
              ? SizedBox.shrink()
              : FloatingActionButton.extended(
                  onPressed: () {
                    serviceLocator.get<NavigationService>().toWithPameter(
                        routeName: RouteKeys.routeComparedStatsScreen,
                        data: {
                          "type": types[
                              tabController == null ? 0 : tabController!.index],
                          "ids": ids,
                          "data": video_comp_data
                        });
                  },
                  icon: Icon(Iconsax.frame_3),
                  backgroundColor: canCompareReally()
                      ? AppColors.sonaBlack2
                      : AppColors.sonaBlack2.withOpacity(0.2),
                  heroTag: "comp",
                  label: Text("Compare".tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 14.sp)),
                ),
      bottomSheet: const Padding(padding: EdgeInsets.only(bottom: 100)),
    );
  }
}
