part of 'splash_cubit.dart';


abstract class SplashState {}

class UpdateDeviceTokenInitial extends SplashState {}

class UpdateDeviceTokenLoading extends SplashState {}


class UpdateDeviceTokenSuccess extends SplashState {
  final String message;
  UpdateDeviceTokenSuccess(this.message);
}

class UpdateDeviceTokenError extends SplashState {
  final String message;
  UpdateDeviceTokenError(this.message);
}

class GetPlayerClubIDInitial extends SplashState {}

class GetPlayerClubIDLoading extends SplashState {}


class GetPlayerClubIDSuccess extends SplashState {
  final String message;
  GetPlayerClubIDSuccess(this.message);
}

class GetPlayerClubIDError extends SplashState {
  final String message;
  GetPlayerClubIDError(this.message);
}


class GetStaffClubIDInitial extends SplashState {}

class GetStaffClubIDLoading extends SplashState {}


class GetStaffClubIDSuccess extends SplashState {
  final String message;
  GetStaffClubIDSuccess(this.message);
}

class GetStaffClubIDError extends SplashState {
  final String message;
  GetStaffClubIDError(this.message);
}
