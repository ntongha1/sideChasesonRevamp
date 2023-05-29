import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/styles.dart';

import '../../../features2/settings/widgets/personalInfoModalWidget.dart';
import '../../../helpers/helpers.dart';
import '../../enums/user_type.dart';
import '../../models/response/UserResultModel.dart';
import '../../navigation/keys.dart';
import '../../navigation/navigation_service.dart';
import '../../startup/app_startup.dart';
import '../../utils/constants.dart';

class AppBarAuth extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final String? photoUrl;
  final String? firstName;
  final String? lastName;
  final String? club;
  final String? role;
  final Color? leadColor;
  final bool cancel;
  final bool notificationPage;
  final bool settingsPage;
  final TextStyle? titleStyle;
  final TextAlign? titleAlign;
  final UserResultData? userResultData;
  final Widget? action;
  const AppBarAuth({
    Key? key,
    required this.titleText,
    this.photoUrl,
    this.firstName,
    this.lastName,
    this.club,
    this.role,
    this.titleStyle,
    this.titleAlign = TextAlign.center,
    required this.userResultData,
    this.cancel = false,
    this.notificationPage = false,
    this.settingsPage = false,
    this.action,
    this.leadColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [],
        centerTitle: false,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Navigator.canPop(context)
                  ? InkWell(
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
                    )
                  : SizedBox.shrink(),
              !Navigator.canPop(context)
                  ? Container(
                      child: InkWell(
                          onTap: () {
                            // if (userResultData!.user!.role!.toLowerCase() ==
                            //     UserType.player.type) {
                            //   bottomSheet(context, PersonalInfoModalWidget());
                            // } else if (userResultData!.user!.role!
                            //             .toLowerCase() ==
                            //         UserType.coach.type ||
                            //     userResultData!.user!.role!.toLowerCase() ==
                            //         UserType.manager.type) {
                            //   bottomSheet(context, PersonalInfoModalWidget());
                            // } else {
                            //   bottomSheet(context, PersonalInfoModalWidget());
                            // }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  // userResultData == null ||
                                  //         userResultData!.user!.photo == null ||
                                  //         !Uri.parse(
                                  //                 userResultData!.user!.photo!)
                                  //             .isAbsolute
                                  //     ? AppConstants.defaultProfilePictures
                                  //     : userResultData!.user!.photo!,
                                  AppConstants.defaultProfilePictures,
                                  fit: BoxFit.cover,
                                  repeat: ImageRepeat.noRepeat,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userResultData != null
                                        ? userResultData!.user!.firstName!
                                        : "",
                                    style: AppStyle.text1.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.sonaBlack,
                                    ),
                                  ),
                                  Text(
                                    userResultData!.user!.role == "owner"
                                        ? "Club Admin".tr()
                                        : userResultData!.user!.role!,
                                    style: AppStyle.text1.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.sonaGrey3,
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          )))
                  : SizedBox.shrink(),
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 0.w), child: Container()

                      // Text(
                      //   titleText,
                      //   textAlign: titleAlign,
                      //   style: AppStyle.h3.copyWith(
                      //       color: AppColors.sonaBlack2,
                      //       fontWeight: FontWeight.w400,
                      //       fontSize: 18.sp),
                      // ),
                      )),
              // InkWell(
              //   onTap: () {},
              //   child: Container(
              //     padding: EdgeInsets.all(0),
              //     child: SvgPicture.asset(
              //       "assets/svgs/bell_icon.svg",
              //       width: 20,
              //       height: 20,
              //     ),
              //   ),
              // ),
              SizedBox(
                width: 30,
              ),
              InkWell(
                onTap: !settingsPage
                    ? () {
                        serviceLocator
                            .get<NavigationService>()
                            .to(RouteKeys.routeSettingsScreen);
                      }
                    : null,
                child: Container(
                  padding: EdgeInsets.all(0),
                  child: SvgPicture.asset(
                    "assets/svgs/settings_icon.svg",
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
