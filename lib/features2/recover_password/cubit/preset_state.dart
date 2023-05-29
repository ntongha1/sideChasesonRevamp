part of 'preset_cubit.dart';


abstract class PasswordResetState {}

class ResetEmailInitial extends PasswordResetState {}

class ResetEmailLoading extends PasswordResetState {}


class ResetEmailSuccess extends PasswordResetState {
  final String message;
  ResetEmailSuccess(this.message);
}

class ResetEmailError extends PasswordResetState {
  final String message;
  ResetEmailError(this.message);
}

class VerifyOTPInitial extends PasswordResetState {}

class VerifyOTPLoading extends PasswordResetState {}


class VerifyOTPSuccess extends PasswordResetState {
  final String message;
  VerifyOTPSuccess(this.message);
}

class VerifyOTPError extends PasswordResetState {
  final String message;
  VerifyOTPError(this.message);
}

class ResetPasswordInitial extends PasswordResetState {}

class ResetPasswordLoading extends PasswordResetState {}


class ResetPasswordSuccess extends PasswordResetState {
  final String message;
  ResetPasswordSuccess(this.message);
}

class ResetPasswordError extends PasswordResetState {
  final String message;
  ResetPasswordError(this.message);
}
