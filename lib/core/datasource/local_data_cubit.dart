
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/utils/constants.dart';

import '../startup/app_startup.dart';
import 'key.dart';
import 'local_storage.dart';


part 'local_data_state.dart';


class LocalDataCubit extends Cubit<LocalDataState> {

  LocalDataCubit() : super(GetLocallyStoredUserDataInitial());

  getLocallyStoredUserData() async {

    emit(GetLocallyStoredUserDataLoading());

    try {

      UserResultData? userResultData = await serviceLocator.get<LocalStorage>().readSecureObject(LocalStorageKeys.kUserPrefs);
      if (userResultData == null) {
        emit(GetLocallyStoredUserDataError(AppConstants.localDBErrorMessage));
      } else {
        resolveGetLocallyStoredUserData(userResultData);
      }
    } catch (ex) {
      emit(GetLocallyStoredUserDataError(AppConstants.localDBErrorMessage));
    }
  }

  void resolveGetLocallyStoredUserData(UserResultData userResultData) {
        if (serviceLocator.isRegistered<UserResultData>()) {
          serviceLocator.unregister<UserResultData>();
        }
        serviceLocator.registerSingleton<UserResultData>(userResultData);
        emit(GetLocallyStoredUserDataSuccess("message"));
      }
  }