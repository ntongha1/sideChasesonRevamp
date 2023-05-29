part of 'login_user_cubit.dart';


abstract class LoginUserState {}

class LoginUserInitial extends LoginUserState {}

class LoginUserLoading extends LoginUserState {}


class LoginUserSuccess extends LoginUserState {
  final String message;
  LoginUserSuccess(this.message);
}

class LoginUserError extends LoginUserState {
  final String message;
  LoginUserError(this.message);
}
