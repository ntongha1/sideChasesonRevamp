import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:sonalysis/core/utils/constants.dart';

import '../service/service.dart';

part 'preset_state.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  final PasswordResetService registerService;

  PasswordResetCubit(this.registerService) : super(ResetEmailInitial());

  sendResetEmail(email) async {
    emit(ResetEmailLoading());

    var request = {
      "email": email,
    };

    Response? response = await registerService.submitResetEmail(request);
    if (response == null) {
      emit(ResetEmailError(AppConstants.exceptionMessage));
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      resolveResetEmail(jsonDecode(response.body));
    } else {
      Map? body = jsonDecode(response.body);
      emit(ResetEmailError(body!['message']));
    }
  }

  void resolveResetEmail(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        emit(ResetEmailSuccess(message));
      } else {
        emit(ResetEmailError(message));
      }
    }
  }

  verifyOTP(token) async {
    emit(VerifyOTPLoading());

    var request = {
      "token": token,
    };

    Response? response = await registerService.submitResetOTP(request);
    if (response == null) {
      emit(VerifyOTPError(AppConstants.exceptionMessage));
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      resolveVerifyOTP(jsonDecode(response.body));
    } else {
      Map? body = jsonDecode(response.body);
      emit(VerifyOTPError(body!['message']));
    }
  }

  void resolveVerifyOTP(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        emit(VerifyOTPSuccess(message));
      } else {
        emit(VerifyOTPError(message));
      }
    }
  }

  doResetPassword(email, password) async {
    emit(ResetPasswordLoading());

    var request = {
      "email": email,
      "password": password,
    };

    print("reset : $request");

    Response? response = await registerService.submitResetPassword(request);
    if (response == null) {
      emit(ResetPasswordError(AppConstants.exceptionMessage));
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      resolveResetPassword(jsonDecode(response.body));
    } else {
      Map? body = jsonDecode(response.body);
      emit(ResetPasswordError(body!['message']));
    }
  }

  void resolveResetPassword(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        emit(ResetPasswordSuccess(message));
      } else {
        emit(ResetPasswordError(message));
      }
    }
  }
}
