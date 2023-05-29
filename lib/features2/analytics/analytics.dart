import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/models/League.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/helpers.dart';
import 'package:sonalysis/core/widgets/popup_screen.dart';

import '../../core/enums/user_type.dart';
import '../../core/startup/app_startup.dart';
import '../../core/utils/styles.dart';
import '../../core/widgets/appBar/appbarAuth.dart';
import 'tabs/allAnalytics.dart';
import 'tabs/completedAnalytics.dart';
import 'tabs/pendingAnalytics.dart';
import 'widgets/upload_video_popup.dart';

class Analytics extends StatefulWidget {
  const Analytics({Key? key}) : super(key: key);

  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics>
    with SingleTickerProviderStateMixin {
  UserResultData? userResultData;
  TabController? tabController;
  int _selectedIndex = 0;
  bool showSuccess = false;
  bool loading = false;
  final Client _httpClient = Client();
  bool loadingLegs = true;
  List<Leagues> leagues = [];

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
    getLeagues();
  }

  getLeagues() async {
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
    print('analyeags to fetch leageus' + res.statusCode.toString());
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      print('analyeags:' + data['response'].toString());
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

  Future<void> _getData() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    setState(() {
      loading = true;
    });
    //  sleep for 1 second
    await Future.delayed(Duration(microseconds: 10));
    setState(() {
      loading = false;
    });
    //print("Token::: "+userResultData!.authToken.toString());
  }

  void reloadAllPages() {
    setState(() {
      loading = true;
    });

    // wait 2 seconds
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(userResultData!.user!.firstName.toString());
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarAuth(
              titleText: "Analytics".tr(), userResultData: userResultData),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 0),
                        child: Text("All".tr(),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        child: Text("Complete".tr(),
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
                        child: Text("Pending".tr(),
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
                          loading ? Container() : AllAnalytics(),
                          loading ? Container() : CompletedAnalytics(),
                          loading ? Container() : pendingAnalytics(),
                        ],
                      ))),
            ],
          )),
          floatingActionButton:
              userResultData!.user!.role!.toLowerCase() == UserType.player.type
                  ? SizedBox.shrink()
                  : FloatingActionButton.extended(
                      onPressed: () {
                        if (loadingLegs) {
                          showSnackBar(
                              "Please wait, we are loading leagues", context);
                          return;
                        }
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) =>
                                UploadVideoPopUpScreen(
                                    leagues: leagues,
                                    onClose: (bool wasClosed) {
                                      if (!wasClosed) {
                                        _getData();
                                        print("this worked");
                                        setState(() {
                                          showSuccess = true;
                                          reloadAllPages();
                                        });
                                      }
                                    })).then((value) {
                          print("value is" + value.toString());
                        });
                      },
                      icon: Icon(Iconsax.video_add),
                      backgroundColor: AppColors.sonaBlack2,
                      heroTag: "uavid",
                      label: Text("Upload a video".tr(),
                          style: AppStyle.text1.copyWith(
                              color: AppColors.sonaWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                    ),
          bottomSheet: const Padding(padding: EdgeInsets.only(bottom: 100)),
        ),
        Positioned(
            child: showSuccess
                ? PopUpPageScreen(data: {
                    "title": "Success".tr(),
                    "subTitle": "Video uploaded successfully!".tr(),
                    "route": "",
                    "callback": () {
                      setState(() {
                        showSuccess = false;
                      });
                    },
                    "routeType": "callback",
                    "buttonText": "continue".tr()
                  })
                : Container())
      ],
    );
  }
}
