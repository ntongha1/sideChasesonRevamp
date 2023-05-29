import 'package:sonalysis/core/config/config.dart';

class ApiConstants {
  static String paystackPublicKey = 'pk_test_';
  static const String verifyPaystackPayment =
      "https://api.paystack.co/transaction/verify/";

  //static const String baseUrl="http://api.sonalysis.io:4001/";
  static const String baseUrl = "http://api.sonalysis.io:90/";
  static const String baseUrlOld = "http://api.sonalysis.io:3001/";
  static const String liveKitUrl = "wss://livekit.sonalysis.io";
  static const String liveKitToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2ODEzNTYxNTQsImlzcyI6IkFQSWtMdks4M2FpVDVRNyIsImp0aSI6InRvbnlfc3RhcmsiLCJuYW1lIjoiVG9ueSBTdGFyayIsIm5iZiI6MTY0NTM1NjE1NCwic3ViIjoidG9ueV9zdGFyayIsInZpZGVvIjp7InJvb20iOiJzdGFyay10b3dlciIsInJvb21Kb2luIjp0cnVlfX0.oQ8_VFMzru8T-oKTq353TCuyl1uLO9TdK5kg-XQdu-0";
  static const String rapidApiToken =
      'f2017915d2msh86f10fe38a4c896p13d436jsnee3e8fe30a2a';

  ApiConstants() {
    if (AppConfig.environment == Environment.production) {
      String paystackPublicKey = 'pk_test_';
      const String verifyPaystackPayment =
          "https://api.paystack.co/transaction/verify/";

      const String baseUrl = "http://api.sonalysis.io:4001/";
      const String liveKitUrl = "wss://livekit.sonalysis.io";
      const String liveKitToken =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2ODEzNTYxNTQsImlzcyI6IkFQSWtMdks4M2FpVDVRNyIsImp0aSI6InRvbnlfc3RhcmsiLCJuYW1lIjoiVG9ueSBTdGFyayIsIm5iZiI6MTY0NTM1NjE1NCwic3ViIjoidG9ueV9zdGFyayIsInZpZGVvIjp7InJvb20iOiJzdGFyay10b3dlciIsInJvb21Kb2luIjp0cnVlfX0.oQ8_VFMzru8T-oKTq353TCuyl1uLO9TdK5kg-XQdu-0";
    }
  }

  static String getFixturesbyDate =
      'https://api-football-beta.p.rapidapi.com/fixtures?';
  static String getFixturesbyDateSonaBackend =
      "${baseUrl}analytics/fixtures/rapid?";
  static String getAllLeagues =
      'https://api-football-beta.p.rapidapi.com/leagues';
  static String getFixtureByID =
      'https://api-football-beta.p.rapidapi.com/fixtures/players?fixture=';

  static String getFixtureByIDSonaBackend =
      "${baseUrl}analytics/fixtures/players?fixture=";

  static String getFixtureByTeamID =
      'https://api-football-beta.p.rapidapi.com/fixtures/statistics?';

  static String registerUrl = '${baseUrl}users/signup';
  static String loginUrl = '${baseUrl}users/login';
  static String find = '${baseUrl}rooms/find';
  static String createRoom = '${baseUrl}rooms';
  static String addParticipant = '${baseUrl}rooms/';
  static String fetchAllTeams = '${baseUrl}teams?club_id=';
  static String fetchSingleTeam = '${baseUrl}teams/';
  static String fetchPlayerVerifyImage = '${baseUrl}analytics/';
  static String fetchSinglePlayerProfile = '${baseUrl}players/';
  static String fetchSingleStaffProfile = '${baseUrl}staffs/';
  static String submitTeamVerify = '${baseUrl}analytics/';
  static String teamCategories = '${baseUrl}categories';
  static String createTeam = '${baseUrl}teams';
  static String updateTeam = '${baseUrl}teams/';
  static String createPlayer = '${baseUrl}players';
  static String addPlayerToTeam = '${baseUrl}teams/players/add';
  static String removePlayerFromTeam = '${baseUrl}teams/players/remove';
  static String addStaffToTeam = '${baseUrl}teams/staff/add';
  static String removeStaffFromTeam = '${baseUrl}teams/staff/remove';
  static String updatePlayer = '${baseUrl}players/';
  static String deletePlayer = '${baseUrl}players/';
  static String deleteStaff = '${baseUrl}staffs/';
  static String createStaff = '${baseUrl}staffs';
  static String submitPersonalInfo = '${baseUrl}users/';
  static String getUserProfile = '${baseUrl}users/';
  static String getSingleStaffInfo = '${baseUrl}staffs/';
  static String getSinglePlayerInfo = '${baseUrl}players/';
  static String fetchAllPlayers = '${baseUrl}players?club_id=';
  static String fetchAllPlayersInATeam = '${baseUrl}teams/players-in-team/';
  static String fetchAllPlayersInAClub = '${baseUrl}clubs/';
  static String fetchDashboardStats = '${baseUrl}clubs/';
  static String fetchAllStaffInATeam = '${baseUrl}teams/staffs-in-team/';
  static String fetchAllStaff = '${baseUrl}staffs?club_id=';
  static String myRoomsList = '${baseUrl}rooms/me';
  static String uploadVideo = '${baseUrl}kafka/upload-link';
  static String uploadCSV = '${baseUrl}players/create-multipe-users';
  static String getAllUploadedVideos = '${baseUrl}analytics/';
  static String getAllPlayerInUploadedVideo = '${baseUrl}players/group/';
  static String comparePlayers = '${baseUrl}analytics/';
  static String comparePVP = '${baseUrl}analytics/multiple-players-stats';
  static String compareVTV =
      '${baseUrl}analytics/player-stats-in-multiple-matches';
  static String compareTVT = '${baseUrl}club_stats/team/analytics';
  static String compareVideos =
      '${baseUrl}analytics/get-stats/multiple-matches';
  static String getAnalysedVideosSingleton = '${baseUrl}analytics/';
  static String getLineUp = '${baseUrl}players/players-in-match/';
  static String submitResetEmail = '${baseUrl}users/email-verification';
  static String submitResetEmailNewFlow = '${baseUrl}users/send-otp';
  static String doesUserExistEmailVerify = '${baseUrl}users/email-exist';
  static String submitResetOTP = '${baseUrl}users/verify-token';
  static String submitResetOTPNewFlow = '${baseUrl}users/verify-send/otp';
  static String submitResetChangePassword = '${baseUrl}users/reset-password';
  static String passwordresetrequest = '${baseUrl}users/password-reset-request';
  static String submitUpdateUserProfile = '${baseUrl}players/update-player/';
  static String updateUser = '${baseUrl}users/';

  //TO BE REMOVED
  static String getOldServerPlayerList = '${baseUrlOld}player/club/';
}
