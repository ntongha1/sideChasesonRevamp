

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sonalysis/model/response/PlayerComparisonResponseModel.dart';
import 'package:sonalysis/model/response/PlayersListResponseModel.dart';
import 'package:sonalysis/model/response/StaffListResponseModel.dart';
import 'package:sonalysis/model/response/VideoComparisonResponseModel.dart';
import 'package:sonalysis/model/response/VideoUploadedByIDResponseModel.dart';
import 'package:sonalysis/services/api.dart';
import 'package:sonalysis/services/network_service.dart';

import '../core/models/response/TeamsListResponseModel.dart';
import '../core/models/response/VideoListResponseModel.dart';

class DashboardController {

  var logger = Logger();
  String apiUser = "upload/users/";

//getAllVideos
  Future<VideoListResponseModel> getAllVideos(BuildContext context, String userId, int pageNo) async {


    Map<String, dynamic> analysedVideos = await callAPI(
        url: baseUrl + apiUser + userId + "?page="+pageNo.toString(),//&analyzed=true
        requestType: RequestType.GET,
        context: context);


    return VideoListResponseModel.fromJson(analysedVideos);
  }

//getTeamsList
  Future<TeamsListResponseModel> getTeamList(BuildContext context, String userId) async {

    Map<String, dynamic> teamsList = await callAPI(
        url: baseUrl + "teams/club/"+userId,
        requestType: RequestType.GET,
        context: context);

    return TeamsListResponseModel.fromJson(teamsList);
  }

//getPlayerList
  Future<PlayerListResponseModel> getPlayerList(BuildContext context, String clubId) async {

    Map<String, dynamic> playerList = await callAPI(
        url: baseUrl + "player/club/"+clubId,
        requestType: RequestType.GET,
        context: context);

    return PlayerListResponseModel.fromJson(playerList);
  }

//getStaffList
  Future<StaffListResponseModel> getStaffList(BuildContext context, String userId) async {

    Map<String, dynamic> teamsList = await callAPI(
        url: baseUrl + "users/staff/club/"+userId,
        requestType: RequestType.GET,
        context: context);


    return StaffListResponseModel.fromJson(teamsList);
  }


  //getSelectedPlayerComparisonValue
  Future<PlayerComparisonResponseModel> getSelectedPlayerComparisonValues(BuildContext context, String selectedVideoID, String selectedPlayerName) async {

    var request = {
      "players": [selectedPlayerName]
    };

    Map<String, dynamic> selectedPlayerComparisonValues = await callAPI(
      url: baseUrl + "upload/"+ selectedVideoID +"/players/compare",
        requestType: RequestType.POST,
        payload: request,
        context: context);


    return PlayerComparisonResponseModel.fromJson(selectedPlayerComparisonValues);
  }

  //getAnalysedVideos
  Future<VideoListResponseModel> getAnalysedVideos(BuildContext context, String userId, int pageNo) async {


    Map<String, dynamic> analysedVideos = await callAPI(
        url: baseUrl + apiUser + userId + "?page="+pageNo.toString()+"&analyzed=true",//&analyzed=true
        requestType: RequestType.GET,
        context: context);


    return VideoListResponseModel.fromJson(analysedVideos);
  }


  //getSelectedPlayerVideoComparisonValue
  Future<VideoComparisonResponseModel> getSelectedPlayerVideoComparisonValue(BuildContext context, String selectedVideoID, String selectedPlayerName) async {

    var request = {
      "videoData": [
        {
          "player": selectedPlayerName,
          "uploadId": selectedVideoID
        }
      ]
    };

    Map<String, dynamic> selectedPlayerVideoComparisonValues = await callAPI(
        url: baseUrl + "upload/videos/compare",
        requestType: RequestType.POST,
        payload: request,
        context: context);

    return VideoComparisonResponseModel.fromJson(selectedPlayerVideoComparisonValues);
  }

 //getVideoUploadById
  Future<VideoUploadedByIDResponseModel> getVideoUploadById(BuildContext context, String videoId, String pageNo) async {


    Map<String, dynamic> analysedVideos = await callAPI(
        url: baseUrl + "upload/" + videoId + "?page="+pageNo.toString()+"&analyzed=true",
      requestType: RequestType.GET,
        context: context);


    return VideoUploadedByIDResponseModel.fromJson(analysedVideos);
  }

}