import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/models/response/TeamsListResponseModel.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/images.dart';

import '../core/navigation/keys.dart';
import '../core/navigation/navigation_service.dart';
import '../core/startup/app_startup.dart';
import '../core/utils/styles.dart';

class TeamGridItem extends StatelessWidget {
  final TeamsListResponseModelData? teamsListResponseModelItem;
  final Function? onTap;
  final Function? onRefresh;

  const TeamGridItem(
      {Key? key, this.teamsListResponseModelItem, this.onTap, this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
            color: AppColors.sonaGrey6,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: InkWell(
            onTap: () {
              print(teamsListResponseModelItem!.clubId);
              var teamData = {
                "teamID": teamsListResponseModelItem!.id,
                "clubId": teamsListResponseModelItem!.clubId,
                "teamName": teamsListResponseModelItem!.teamName,
                "totalPlayers": teamsListResponseModelItem!.totalPlayers,
                "totalStaff": teamsListResponseModelItem!.totalStaff,
                "teamSelf": teamsListResponseModelItem
              };

              serviceLocator
                  .get<NavigationService>()
                  .toWithPameter(
                      routeName: RouteKeys.routeTeamSingletonScreen,
                      data: teamData)
                  .then((value) {
                print("refreshing step 0");
                if (onRefresh != null) {
                  print("refreshing step 2");
                  onRefresh!();
                }
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.sonaBlack,
                    child: ClipOval(
                      child: Image.network(
                        teamsListResponseModelItem!.photo == null ||
                                teamsListResponseModelItem!.photo == "null" ||
                                teamsListResponseModelItem!.photo == ""
                            ? AppConstants.defaultProfilePictures
                            : teamsListResponseModelItem!.photo!,
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.noRepeat,
                        width: 40.w,
                        height: 40.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                    child: Text(
                  teamsListResponseModelItem!.teamName!,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppStyle.text1.copyWith(
                      color: AppColors.sonaBlack, fontWeight: FontWeight.w400),
                )),
                SizedBox(height: 10.h),
                Text(
                  teamsListResponseModelItem!.totalPlayers!.toString() +
                      " Player(s)".tr(),
                  textAlign: TextAlign.center,
                  style: AppStyle.text1.copyWith(
                      color: AppColors.sonaBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp),
                ),
                SizedBox(height: 10.h),
                Text(
                  teamsListResponseModelItem!.totalStaff!
                          .toString()
                          .toString() +
                      " Staff".tr(),
                  textAlign: TextAlign.center,
                  style: AppStyle.text1.copyWith(
                      color: AppColors.sonaGrey3,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp),
                ),
              ],
            )),
      ),
    );
  }
}
