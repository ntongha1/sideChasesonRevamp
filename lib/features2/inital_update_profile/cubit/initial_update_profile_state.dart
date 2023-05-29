part of 'initial_update_profile_cubit.dart';


abstract class InitialUpdateProfileState {}

class PasswordResetInitial extends InitialUpdateProfileState {}

class PasswordResetLoading extends InitialUpdateProfileState {}


class PasswordResetSuccess extends InitialUpdateProfileState {
  final String message;
  PasswordResetSuccess(this.message);
}

class PasswordResetError extends InitialUpdateProfileState {
  final String message;
  PasswordResetError(this.message);
}

class UpdateUserProfileInitial extends InitialUpdateProfileState {}

class UpdateUserProfileLoading extends InitialUpdateProfileState {}


class UpdateUserProfileSuccess extends InitialUpdateProfileState {
  final String message;
  UpdateUserProfileSuccess(this.message);
}

class UpdateUserProfileError extends InitialUpdateProfileState {
  final String message;
  UpdateUserProfileError(this.message);
}
