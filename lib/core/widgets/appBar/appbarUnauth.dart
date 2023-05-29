import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sonalysis/core/utils/colors.dart';

import '../../navigation/navigation_service.dart';
import '../../startup/app_startup.dart';
import '../../utils/constants.dart';

class AppBarUnauth extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final String? photoUrl;
  final String? firstName;
  final String? lastName;
  final String? club;
  final String? role;
  final Color? leadColor;
  final bool cancel;
  final TextStyle? titleStyle;
  final Widget? action;
  const AppBarUnauth({
    Key? key,
    this.titleText,
    this.photoUrl,
    this.firstName,
    this.lastName,
    this.club,
    this.role,
    this.titleStyle,
    this.cancel = false,
    this.action,
    this.leadColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [],
      centerTitle: false,
      title: Row(
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
                  ))
              : SizedBox.shrink(),
          Expanded(child: SizedBox.shrink()),
          // Container(
          //   height: 27.w,
          //   width: 70.h,
          //   decoration: BoxDecoration(
          //       color: AppColors.sonaGrey6,
          //       borderRadius: BorderRadius.circular(30)),
          //   padding: EdgeInsets.all(0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       CircleAvatar(
          //           backgroundColor: AppColors.sonaGrey6,
          //           child: ClipOval(
          //             child: Image.network(
          //               "http://www.geonames.org/flags/x/us.gif",
          //               fit: BoxFit.fill,
          //               repeat: ImageRepeat.noRepeat,
          //               width: 17.w,
          //               height: 14.h,
          //             ),
          //           )),
          //       Padding(
          //         padding: EdgeInsets.all(5),
          //         child: Icon(
          //           Boxicons.bx_chevron_down,
          //           color: AppColors.sonaBlack2,
          //           size: 15,
          //         ),
          //       )
          //     ],
          //   ),
          //   // child: AppDropdownModal(
          //   //   options: languages!,
          //   //   value: selectedLanguage,
          //   //   hasSearch: true,
          //   //   onChanged: (val) {
          //   //     selectedLanguage = val as SimpleDropDownModel;
          //   //     context.setLocale(Locale('en', 'US'));
          //   //     print(context.locale.toString());
          //   //     setState(() {});
          //   //   },
          //   //   modalHeight: MediaQuery.of(context).size.height * 0.9,
          //   //   // hint: 'Select an option',
          //   //   headerText: "",
          //   // ),
          // ),
          SizedBox(width: 15),
          // InkWell(
          //     onTap: () {

          //     },
          //     child:Card(
          //       semanticContainer: true,
          //       clipBehavior: Clip.antiAliasWithSaveLayer,
          //       elevation: 5.0,
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppConstants.circularRadius))),
          //       child: Container(
          //           padding: EdgeInsets.all(7),
          //           child: Icon(
          //             Boxicons.bxs_moon,
          //             color: AppColors.sonaBlack2,
          //             size: 15,
          //           )
          //       ),
          //     )),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
