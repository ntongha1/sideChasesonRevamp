import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/players_club_management/add_edit_player/addEditPlayer.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/players_club_management/singleton/player_singleton.dart';
import 'package:sonalysis/helpers/helpers.dart';

import '../core/models/response/PlayerListResponseModel.dart';
import '../core/models/response/TeamsListResponseModel.dart';
import '../core/navigation/keys.dart';
import '../core/navigation/navigation_service.dart';
import '../core/utils/styles.dart';
import '../features/common/models/PlayersInATeamModel.dart';

class PlayerGridItem extends StatelessWidget {
  final TeamsListResponseModelPlayers? teamsListResponseModelPlayers;
  final PlayerListResponseModelData? playerListResponseModelData;
  final Players? players;
  final Function? onTap;
  const PlayerGridItem(
      {Key? key,
      this.teamsListResponseModelPlayers,
      this.playerListResponseModelData,
      this.players,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (teamsListResponseModelPlayers == null && players == null) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          decoration: BoxDecoration(
              color: AppColors.sonaGrey6,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: InkWell(
              onTap: () {
                print("lol");
                this.onTap!();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      alignment: Alignment.center,
                      //margin: const EdgeInsets.symmetric(vertical: 5),
                      //padding: const EdgeInsets.all(13),
                      height: 60,
                      child: Stack(
                        children: [
                          CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.sonaBlack,
                              child: ClipOval(
                                child: Image.network(
                                  playerListResponseModelData!.photo == null ||
                                          playerListResponseModelData!.photo ==
                                              "null" ||
                                          playerListResponseModelData!.photo ==
                                              ""
                                      ? AppConstants.defaultProfilePictures
                                      : playerListResponseModelData!.photo!,
                                  fit: BoxFit.cover,
                                  repeat: ImageRepeat.noRepeat,
                                  width: 40.w,
                                  height: 40.h,
                                ),
                              )),
                          Positioned(
                              right: 0,
                              child: playerListResponseModelData!.loginCount !=
                                          null &&
                                      playerListResponseModelData!.loginCount! >
                                          0
                                  ? Container(
                                      // add border radius 8

                                      decoration: BoxDecoration(
                                        color: AppColors.sonaWhite,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      width: 16,
                                      height: 16,
                                      child: SvgPicture.asset(
                                        "assets/svgs/verified.svg",
                                        color: AppColors.sonaPurple1,
                                      ),
                                    )
                                  : Container())
                        ],
                      )),
                  SizedBox(
                      child: Text(
                    playerListResponseModelData!.firstName!
                            .substring(0, 1)
                            .toUpperCase() +
                        playerListResponseModelData!.firstName!.substring(1) +
                        " " +
                        playerListResponseModelData!.lastName!
                            .substring(0, 1)
                            .toUpperCase() +
                        playerListResponseModelData!.lastName!.substring(1),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppStyle.text1.copyWith(
                        color: AppColors.sonaBlack,
                        fontWeight: FontWeight.w400),
                  )),
                  SizedBox(height: 10.h),
                  Text(
                    "player".tr(),
                    textAlign: TextAlign.center,
                    style: AppStyle.text2.copyWith(
                        color: AppColors.sonaBlack,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "No. " + playerListResponseModelData!.jerseyNumber!,
                    textAlign: TextAlign.center,
                    style: AppStyle.text2.copyWith(
                        color: AppColors.sonaGrey3,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              )),
        ),
      );
    } else if (playerListResponseModelData == null && players == null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3),
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          decoration: BoxDecoration(
              color: AppColors.sonaGrey6,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      bottomSheet(
                          context,
                          AddEditPlayerScreen(
                              type: "edit",
                              playerID: teamsListResponseModelPlayers!.id!));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.more_vert,
                            color: AppColors.sonaBlack2,
                          )),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      height: 70,
                      child: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.sonaBlack,
                          child: ClipOval(
                            child: Image.network(
                              teamsListResponseModelPlayers!.photo == null &&
                                      teamsListResponseModelPlayers!.photo !=
                                          "null" &&
                                      teamsListResponseModelPlayers!.photo != ""
                                  ? AppConstants.defaultProfilePictures
                                  : teamsListResponseModelPlayers!.photo!,
                              fit: BoxFit.cover,
                              repeat: ImageRepeat.noRepeat,
                              width: 55.w,
                              height: 55.h,
                            ),
                          ))),
                  SizedBox(
                      width: 120.0,
                      child: Text(
                        teamsListResponseModelPlayers!.firstName!
                                .substring(0, 1)
                                .toUpperCase() +
                            teamsListResponseModelPlayers!.firstName!
                                .substring(1) +
                            " " +
                            teamsListResponseModelPlayers!.lastName!
                                .substring(0, 1)
                                .toUpperCase() +
                            teamsListResponseModelPlayers!.lastName!
                                .substring(1),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style:
                            AppStyle.text2.copyWith(color: AppColors.sonaBlack),
                      )),
                  Text(
                    "player".tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Text(
                    teamsListResponseModelPlayers!.clubId!
                            .substring(0, 1)
                            .toUpperCase() +
                        teamsListResponseModelPlayers!.firstName!.substring(1),
                    textAlign: TextAlign.center,
                    style: AppStyle.text2
                        .copyWith(color: AppColors.sonaBlack, fontSize: 10.sp),
                  ),
                  //const SizedBox(height: 10)
                ],
              )),
        ),
      );
    } else {
      return Center(
        child: Container(
          // padding: const EdgeInsets.symmetric(vertical: 3),
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          decoration: BoxDecoration(
              color: AppColors.sonaGrey6,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: InkWell(
              onTap: () {
                this.onTap!();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      alignment: Alignment.center,
                      //margin: const EdgeInsets.symmetric(vertical: 5),
                      //padding: const EdgeInsets.all(13),
                      height: 40,
                      child: CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.sonaBlack,
                          child: ClipOval(
                            child: Image.network(
                              players!.photo == null ||
                                      players!.photo == "null" ||
                                      players!.photo == ""
                                  ? AppConstants.defaultProfilePictures
                                  : players!.photo!,
                              fit: BoxFit.cover,
                              repeat: ImageRepeat.noRepeat,
                              width: 40.w,
                              height: 40.h,
                            ),
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      child: Text(
                    players!.firstName!.substring(0, 1).toUpperCase() +
                        players!.firstName!.substring(1) +
                        " " +
                        players!.lastName!.substring(0, 1).toUpperCase() +
                        players!.lastName!.substring(1),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppStyle.text1.copyWith(
                        color: AppColors.sonaBlack,
                        fontWeight: FontWeight.w400),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Player".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.sonaBlack2,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    players!.clubId!.substring(0, 1).toUpperCase() +
                        players!.firstName!.substring(1),
                    textAlign: TextAlign.center,
                    style: AppStyle.text2.copyWith(
                        color: AppColors.sonaGrey3,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              )),
        ),
      );
    }
  }
}
