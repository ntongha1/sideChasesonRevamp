import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:sonalysis/core/enums/messaging_type.dart';
import 'package:sonalysis/core/models/response/AnalysedVideosSingletonModel.dart';
import 'package:sonalysis/core/models/response/CreateTeamResponseModel.dart';
import 'package:sonalysis/core/models/response/DashboardStatsModel.dart';
import 'package:sonalysis/core/models/response/PlayerListOldServerResponseModel.dart';
import 'package:sonalysis/core/models/response/PlayerListResponseModel.dart';
import 'package:sonalysis/core/models/response/StaffListResponseModel.dart';
import 'package:sonalysis/core/models/response/TeamCategory.dart';
import 'package:sonalysis/core/models/response/TeamsListResponseModel.dart';
import 'package:sonalysis/core/models/response/VideoListResponseModel.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/features/common/models/AddParticipantsModel.dart';
import 'package:sonalysis/features/common/models/ChatRoomsListResponseModel.dart';
import 'package:sonalysis/features/common/models/ComparePVPModel.dart';
import 'package:sonalysis/features/common/models/CompareTVTModel.dart';
import 'package:sonalysis/features/common/models/CompareVTVModel.dart';
import 'package:sonalysis/features/common/models/CreateRoomModel.dart';
import 'package:sonalysis/features/common/models/GetChatResponseModel.dart';
import 'package:sonalysis/features/common/models/LineUpModel.dart';
import 'package:sonalysis/features/common/models/SingleStaffModel.dart';
import 'package:sonalysis/features/common/models/UploadVideoResponseModel.dart';
import 'package:sonalysis/features/common/service/service.dart';
import 'package:path/path.dart' as p;

import '../../../core/config/config.dart';
import '../../../core/utils/utils.dart';
import '../models/AllPlayerInUploadedVideoModel.dart';
import '../models/ComparePlayersModel.dart';
import '../models/CompareVideosModel.dart';
import '../models/CreatePlayerResponseModel.dart';
import '../models/CreateStaffResponseModel.dart';
import '../models/GetPlayerVerifyImageModel.dart';
import '../models/PlayersInATeamModel.dart';
import '../models/SinglePlayerModel.dart';
import '../models/StaffInATeamModel.dart';

part 'common_state.dart';

class CommonCubit extends Cubit<CommonState> {
  final CommonService _commonService;

  CommonCubit(this._commonService) : super(AnalysedVideosInitial());

