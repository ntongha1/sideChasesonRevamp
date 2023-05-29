import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/utils.dart';
import '../../../core/config/config.dart';
import '../../../core/startup/app_startup.dart';
import '../models/EmailExistModel.dart';
import '../service/service.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupService signupService;

  SignupCubit(this.signupService) : super(RegisterClubInitial());

  registerClub(File? file, role, clubName, companyEmail, password, deviceToken,
      oFirstName, oLastName, country) async {
    String folderName =
        DateTime.now().toString().replaceAll(RegExp(' '), '_').toString();

    emit(RegisterClubLoading());
    try {
      String? spacesImageUrl = await uploadFile(
        folderName: folderName,
        bucketName: AppConfig.spacesUploadBucketName,
        documentType: 'club_logos',
        file: file,
      );
      if (spacesImageUrl == null) {
        emit(RegisterClubError('unable to upload image'));
        return;
      }
      print("Lol I was here2");

      var request = {
        "photo": spacesImageUrl,
        "role": role,
        "club_name": clubName,
        //"permision": [],
        "email": companyEmail,
        "password": password,
        "device_token": deviceToken,
        "first_name": oFirstName,
        "last_name": oLastName,
        "country": country
      };

      Response? response = await signupService.submitRegisterClub(request);
      if (response == null) {
        emit(RegisterClubError(AppConstants.exceptionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveRegisterClub(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(RegisterClubError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(RegisterClubError(AppConstants.exceptionMessage));
    }
  }

  void resolveRegisterClub(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "created") {
        if (serviceLocator.isRegistered<UserResultData>()) {
          serviceLocator.unregister<UserResultData>();
        }
        UserResultData userResultData = UserResultData.fromJson(body['data']);
        serviceLocator.registerSingleton<UserResultData>(userResultData);
        emit(RegisterClubSuccess(message));
      } else {
        emit(RegisterClubError(message));
      }
    }
  }

  updateUserPayment(userID) async {
    emit(UpdateUserPaymentLoading());

    var request = {
      "paid": true,
    };

    Response? response =
        await signupService.submitUpdateUserPayment(request, userID);
    if (response == null) {
      emit(UpdateUserPaymentError(AppConstants.exceptionMessage));
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      resolveUpdateUserPayment(jsonDecode(response.body));
    } else {
      Map? body = jsonDecode(response.body);
      emit(UpdateUserPaymentError(body!['message']));
    }
  }

  void resolveUpdateUserPayment(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];
      if (responseStatus.toLowerCase() == "ok") {
        emit(UpdateUserPaymentSuccess(message));
      } else {
        emit(UpdateUserPaymentError(message));
      }
    }
  }

  sendOTPTOEmailNewFlow(email) async {
    emit(SendOTPTOEmailLoading());

    var request = {
      "email": email,
    };

    Response? response = await signupService.sendOTPTOEmailNewFlow(request);
    if (response == null) {
      emit(SendOTPTOEmailError(AppConstants.exceptionMessage));
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      resolveSendOTPTOEmail(jsonDecode(response.body));
    } else {
      Map? body = jsonDecode(response.body);
      emit(SendOTPTOEmailError(body!['message']));
    }
  }

  sendOTPTOEmail(email) async {
    emit(SendOTPTOEmailLoading());

    var request = {
      "email": email,
    };

    Response? response = await signupService.sendOTPTOEmail(request);
    if (response == null) {
      emit(SendOTPTOEmailError(AppConstants.exceptionMessage));
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      resolveSendOTPTOEmail(jsonDecode(response.body));
    } else {
      Map? body = jsonDecode(response.body);
      emit(SendOTPTOEmailError(body!['message']));
    }
  }

  void resolveSendOTPTOEmail(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        emit(SendOTPTOEmailSuccess(message));
      } else {
        emit(SendOTPTOEmailError(message));
      }
    }
  }

  verifyOTPEmailNewFlow(token, email) async {
    emit(VerifyOTPLoading());

    var request = {"token": token, "email": email};

    Response? response = await signupService.submitVerifyOTPNewFlow(request);
    if (response == null) {
      emit(VerifyOTPError(AppConstants.exceptionMessage));
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      resolveVerifyOTP(jsonDecode(response.body));
    } else {
      Map? body = jsonDecode(response.body);
      emit(VerifyOTPError(body!['message']));
    }
  }

  verifyOTP(token) async {
    emit(VerifyOTPLoading());

    var request = {
      "token": token,
    };

    Response? response = await signupService.submitVerifyOTP(request);
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

  registerPlayer(
      role, club, email, password, firstName, lastName, country) async {
    emit(RegisterPlayerLoading());

    var request = {
      "photo": AppConstants.defaultProfilePictures,
      "role": role,
      //"club": club,
      //"permision": [],
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "country": country
    };

    try {
      Response? response = await signupService.submitRegisterPlayer(request);
      if (response == null) {
        emit(RegisterPlayerError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolveRegisterPlayer(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(RegisterPlayerError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(RegisterPlayerError(AppConstants.exceptionMessage));
    }
  }

  void resolveRegisterPlayer(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "created") {
        if (serviceLocator.isRegistered<UserResultData>()) {
          serviceLocator.unregister<UserResultData>();
        }
        UserResultData userResultData = UserResultData.fromJson(body['data']);
        serviceLocator.registerSingleton<UserResultData>(userResultData);
        emit(RegisterPlayerSuccess(message));
      } else {
        emit(RegisterPlayerError(message));
      }
    }
  }

  doesUserExistEmailVerify(email) async {
    emit(DoesUserExistEmailVerifyLoading());

    var request = {
      "email": email,
    };

    Response? response = await signupService.doesUserExistEmailVerify(request);
    if (response == null) {
      emit(DoesUserExistEmailVerifyError(AppConstants.exceptionMessage));
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      resolveDoesUserExistEmailVerify(jsonDecode(response.body));
    } else {
      Map? body = jsonDecode(response.body);
      emit(DoesUserExistEmailVerifyError(body!['message']));
    }
  }

  void resolveDoesUserExistEmailVerify(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "ok") {
        if (serviceLocator.isRegistered<EmailExistModel>()) {
          serviceLocator.unregister<EmailExistModel>();
        }
        EmailExistModel emailExistModel = EmailExistModel.fromJson(body);
        serviceLocator.registerSingleton<EmailExistModel>(emailExistModel);
        emit(DoesUserExistEmailVerifySuccess(message));
      } else {
        emit(DoesUserExistEmailVerifyError(message));
      }
    }
  }
}
