import 'dart:io';

import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SonaSubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final bool showLead;
  final Color? leadColor;
  final bool cancel;
  final TextStyle? titleStyle;
  final Widget? action;
  final Widget? lead;
  final bool centerTitle;
  const SonaSubAppBar({
    Key? key,
    this.titleText,
    this.titleStyle,
    this.showLead = true,
    this.cancel = false,
    this.action,
    this.leadColor,
    this.centerTitle = true,
    this.lead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: showLead
          ? lead ??
              IconButton(
                icon: Icon(
                  Platform.isIOS
                      ? Icons.arrow_back_ios
                      : Icons.arrow_back_outlined,
                  color: leadColor ?? const Color(0xFF242F40),
                ),
                onPressed: () => serviceLocator<NavigationService>().pop(),
              )
          : const SizedBox(),
      backgroundColor: Colors.transparent,
      actions: [action ?? const SizedBox()],
      centerTitle: centerTitle,
      title: titleText == null
          ? null
          : Text(
              titleText!,
              style: titleStyle ??
                  TextStyle(
                    color: Colors.white,
                    fontSize: 18.0.sp,
                    height: 1,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}


// Widget kAppBar(String? titleText, bool showLead,bool cancel, Widget? action){
//   return AppBar(
//     elevation: 0,
//     leading: showLead
//         ? IconButton(
//       icon: Icon(
//         Platform.isIOS
//             ? Icons.arrow_back_ios
//             : Icons.arrow_back_outlined,
//         color: const Color(0xFF242F40),
//       ),
//       onPressed: () => serviceLocator.get<NavigationService>().pop(),
//     )
//         : const SizedBox(),
//     backgroundColor: Colors.transparent,
//     actions: [action ?? const SizedBox()],
//     centerTitle: true,
//     title: titleText == null
//         ? null
//         : Text(titleText!,
//         style: const TextStyle(
//           fontWeight: FontWeight.w400,
//           color: Colors.yellow,
//         )),
//   );
// }