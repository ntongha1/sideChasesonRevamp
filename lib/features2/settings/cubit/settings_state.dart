part of 'settings_cubit.dart';


abstract class SettingsState {}

class PersonalInfoInitial extends SettingsState {}

class PersonalInfoLoading extends SettingsState {}


class PersonalInfoSuccess extends SettingsState {
  final String message;
  PersonalInfoSuccess(this.message);
}

class PersonalInfoError extends SettingsState {
  final String message;
  PersonalInfoError(this.message);
}
