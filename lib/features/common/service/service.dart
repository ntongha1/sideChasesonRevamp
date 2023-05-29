import 'package:http/http.dart';
import 'package:sonalysis/core/enums/request_type.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/network/network_service.dart';

class CommonService {
  final NetworkService oldServerService;
  final NetworkService newServerService;

  CommonService({
    required this.oldServerService,
    required this.newServerService,
  });

  Future<Response?> getAllUploadedVideos(String userId) async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.getAllUploadedVideos + userId + "/analytics",
    );
  }

  Future<Response?> getAllPlayerInUploadedVideo(String analyticsId) async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.getAllPlayerInUploadedVideo + analyticsId,
    );
  }

  Future<Response?> comparePlayers(String analyticsId, var payload) async {
    return await newServerService(
      requestType: RequestType.post,
      payload: payload,
      url:
          ApiConstants.comparePlayers + analyticsId + "/players-stats-by-video",
    );
  }

  Future<Response?> comparePVP(var payload) async {
    return await newServerService(
      requestType: RequestType.post,
      payload: payload,
      url: ApiConstants.comparePVP,
    );
  }

  Future<Response?> compareTVT(var payload) async {
    return await newServerService(
      requestType: RequestType.post,
      payload: payload,
      url: ApiConstants.compareTVT,
    );
  }

  Future<Response?> compareVideos(var payload) async {
    return await newServerService(
      requestType: RequestType.post,
      payload: payload,
      url: ApiConstants.compareVideos,
    );
  }

  Future<Response?> getDashboardStats(String clubId) async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.fetchDashboardStats + clubId,
    );
  }

  Future<Response?> getOldServerPlayerList(String clubId) async {
    return await oldServerService(
      requestType: RequestType.get,
      url: ApiConstants.getOldServerPlayerList + clubId,
    );
  }

  Future<Response?> getTeamList(String clubId) async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.fetchAllTeams + clubId,
    );
  }

  Future<Response?> getTeamSingle(String teamId) async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.fetchSingleTeam + teamId,
    );
  }

  Future<Response?> getPlayerVerifyImage(String clubId) async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.fetchPlayerVerifyImage + clubId + "/verify",
    );
  }

  Future<Response?> getSinglePlayerProfile(String playerID) async {
    print("get single player profile: " +
        ApiConstants.fetchSinglePlayerProfile +
        playerID);
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.fetchSinglePlayerProfile + playerID,
    );
  }

  Future<Response?> getSingleStaffProfile(String staffID) async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.fetchSingleStaffProfile + staffID,
    );
  }

  Future<Response?> getPlayerList(String clubId) async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.fetchAllPlayers + clubId,
    );
  }

  Future<Response?> getPlayersInATeamList(String teamName) async {
    print("did call: " + ApiConstants.fetchAllPlayersInATeam + teamName);
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.fetchAllPlayersInATeam + teamName,
    );
  }

  Future<Response?> getPlayersInAClubList(String clubId) async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.fetchAllPlayersInAClub + clubId,
    );
  }

  Future<Response?> getStaffList(String clubId) async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.fetchAllStaff + clubId,
    );
  }

  Future<Response?> getStaffInATeamList(String teamName) async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.fetchAllStaffInATeam + teamName,
    );
  }

  Future<Response?> fetchCategories() async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.teamCategories,
    );
  }

  Future<Response?> checkIfWeAreConnected(var payload) async {
    return await newServerService(
        requestType: RequestType.post,
        url: ApiConstants.find,
        payload: payload);
  }

  Future<Response?> createPrivateRoom(var payload) async {
    return await newServerService(
        requestType: RequestType.post,
        url: ApiConstants.createRoom,
        payload: payload);
  }

  Future<Response?> createTeam(var payload) async {
    return await newServerService(
        requestType: RequestType.post,
        url: ApiConstants.createTeam,
        payload: payload);
  }

  Future<Response?> updateTeam(var payload, String teamId) async {
    return await newServerService(
        requestType: RequestType.put,
        url: ApiConstants.updateTeam + teamId,
        payload: payload);
  }

  Future<Response?> createPlayer(var payload) async {
    return await newServerService(
        requestType: RequestType.post,
        url: ApiConstants.createPlayer,
        payload: payload);
  }

  Future<Response?> addPlayerToTeam(var payload) async {
    return await newServerService(
        requestType: RequestType.post,
        url: ApiConstants.addPlayerToTeam,
        payload: payload);
  }

  Future<Response?> addStaffToTeam(var payload) async {
    return await newServerService(
        requestType: RequestType.post,
        url: ApiConstants.addStaffToTeam,
        payload: payload);
  }

  Future<Response?> updatePlayer(var payload, String playerID) async {
    return await newServerService(
        requestType: RequestType.put,
        url: ApiConstants.updatePlayer + playerID,
        payload: payload);
  }

  Future<Response?> deletPlayer(String playerId) async {
    return await newServerService(
        requestType: RequestType.delete,
        url: ApiConstants.deletePlayer + playerId);
  }

  Future<Response?> removePlayer(var payload) async {
    return await newServerService(
        requestType: RequestType.post,
        url: ApiConstants.removePlayerFromTeam,
        payload: payload);
  }

  Future<Response?> deleteStaff(String staffId) async {
    return await newServerService(
        requestType: RequestType.delete,
        url: ApiConstants.deleteStaff + staffId);
  }

  Future<Response?> removeStaff(var payload) async {
    return await newServerService(
        requestType: RequestType.post,
        url: ApiConstants.removeStaffFromTeam,
        payload: payload);
  }

  Future<Response?> createStaff(var payload) async {
    return await newServerService(
        requestType: RequestType.post,
        url: ApiConstants.createStaff,
        payload: payload);
  }

  Future<Response?> addParticipant(var payload, String? roomId) async {
    return await newServerService(
        requestType: RequestType.post,
        url: ApiConstants.addParticipant + roomId! + "/participant",
        payload: payload);
  }

  Future<Response?> videoUpload(var payload) async {
    return await newServerService(
        requestType: RequestType.post,
        url: ApiConstants.uploadVideo,
        payload: payload);
  }

  Future<Response?> csvUpload(var payload) async {
    return await newServerService(
        requestType: RequestType.post,
        url: ApiConstants.uploadCSV,
        payload: payload,
        isMultipart: true);
  }

  Future<Response?> getRoomList() async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.myRoomsList,
    );
  }

  Future<Response?> getAnalysedVideosSingleton(String analyticsId) async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.getAnalysedVideosSingleton + analyticsId,
    );
  }

  Future<Response?> getLineUp(String analyticsId, String teamName) async {
    return await newServerService(
      requestType: RequestType.get,
      url: ApiConstants.getLineUp + analyticsId + "/" + teamName,
    );
  }

  Future<Response?> submitVerifyTeam(var payload, String? videoID) async {
    print(ApiConstants.submitTeamVerify + videoID! + "/verify");
    return await newServerService(
        requestType: RequestType.put,
        url: ApiConstants.submitTeamVerify + videoID! + "/verify",
        payload: payload);
  }
}
