import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sonalysis/core/config/config.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/utils.dart';
import 'package:sonalysis/model/response/CreatePlayerResponseModel.dart';
import 'package:sonalysis/model/response/CreateStaffResponseModel.dart';
import 'package:sonalysis/model/response/CreateTeamResponseModel.dart';
import 'package:sonalysis/services/api.dart';
import 'package:sonalysis/services/network_service.dart';

import '../core/models/response/AddPlayerToTeamResponseModel.dart';

class ClubManagementController {
  var logger = Logger();

  //doCreateTeam
  Future<CreateTeamResponseModel> doCreateTeam(
      BuildContext context, String userID, String clubName) async {
    var request = {"club_id": userID, "name": clubName};

    Map<String, dynamic> userSignup = await callAPI(
        url: baseUrl + "teams",
        requestType: RequestType.POST,
        payload: request,
        context: context);

    return CreateTeamResponseModel.fromJson(userSignup);
  }

  //doCreateTeam
  Future<CreatePlayerResponseModel> doCreatePlayer(
      BuildContext context,
      String lastname,
      String firstname,
      String email,
      String position,
      String jersey_no) async {
    var request = {
      "lastname": lastname,
      "firstname": firstname,
      "email": email,
      "position": position,
      "jersey_number": jersey_no
    };

    Map<String, dynamic> userSignup = await callAPI(
        url: baseUrl + "player",
        requestType: RequestType.POST,
        payload: request,
        context: context);

    return CreatePlayerResponseModel.fromJson(userSignup);
  }

  Future<bool> doUpdatePlayer(
      BuildContext context,
      String lastname,
      String firstname,
      String email,
      String position,
      String jersey_no,
      String teamId,
      String playerId,
      File? file,
      String? oldPhoto,
      int len) async {
    String? spacesImageUrl = oldPhoto;
    String folderName =
        DateTime.now().toString().replaceAll(RegExp(' '), '_').toString();
    String? newName = null;

    if (len > 0) {
      newName = await uploadFile(
          folderName: folderName,
          bucketName: AppConfig.spacesUploadBucketName,
          documentType: 'club_logos',
          file: file);
      print('this is the image url');
      print(len);
      print(spacesImageUrl);

      spacesImageUrl = newName;
    }

    if (spacesImageUrl == null) {
      spacesImageUrl = oldPhoto;
    }

    // return false;
    var request = {
      "last_name": lastname,
      "first_name": firstname,
      "email": email,
      "position": position,
      "jersey_number": jersey_no,
      "photo": spacesImageUrl,
      "team_id": teamId
    };
    print('this is what we are sending to the server9999999999999999999999');
    print(request.toString());

    Map<String, dynamic> userSignup = await callAPI(
        url: ApiConstants.baseUrl + "players/" + playerId.toString(),
        requestType: RequestType.PUT,
        payload: request,
        context: context);

    if (userSignup['status'] == 'ACCEPTED') {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> doUpdateStaff(
    BuildContext context,
    String lastname,
    String firstname,
    String email,
    String position,
    String teamId,
    String staffId,
    File? file,
  ) async {
    var request = {
      "last_name": lastname,
      "first_name": firstname,
      "email": email,
      "role": position,
      "team_id": teamId
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

    Map<String, dynamic> userSignup = await callAPI(
        url: ApiConstants.baseUrl + "staffs/" + staffId.toString(),
        requestType: RequestType.PUT,
        payload: request,
        context: context);

    if (userSignup['status'] == 'OK') {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> doDeletePlayer(BuildContext context, String playerId) async {
    Map<String, dynamic> userSignup = await callAPI(
        url: ApiConstants.baseUrl + "players/" + playerId.toString(),
        requestType: RequestType.DELETE,
        context: context);

    if (userSignup['status'] == 'ACCEPTED') {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> doRemovePlayer(BuildContext context, var payload) async {
    Map<String, dynamic> userSignup = await callAPI(
        url: ApiConstants.baseUrl + "teams/players/remove",
        requestType: RequestType.POST,
        payload: payload,
        context: context);

    if (userSignup['status'] == 'ACCEPTED') {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> doDeleteTeam(BuildContext context, String playerId) async {
    print("lol" + playerId.toString());
    Map<String, dynamic> userSignup = await callAPI(
        url: ApiConstants.baseUrl + "teams/" + playerId.toString(),
        requestType: RequestType.DELETE,
        context: context);

    print("res: " + userSignup.toString());

    if (userSignup['status'] == 'ACCEPTED') {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> doDeleteStaff(BuildContext context, String playerId) async {
    Map<String, dynamic> userSignup = await callAPI(
        url: ApiConstants.baseUrl + "staffs/" + playerId.toString(),
        requestType: RequestType.DELETE,
        context: context);
    print('res');
    // print()
    print(userSignup);
    if (userSignup['status'] == 'OK') {
      return true;
    } else {
      return false;
    }
  }

//doCreateStaff
  Future<CreateStaffResponseModel> doCreateStaff(BuildContext context,
      String lastname, String firstname, String email, String role) async {
    var request = {
      "lastname": lastname,
      "firstname": firstname,
      "email": email,
      "role": role
    };

    Map<String, dynamic> userSignup = await callAPI(
        url: baseUrl + "users/staff",
        requestType: RequestType.POST,
        payload: request,
        context: context);

    return CreateStaffResponseModel.fromJson(userSignup);
  }

//doAddPlayerToTeam
  Future<AddPlayerToTeamResponseModel> doAddPlayerToTeam(
      BuildContext context, List<String> teamListIDs, String playerId) async {
    var request = {
      "players": [playerId]
    };

    Map<String, dynamic>? addPlayerToTeam;

    for (int i = 0; i < teamListIDs.length; i++) {
      addPlayerToTeam = await callAPI(
          url: baseUrl + "teams/" + teamListIDs[i] + "/players/add",
          requestType: RequestType.POST,
          payload: request,
          context: context);
    }

    return AddPlayerToTeamResponseModel.fromJson(addPlayerToTeam!);
  }
}
