part of 'local_data_cubit.dart';


abstract class LocalDataState {}

class GetLocallyStoredUserDataInitial extends LocalDataState {}

class GetLocallyStoredUserDataLoading extends LocalDataState {}


class GetLocallyStoredUserDataSuccess extends LocalDataState {
  final String message;
  GetLocallyStoredUserDataSuccess(this.message);
}

class GetLocallyStoredUserDataError extends LocalDataState {
  final String message;
  GetLocallyStoredUserDataError(this.message);
}
