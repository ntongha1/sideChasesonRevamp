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
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/core/widgets/empty_response.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/models/ComparePVPModel.dart' as pvp;
import 'package:sonalysis/features/common/models/PlayersInATeamModel.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/player_row_item.dart';
import '../../../../../../core/datasource/local_storage.dart';
import '../../../../../core/enums/user_type.dart';
import '../../../../../core/utils/styles.dart';

class PlayerSelector extends StatefulWidget {
  pvp.Player p;
  void Function(pvp.Player) onPlayerSelected;

  PlayerSelector({Key? key, required this.p, required this.onPlayerSelected})
      : super(key: key);

  @override
  _PlayerSelectorState createState() => _PlayerSelectorState();
}

class _PlayerSelectorState extends State<PlayerSelector> {
  int activeIndex = 0;
  pvp.ComparePVPModel? stats;
  List<String> statsData = [];
  @override
  void initState() {
    super.initState();
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

  String getstats(pvp.Data dataa) {
    print("current pill");
    print(dataa.toJson());
    if (dataa == null) {
      return "0";
    }

    var all = dataa;

    // var r = all.toJson()[widget.currentPill.key].toString();
    return "lsd";
    // return r;
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
                                flex: 6,
                                child: Text(
                                  'Player'.tr(),
                                  style: AppStyle.text2.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.sonaGrey3),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Team'.tr(),
                                  style: AppStyle.text2.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.sonaGrey3),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Total'.tr(),
                                  textAlign: TextAlign.center,
                                  style: AppStyle.text2.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.sonaGrey3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Column(
                        //   children: List.generate(
                        //       widget.stats.data!.length,
                        //       (index) => Container(
                        //           color: index % 2 == 0
                        //               ? AppColors.sonaGrey5
                        //               : AppColors.sonaGrey6,
                        //           padding: EdgeInsets.symmetric(
                        //               horizontal: 20.w, vertical: 10.h),
                        //           child: Row(
                        //             children: [
                        //               Expanded(
                        //                 flex: 6,
                        //                 child: Row(
                        //                   children: [
                        //                     Container(
                        //                       width: 20.w,
                        //                       height: 20.h,
                        //                       decoration: BoxDecoration(
                        //                         borderRadius:
                        //                             BorderRadius.circular(10),
                        //                         image: DecorationImage(
                        //                           image: NetworkImage(photo(
                        //                               widget.stats.data![index]
                        //                                   .player)),
                        //                           fit: BoxFit.cover,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                     SizedBox(width: 10.w),
                        //                     Text(
                        //                       name(widget
                        //                           .stats.data![index].player),
                        //                       style: AppStyle.text2.copyWith(
                        //                           fontWeight: FontWeight.w400,
                        //                           color: AppColors.sonaGrey3),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               Expanded(
                        //                 flex: 2,
                        //                 child: Text(
                        //                   team(
                        //                       widget.stats.data![index].player),
                        //                   style: AppStyle.text2.copyWith(
                        //                       fontWeight: FontWeight.w400,
                        //                       color: AppColors.sonaGrey3),
                        //                 ),
                        //               ),
                        //               Expanded(
                        //                 flex: 2,
                        //                 child: Text(
                        //                   getstats(widget.stats.data![index]),
                        //                   textAlign: TextAlign.center,
                        //                   style: AppStyle.text2.copyWith(
                        //                       fontWeight: FontWeight.w400,
                        //                       color: AppColors.sonaGrey3),
                        //                 ),
                        //               ),
                        //             ],
                        //           ))),
                        // ),
                        SizedBox(height: 5),
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
