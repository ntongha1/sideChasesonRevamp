import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:sonalysis/core/utils/constants.dart';

import '../../../core/models/response/UserResultModel.dart';
import '../../../core/startup/app_startup.dart';
import '../service/service.dart';

part 'splash_state.dart';


class SplashCubit extends Cubit<SplashState> {
  final SplashService _splashService;

  SplashCubit(this._splashService) : super(UpdateDeviceTokenInitial());

  updateDeviceToken(userId, deviceToken) async {

    //print("::::::userId "+userId.toString());
    emit(UpdateDeviceTokenLoading());
    var request = {
      "device_token": deviceToken
    };

    try {

      Response? response = await _splashService.submitDeviceToken(request, userId);
      if (response == null) {
        emit(UpdateDeviceTokenError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveUpdateDeviceToken(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(UpdateDeviceTokenError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(UpdateDeviceTokenError(AppConstants.exceptionMessage));
    }
  }

  void resolveUpdateDeviceToken(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<UserResultData>()) {
          serviceLocator.unregister<UserResultData>();
        }
        UserResultData userResultData = UserResultData.fromJson(body);
        serviceLocator.registerSingleton<UserResultData>(userResultData);
        emit(UpdateDeviceTokenSuccess(message));
      } else {
        emit(UpdateDeviceTokenError(message));
      }
    }
  }


  getUserProfile(userId) async {

    //print("::::::userId "+userId.toString());
    try {
      Response? response = await _splashService.getUserProfile(userId);
      if (response == null) {
        emit(UpdateDeviceTokenError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveGetUserProfile(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(UpdateDeviceTokenError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(UpdateDeviceTokenError(AppConstants.exceptionMessage));
    }
  }

  void resolveGetUserProfile(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<UserResultData>()) {
          serviceLocator.unregister<UserResultData>();
        }
        UserResultData userResultData = UserResultData.fromJson(body["data"]);
        serviceLocator.registerSingleton<UserResultData>(userResultData);
        emit(UpdateDeviceTokenSuccess(message));
      } else {
        emit(UpdateDeviceTokenError(message));
      }
    }
  }


}