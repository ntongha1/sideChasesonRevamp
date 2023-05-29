import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/models/response/StaffListResponseModel.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/helpers.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/staff_club_management/add_edit_staff/addEditStaff.dart';

import '../core/models/response/TeamsListResponseModel.dart';
import '../core/utils/styles.dart';
import '../features/common/models/StaffInATeamModel.dart';

class StaffGridItem extends StatelessWidget {
  final TeamsListResponseModelStaff? teamsListResponseModelStaff;
  final StaffListResponseModelData? staffListResponseModelData;
  final Staff? staffInATeamModelData;
  final Function? onTap;
  final TeamsSingleModel? teams;

  const StaffGridItem(
      {Key? key,
      this.teamsListResponseModelStaff,
      this.staffListResponseModelData,
      this.staffInATeamModelData,
      this.onTap,
      this.teams})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (teamsListResponseModelStaff == null && staffInATeamModelData == null) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
              color: AppColors.sonaGrey6,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: InkWell(
              onTap: () {
                onTap!();
                // serviceLocator.get<NavigationService>().toWithPameter(routeName: RouteKeys.routeStaffSingletonScreen, data: {
                //   "playerListResponseModelData" : playerListResponseModelData!
                // });
                ////
                // pushNewScreen(
                //   context,
                //   screen: StaffSingletonScreen(),
                //   withNavBar: false, // OPTIONAL VALUE. True by default.
                //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                // );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      alignment: Alignment.center,
                      //margin: const EdgeInsets.symmetric(vertical: 5),
                      //padding: const EdgeInsets.all(13),
                      child: CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.sonaBlack,
                          child: ClipOval(
                            child: Image.network(
                              staffListResponseModelData!.user!.photo == null
                                  ? AppConstants.defaultProfilePictures
                                  : staffListResponseModelData!.user!.photo!,
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
                    (staffListResponseModelData!.user!.firstName! +
                            " " +
                            staffListResponseModelData!.user!.lastName!)
                        .capitalizeFirstofEach,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppStyle.text2.copyWith(
                        color: AppColors.sonaBlack,
                        fontWeight: FontWeight.w400),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    staffListResponseModelData!.role!,
                    textAlign: TextAlign.center,
                    style: AppStyle.text2.copyWith(
                        color: AppColors.sonaBlack,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400),
                  )
                ],
              )),
        ),
      );
    } else if (staffListResponseModelData == null &&
        staffInATeamModelData == null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
              color: AppColors.sonaGrey6,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: InkWell(
              onTap: () {
                // serviceLocator.get<NavigationService>().toWithPameter(routeName: RouteKeys.routeStaffSingletonScreen, data: {
                //   "playerListResponseModelData" : playerListResponseModelData!
                // });
                ////
                // pushNewScreen(
                //   context,
                //   screen: StaffSingletonScreen(),
                //   withNavBar: false, // OPTIONAL VALUE. True by default.
                //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                // );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      alignment: Alignment.center,
                      //margin: const EdgeInsets.symmetric(vertical: 5),
                      //padding: const EdgeInsets.all(13),
                      height: 70,
                      child: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.sonaBlack,
                          child: ClipOval(
                            child: Image.network(
                              teamsListResponseModelStaff!.user!.photo == null
                                  ? AppConstants.defaultProfilePictures
                                  : teamsListResponseModelStaff!.user!.photo!,
                              fit: BoxFit.cover,
                              repeat: ImageRepeat.noRepeat,
                              width: 55.w,
                              height: 55.h,
                            ),
                          ))),
                  SizedBox(
                      width: 80.0,
                      child: Text(
                        teamsListResponseModelStaff!.user!.firstName!
                                .substring(0, 1)
                                .toUpperCase() +
                            teamsListResponseModelStaff!.user!.firstName!
                                .substring(1) +
                            " " +
                            teamsListResponseModelStaff!.user!.lastName!
                                .substring(0, 1)
                                .toUpperCase() +
                            teamsListResponseModelStaff!.user!.lastName!
                                .substring(1),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style:
                            AppStyle.text2.copyWith(color: AppColors.sonaBlack),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        teamsListResponseModelStaff!.role!,
                        textAlign: TextAlign.center,
                        style: AppStyle.text2.copyWith(
                            color: AppColors.sonaBlack, fontSize: 12.sp),
                      ))
                ],
              )),
        ),
      );
    } else {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
              color: AppColors.sonaGrey6,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: InkWell(
              onTap: () {
                // serviceLocator.get<NavigationService>().toWithPameter(routeName: RouteKeys.routeStaffSingletonScreen, data: {
                //   "playerListResponseModelData" : playerListResponseModelData!
                // });
                ////
                // pushNewScreen(
                //   context,
                //   screen: StaffSingletonScreen(),
                //   withNavBar: false, // OPTIONAL VALUE. True by default.
                //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                // );

                this.onTap!();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     bottomSheet(
                  //         context,
                  //         AddEditStaffScreen(
                  //             type: "edit",
                  //             playerID: staffInATeamModelData!.userId!));
                  //   },
                  //   child: Container(
                  //     margin: const EdgeInsets.only(right: 15),
                  //     child: Align(
                  //         alignment: Alignment.topRight,
                  //         child: Icon(
                  //           Icons.more_vert,
                  //           color: AppColors.sonaBlack2,
                  //         )),
                  //   ),
                  // ),
                  Container(
                      alignment: Alignment.center,
                      //margin: const EdgeInsets.symmetric(vertical: 5),
                      //padding: const EdgeInsets.all(13),
                      // height: 70,
                      child: CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.sonaBlack,
                          child: ClipOval(
                            child: Image.network(
                              staffInATeamModelData!.user!.photo == null ||
                                      staffInATeamModelData!.user!.photo ==
                                          "" ||
                                      staffInATeamModelData!.user!.photo ==
                                          "null"
                                  ? AppConstants.defaultProfilePictures
                                  : staffInATeamModelData!.user!.photo!,
                              fit: BoxFit.cover,
                              repeat: ImageRepeat.noRepeat,
                              width: 40.w,
                              height: 40.h,
                            ),
                          ))),
                  SizedBox(height: 10),
                  SizedBox(
                      child: Text(
                    staffInATeamModelData!.user!.firstName!
                            .substring(0, 1)
                            .toUpperCase() +
                        staffInATeamModelData!.user!.firstName!.substring(1) +
                        " " +
                        staffInATeamModelData!.user!.lastName!
                            .substring(0, 1)
                            .toUpperCase() +
                        staffInATeamModelData!.user!.lastName!.substring(1),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppStyle.text1.copyWith(
                        color: AppColors.sonaBlack,
                        fontWeight: FontWeight.w400),
                  )),
                  SizedBox(height: 10),
                  Text(
                    staffInATeamModelData!.role!,
                    textAlign: TextAlign.center,
                    style: AppStyle.text2.copyWith(
                        color: AppColors.sonaBlack,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400),
                  )
                ],
              )),
        ),
      );
    }
  }
}
