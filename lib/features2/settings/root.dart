import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sonalysis/core/datasource/local_data_cubit.dart';
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/enums/user_type.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/helpers.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/widgets/app_dropdown_modal.dart';

import '../../core/models/language.dart';
import '../../core/navigation/keys.dart';
import '../../core/utils/styles.dart';
import '../../core/widgets/appBar/appbarAuth.dart';
import '../../core/widgets/button.dart';
import 'widgets/personalInfoModalWidget.dart';

class MySettingsScreen extends StatefulWidget {
  @override
  _MySettingsScreenState createState() => _MySettingsScreenState();
}

class _MySettingsScreenState extends State<MySettingsScreen> {
  bool nightModeOn = false, notifications = false;
  UserResultData? userResultData;
  Color? lightModeBgColor = Colors.white, darkModeBgColor = AppColors.sonaBlack;
  Color? lightFontColor = Colors.black, darkFontColor = Colors.white;
  PackageInfo? packageInfo;
  Languages? selectedLanguage;
  final List<Languages>? languages = [
    Languages(name: "English (US)"),
    Languages(name: "Italian"),
  ];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    packageInfo = await PackageInfo.fromPlatform();
    await serviceLocator<LocalDataCubit>().getLocallyStoredUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: serviceLocator.get<LocalDataCubit>(),
        listener: (_, state) {
          if (state is GetLocallyStoredUserDataLoading) {
            //context.loaderOverlay.show();
            isLoading = true;
            setState(() {});
          }

          if (state is GetLocallyStoredUserDataError) {
            //context.loaderOverlay.hide();
            isLoading = false;
            ResponseMessage.showErrorSnack(
                context: context, message: state.message);
            setState(() {});
          }

          if (state is GetLocallyStoredUserDataSuccess) {
            //context.loaderOverlay.hide();
            setState(() {
              userResultData = serviceLocator.get<UserResultData>();
              isLoading = false;
              //print("filename:::::: "+videoListResponseModel!.data!.videosListResponseModelData![0].filename.toString());
            });
            // print("Token: "+userResultData!.authToken.toString());
            // print("id: "+userResultData!.user!.id.toString());
            // print("clubId: "+userResultData!.user!.clubs!.length.toString());
            // print("photo: "+userResultData!.user!.photo.toString());
          }
        },
        child: isLoading
            ? Container()
            : Scaffold(
                backgroundColor:
                    nightModeOn ? darkModeBgColor : lightModeBgColor,
                appBar: AppBarAuth(
                    titleText: "Settings".tr(),
                    userResultData: userResultData,
                    settingsPage: true),
                body: SingleChildScrollView(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text("Change password".tr(),
                        //     style: AppStyle.text2.copyWith(
                        //         color: AppColors.sonaBlack2,
                        //         fontWeight: FontWeight.w400)),
                        // SizedBox(height: 5.h),
                        // Text(
                        //     "You can change your already existing password"
                        //         .tr(),
                        //     style: AppStyle.text1.copyWith(
                        //         color: AppColors.sonaGrey3,
                        //         fontWeight: FontWeight.w400)),
                        // Text(
                        //     "(You will be logged out to complete this process)"
                        //         .tr(),
                        //     style: AppStyle.text1.copyWith(
                        //         color: AppColors.sonaRed,
                        //         fontWeight: FontWeight.w600)),
                        // SizedBox(height: 20),
                        // SizedBox(
                        //     width: MediaQuery.of(context).size.width * 0.4,
                        //     height: 35.h,
                        //     child: AppButton(
                        //         buttonText: "Change password".tr(),
                        //         buttonType: ButtonType.secondary,
                        //         onPressed: () {
                        //           serviceLocator
                        //               .get<NavigationService>()
                        //               .toWithPameter(
                        //                   routeName: RouteKeys.routeOTPScreen,
                        //                   data: {
                        //                 "email": userResultData!.user!.email,
                        //                 "routeName":
                        //                     RouteKeys.routeResetPasswordScreen,
                        //                 "sendOTPOnload": true,
                        //                 "pageType": "passwordReset",
                        //                 "successTitle":
                        //                     "OTP Verified Successfully".tr(),
                        //                 "successSubTitle":
                        //                     "Proceed to reset your password"
                        //                         .tr(),
                        //               });
                        //         })),
                        // SizedBox(height: 15),
                        // Divider(
                        //   thickness: 1.0,
                        //   color: AppColors.sonaGrey6,
                        // ),
                        // SizedBox(height: 10),
                        // Text("Change email".tr(),
                        //     style: AppStyle.text2.copyWith(
                        //         color: AppColors.sonaBlack2,
                        //         fontWeight: FontWeight.w400)),
                        // SizedBox(height: 5.h),
                        // Text("You can change your already existing email".tr(),
                        //     style: AppStyle.text1.copyWith(
                        //         color: AppColors.sonaGrey3,
                        //         fontWeight: FontWeight.w400)),
                        // Text("(Not available)".tr(),
                        //     style: AppStyle.text1.copyWith(
                        //         color: AppColors.sonaRed,
                        //         fontWeight: FontWeight.w600)),
                        // SizedBox(height: 20),
                        // SizedBox(
                        //     width: MediaQuery.of(context).size.width * 0.4,
                        //     height: 35.h,
                        //     child: AppButton(
                        //         buttonText: "Change email".tr(),
                        //         buttonType: ButtonType.secondary,
                        //         onPressed: null)),
                        // SizedBox(height: 20),
                        // Divider(
                        //   thickness: 1.0,
                        //   color: AppColors.sonaGrey6,
                        // ),
                        SizedBox(height: 20),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //         child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text("Notifications".tr(),
                        //             style: AppStyle.text2.copyWith(
                        //                 color: AppColors.sonaBlack2,
                        //                 fontWeight: FontWeight.w400)),
                        //         Text("Receive notifications in your mail".tr(),
                        //             style: AppStyle.text1.copyWith(
                        //                 color: AppColors.sonaGrey3,
                        //                 fontWeight: FontWeight.w400)),
                        //       ],
                        //     )),
                        //     FlutterSwitch(
                        //       width: 50.0,
                        //       height: 25.0,
                        //       valueFontSize: 12.0,
                        //       toggleSize: 25.0,
                        //       value: notifications,
                        //       borderRadius: 20.0,
                        //       padding: 4.0,
                        //       showOnOff: false,
                        //       activeColor: AppColors.sonalysisBabyBlue,
                        //       onToggle: (val) {
                        //         setState(() {
                        //           notifications = val;
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 20),
                        // Divider(
                        //   thickness: 1.0,
                        //   color: AppColors.sonaGrey6,
                        // ),
                        SizedBox(height: 20),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //         child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text("Appearance".tr(),
                        //             style: AppStyle.text2.copyWith(
                        //                 color: AppColors.sonaBlack2,
                        //                 fontWeight: FontWeight.w400)),
                        //         Text(
                        //             "Customize how the app looks on your device"
                        //                 .tr(),
                        //             style: AppStyle.text1.copyWith(
                        //                 color: AppColors.sonaGrey3,
                        //                 fontWeight: FontWeight.w400)),
                        //       ],
                        //     )),
                        //     FlutterSwitch(
                        //       width: 50.0,
                        //       height: 25.0,
                        //       valueFontSize: 12.0,
                        //       toggleSize: 25.0,
                        //       value: nightModeOn,
                        //       borderRadius: 20.0,
                        //       padding: 4.0,
                        //       showOnOff: false,
                        //       activeColor: AppColors.sonalysisBabyBlue,
                        //       onToggle: (val) {
                        //         setState(() {
                        //           nightModeOn = val;
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 20),
                        // Divider(
                        //   thickness: 1.0,
                        //   color: AppColors.sonaGrey6,
                        // ),
                        SizedBox(height: 20),
                        Stack(
                          fit: StackFit.passthrough,
                          children: [
                            // Row(
                            //   children: [
                            //     Expanded(
                            //         child: Column(
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Text("Language".tr(),
                            //                 style: AppStyle.text2.copyWith(
                            //                     color: AppColors.sonaBlack2,
                            //                     fontWeight: FontWeight.w400)),
                            //             Text("Customize Sonalysis language".tr(),
                            //                 style: AppStyle.text1.copyWith(
                            //                     color: AppColors.sonaGrey3,
                            //                     fontWeight: FontWeight.w400)),
                            //           ],
                            //         )),
                            //     Container(
                            //       height: 27.w,
                            //       width: 50.h,
                            //       decoration: BoxDecoration(
                            //           color: AppColors.sonaGrey6,
                            //           borderRadius: BorderRadius.circular(30)),
                            //       padding: EdgeInsets.all(0),
                            //       child: Row(
                            //         mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //         crossAxisAlignment: CrossAxisAlignment.center,
                            //         children: [
                            //           CircleAvatar(
                            //               backgroundColor: AppColors.sonaGrey6,
                            //               child: ClipOval(
                            //                 child: Image.network(
                            //                   "http://www.geonames.org/flags/x/us.gif",
                            //                   fit: BoxFit.fill,
                            //                   repeat: ImageRepeat.noRepeat,
                            //                   width: 17.w,
                            //                   height: 14.h,
                            //                 ),
                            //               )),
                            //           Padding(
                            //             padding: EdgeInsets.all(5),
                            //             child: Icon(
                            //               Boxicons.bx_chevron_down,
                            //               color: AppColors.sonaBlack2,
                            //               size: 15,
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Opacity(
                              opacity: 0,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: AppDropdownModal(
                                  options: languages!,
                                  value: selectedLanguage,
                                  hasSearch: true,
                                  onChanged: (val) {
                                    selectedLanguage = val as Languages;
                                    context.setLocale(Locale('en', 'US'));
                                    print(context.locale.toString());
                                    setState(() {});
                                  },
                                  modalHeight:
                                      MediaQuery.of(context).size.height * 0.9,
                                  // hint: 'Select an option',
                                  headerText: "",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(
                          thickness: 1.0,
                          color: AppColors.sonaGrey6,
                        ),
                        SizedBox(height: 10),
                        Text("version: " + packageInfo!.version,
                            style: AppStyle.text2.copyWith(
                                color: AppColors.sonaBlack2,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 30),
                        Center(
                            child: InkWell(
                                onTap: () {
                                  logoutDialog(context, "Logout".tr(),
                                      "are_you_sure_you_want_to_logout".tr());
                                },
                                child: Text("Logout".tr(),
                                    style: AppStyle.text2.copyWith(
                                        color: AppColors.sonaRed,
                                        fontWeight: FontWeight.w400)))),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
