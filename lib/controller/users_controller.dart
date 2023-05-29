

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/model/response/UserLoginResultModel.dart';
import 'package:sonalysis/model/response/UserRegisterResultModel.dart';
import 'package:sonalysis/services/api.dart';
import 'package:sonalysis/services/network_service.dart';

class UsersController {

  var logger = Logger();
  String apiUser = "users/";

  //doUserRegister
  Future<UserRegisterResultModel> doUserRegister(BuildContext context, String role, String club, String email, String password, String firstName, String lastName, String country) async {

    var request = {
      "photo": defaultProfilePictures,
      "role": role,
      "club": club,
      "permision": [],
      "email": email,
      "password": password,
      "firstname": firstName,
      "lastname": lastName,
      "country": country
    };


    Map<String, dynamic> userSignup = await callAPI(
        url: baseUrl + apiUser + "sign_up",
        requestType: RequestType.POST,
        payload: request,
        context: context);

    return UserRegisterResultModel.fromJson(userSignup);
  }

//doUserLogin
  Future<UserLoginResultModel> doUserLogin(BuildContext context, String email, String password) async {

    var request = {
      "email": email,
      "password": password,
    };


    Map<String, dynamic> userLogin = await callAPI(
        url: baseUrl + apiUser + "login",
        requestType: RequestType.POST,
        payload: request,
        context: context);

    print(userLogin.toString());


    return UserLoginResultModel.fromJson(userLogin);
  }


  //doUserPasswordChange
  Future<UserLoginResultModel> doUserPasswordChange(BuildContext context, String userID, String password) async {

    var request = {
      "password": password,
    };


    Map<String, dynamic> userLogin = await callAPI(
        url: baseUrl + apiUser + userID,
        requestType: RequestType.PUT,
        payload: request,
        context: context);


    return UserLoginResultModel.fromJson(userLogin);
  }


//doUserRegister
  Future<UserRegisterResultModel> doPlayerProfileUpdate(BuildContext context, String userId, String club, String email, String password, String firstName, String lastName, String country) async {

    var request = {
      "photo": defaultProfilePictures,
      //"role": role,
      "club": club,
      "permision": [],
      "email": email,
      "password": password,
      "firstname": firstName,
      "lastname": lastName,
      "country": country
    };


    Map<String, dynamic> userSignup = await callAPI(
        url: baseUrl + apiUser + "player/" + userId,
        requestType: RequestType.POST,
        payload: request,
        context: context);

    return UserRegisterResultModel.fromJson(userSignup);
  }

//doProfilePictureUpload
  Future<UserLoginResultModel> doProfilePictureUpload(BuildContext context, String profilePictureURI, String userId) async {

    var request = {
      "photo": profilePictureURI,
    };


    Map<String, dynamic> profilePictureResponse = await callAPI(
        url: baseUrl + apiUser + userId,
        requestType: RequestType.PUT,
        payload: request,
        context: context);

    return UserLoginResultModel.fromJson(profilePictureResponse);
  }

}