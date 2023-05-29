import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/utils.dart';

import '../service/service.dart';

part 'initial_update_profile_state.dart';

class InitialUpdateProfileCubit extends Cubit<InitialUpdateProfileState> {
  final InitialUpdateProfileService registerService;

  InitialUpdateProfileCubit(this.registerService)
      : super(PasswordResetInitial());

  changeUserPassword(password, userID) async {
    emit(PasswordResetLoading());

    var request = {"password": password};

    Response? response =
        await registerService.submitChangeUserPassword(request, userID);
    if (response == null) {
      emit(PasswordResetError(AppConstants.exceptionMessage));
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      resolvePasswordReset(jsonDecode(response.body));
    } else {
      Map? body = jsonDecode(response.body);
      emit(PasswordResetError(body!['message']));
    }
  }

  void resolvePasswordReset(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];
      if (responseStatus.toLowerCase() == "ok") {
        emit(PasswordResetSuccess(message));
      } else {
        emit(PasswordResetError(message));
      }
    }
  }

  updateUserProfile(
      userID,
      firstname,
      lastname,
      yearsOfExperience,
      employmentStartDate,
      employmentEndDate,
      age,
      linkToPortfolio,
      ePhoneNumber,
      dob,
      jerseyNumber,
      country,
      phoneNumber) async {
    emit(UpdateUserProfileLoading());

    var request = {
      "jersey_number": jerseyNumber,
      "employment_start_date": employmentStartDate,
      "employment_end_date": employmentEndDate,
      "dob": dob,
      "age": age,
      "first_name": firstname,
      "last_name": lastname,
      "years_of_experience": yearsOfExperience,
      "phone": phoneNumber,
      "link_to_portfolio": linkToPortfolio,
      "emergency_contact_number": ePhoneNumber,
      "country": country
    };

    Response? response =
        await registerService.submitUpdateUserProfile(request, userID);
    if (response == null) {
      emit(UpdateUserProfileError(AppConstants.exceptionMessage));
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      resolveUpdateUserProfile(jsonDecode(response.body));
    } else {
      Map? body = jsonDecode(response.body);
      emit(UpdateUserProfileError(body!['message']));
    }
  }

  void resolveUpdateUserProfile(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];
      if (responseStatus.toLowerCase() == "accepted" ||
          responseStatus.toLowerCase() == "ok" ||
          responseStatus.toLowerCase() == "user updated successfully") {
        emit(UpdateUserProfileSuccess(message));
      } else {
        emit(UpdateUserProfileError(message));
      }
    }
  }

  updateUserProfileLite(
      userID, firstname, lastname, country, phoneNumber, file) async {
    emit(UpdateUserProfileLoading());

    var request = {
      "first_name": firstname,
      "last_name": lastname,
      "phone": phoneNumber,
      "country": country
    };

    if (file != null) {
      String? newName = await uploadFile(
          folderName: "club_logos",
          bucketName: "",
          documentType: 'club_logos',
          file: file);
      print('this is the image url');

      if (newName != null) {
        request.addAll({"photo": newName});
      }
    }

    Response? response =
        await registerService.submitUpdateUserProfileLite(request, userID);
    if (response == null) {
      emit(UpdateUserProfileError(AppConstants.exceptionMessage));
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      resolveUpdateUserProfile(jsonDecode(response.body));
    } else {
      Map? body = jsonDecode(response.body);
      emit(UpdateUserProfileError(body!['message']));
    }
  }
}
