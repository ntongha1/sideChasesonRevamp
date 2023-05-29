//Routes
import 'package:sonalysis/model/availabelRoles.dart';

const String routeSplash = "/";
const String routeOnboarding = "/OnboardingPage";
const String routeSelectRole = "/SelectRole";
const String routeLoginScreen = "/loginScreen";
const String routeRecoverPasswordScreen = "/recoverPasswordScreen";
const String routeResetPasswordScreen = "/resetPasswordScreen";
const String routeRegisterClubScreen = "/routeRegisterClubScreen";
const String routeRegisterPlayerScreen = "/routeRegisterPlayerScreen";
const String routeClubManagementProfile = "/routeClubManagementProfile";
const String routePopUpPageScreen = "/popUpPageScreen";
const String routeProfileScreenPlayer = "/profileScreenPlayer";
const String routeProfileScreenCoach = "/profileScreenCoach";
const String routeProfileScreenClubAdmin = "/profileScreenClubAdmin";
const String routePlayerDashboardScreen = "/playerDashboardScreen";
const String routeCoachDashboardScreen = "/coachDashboardScreen";
const String routeProfileInnerScreen = "/profileInnerScreen";
const String routeClubManagementScreen = "/clubManagementScreen";
const String routeClubDashboardScreen = "/clubDashboardScreen";
const String routeAnalysedVideosSingletonScreen = "/analysedVideosSingletonScreen";


const String defaultProfilePictures = "https://i.ibb.co/tqqcpHj/933-9332131-profile-picture-default-png.jpg";


//strings
const String imagesDir = "assets/images";
const String lottieDir = "assets/lottie_files";

const String appName = "Sonalysis";
const String appLogo = imagesDir+"/logo.png";
const String ONBOARDING_SCREEN_01_IMAGE = "/onboardBg1.png";
const String ONBOARDING_SCREEN_02_IMAGE = "/onboardBg2.png";
const String ONBOARDING_SCREEN_03_IMAGE = "/onboardBg3.png";
const String ONBOARDING_SCREEN_04_IMAGE = "/onboardBg4.png";
const AVAILABLE_ROLES = [
  AvailableRoles(
    id: 1,
    name: "coach",
    image: '/role1.png',
  ),
  AvailableRoles(
    id: 2,
    name: "player",
    image: '/role2.png',
  ),
  AvailableRoles(
    id: 3,
    name: "analyst",
    image: '/role3.png',
  ),
  AvailableRoles(
    id: 4,
    name: "fan",
    image: '/role4.png',
  ),
];


//Errors
const teamName_error = "Team Name is not valid.";
const clubName_error = "Club Name is not valid.";
const email_error = "Email is not valid.";
const video_link_error = "Video Link is not valid.";
const password_error = "Password is required";
const userName_error = "Email/Username is not valid.";
const firstName_error = "First name is not valid.";
const jerseyNumber_error = "Jersey Number is not valid.";
const lastName_error = "Last name is not valid.";
const abbrClubName_error = "Abbreviated Club is not valid.";
const middleName_error = "Middle name is not valid.";
const phoneNumber_error = "Phone number is not valid.";
const code_error = "Code is not valid.";
const address_error = "Address is not valid.";
const city_error = "City is not valid.";
const country_error = "Country is not valid.";
const state_error = "State is not valid.";
const bvn_error = "BVN is not valid.";
const account_number_error = "Account Number is not valid.";
const place_of_birth_error = "place of birth is not valid.";
const state_of_origin_error = "state of birth is not valid.";
const date_of_birth_error = "date of birth is not valid.";
const gender_error = "gender is required";
const nationality_error = "nationality is required";
const password_error_min_length = "Password should be at least 3 symbols long.";
const password_error_max_length = "Password should be at most 8 symbols long.";
const password_error_capital_letter =
    "Password should contain a capital letter.";
const password_error_mismatch = "Password does not match";
const password_error_small_letter = "Password should contain a small letter.";
const password_error_digit = "Password should contain a digit";
const password_error_special_character = "Password should contain a special character";