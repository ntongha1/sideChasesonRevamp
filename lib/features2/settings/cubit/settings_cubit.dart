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
import '../service/service.dart';

part 'settings_state.dart';


class SettingsCubit extends Cubit<SettingsState> {
  final SettingsService _settingsService;

  SettingsCubit(this._settingsService) : super(PersonalInfoInitial());

  updatePersonalInfo(userID, File? file, myProfile, firstname, lastname, yearsOfExperience, employmentStartDate, employmentEndDate, age, linkToPortfolio, ePhoneNumber, dob, jerseyNumber, country, phoneNumber) async {
    String folderName = DateTime.now().toString().replaceAll(RegExp(' '), '_').toString();
    String? awsImageUrl = "";

    emit(PersonalInfoLoading());
    if (file != null) {
      awsImageUrl = await uploadFile(
        folderName: folderName,
        bucketName: AppConfig.spacesUploadBucketName,
        documentType: 'club_logos',
        file: file,
      );
      if (awsImageUrl == null) {
        emit(PersonalInfoError('unable to upload image'));
        return;
      }
    }

    var request = {
      "photo": file != null ? awsImageUrl : myProfile,
      "jersey_no": jerseyNumber,
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

    try {

      Response? response = await _settingsService.submitPersonalInfo(request, userID);
      if (response == null) {
        emit(PersonalInfoError(AppConstants.serverConnectionMessage));
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        resolvePersonalInfo(jsonDecode(response.body));
      } else {
        Map? body = jsonDecode(response.body);
        emit(PersonalInfoError(body!['message']));
      }
    } catch (ex) {
      print(ex);
      emit(PersonalInfoError(AppConstants.exceptionMessage));
    }
  }

  void resolvePersonalInfo(Map? body) {
    if (body == null) {
      throw Exception('null response');
    } else {
      String responseStatus = body['status'];
      String message = body['message'];

      if (responseStatus.toLowerCase() == "accepted") {
        if (serviceLocator.isRegistered<UserResultData>()) {
          serviceLocator.unregister<UserResultData>();
        }
        UserResultData userResultData = UserResultData.fromJson(body['data']);
        serviceLocator.registerSingleton<UserResultData>(userResultData);
        emit(PersonalInfoSuccess(message));
      } else {
        emit(PersonalInfoError(message));
      }
    }
  }


}