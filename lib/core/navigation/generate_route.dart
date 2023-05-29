import 'package:sonalysis/core/navigation/keys.dart';
import 'package:flutter/material.dart';
import 'package:sonalysis/core/widgets/popup_screen.dart';
import 'package:sonalysis/features2/OTPScreen/otpScreenEmail.dart';
import 'package:sonalysis/features2/bottomNavi/bottomNavi.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/players_club_management/singleton/player_singleton.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/staff_club_management/singleton/staff_singleton.dart';
import 'package:sonalysis/features2/comparison/stats.dart';
import 'package:sonalysis/features2/inital_update_profile/screens/inital_update_profile3.dart';
import 'package:sonalysis/features2/onboarding/onboardingScreen.dart';
import 'package:sonalysis/features2/recover_password/screens/set_password.dart';
import 'package:sonalysis/features2/settings/root.dart';
import 'package:sonalysis/features2/signup/screens/createClubAccountEmail.dart';
import 'package:sonalysis/features2/signup/screens/createPlayerCoachAccountRevamp.dart';
import 'package:sonalysis/features2/signup/screens/socialMediasignup.dart';

import '../../features/common/call/audio_call/audio_call.dart';
import '../../features/common/messages/MessagesScreen.dart';
import '../../features/player/profile/profile_screen.dart';
import '../../features2/OTPScreen/otpScreen.dart';
import '../../features2/analytics/singleton/AnalysedVideosSingletonScreen.dart';
import '../../features2/club_management/ClubManagementScreen.dart';
import '../../features2/club_management/screen_tabs/teams_club_management/create_team_flow/createTeamFlow.dart';
import '../../features2/club_management/screen_tabs/teams_club_management/singleton/team_singleton.dart';
import '../../features2/inital_update_profile/root.dart';
import '../../features2/inital_update_profile/screens/inital_update_profile2.dart';
import '../../features2/login/root.dart';
import '../../features2/recover_password/root.dart';
import '../../features2/recover_password/screens/reset_password.dart';
import '../../features2/settings/widgets/personalInfoModalWidget.dart';
import '../../features2/signup/screens/choosePaymentMethod.dart';
import '../../features2/signup/screens/chooseSubscriptionPlan.dart';
import '../../features2/signup/screens/createClubAccount.dart';
import '../../features2/signup/screens/createPlayerCoachAccount.dart';
import '../../features2/signup/signupOption.dart';
import '../../features2/splash/root.dart';
import '../../features2/welcomeBack/welcomeBack.dart';

