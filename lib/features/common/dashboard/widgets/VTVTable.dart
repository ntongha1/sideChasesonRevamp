import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/models/position.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/core/widgets/empty_response.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/models/CompareTVTModel.dart' as tvt;
import 'package:sonalysis/features/common/models/ComparePVPModel.dart' as pvp;
import 'package:sonalysis/features/common/models/PlayersInATeamModel.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/player_row_item.dart';
import '../../../../../../core/datasource/local_storage.dart';
import '../../../../../core/enums/user_type.dart';
import '../../../../../core/utils/styles.dart';

class VTVTableWidget extends StatefulWidget {
  dynamic stats;
  pvp.PillModel currentPill;

  VTVTableWidget({Key? key, required this.stats, required this.currentPill})
      : super(key: key);

  @override
  _VTVTableWidgetState createState() => _VTVTableWidgetState();
}

class _VTVTableWidgetState extends State<VTVTableWidget> {
  int activeIndex = 0;
  dynamic stats;
  List<dynamic> statsLocal = [];

  List<String> statsData = [];
  List<dynamic> statsList = [
    {
      "name": "Speed",
      "key": "speed",
      "value": "0",
    },
    // goal
    {
      "name": "Goal",
      "key": "goal",
      "value": "0",
    },
    // free_kick
    {
      "name": "Free Kick",
      "key": "free_kick",
      "value": "0",
    },
    // long_pass
    {
      "name": "Long Pass",
      "key": "long_pass",
      "value": "0",
    },
    // short_pass
    {
      "name": "Short Pass",
      "key": "short_pass",
      "value": "0",
    },
    // red_card
    {
      "name": "Red Card",
      "key": "red_card",
      "value": "0",
    },
    // yellow_card
    {
      "name": "Yellow Card",
      "key": "yellow_card",
      "value": "0",
    },
    // penalty
    {
      "name": "Penalty",
      "key": "penalty",
      "value": "0",
    },
  ];
  @override
  void initState() {
    stats = widget.stats;

    fixStats();

    super.initState();
  }

  void fixStats() {
    for (var i = 0; i < stats.length; i++) {
      // var stat = stats[i]['data'];

      var statData = [];

      for (var k = 0; k < statsList.length; k++) {
        var statItem = statsList[k];
        var statItemData = statItem;
        // statItemData["value"] = stat[statItem["key"]].toString();
        statItemData["value"] = 5.toString();
        statData.add(statItemData);
      }
      // stats[i]["stats"] = statData;

      statsLocal.add(statData);
    }

    setState(() {});
  }

  String name(pvp.Player? player) {
    if (player!.firstName == null) {
      return "N/A";
    } else if (player.lastName != null) {
      return player.firstName!.substring(0, 1).toUpperCase() +
          player.firstName!.substring(1);
    } else {
      return player.firstName!.substring(0, 1).toUpperCase() +
          player.firstName!.substring(1) +
          " " +
          player.lastName!.substring(0, 1).toUpperCase() +
          player.lastName!.substring(1);
    }
  }

  String team(pvp.Player? player) {
    if (player!.teamName == null) {
      return "N/A";
    }

    return player.teamName!;
  }

  String photo(pvp.Player? player) {
    if (player!.photo == null) {
      return AppConstants.defaultProfilePictures;
    }

    if (Uri.parse(player.photo!).isAbsolute) {
      return player.photo!;
    }

    return AppConstants.defaultProfilePictures;
  }

  String getstats(tvt.Analytics dataa) {
    print("current pill");
    print(widget.currentPill.key);
    print(dataa.toJson());
    if (dataa == null) {
      return "0";
    }

    var all = dataa;

    var r = all.toJson()[widget.currentPill.key].toString();

    return r;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          color: AppColors.sonaWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      // border radius and background color
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.sonaGrey6,
                      ),
                      child: Column(children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Text(
                                  'Video',
                                  style: AppStyle.text2.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.sonaGrey3),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Text(
                                  'Player',
                                  style: AppStyle.text2.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.sonaGrey3),
                                ),
                              ),
                              Row(
                                children: List.generate(
                                  statsList.length,
                                  (index) => Expanded(
                                    flex: 2,
                                    child: Text(
                                      statsList[index]['name'],
                                      textAlign: TextAlign.center,
                                      style: AppStyle.text2.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.sonaGrey3),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: List.generate(
                              widget.stats.length,
                              (index) => Container(
                                  color: index % 2 == 0
                                      ? AppColors.sonaGrey5
                                      : AppColors.sonaGrey6,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 10.h),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          stats['videos'][0]['title'],
                                          style: AppStyle.text2.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.sonaGrey3),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "sds",
                                          style: AppStyle.text2.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.sonaGrey3),
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          widget.stats[index].length,
                                          (index) => Expanded(
                                            flex: 2,
                                            child: Text(
                                              statsLocal[index]['value']
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: AppStyle.text2.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.sonaGrey3),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ))),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
            ],
          )),
    );
  }
}
