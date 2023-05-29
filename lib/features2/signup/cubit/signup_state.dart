part of 'signup_cubit.dart';


abstract class SignupState {}

class RegisterClubInitial extends SignupState {}


class RegisterClubLoading extends SignupState {}

class RegisterClubSuccess extends SignupState {
  final String message;
  RegisterClubSuccess(this.message);
}

class RegisterClubError extends SignupState {
  final String message;
  RegisterClubError(this.message);
}

class UpdateUserPaymentLoading extends SignupState {}

class UpdateUserPaymentSuccess extends SignupState {
  final String message;
  UpdateUserPaymentSuccess(this.message);
}

class UpdateUserPaymentError extends SignupState {
  final String message;
  UpdateUserPaymentError(this.message);
}

class SendOTPTOEmailLoading extends SignupState {}

class SendOTPTOEmailSuccess extends SignupState {
  final String message;
  SendOTPTOEmailSuccess(this.message);
}

class SendOTPTOEmailError extends SignupState {
  final String message;
  SendOTPTOEmailError(this.message);
}

class VerifyOTPLoading extends SignupState {}

class VerifyOTPSuccess extends SignupState {
  final String message;
  VerifyOTPSuccess(this.message);
}

class VerifyOTPError extends SignupState {
  final String message;
  VerifyOTPError(this.message);
}

class RegisterPlayerLoading extends SignupState {}


class RegisterPlayerSuccess extends SignupState {
  final String message;
  RegisterPlayerSuccess(this.message);
}

class RegisterPlayerError extends SignupState {
  final String message;
  RegisterPlayerError(this.message);
}

class DoesUserExistEmailVerifyLoading extends SignupState {}


class DoesUserExistEmailVerifySuccess extends SignupState {
  final String message;
  DoesUserExistEmailVerifySuccess(this.message);
}

class DoesUserExistEmailVerifyError extends SignupState {
  final String message;
  DoesUserExistEmailVerifyError(this.message);
}
