import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/models/response/TeamsListResponseModel.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/styles.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/dashboard/widgets/PVPTable.dart';
import 'package:sonalysis/features/common/dashboard/widgets/TVTTable.dart';
import 'package:sonalysis/features/common/dashboard/widgets/VTVTable.dart';
import 'package:sonalysis/features/common/dashboard/widgets/selectPillsWidget.dart';
import 'package:sonalysis/features/common/dashboard/widgets/selectPlayersWidget.dart';
import 'package:sonalysis/features/common/dashboard/widgets/selectTeamsWidget.dart';
import 'package:sonalysis/features/common/models/ComparePVPModel.dart';
import 'package:sonalysis/features/common/models/CompareTVTModel.dart';
import 'package:sonalysis/features/common/models/PlayersInATeamModel.dart';
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

class CompareStatsScreen extends StatefulWidget {
  final data;
  CompareStatsScreen({Key? key, this.data}) : super(key: key);

  @override
  State<CompareStatsScreen> createState() => _CompareStatsScreenState();
}

class _CompareStatsScreenState extends State<CompareStatsScreen> {
  UserResultModel.UserResultData? userResultData;
  bool isLoading = false;
  bool showingFilter = false;
  final Client _httpClient = Client();

  String type = "PVP";
  List<String> ids = [];
  String clubId = "";
  ComparePVPModel? statsPVP;
  CompareTVTModel? statsTVT;
  PillModel currentPill = PillModel(title: "", key: "", value: "");

  bool hasData = false;
  var compData = null;
  List<PillModel> pills = [];

  List<String> keysPVP = [
    "speed",
    "goal",
    "free_kick",
    "long_pass",
    "short_pass",
    "red_card",
    "yellow_card",
    "penalty"
  ];

  List<String> keysTVT = [
    "long_pass",
    "short_pass",
    "dribble",
    "shots",
    "tackles",
    "yellow_cards",
    "red_cards",
    "foul",
    "offside",
    "ball_possession",
    "free_kick",
    "penalty",
    "corners",
    "free_throw",
    "goals",
    "saves",
    "cross",
    "long_shot"
  ];

  Future<void> _getData() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    //load all teams
    clubId = userResultData!.user!.clubs![0].id!;
    ids = widget.data["ids"];
    compData = widget.data["data"];
    type = widget.data["type"];