Route generateRoute(RouteSettings settings) {
  String routeName = settings.name ?? '';

  switch (routeName) {
    case RouteKeys.routeSplash:
      return MaterialPageRoute(builder: (_) => SplashScreen());
    case RouteKeys.routeOnboarding:
      return MaterialPageRoute(builder: (_) => OnboardingScreen());
    case RouteKeys.routeSignupOptionScreen:
      return MaterialPageRoute(builder: (_) => SignupOptionScreen());
    case RouteKeys.routeSignupSocialMediaScreen:
      Map args = settings.arguments as Map;
      return MaterialPageRoute(
          builder: (_) => SocialMediasignupScreen(data: args));
    case RouteKeys.routeCreateCLubAccountScreen:
      Map? args = settings.arguments as Map?;
      return MaterialPageRoute(
          builder: (_) => CreateClubAccountScreen(data: args));
    case RouteKeys.routeCreateCLubAccountEmailScreen:
      return MaterialPageRoute(builder: (_) => CreateClubAccountEmailScreen());
    case RouteKeys.routeChooseSubscriptionPlanScreen:
      return MaterialPageRoute(builder: (_) => ChooseSubscriptionPlanScreen());
    case RouteKeys.routeOTPScreen:
      Map? args = settings.arguments as Map?;
      return MaterialPageRoute(builder: (_) => OTPScreen(data: args));
    case RouteKeys.routeOTPScreenEmail:
      Map? args = settings.arguments as Map?;
      return MaterialPageRoute(builder: (_) => OTPScreenEmail(data: args));
    case RouteKeys.routeChoosePaymentMethodScreen:
      return MaterialPageRoute(builder: (_) => ChoosePaymentMethodScreen());
    case RouteKeys.routeWelcomeBackScreen:
      return MaterialPageRoute(builder: (_) => WelcomeBackScreen());
    case RouteKeys.routePlayerSingletonScreen:
      Map? args = settings.arguments as Map?;
      return MaterialPageRoute(
          builder: (_) => PlayerSingletonScreen(data: args));
    case RouteKeys.routeStaffSingletonScreen:
      Map? args = settings.arguments as Map?;
      return MaterialPageRoute(
          builder: (_) => StaffSingletonScreen(data: args));
    case RouteKeys.routeComparedStatsScreen:
      Map? args = settings.arguments as Map?;
      return MaterialPageRoute(builder: (_) => CompareStatsScreen(data: args));
    case RouteKeys.routeTeamSingletonScreen:
      Map? args = settings.arguments as Map?;
      return MaterialPageRoute(builder: (_) => TeamSingletonScreen(data: args));
    case RouteKeys.routeLoginScreen:
      return MaterialPageRoute(builder: (_) => LoginScreen());
    case RouteKeys.routeRecoverPasswordScreen:
      return MaterialPageRoute(builder: (_) => RecoverPasswordScreen());
    case RouteKeys.routeResetPasswordScreen:
      Map? args = settings.arguments as Map?;
      return MaterialPageRoute(builder: (_) => ResetPasswordScreen(data: args));
    case RouteKeys.routeSetPasswordScreen:
      Map? args = settings.arguments as Map?;
      return MaterialPageRoute(builder: (_) => SetPasswordScreen(data: args));
    case RouteKeys.routeCreatePlayerCoachAccount:
      return MaterialPageRoute(builder: (_) => CreatePlayerCoachAccount());
    case RouteKeys.routeCreatePlayerCoachAccountRevamp:
      Map args = settings.arguments as Map;
      return MaterialPageRoute(
          builder: (_) => CreateClubAccountScreenRevamp(
                data: args,
              ));
    case RouteKeys.routeBottomNaviScreen:
      return MaterialPageRoute(builder: (_) => BottomNaviScreen());
    case RouteKeys.routeCreateTeamFlowScreen:
      return MaterialPageRoute(builder: (_) => CreateTeamFlowScreen());
    case RouteKeys.routePopUpPageScreen:
      Map args = settings.arguments as Map;
      return MaterialPageRoute(
          builder: (_) => PopUpPageScreen(
              data: args)); // case RouteKeys// .registrationSuccess:
    case RouteKeys.routeProfileScreenPlayer:
      return MaterialPageRoute(builder: (_) => ProfileScreenPlayer());

    case RouteKeys.routeInitialUpdateProfileScreen:
      return MaterialPageRoute(builder: (_) => InitialUpdateProfileScreen());
    case RouteKeys.routeInitialUpdateProfileScreen2:
      return MaterialPageRoute(builder: (_) => InitialUpdateProfileScreen2());
    case RouteKeys.routeInitialUpdateProfileScreen3:
      return MaterialPageRoute(builder: (_) => InitialUpdateProfileScreen3());
    case RouteKeys.routeAnalysedVideosSingletonScreen:
      Map? args = settings.arguments as Map?;
      return MaterialPageRoute(
          builder: (_) => AnalysedVideosSingletonScreen(data: args));
    case RouteKeys.routeAudioCallScreen:
      Map args = settings.arguments as Map;
      return MaterialPageRoute(builder: (_) => AudioCall(data: args));
    case RouteKeys.routeSettingsScreen:
      return MaterialPageRoute(builder: (_) => MySettingsScreen());
    case RouteKeys.routeMessagesScreen:
      return MaterialPageRoute(builder: (_) => MessagesScreen());

    //   Map args = settings.arguments as Map;
    //   return MaterialPageRoute(builder: (_) =>  RegistrationSuccessScreen(data: args,));
    default:
      return MaterialPageRoute(
          builder: (_) => _ErrorScreen(routeName: routeName));
  }
}

class _ErrorScreen extends StatelessWidget {
  final String routeName;
  const _ErrorScreen({Key? key, required this.routeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Route '$routeName' does not exist"),
      ),
    );
  }
}