  getAllUploadedVideos(String userId) async {
    emit(AnalysedVideosLoading());

    try {
      Response? response = await _commonService.getAllUploadedVideos(userId);
      //print(response.toString());
      if (response == null) {
        emit(AnalysedVideosError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetAllUploadedVideos(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(AnalysedVideosError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(AnalysedVideosError(ex.toString()));
    }
  }

  getAllPlayerInUploadedVideo(String analyticsId) async {
    emit(AnalysedVideosLoading());

    try {
      Response? response =
          await _commonService.getAllPlayerInUploadedVideo(analyticsId);
      //print(response.toString());
      if (response == null) {
        emit(AllPlayerInUploadedVideoError(
            AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetAllPlayerInUploadedVideo(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(AllPlayerInUploadedVideoError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(AllPlayerInUploadedVideoError(ex.toString()));
    }
  }

  comparePlayers(String analyticsId, String playerAId, String playerBId) async {
    emit(AnalysedVideosLoading());

    var request = {
      "player_ids": [playerAId, playerBId]
    };

    try {
      Response? response =
          await _commonService.comparePlayers(analyticsId, request);
      //print(response.toString());
      if (response == null) {
        emit(ComparePlayersError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveComparePlayers(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(ComparePlayersError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(ComparePlayersError(ex.toString()));
    }
  }

  comparePVP(List<String> ids) async {
    emit(ComparePVPLoading());

    var request = {"player_ids": ids};

    try {
      Response? response = await _commonService.comparePVP(request);
      //print(response.toString());
      if (response == null) {
        emit(ComparePVPError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        var dumm = {
          "status": "OK",
          "message": "Result found successfully",
          "data": [
            {
              "player": {
                "id": "dd54aec5-bd09-4a04-b40a-b173fe2a9294",
                "first_name": "Markuuu",
                "last_name": "Manueljjj",
                "dob": null,
                "age": null,
                "gender": null,
                "jersey_no": "93",
                "user_id": "89bb9e31-a13f-4cc6-bb85-b2636009e3d0",
                "club_id": "137038de-129c-4ea2-83eb-9bd3450073e8",
                "weight": null,
                "height": null,
                "photo": "same",
                "position": null,
                "team_name": null,
                "employment_start_date": null,
                "employment_end_date": null,
                "emergency_contact_number": null,
                "phone": null,
                "emergency_contact_name": null,
                "country": null,
                "link_to_portfolio": null,
                "profile_updated": 0,
                "created_at": "2022-06-20T14:31:14.000Z",
                "updated_at": "2022-06-20T14:31:14.000Z"
              },
              "speed": 1,
              "goal": 3,
              "free_kick": 2,
              "long_pass": 4,
              "short_pass": 5,
              "red_card": 6,
              "yellow_card": 7,
              "penalty": 8
            },
            {
              "player": {
                "id": "42421951-8370-4c46-974b-dbaea8bbf14e",
                "first_name": "Boss",
                "last_name": "Man",
                "dob": null,
                "age": null,
                "gender": null,
                "jersey_no": "44",
                "user_id": "091e3fc1-4c2d-4e27-a1c4-7325a6391615",
                "club_id": "137038de-129c-4ea2-83eb-9bd3450073e8",
                "weight": null,
                "height": null,
                "photo": null,
                "position": null,
                "team_name": null,
                "employment_start_date": null,
                "employment_end_date": null,
                "emergency_contact_number": null,
                "phone": null,
                "emergency_contact_name": null,
                "country": null,
                "link_to_portfolio": null,
                "profile_updated": 0,
                "created_at": "2022-06-15T13:40:13.000Z",
                "updated_at": "2022-06-15T13:40:13.000Z"
              },
              "speed": 9,
              "goal": 3,
              "free_kick": 8,
              "long_pass": 2,
              "short_pass": 5,
              "red_card": 1,
              "yellow_card": 0,
              "penalty": 0
            }
          ]
        };
        resolveComparePVP(dumm);
      } else {
        Map? body = jsonDecode(response.body);
        emit(ComparePVPError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(ComparePVPError(ex.toString()));
    }
  }

  compareTVT(List<String> ids) async {
    emit(CompareTVTLoading());

    var request = {"team_names": ids};

    try {
      Response? response = await _commonService.compareTVT(request);
      //print(response.toString());
      if (response == null) {
        emit(CompareTVTError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        var dumm = {
          "status": "OK",
          "message": "Analytics fetched successfully",
          "data": [
            {
              "temp_team_name": "TeamB",
              "analytics": {
                "long_pass": 1,
                "short_pass": 2,
                "dribble": 3,
                "shots": 26,
                "tackles": 5,
                "yellow_cards": 4,
                "red_cards": 6,
                "foul": 48,
                "offside": 0,
                "ball_possession": 478,
                "free_kick": 7,
                "penalty": 7,
                "corners": 8,
                "free_throw": 9,
                "goals": 26,
                "saves": 88,
                "cross": 99,
                "long_shot": 9
              }
            },
            {
              "temp_team_name": "TeamA",
              "analytics": {
                "long_pass": 4,
                "short_pass": 43,
                "dribble": 54,
                "shots": 31,
                "tackles": 65,
                "yellow_cards": 56,
                "red_cards": 45,
                "foul": 24,
                "offside": 34,
                "ball_possession": 222,
                "free_kick": 76,
                "penalty": 67,
                "corners": 678,
                "free_throw": 88,
                "goals": 31,
                "saves": 3,
                "cross": 0,
                "long_shot": 11
              }
            }
          ]
        };
        resolveCompareTVT(dumm);
      } else {
        Map? body = jsonDecode(response.body);
        emit(CompareTVTError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(CompareTVTError(ex.toString()));
    }
  }

  compareVideos(String videoAId, String videoBId) async {
    emit(CompareVideosLoading());

    var request = {
      "video_ids": [videoAId, videoBId]
    };

    try {
      Response? response = await _commonService.compareVideos(request);
      //print(response.toString());
      if (response == null) {
        emit(CompareVideosError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveCompareVideos(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(CompareVideosError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(CompareVideosError(ex.toString()));
    }
  }

  checkIfWeAreConnected(
      String userId, String? otherGuyUserId, String? type) async {
    emit(CheckIfWeAreConnectedLoading());

    var request = {"participantId": otherGuyUserId};

    try {
      Response? response = await _commonService.checkIfWeAreConnected(request);
      if (response == null) {
        emit(CheckIfWeAreConnectedError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'].toLowerCase() == "ok") {
          //are we connected
          if (serviceLocator.isRegistered<GetChatResponseModel>()) {
            serviceLocator.unregister<GetChatResponseModel>();
          }
          GetChatResponseModel getChatResponseModel =
              GetChatResponseModel.fromJson(jsonDecode(response.body));
          serviceLocator
              .registerSingleton<GetChatResponseModel>(getChatResponseModel);

          if (getChatResponseModel.data!.length == 0) {
            //no
            //do createPrivateRoomAddParticipant
            await serviceLocator<CommonCubit>()
                .createPrivateRoomAddParticipant(userId, otherGuyUserId, type);
          } else {
            //yes
            //stop processing here
            CheckIfWeAreConnectedSuccess(getChatResponseModel.message!);
          }
        } else {
          emit(
              CheckIfWeAreConnectedError(AppConstants.serverConnectionMessage));
        }
      } else {
        //print("::::"+message);
        Map? body = jsonDecode(response.body);
        emit(CheckIfWeAreConnectedError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(CheckIfWeAreConnectedError(AppConstants.exceptionMessage));
    }
  }

  createPrivateRoomAddParticipant(
      String userId, String? otherGuyUserId, String? type) async {
    emit(CreatePrivateRoomAddParticipantLoading());

    var request = {"is_private": true, "empty_timeout": 10000000};

    try {
      Response? response = await _commonService.createPrivateRoom(request);
      if (response == null) {
        emit(CreatePrivateRoomAddParticipantError(
            AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['status'].toLowerCase() == "created") {
          if (serviceLocator.isRegistered<CreateRoomModel>()) {
            serviceLocator.unregister<CreateRoomModel>();
          }
          CreateRoomModel createRoomModel =
              CreateRoomModel.fromJson(jsonDecode(response.body));
          serviceLocator.registerSingleton<CreateRoomModel>(createRoomModel);
          var request2;
          if (type == MessagingType.chat.type) {
            request2 = {
              "participants": [otherGuyUserId],
              "notification_data": {
                "notificationType": MessagingType.chat.type,
                "userRole": "coach",
                "userID": "933-dss9332131",
                "userName": "Tude Bala",
                "userImage":
                    "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&auto=format&fit=crop&w=880&q=80",
                "GroupCall": "false",
                "roomID": "fhghdfghdf"
              },
              "type": MessagingType.chat.type
            };
          } else {
            request2 = {
              "participants": [otherGuyUserId],
              "notification_data": {
                "notificationType": "audio",
                "userRole": "coach",
                "userID": "933-dss9332131",
                "userName": "Tude Bala",
                "userImage":
                    "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&auto=format&fit=crop&w=880&q=80",
                "GroupCall": "false",
                "roomID": "fhghdfghdf"
              },
              "type": type
            };
          }
          //print(body['status'].toLowerCase()+",...,"+createRoomModel.data!.id.toString());
          //add participant
          Response? response2 = await _commonService.addParticipant(
              request2, serviceLocator.get<CreateRoomModel>().data!.room!.id);
          if (response2 == null) {
            emit(CreatePrivateRoomAddParticipantError(
                AppConstants.serverConnectionMessage));
          } else if (response.statusCode != 200 || response.statusCode != 201) {
            Map? body = jsonDecode(response.body);
            emit(CreatePrivateRoomAddParticipantError(body!['message']));
          } else {
            resolveCreatePrivateRoomAddParticipant(jsonDecode(response.body));
          }
        } else {
          emit(CreatePrivateRoomAddParticipantError(
              AppConstants.exceptionMessageCreateRoom));
        }
      } else {
        Map? body = jsonDecode(response.body);
        emit(CreatePrivateRoomAddParticipantError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(CreatePrivateRoomAddParticipantError(AppConstants.exceptionMessage));
    }
  }

  getOldServerPlayerList(String clubId) async {
    emit(PlayerListOldServerLoading());

    try {
      Response? response = await _commonService.getOldServerPlayerList(clubId);
      if (response == null) {
        emit(PlayerListOldServerError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetPlayerListOldServer(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(PlayerListOldServerError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(PlayerListOldServerError(AppConstants.exceptionMessage));
    }
  }

  getTeamList(String clubId) async {
    emit(TeamListLoading());

    try {
      Response? response = await _commonService.getTeamList(clubId);
      if (response == null) {
        emit(TeamListError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetTeamList(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(TeamListError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(TeamListError(AppConstants.exceptionMessage));
    }
  }

  getTeamSingle(String teamId) async {
    emit(TeamSingleLoading());

    try {
      Response? response = await _commonService.getTeamSingle(teamId);
      if (response == null) {
        emit(TeamSingleError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        print("server response for editing team: " + response.body.toString());
        resolveGetTeamSingle(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(TeamSingleError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(TeamSingleError(AppConstants.exceptionMessage));
    }
  }

  getDashboardStats(String clubId) async {
    emit(DashboardStatsLoading());

    try {
      Response? response = await _commonService.getDashboardStats(clubId);
      if (response == null) {
        emit(DashboardStatsError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetDashboardStats(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(DashboardStatsError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(DashboardStatsError(AppConstants.exceptionMessage));
    }
  }

  getPlayerVerifyImage(String clubId) async {
    emit(GetPlayerVerifyImageLoading());

    try {
      Response? response = await _commonService.getPlayerVerifyImage(clubId);
      if (response == null) {
        emit(GetPlayerVerifyImageError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetPlayerVerifyImage(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(GetPlayerVerifyImageError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(GetPlayerVerifyImageError(AppConstants.exceptionMessage));
    }
  }

  getSinglePlayerProfile(String playerID) async {
    emit(GetSinglePlayerProfileLoading());

    try {
      Response? response =
          await _commonService.getSinglePlayerProfile(playerID);
      if (response == null) {
        emit(GetSinglePlayerProfileError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetSinglePlayerProfile(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(GetSinglePlayerProfileError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(GetSinglePlayerProfileError(AppConstants.exceptionMessage));
    }
  }

  getSingleStaffProfile(String playerID) async {
    emit(GetSingleStaffProfileLoading());

    try {
      Response? response = await _commonService.getSingleStaffProfile(playerID);
      if (response == null) {
        emit(GetSingleStaffProfileError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        print("lol staff profile: " + response.body.toString());
        resolveGetSingleStaffProfile(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(GetSingleStaffProfileError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(GetSingleStaffProfileError(AppConstants.exceptionMessage));
    }
  }

  getPlayerList(String clubId) async {
    emit(PlayerListLoading());
    try {
      Response? response = await _commonService.getPlayerList(clubId);
      if (response == null) {
        emit(PlayerListError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetPlayerList(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(PlayerListError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(PlayerListError(AppConstants.exceptionMessage));
    }
  }

  getPlayersInATeamList(String teamName) async {
    emit(PlayerListLoading());
    try {
      Response? response = await _commonService.getPlayersInATeamList(teamName);
      if (response == null) {
        emit(PlayerListError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetPlayersInATeamList(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(PlayerListError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(PlayerListError(AppConstants.exceptionMessage));
    }
  }

  getPlayersInAClubList(String clubId) async {
    emit(PlayerListLoading());
    try {
      Response? response = await _commonService.getPlayersInAClubList(clubId);
      if (response == null) {
        emit(PlayerListError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetPlayersInAClubList(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(PlayerListError(body!['message']));
      }
    } catch (ex) {
      print("exsiting: $ex");
      print(ex);
      emit(PlayerListError(AppConstants.exceptionMessage));
    }
  }

  getStaffList(String clubId) async {
    emit(StaffListLoading());
    try {
      Response? response = await _commonService.getStaffList(clubId);
      print(response);
      if (response == null) {
        emit(StaffListError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetStaffList(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(StaffListError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(StaffListError(AppConstants.exceptionMessage));
    }
  }

  getStaffInATeamList(String teamName) async {
    emit(StaffInATeamListLoading());
    try {
      Response? response = await _commonService.getStaffInATeamList(teamName);
      if (response == null) {
        emit(StaffInATeamListError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetStaffInATeamList(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(StaffInATeamListError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(StaffInATeamListError(AppConstants.exceptionMessage));
    }
  }

  fetchCategories() async {
    emit(FetchCategoriesLoading());

    try {
      Response? response = await _commonService.fetchCategories();
      if (response == null) {
        emit(FetchCategoriesError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveFetchCategories(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(FetchCategoriesError(body!['message']));
      }
    } catch (ex) {
      emit(FetchCategoriesError(AppConstants.exceptionMessage));
    }
  }

  createTeam(categoryId, name, abb, clubId, location, file) async {
    emit(CreateTeamLoading());

    var request = {
      "category_id": categoryId,
      "team_name": name,
      "club_id": clubId,
      "location": location,
      "country": location,
      "name_abbreviation": abb
    };

    if (file != null) {
      String folderName =
          DateTime.now().toString().replaceAll(RegExp(' '), '_').toString();
      String? newName = await uploadFile(
          folderName: folderName,
          bucketName: AppConfig.spacesUploadBucketName,
          documentType: 'club_logos',
          file: file);
      print('this is the image url');
      print(newName);
      if (newName != null) request['photo'] = newName;
    }

    try {
      Response? response = await _commonService.createTeam(request);
      if (response == null) {
        emit(CreateTeamError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveCreateTeam(jsonDecode(response.body));
      } else {
        print("what is here error from 1");
        Map? body = jsonDecode(response.body);
        emit(CreateTeamError(body!['message']));
      }
    } catch (ex) {
      print("what is here error from 2");
      print(ex);
      emit(CreateTeamError(AppConstants.exceptionMessage));
    }
  }

  updateTeam(categoryId, name, abb, location, teamId, file) async {
    emit(CreateTeamLoading());

    var request = {
      "category_id": categoryId != null ? categoryId : 0,
      "team_name": name != null ? name : "",
      "location": location != null ? location : "",
      "name_abbreviation": abb != null ? abb : "",
    };

    if (file != null) {
      String folderName =
          DateTime.now().toString().replaceAll(RegExp(' '), '_').toString();
      String? newName = await uploadFile(
          folderName: folderName,
          bucketName: AppConfig.spacesUploadBucketName,
          documentType: 'club_logos',
          file: file);
      print('this is the image url');
      print(newName);
      if (newName != null) request['photo'] = newName;
    }

    try {
      Response? response = await _commonService.updateTeam(request, teamId);
      if (response == null) {
        emit(CreateTeamError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveCreateTeam(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(CreateTeamError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(CreateTeamError(AppConstants.exceptionMessage));
    }
  }

  createPlayer(clubID, teamID, firstname, lastname, position, jerseyNo, email,
      File? file, int len) async {
    emit(CreatePlayerLoading());

    String? spacesImageUrl = "";
    String folderName =
        DateTime.now().toString().replaceAll(RegExp(' '), '_').toString();
    String? newName = null;

    if (len > 0) {
      newName = await uploadFile(
          folderName: folderName,
          bucketName: AppConfig.spacesUploadBucketName,
          documentType: 'club_logos',
          file: file);
      spacesImageUrl = newName;
    }

    var request = {
      "club_id": clubID,
      "email": email,
      "first_name": firstname,
      "last_name": lastname,
      "jersey_number": jerseyNo,
      "position": position,
      "photo": spacesImageUrl,
    };

    try {
      Response? response = await _commonService.createPlayer(request);
      if (response == null) {
        emit(CreatePlayerError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveCreatePlayer(jsonDecode(response.body), teamID);
      } else {
        Map? body = jsonDecode(response.body);
        emit(CreatePlayerError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(CreatePlayerError(AppConstants.exceptionMessage));
    }
  }

  updatePlayer(
      File? file, PlayerID, firstname, lastname, position, jerseyNo) async {
    String folderName =
        DateTime.now().toString().replaceAll(RegExp(' '), '_').toString();

    emit(UpdatePlayerLoading());
    try {
      String? awsImageUrl = await uploadFile(
        folderName: folderName,
        bucketName: AppConfig.spacesUploadBucketName,
        documentType: 'player_images',
        file: file,
      );
      if (awsImageUrl == null) {
        emit(UpdatePlayerError('unable to upload image'));
        return;
      }
      var request = {
        "first_name": firstname,
        "last_name": lastname,
        "jersey_number": jerseyNo,
        "position": position,
        "photo": awsImageUrl,
      };

      try {
        Response? response =
            await _commonService.updatePlayer(request, PlayerID);
        if (response == null) {
          emit(UpdatePlayerError(AppConstants.serverConnectionMessage));
        } else if (response.statusCode == 200 || response.statusCode == 201) {
          resolveUpdatePlayer(jsonDecode(response.body));
        } else {
          Map? body = jsonDecode(response.body);
          emit(UpdatePlayerError(body!['message']));
        }
      } catch (ex) {
        print(ex);
        emit(UpdatePlayerError(AppConstants.exceptionMessage));
      }
    } catch (ex) {
      print(ex);
      emit(UpdatePlayerError(AppConstants.exceptionMessage));
    }
  }

  deletePlayer(String playerID) async {
    emit(DeletePlayerLoading());
    try {
      try {
        Response? response = await _commonService.deletPlayer(playerID);
        if (response == null) {
          emit(DeletePlayerError(AppConstants.serverConnectionMessage));
        } else if (response.statusCode == 200 || response.statusCode == 201) {
          emit(DeletePlayerSuccess("Player deleted successfully"));
        } else {
          Map? body = jsonDecode(response.body);
          emit(DeletePlayerError(body!['message']));
        }
      } catch (ex) {
        print(ex);
        emit(DeletePlayerError(AppConstants.exceptionMessage));
      }
    } catch (ex) {
      print(ex);
      emit(DeletePlayerError(AppConstants.exceptionMessage));
    }
  }

  removePlayer(playerID, teamID) async {
    emit(DeletePlayerLoading());

    var request = {
      "players": [
        {"player_id": playerID, "team_id": teamID}
      ]
    };
    try {
      try {
        Response? response = await _commonService.removePlayer(request);
        if (response == null) {
          emit(DeletePlayerError(AppConstants.serverConnectionMessage));
        } else if (response.statusCode == 200 || response.statusCode == 201) {
          emit(DeletePlayerSuccess("Player deleted successfully"));
        } else {
          Map? body = jsonDecode(response.body);
          emit(DeletePlayerError(body!['message']));
        }
      } catch (ex) {
        print(ex);
        emit(DeletePlayerError(AppConstants.exceptionMessage));
      }
    } catch (ex) {
      print(ex);
      emit(DeletePlayerError(AppConstants.exceptionMessage));
    }
  }

  removeStaff(staffId, teamID, role) async {
    emit(DeletePlayerLoading());

    var request = {
      "staff": [
        {"staff_id": staffId, "team_id": teamID, "role": role}
      ]
    };
    try {
      try {
        Response? response = await _commonService.removeStaff(request);
        if (response == null) {
          emit(DeletePlayerError(AppConstants.serverConnectionMessage));
        } else if (response.statusCode == 200 || response.statusCode == 201) {
          emit(DeletePlayerSuccess("Player deleted successfully"));
        } else {
          Map? body = jsonDecode(response.body);
          emit(DeletePlayerError(body!['message']));
        }
      } catch (ex) {
        print(ex);
        emit(DeletePlayerError(AppConstants.exceptionMessage));
      }
    } catch (ex) {
      print(ex);
      emit(DeletePlayerError(AppConstants.exceptionMessage));
    }
  }

  deleteStaff(String staffId) async {
    emit(DeletePlayerLoading());
    try {
      try {
        Response? response = await _commonService.deleteStaff(staffId);
        if (response == null) {
          emit(DeletePlayerError(AppConstants.serverConnectionMessage));
        } else if (response.statusCode == 200 || response.statusCode == 201) {
          emit(DeletePlayerSuccess("Player deleted successfully"));
        } else {
          Map? body = jsonDecode(response.body);
          emit(DeletePlayerError(body!['message']));
        }
      } catch (ex) {
        print(ex);
        emit(DeletePlayerError(AppConstants.exceptionMessage));
      }
    } catch (ex) {
      print(ex);
      emit(DeletePlayerError(AppConstants.exceptionMessage));
    }
  }

  createStaff(clubID, teamId, firstname, lastname, role, email, File? file,
      int len) async {
    emit(CreateStaffLoading());

    String? spacesImageUrl = "";
    String folderName =
        DateTime.now().toString().replaceAll(RegExp(' '), '_').toString();
    String? newName = null;

    if (len > 0) {
      newName = await uploadFile(
          folderName: folderName,
          bucketName: AppConfig.spacesUploadBucketName,
          documentType: 'club_logos',
          file: file);
      spacesImageUrl = newName;
    }

    var request = {
      "club_id": clubID,
      "email": email,
      "role": role,
      "first_name": firstname,
      "last_name": lastname,
      "photo": spacesImageUrl == null ? "" : spacesImageUrl,
    };

    try {
      Response? response = await _commonService.createStaff(request);
      if (response == null) {
        emit(CreateStaffError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveCreateStaff(jsonDecode(response.body), teamId, role);
      } else {
        Map? body = jsonDecode(response.body);
        emit(CreateStaffError(body!['message']));
      }
    } catch (ex) {
      emit(CreateStaffError(AppConstants.exceptionMessage));
    }
  }

  videoUpload(String videoURL, String pastedVideoURL, File? file,
      String? ClubId, int league, String season) async {
    emit(VideoUploadLoading());
    // int le = int.parse(league);
    int se = int.parse(season);
    var request = {
      "last_media_url": videoURL == null ? pastedVideoURL : videoURL,
      "filename":
          file != null ? p.basenameWithoutExtension(file.path) : "file upload",
      "club_id": ClubId,
      "league": league,
      "season": se
    };

    print(request);

    try {
      Response? response = await _commonService.videoUpload(request);
      if (response == null) {
        emit(VideoUploadError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveUploadVideo(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(VideoUploadError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(VideoUploadError(AppConstants.exceptionMessage));
    }
  }

  csvUpload(File? selectedFile, String? ClubId, String? userType) async {
    String folderName =
        DateTime.now().toString().replaceAll(RegExp(' '), '_').toString();

    emit(CSVUploadLoading());
    //print(selectedFile!.path.toString());
    try {
      String? awsImageUrl = await uploadFile(
        folderName: folderName,
        bucketName: AppConfig.spacesUploadBucketName,
        documentType: 'csv_files',
        file: selectedFile,
      );
      if (awsImageUrl == null) {
        emit(CSVUploadError('unable to upload file'));
        return;
      }

      var request = {
        "url": awsImageUrl,
        "club_id": ClubId,
        "user_type": userType,
      };

      Response? response = await _commonService.csvUpload(request);
      if (response == null) {
        emit(CSVUploadError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveCSVUpload(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(CSVUploadError(body!['message']));
      }
    } catch (ex) {
      print("error: " + ex.toString());
      emit(VideoUploadError(AppConstants.exceptionMessage));
    }
  }

  getRoomList() async {
    emit(RoomListLoading());
    try {
      Response? response = await _commonService.getRoomList();
      if (response == null) {
        emit(RoomListError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveRoomList(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(RoomListError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(RoomListError(AppConstants.exceptionMessage));
    }
  }

  getAnalysedVideosSingleton(String analyticsId) async {
    emit(AnalysedVideosSingletonLoading());

    try {
      Response? response =
          await _commonService.getAnalysedVideosSingleton(analyticsId);
      //print(response.toString());
      if (response == null) {
        emit(
            AnalysedVideosSingletonError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetAnalysedVideosSingleton(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(AnalysedVideosSingletonError(body!['message']));
      }
    } catch (ex) {
      print(ex.toString());
      emit(AnalysedVideosSingletonError(ex.toString()));
    }
  }

  getLineUp(String analyticsId, String teamName) async {
    emit(LineUpLoading());

    try {
      Response? response =
          await _commonService.getLineUp(analyticsId, teamName);
      //print(response.toString());
      if (response == null) {
        emit(LineUpError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveLineUp(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(LineUpError(body!['message']));
      }
    } catch (ex) {
      print(ex.toString());
      //emit(LineUpError(ex.toString()));
    }
  }

  verifyTeam(String? selectedTeamA, String? selectedTeamB, String? oldTeamNameA,
      String? oldTeamNameB, String? videoID) async {
    emit(VerifyTeamLoading());

    var request = {
      "old_temp_name1": oldTeamNameA.toString(),
      "new_temp_name1": selectedTeamA.toString(),
      "old_temp_name2": oldTeamNameB.toString(),
      "new_temp_name2": selectedTeamB.toString()
    };

    try {
      Response? response =
          await _commonService.submitVerifyTeam(request, videoID);
      if (response == null) {
        emit(VerifyTeamError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveVerifyTeam(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(VerifyTeamError(body!['message']));
      }
    } catch (ex) {
      print(ex.toString() + "-----");
      emit(VerifyTeamError(AppConstants.exceptionMessage));
    }
  }

  void resolveGetAllUploadedVideos(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];
      //print("::::"+message);

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<VideoListResponseModel>()) {
          serviceLocator.unregister<VideoListResponseModel>();
        }
        VideoListResponseModel videoListResponseModel =
            VideoListResponseModel.fromJson(body);
        serviceLocator
            .registerSingleton<VideoListResponseModel>(videoListResponseModel);
        emit(AnalysedVideosSuccess(videoListResponseModel));
      } else {
        emit(AnalysedVideosError(message));
      }
    }
  }

  void resolveGetAllPlayerInUploadedVideo(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];
      //print("::::"+message);

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<AllPlayerInUploadedVideoModel>()) {
          serviceLocator.unregister<AllPlayerInUploadedVideoModel>();
        }
        AllPlayerInUploadedVideoModel allPlayerInUploadedVideoModel =
            AllPlayerInUploadedVideoModel.fromJson(body);
        serviceLocator.registerSingleton<AllPlayerInUploadedVideoModel>(
            allPlayerInUploadedVideoModel);
        emit(AllPlayerInUploadedVideoSuccess(allPlayerInUploadedVideoModel));
      } else {
        emit(AllPlayerInUploadedVideoError(message));
      }
    }
  }

  void resolveComparePlayers(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];
      //print("::::"+message);

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<ComparePlayersModel>()) {
          serviceLocator.unregister<ComparePlayersModel>();
        }
        ComparePlayersModel comparePlayersModel =
            ComparePlayersModel.fromJson(body);
        serviceLocator
            .registerSingleton<ComparePlayersModel>(comparePlayersModel);
        emit(ComparePlayersSuccess(comparePlayersModel));
      } else {
        emit(ComparePlayersError(message));
      }
    }
  }

  void resolveComparePVP(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<ComparePVPModel>()) {
          serviceLocator.unregister<ComparePVPModel>();
        }
        ComparePVPModel comparePlayersModel = ComparePVPModel.fromJson(body);
        serviceLocator.registerSingleton<ComparePVPModel>(comparePlayersModel);
        emit(ComparePVPSuccess(comparePlayersModel));
      } else {
        emit(ComparePVPError(message));
      }
    }
  }

  void resolveCompareTVT(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<CompareTVTModel>()) {
          serviceLocator.unregister<CompareTVTModel>();
        }
        CompareTVTModel comparePlayersModel = CompareTVTModel.fromJson(body);
        serviceLocator.registerSingleton<CompareTVTModel>(comparePlayersModel);
        emit(CompareTVTSuccess(comparePlayersModel));
      } else {
        emit(CompareTVTError(message));
      }
    }
  }

  void resolveCompareVideos(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];
      //print("::::"+message);

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<CompareVideosModel>()) {
          serviceLocator.unregister<CompareVideosModel>();
        }
        CompareVideosModel compareVideosModel =
            CompareVideosModel.fromJson(body);
        serviceLocator
            .registerSingleton<CompareVideosModel>(compareVideosModel);
        emit(CompareVideosSuccess(compareVideosModel));
      } else {
        emit(CompareVideosError(message));
      }
    }
  }

  void resolveGetTeamList(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<TeamsListResponseModel>()) {
          serviceLocator.unregister<TeamsListResponseModel>();
        }
        TeamsListResponseModel teamsListResponseModel =
            TeamsListResponseModel.fromJson(body);
        serviceLocator
            .registerSingleton<TeamsListResponseModel>(teamsListResponseModel);
        emit(TeamListSuccess(teamsListResponseModel));
      } else {
        emit(TeamListError(message));
      }
    }
  }

  void resolveGetTeamSingle(Map<String, dynamic>? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<TeamsSingleModel>()) {
          serviceLocator.unregister<TeamsSingleModel>();
        }
        TeamsSingleModel teamsListResponseModel =
            TeamsSingleModel.fromJson(body['data']);
        serviceLocator
            .registerSingleton<TeamsSingleModel>(teamsListResponseModel);
        emit(TeamSingleSuccess(teamsListResponseModel));
      } else {
        emit(TeamSingleError(message));
      }
    }
  }

  void resolveGetDashboardStats(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<DashboarStatsModel>()) {
          serviceLocator.unregister<DashboarStatsModel>();
        }
        DashboarStatsModel dashboardstats = DashboarStatsModel.fromJson(body);
        serviceLocator.registerSingleton<DashboarStatsModel>(dashboardstats);
        emit(DashboardStatsSuccess(dashboardstats));
      } else {
        emit(DashboardStatsError(message));
      }
    }
  }

  void resolveGetPlayerVerifyImage(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<GetPlayerVerifyImageModel>()) {
          serviceLocator.unregister<GetPlayerVerifyImageModel>();
        }
        GetPlayerVerifyImageModel getPlayerVerifyImageModel =
            GetPlayerVerifyImageModel.fromJson(body);
        serviceLocator.registerSingleton<GetPlayerVerifyImageModel>(
            getPlayerVerifyImageModel);
        emit(GetPlayerVerifyImageSuccess(getPlayerVerifyImageModel));
      } else {
        emit(GetPlayerVerifyImageError(message));
      }
    }
  }

  void resolveGetSinglePlayerProfile(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        print("get single player profile: success ok");

        if (serviceLocator.isRegistered<SinglePlayerModel>()) {
          serviceLocator.unregister<SinglePlayerModel>();
        }
        SinglePlayerModel singlePlayerModel = new SinglePlayerModel();
        try {
          debugPrint("body.toString()");
          debugPrint(body.toString());
          singlePlayerModel = SinglePlayerModel.fromJson(body);
        } catch (e) {
          print('9999');
          print(e);
          print('888');
        }
        print("get single player profile: success ok 2");

        serviceLocator.registerSingleton<SinglePlayerModel>(singlePlayerModel);
        emit(GetSinglePlayerProfileSuccess(singlePlayerModel));
      } else {
        emit(GetSinglePlayerProfileError(message));
      }
    }
  }

  void resolveGetSingleStaffProfile(Map<String, dynamic>? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<Staff>()) {
          serviceLocator.unregister<Staff>();
        }
        Staff singlePlayerModel = Staff.fromJson(body['data']);
        serviceLocator.registerSingleton<Staff>(singlePlayerModel);
        emit(GetSingleStaffProfileSuccess(singlePlayerModel));
      } else {
        emit(GetSingleStaffProfileError(message));
      }
    }
  }

  void resolveGetPlayerList(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<PlayerListResponseModel>()) {
          serviceLocator.unregister<PlayerListResponseModel>();
        }
        PlayerListResponseModel playerListResponseModel =
            PlayerListResponseModel.fromJson(body);
        serviceLocator.registerSingleton<PlayerListResponseModel>(
            playerListResponseModel);
        emit(PlayerListSuccess(message));
      } else {
        emit(PlayerListError(message));
      }
    }
  }

  void resolveGetPlayersInATeamList(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<PlayersInATeamModel>()) {
          serviceLocator.unregister<PlayersInATeamModel>();
        }
        PlayersInATeamModel playersInATeamModel =
            PlayersInATeamModel.fromJson(body);
        serviceLocator
            .registerSingleton<PlayersInATeamModel>(playersInATeamModel);
        emit(PlayerListSuccess(message));
      } else {
        emit(PlayerListError(message));
      }
    }
  }

  void resolveGetPlayersInAClubList(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<PlayersInAClubModel>()) {
          serviceLocator.unregister<PlayersInAClubModel>();
        }
        print("existing:: made here 1");

        PlayersInAClubModel playersInATeamModel =
            PlayersInAClubModel.fromJson(body);
        serviceLocator
            .registerSingleton<PlayersInAClubModel>(playersInATeamModel);
        emit(PlayerListSuccess(message));
      } else {
        print("existing:: made here 2");

        emit(PlayerListError(message));
      }
    }
  }

  void resolveGetStaffList(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<StaffListResponseModel>()) {
          serviceLocator.unregister<StaffListResponseModel>();
        }
        StaffListResponseModel staffListResponseModel =
            StaffListResponseModel.fromJson(body);
        serviceLocator
            .registerSingleton<StaffListResponseModel>(staffListResponseModel);
        emit(StaffListSuccess(message));
      } else {
        emit(StaffListError(message));
      }
    }
  }

  void resolveGetStaffInATeamList(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<StaffInATeamModel>()) {
          serviceLocator.unregister<StaffInATeamModel>();
        }
        StaffInATeamModel staffInATeamModel = StaffInATeamModel.fromJson(body);

        serviceLocator.registerSingleton<StaffInATeamModel>(staffInATeamModel);
        emit(StaffInATeamListSuccess(message));
      } else {
        emit(StaffInATeamListError(message));
      }
    }
  }

  void resolveGetPlayerListOldServer(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "success") {
        if (serviceLocator.isRegistered<PlayerListOldServerResponseModel>()) {
          serviceLocator.unregister<PlayerListOldServerResponseModel>();
        }
        PlayerListOldServerResponseModel playerListOldServerResponseModel =
            PlayerListOldServerResponseModel.fromJson(body);
        serviceLocator.registerSingleton<PlayerListOldServerResponseModel>(
            playerListOldServerResponseModel);
        emit(PlayerListOldServerSuccess(message));
      } else {
        emit(PlayerListOldServerError(message));
      }
    }
  }

  void resolveCreatePrivateRoomAddParticipant(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "created") {
        if (serviceLocator.isRegistered<AddParticipantsModel>()) {
          serviceLocator.unregister<AddParticipantsModel>();
        }
        AddParticipantsModel addParticipantsModel =
            AddParticipantsModel.fromJson(body['data']);
        serviceLocator
            .registerSingleton<AddParticipantsModel>(addParticipantsModel);
        emit(CreatePrivateRoomAddParticipantSuccess(message));
      } else {
        emit(CreatePrivateRoomAddParticipantError(message));
      }
    }
  }

  void resolveFetchCategories(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<TeamCategory>()) {
          serviceLocator.unregister<TeamCategory>();
        }
        TeamCategory teamCategory = TeamCategory.fromJson(body);
        serviceLocator.registerSingleton<TeamCategory>(teamCategory);
        emit(FetchCategoriesSuccess(message));
      } else {
        emit(FetchCategoriesError(message));
      }
    }
  }

  void resolveCreateTeam(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "created") {
        if (serviceLocator.isRegistered<CreateTeamResponseModelData>()) {
          serviceLocator.unregister<CreateTeamResponseModelData>();
        }
        try {
          CreateTeamResponseModelData? createTeamResponseModelData =
              CreateTeamResponseModelData.fromJson(body['data']);
          serviceLocator.registerSingleton<CreateTeamResponseModelData>(
              createTeamResponseModelData);
          emit(CreateTeamSuccess(createTeamResponseModelData));
        } catch (e) {
          print("what is here error from 100");
          print(e);
        }
      } else if (responseStatus.toLowerCase() == "accepted") {
        emit(CreateTeamSuccess(null));
      } else {
        print("what is here error from 3");
        print("fuckkkkk here");
        emit(CreateTeamError(message));
      }
    }
  }

  void resolveCreatePlayer(Map? body, String? teamID) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "created") {
        //check to know if i am to add player to team
        if (teamID != null) {
          if (serviceLocator.isRegistered<CreatePlayerResponseModelData>()) {
            serviceLocator.unregister<CreatePlayerResponseModelData>();
          }
          CreatePlayerResponseModelData? createPlayerResponseModelData =
              CreatePlayerResponseModelData.fromJson(body['data']);
          serviceLocator.registerSingleton<CreatePlayerResponseModelData>(
              createPlayerResponseModelData);
          // add player to team
          addPlayerToTeam(teamID, createPlayerResponseModelData.id.toString());
        } else {
          emit(CreatePlayerSuccess(message));
        }
      } else {
        emit(CreatePlayerError(message));
      }
    }
  }

  addPlayerToTeam(teamID, playerID) async {
    var request = {
      "players": [
        {"player_id": playerID, "team_id": teamID}
      ]
    };

    try {
      Response? response = await _commonService.addPlayerToTeam(request);
      if (response == null) {
        emit(CreatePlayerError(AppConstants.cannotAddPlayerToTeamMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CreatePlayerSuccess(jsonDecode(response.body)!['message']));
        //resolveCreatePlayer(jsonDecode(response.body), teamID); ///redo resolveCreatePlayer but without teamID
      } else {
        Map? body = jsonDecode(response.body);
        emit(CreatePlayerError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(CreatePlayerError(AppConstants.exceptionMessage));
    }
  }

  addPlayerToTeamMultiple(request) async {
    // var request = {
    //   "players": [
    //     {"player_id": playerID, "team_id": teamID}
    //   ]
    // };

    try {
      Response? response = await _commonService.addPlayerToTeam(request);
      if (response == null) {
        emit(CreatePlayerError(AppConstants.cannotAddPlayerToTeamMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CreatePlayerSuccess(jsonDecode(response.body)!['message']));
        //resolveCreatePlayer(jsonDecode(response.body), teamID); ///redo resolveCreatePlayer but without teamID
      } else {
        Map? body = jsonDecode(response.body);
        emit(CreatePlayerError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(CreatePlayerError(AppConstants.exceptionMessage));
    }
  }

  void resolveUpdatePlayer(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "accepted") {
        emit(UpdatePlayerSuccess(message));
      } else {
        emit(UpdatePlayerError(message));
      }
    }
  }

  void resolveCreateStaff(Map? body, String? teamId, String? role) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "created") {
        //check to know if i am to add player to team
        if (teamId != null) {
          if (serviceLocator.isRegistered<CreateStaffResponseModelData>()) {
            serviceLocator.unregister<CreateStaffResponseModelData>();
          }
          CreateStaffResponseModelData? createStaffResponseModelData =
              CreateStaffResponseModelData.fromJson(body['data']);
          serviceLocator.registerSingleton<CreateStaffResponseModelData>(
              createStaffResponseModelData);
          // add player to team
          addStaffToTeam(
              teamId, createStaffResponseModelData.id.toString(), role!);
        } else {
          emit(CreateStaffSuccess(message));
        }
      } else {
        emit(CreateStaffError(message));
      }
    }
  }

  addStaffToTeam(teamID, playerID, role) async {
    var request = {
      "staff": [
        {"staff_id": playerID, "team_id": teamID, "role": role}
      ]
    };

    try {
      Response? response = await _commonService.addStaffToTeam(request);
      if (response == null) {
        emit(CreateStaffError(AppConstants.cannotAddStaffToTeamMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CreateStaffSuccess(jsonDecode(response.body)!['message']));
        //resolveCreateStaff(jsonDecode(response.body), null, null); ///redo resolveCreateStaff but without teamID
      } else {
        Map? body = jsonDecode(response.body);
        emit(CreateStaffError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(CreatePlayerError(AppConstants.exceptionMessage));
    }
  }

  addStaffToTeamMultiple(request) async {
    // var request = {
    //   "staff": [
    //     {"staff_id": playerID, "team_id": teamID, "role": role}
    //   ]
    // };

    try {
      Response? response = await _commonService.addStaffToTeam(request);
      if (response == null) {
        emit(CreateStaffError(AppConstants.cannotAddStaffToTeamMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CreateStaffSuccess(jsonDecode(response.body)!['message']));
        //resolveCreateStaff(jsonDecode(response.body), null, null); ///redo resolveCreateStaff but without teamID
      } else {
        Map? body = jsonDecode(response.body);
        emit(CreateStaffError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(CreatePlayerError(AppConstants.exceptionMessage));
    }
  }

  void resolveUploadVideo(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "created") {
        if (serviceLocator.isRegistered<UploadVideoResponseModel>()) {
          serviceLocator.unregister<UploadVideoResponseModel>();
        }
        UploadVideoResponseModel uploadVideoResponseModel =
            UploadVideoResponseModel.fromJson(body);
        serviceLocator.registerSingleton<UploadVideoResponseModel>(
            uploadVideoResponseModel);
        emit(VideoUploadSuccess(message));
      } else {
        emit(VideoUploadError("video_upload_failed".tr()));
      }
    }
  }

  void resolveCSVUpload(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        emit(CSVUploadSuccess(message));
      } else {
        emit(CSVUploadError("file_upload_failed".tr()));
      }
    }
  }

  void resolveRoomList(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<ChatRoomsListResponseModel>()) {
          serviceLocator.unregister<ChatRoomsListResponseModel>();
        }
        ChatRoomsListResponseModel chatRoomsListResponseModel =
            ChatRoomsListResponseModel.fromJson(body);
        serviceLocator.registerSingleton<ChatRoomsListResponseModel>(
            chatRoomsListResponseModel);
        emit(RoomListSuccess(message));
      } else {
        emit(RoomListError(message));
      }
    }
  }

  void resolveGetAnalysedVideosSingleton(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];
      //print("::::"+message);

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<AnalysedVideosSingletonModel>()) {
          serviceLocator.unregister<AnalysedVideosSingletonModel>();
        }
        AnalysedVideosSingletonModel analysedVideosSingletonModel =
            AnalysedVideosSingletonModel.fromJson(body);
        serviceLocator.registerSingleton<AnalysedVideosSingletonModel>(
            analysedVideosSingletonModel);
        emit(AnalysedVideosSingletonSuccess(message));
      } else {
        emit(AnalysedVideosSingletonError(message));
      }
    }
  }

  void resolveLineUp(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];
      //print("::::"+message);

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<LineUpModel>()) {
          serviceLocator.unregister<LineUpModel>();
        }
        LineUpModel lineUpModel = LineUpModel.fromJson(body);
        serviceLocator.registerSingleton<LineUpModel>(lineUpModel);
        emit(LineUpSuccess(message));
      } else {
        emit(LineUpError(message));
      }
    }
  }

  void resolveVerifyTeam(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];
      //print("::::"+message);
      if (responseStatus.toLowerCase() == "ok") {
        emit(VerifyTeamSuccess(message));
      } else {
        emit(VerifyTeamError(message));
      }
    }
  }
}
