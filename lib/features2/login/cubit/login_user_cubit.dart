import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/utils/constants.dart';

import '../../../core/startup/app_startup.dart';
import '../service/service.dart';

part 'login_user_state.dart';


class LoginUserCubit extends Cubit<LoginUserState> {
  final LoginUserService _loginUserService;

  LoginUserCubit(this._loginUserService) : super(LoginUserInitial());

  loginUser(email, password, deviceToken) async {

    emit(LoginUserLoading());

    var request = {
      "email": email,
      "password": password,
      "device_token": deviceToken,
    };

    try {
      Response? response = await _loginUserService.submitLoginUser(request);
      if (response == null) {
        emit(LoginUserError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveLogin(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(LoginUserError(body!['message']));
      }
    } catch (ex) {
      print(ex.toString()+"-----");
      emit(LoginUserError(AppConstants.exceptionMessage));
    }
  }

  void resolveLogin(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<UserResultData>()) {
          serviceLocator.unregister<UserResultData>();
        }
        UserResultData userResultData = UserResultData.fromJson(body['data']);
        serviceLocator.registerSingleton<UserResultData>(userResultData);
        emit(LoginUserSuccess(message));
      } else {
        emit(LoginUserError(message));
      }
    }
  }


}