    print("comp final: $ids");
    if (type == "PVP") {
      serviceLocator.get<CommonCubit>().comparePVP(ids);
    } else if (type == "TVT") {
      serviceLocator.get<CommonCubit>().compareTVT(ids);
    } else if (type == "VTV") {
      compareVTVLocal();
      setState(() {
        isLoading = true;
      });
    }
    setState(() {});
    context.loaderOverlay.show();
  }

  void compareVTVLocal() async {
    print("I'm here");
    // for (var i = 0; i < compData.length; i++) {
    //   var data = await getPlayerDetails(compData[i]);
    //   if (data != null) {
    //     compData[i]["data"] = data;
    //   }
    // }

    // delay for 2 seconds

    await Future.delayed(Duration(seconds: 2));

    context.loaderOverlay.hide();
    setState(() {
      // hasData = true;
      isLoading = false;
    });
  }

  dynamic getPlayerDetails(p) async {
    String url = ApiConstants.compareVTV + '?club_id=' + clubId;

    Map<String, String> header = {};
    header = {'Content-Type': 'application/json', 'accept': '*/*'};
    print("dataDD " + url);

    var body = {
      "player_id": p["player"]["id"],
      "video_ids": [p["videos"][0]["id"]]
    };

    Response? res = await _httpClient.post(Uri.parse(url),
        headers: header, body: jsonEncode(body));
    print("dataDD " + res.statusCode.toString());

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      print('dataDD:' + data['data'].toString());
      return data['data'];
    } else {
      return null;
    }
  }

  void changePill(PillModel pill) {
    setState(() {
      currentPill = pill;
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  String toTitle(String key) {
    // sample input: "speed" output: "Speed"
    // sample input: "free_kick" output: "Free Kick"
    String title = "";
    List<String> words = key.split("_");
    words.forEach((element) {
      title += element[0].toUpperCase() + element.substring(1) + " ";
    });

    return title;
  }

  List<PillModel> getPills() {
    List<PillModel> pillsLocal = [];

    if (statsPVP != null && type == "PVP") {
      keysPVP.forEach((element) {
        if (statsPVP!.data![0].toJson().containsKey(element)) {
          PillModel pp =
              new PillModel(title: toTitle(element), key: element, value: "");
          pillsLocal.add(pp);
        }
      });
    }

    if (statsTVT != null &&
        type == "TVT" &&
        statsTVT!.data![0].analytics != null) {
      keysTVT.forEach((element) {
        print("elemm" + element);
        if (statsTVT!.data![0].analytics!.toJson().containsKey(element)) {
          PillModel pp =
              new PillModel(title: toTitle(element), key: element, value: "");
          pillsLocal.add(pp);
        } else {
          print("not found" + element);
        }
      });
    }

    if (currentPill.key == "" && pillsLocal.length > 0) {
      setState(() {
        currentPill = pillsLocal[0];
      });
    }
    print('actual pills');
    print(pillsLocal);
    return pillsLocal;
  }

  List<String> getStatsPVP() {
    List<String> statsl = [];
    if (statsPVP != null) {
      statsPVP!.data!.forEach((element) {
        statsl.add(element.toJson()[currentPill.key].toString());
      });
    }

    print("stats now:");
    print(statsl);
    return statsl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocListener(
          bloc: serviceLocator.get<CommonCubit>(),
          listener: (_, state) {
            if (state is ComparePVPLoading || state is CompareTVTLoading) {
              setState(() {
                isLoading = true;
              });
            }

            if (state is ComparePVPError) {
              setState(() {
                isLoading = false;
              });
              context.loaderOverlay.hide();
              ResponseMessage.showErrorSnack(
                  context: context, message: state.message);
            }

            if (state is CompareTVTError) {
              setState(() {
                isLoading = false;
              });
              context.loaderOverlay.hide();
              ResponseMessage.showErrorSnack(
                  context: context, message: state.message);
            }

            if (state is ComparePVPSuccess) {
              statsPVP = serviceLocator.get<ComparePVPModel>();
              hasData = statsPVP!.data!.length > 0;
              context.loaderOverlay.hide();
              setState(() {
                isLoading = false;
              });
            }

            if (state is CompareTVTSuccess) {
              statsTVT = serviceLocator.get<CompareTVTModel>();
              hasData = statsTVT!.data!.length > 0;
              context.loaderOverlay.hide();
              setState(() {
                isLoading = false;
              });
            }
          },
          child: isLoading
              ? Container()
              : Container(
                  width: MediaQuery.of(context).size.width,

                  // padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: InkWell(
                              onTap: () {
                                serviceLocator.get<NavigationService>().pop();
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
                              "Compared stats".tr(),
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
                      hasData
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 40.h),
                                SelectPillsWidget(
                                  horizontal: false,
                                  pills: getPills(),
                                  onSelect: (v) {
                                    changePill(v);
                                  },
                                ),
                                SizedBox(height: 20.h),
                                Center(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: type == "PVP"
                                          ? PVPTableWidget(
                                              stats: statsPVP!,
                                              currentPill: currentPill,
                                            )
                                          : Container()),
                                ),
                                Center(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: type == "TVT"
                                          ? TVTTableWidget(
                                              stats: statsTVT!,
                                              currentPill: currentPill,
                                            )
                                          : Container()),
                                ),
                                Center(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: type == "VTV"
                                          ? VTVTableWidget(
                                              stats: compData!,
                                              currentPill: currentPill,
                                            )
                                          : Container()),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(height: 40.h),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "No data found for this comparison configuration"
                                        .tr(),
                                    textAlign: TextAlign.center,
                                    style: AppStyle.h3.copyWith(
                                        color: AppColors.sonaBlack2,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
