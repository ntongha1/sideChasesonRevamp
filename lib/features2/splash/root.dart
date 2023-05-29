import 'dart:io';

import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart'
    as connectyCube;
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/user_type.dart';
import 'package:sonalysis/core/models/call/IncomingCallModel.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/response_message.dart';
import 'cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late bool isFirstTime;
  bool _isLogedin = false;
  UserResultData? userResultData;
  String? userID;
  late IncomingCallModel? incomingCallModel;

  @override
  void initState() {
    super.initState();
    //serviceLocator.get<LocalStorage>().clearAllExcept(LocalStorageKeys.kLoginEmailPrefs);
    //check user is loggedin
    _isLogedinCheck();
  }

  Future<bool> _isLogedinCheck() async {
    _isLogedin = (await serviceLocator
        .get<LocalStorage>()
        .readBool(LocalStorageKeys.kLoginPrefs))!;
    if (_isLogedin) {
      loadUserProfile();
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        serviceLocator
            .get<NavigationService>()
            .replaceWith(RouteKeys.routeOnboarding);
      });
    }
    return _isLogedin;
  }

  Future _checkFirstOpening() async {
    isFirstTime = await serviceLocator
            .get<LocalStorage>()
            .readBool(LocalStorageKeys.khasOpenedAppBeforeKey) ??
        false;
    if (isFirstTime)
      serviceLocator
          .get<LocalStorage>()
          .writeBool(LocalStorageKeys.khasOpenedAppBeforeKey, false);
  }

  loadUserProfile() async {
    userID = await serviceLocator
        .get<LocalStorage>()
        .readSecureString(LocalStorageKeys.kUIDPrefs);
    print(":::DDD:::" + userID!);
    _getUserProfile();
  }

  // data() async {
  //  //serviceLocator.get<LocalStorage>().clearAllExcept(LocalStorageKeys.kLoginEmailPrefs);
  //
  //     //ensure that the launch was not initiated by a call
  //     String? nameCaller = await serviceLocator.get<LocalStorage>().readString(
  //         LocalStorageKeys.kUserIncomingCallPrefsNameCaller);
  //     String? id = await serviceLocator.get<LocalStorage>().readString(
  //         LocalStorageKeys.kUserIncomingCallPrefsId);
  //     String? avatar = await serviceLocator.get<LocalStorage>().readString(
  //         LocalStorageKeys.kUserIncomingCallPrefsAvatar);
  //     String? callType = await serviceLocator.get<LocalStorage>().readString(
  //         LocalStorageKeys.kUserIncomingCallPrefsCallType);
  //     String? livekitToken = await serviceLocator.get<LocalStorage>().readString(
  //         LocalStorageKeys.kUserIncomingCallPrefsLiveKitToken);
  //   //print("ROOT: incomingCallModel is "+nameCaller.toString());
  //   if (nameCaller != null) {
  //     if (callType == "0") {
  //       serviceLocator.get<NavigationService>().replaceWithPameter(routeName: RouteKeys.routeAudioCallScreen, data: {
  //         "name": nameCaller,
  //         "userId": id,
  //         "imageUrl": avatar,
  //         "livekitToken": livekitToken,
  //         "isOnline": true,
  //         "isOutgoing": false
  //       });
  //     } else {
  //
  //     }
  //   }
  //   else {
  //     if (serviceLocator.isRegistered<LocalStorage>()) {
  //       await _isLogedinCheck();
  //     }
  //     Future.delayed(const Duration(seconds: 1), () {
  //       if (_isLogedin) {
  //         //checks
  //         //check if user has paid
  //         if (userResultData!.user!.emailVerified! == 0 || userResultData!.user!.paid! == 0) {
  //           serviceLocator.get<NavigationService>().clearAllTo(RouteKeys.routeWelcomeBackScreen);
  //         } else {
  //           //check role
  //           if (userResultData!.user!.role!.toLowerCase() == UserType.owner.type) {
  //             //club admin
  //             serviceLocator.get<NavigationService>().clearAllTo(RouteKeys.routeClubAdminDashboardScreen);
  //           }
  //           else if (userResultData!.user!.role!.toLowerCase() == UserType.coach.type || userResultData!.user!.role!.toLowerCase() == UserType.manager.type) {
  //             //coach
  //             if (userResultData!.user!.loginCount == 1) {
  //               serviceLocator.get<NavigationService>().clearAllTo(
  //                   RouteKeys.routeInitialUpdateProfileScreen);
  //             } else {
  //               serviceLocator.get<NavigationService>().clearAllTo(RouteKeys.routeCoachDashboardScreen);
  //             }
  //           } else {
  //             if (userResultData!.user!.loginCount == 1) {
  //               serviceLocator.get<NavigationService>().clearAllTo(RouteKeys.routeInitialUpdateProfileScreen);
  //             } else {
  //               serviceLocator
  //                   .get<NavigationService>()
  //                   .clearAllTo(RouteKeys.routePlayerDashboardScreen);
  //             }
  //           }
  //         }
  //
  //       } else {
  //         serviceLocator.get<NavigationService>().replaceWith(RouteKeys.routeOnboarding);
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          key: const Key('splash_screen'),
          decoration: BoxDecoration(gradient: AppColors.sonalysisGradient),
        ),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50.h),
            child: Image.asset(
              AppAssets.appIcon,
            ),
          ),
        ),
        BlocConsumer(
          bloc: serviceLocator.get<SplashCubit>(),
          listener: (_, state) {
            if (state is UpdateDeviceTokenLoading) {
              context.loaderOverlay.show();
            }

            if (state is UpdateDeviceTokenError) {
              context.loaderOverlay.hide();
              ResponseMessage.showErrorSnack(
                  context: context, message: state.message);
              serviceLocator
                  .get<NavigationService>()
                  .clearAllTo(RouteKeys.routeLoginScreen);
            }

            if (state is UpdateDeviceTokenSuccess) {
              context.loaderOverlay.hide();
              userResultData = serviceLocator.get<UserResultData>();
              print("loginCount: " + userResultData.toString());
              // print("loginCount2: "+userResultData!.authToken.toString());
              //store user details
              serviceLocator.get<LocalStorage>().writeSecureObject(
                  key: LocalStorageKeys.kUserPrefs, value: userResultData);
              Future.delayed(const Duration(seconds: 1), () {
                //checks
                //check role
                if (userResultData!.user!.role!.toLowerCase() ==
                    UserType.owner.type) {
                  if (userResultData!.user!.emailVerified! == 0 ||
                      userResultData!.user!.paid! == 0) {
                    //check if user has paid
                    serviceLocator
                        .get<NavigationService>()
                        .clearAllTo(RouteKeys.routeWelcomeBackScreen);
                  } else {
                    //club admin
                    serviceLocator
                        .get<NavigationService>()
                        .clearAllTo(RouteKeys.routeBottomNaviScreen);
                  }
                } else if (userResultData!.user!.role!.toLowerCase() ==
                        UserType.coach.type ||
                    userResultData!.user!.role!.toLowerCase() ==
                        UserType.manager.type ||
                    userResultData!.user!.role!.toLowerCase() ==
                        UserType.player.type) {
                  //coach || player
                  if (userResultData!.user!.profileUpdated == 0) {
                    serviceLocator
                        .get<NavigationService>()
                        .clearAllWithParameter(
                            routeName: RouteKeys.routeSetPasswordScreen,
                            data: {
                          "email": userResultData!.user!.email,
                        });
                  } else {
                    serviceLocator
                        .get<NavigationService>()
                        .clearAllTo(RouteKeys.routeBottomNaviScreen);
                  }
                } else {
                  if (userResultData!.user!.loginCount == 1) {
                    serviceLocator
                        .get<NavigationService>()
                        .clearAllTo(RouteKeys.routeInitialUpdateProfileScreen);
                  } else {
                    serviceLocator
                        .get<NavigationService>()
                        .clearAllTo(RouteKeys.routeBottomNaviScreen);
                  }
                }
              });
            }
          },
          builder: (_, state) {
            return const SizedBox();
          },
        )
      ],
    ));
  }

  Future<void> _getUserProfile() async {
    await serviceLocator<SplashCubit>().getUserProfile(userID);
  }
}
