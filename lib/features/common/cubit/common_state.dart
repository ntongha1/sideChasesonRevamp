part of 'common_cubit.dart';

abstract class CommonState {}

class AnalysedVideosInitial extends CommonState {}

class AnalysedVideosLoading extends CommonState {}

class AnalysedVideosSuccess extends CommonState {
  final VideoListResponseModel videoListResponseModel;
  AnalysedVideosSuccess(this.videoListResponseModel);
}

class AnalysedVideosError extends CommonState {
  final String message;
  AnalysedVideosError(this.message);
}

class AllPlayerInUploadedVideoInitial extends CommonState {}

class AllPlayerInUploadedVideoLoading extends CommonState {}

class AllPlayerInUploadedVideoSuccess extends CommonState {
  final AllPlayerInUploadedVideoModel allPlayerInUploadedVideoModel;
  AllPlayerInUploadedVideoSuccess(this.allPlayerInUploadedVideoModel);
}

class AllPlayerInUploadedVideoError extends CommonState {
  final String message;
  AllPlayerInUploadedVideoError(this.message);
}

class ComparePlayersInitial extends CommonState {}

class ComparePlayersLoading extends CommonState {}

class ComparePlayersSuccess extends CommonState {
  final ComparePlayersModel comparePlayersModel;
  ComparePlayersSuccess(this.comparePlayersModel);
}

class ComparePlayersError extends CommonState {
  final String message;
  ComparePlayersError(this.message);
}

class ComparePVPInitial extends CommonState {}

class ComparePVPLoading extends CommonState {}

class ComparePVPSuccess extends CommonState {
  final ComparePVPModel comparePVPModel;
  ComparePVPSuccess(this.comparePVPModel);
}

class ComparePVPError extends CommonState {
  final String message;
  ComparePVPError(this.message);
}

class CompareTVTInitial extends CommonState {}

class CompareTVTLoading extends CommonState {}

class CompareTVTSuccess extends CommonState {
  final CompareTVTModel compareTVTModel;
  CompareTVTSuccess(this.compareTVTModel);
}

class CompareTVTError extends CommonState {
  final String message;
  CompareTVTError(this.message);
}

class CompareVTVInitial extends CommonState {}

class CompareVTVLoading extends CommonState {}

class CompareVTVSuccess extends CommonState {
  final CompareVTVModel compareVTVModel;
  CompareVTVSuccess(this.compareVTVModel);
}

class CompareVTVError extends CommonState {
  final String message;
  CompareVTVError(this.message);
}

class CompareVideosInitial extends CommonState {}

class CompareVideosLoading extends CommonState {}

class CompareVideosSuccess extends CommonState {
  final CompareVideosModel compareVideosModel;
  CompareVideosSuccess(this.compareVideosModel);
}

class CompareVideosError extends CommonState {
  final String message;
  CompareVideosError(this.message);
}

class PlayerListOldServerInitial extends CommonState {}

class PlayerListOldServerLoading extends CommonState {}

class PlayerListOldServerSuccess extends CommonState {
  final String message;
  PlayerListOldServerSuccess(this.message);
}

class PlayerListOldServerError extends CommonState {
  final String message;
  PlayerListOldServerError(this.message);
}

class TeamListInitial extends CommonState {}

class TeamListLoading extends CommonState {}

class TeamListSuccess extends CommonState {
  final TeamsListResponseModel? data;
  TeamListSuccess(this.data);
}

class TeamListError extends CommonState {
  final String message;
  TeamListError(this.message);
}

class TeamSingleInitial extends CommonState {}

class TeamSingleLoading extends CommonState {}

class TeamSingleSuccess extends CommonState {
  final TeamsSingleModel? data;
  TeamSingleSuccess(this.data);
}

class TeamSingleError extends CommonState {
  final String message;
  TeamSingleError(this.message);
}

class DashboardStatsInitial extends CommonState {}

class DashboardStatsLoading extends CommonState {}

class DashboardStatsSuccess extends CommonState {
  final DashboarStatsModel? data;
  DashboardStatsSuccess(this.data);
}

class DashboardStatsError extends CommonState {
  final String message;
  DashboardStatsError(this.message);
}

class GetPlayerVerifyImageInitial extends CommonState {}

class GetPlayerVerifyImageLoading extends CommonState {}

class GetPlayerVerifyImageSuccess extends CommonState {
  final GetPlayerVerifyImageModel getPlayerVerifyImageModel;
  GetPlayerVerifyImageSuccess(this.getPlayerVerifyImageModel);
}

class GetPlayerVerifyImageError extends CommonState {
  final String message;
  GetPlayerVerifyImageError(this.message);
}

class GetSinglePlayerProfileInitial extends CommonState {}

class GetSinglePlayerProfileLoading extends CommonState {}

class GetSinglePlayerProfileSuccess extends CommonState {
  final SinglePlayerModel singlePlayerModel;
  GetSinglePlayerProfileSuccess(this.singlePlayerModel);
}

class GetSinglePlayerProfileError extends CommonState {
  final String message;
  GetSinglePlayerProfileError(this.message);
}

class GetSingleStaffProfileInitial extends CommonState {}

class GetSingleStaffProfileLoading extends CommonState {}

class GetSingleStaffProfileSuccess extends CommonState {
  final Staff singleStaffModel;
  GetSingleStaffProfileSuccess(this.singleStaffModel);
}

class GetSingleStaffProfileError extends CommonState {
  final String message;
  GetSingleStaffProfileError(this.message);
}

class VerifyTeamInitial extends CommonState {}

class VerifyTeamLoading extends CommonState {}

class VerifyTeamSuccess extends CommonState {
  final String message;
  VerifyTeamSuccess(this.message);
}

class VerifyTeamError extends CommonState {
  final String message;
  VerifyTeamError(this.message);
}

class PlayerListInitial extends CommonState {}

class PlayerListLoading extends CommonState {}

class PlayerListSuccess extends CommonState {
  final String message;
  PlayerListSuccess(this.message);
}

class PlayerListError extends CommonState {
  final String message;
  PlayerListError(this.message);
}

class StaffListInitial extends CommonState {}

class StaffListLoading extends CommonState {}

class StaffListSuccess extends CommonState {
  final String message;
  StaffListSuccess(this.message);
}

class StaffListError extends CommonState {
  final String message;
  StaffListError(this.message);
}

class StaffInATeamListInitial extends CommonState {}

class StaffInATeamListLoading extends CommonState {}

class StaffInATeamListSuccess extends CommonState {
  final String message;
  StaffInATeamListSuccess(this.message);
}

class StaffInATeamListError extends CommonState {
  final String message;
  StaffInATeamListError(this.message);
}

class FetchCategoriesInitial extends CommonState {}

class FetchCategoriesLoading extends CommonState {}

class FetchCategoriesSuccess extends CommonState {
  final String message;
  FetchCategoriesSuccess(this.message);
}

class FetchCategoriesError extends CommonState {
  final String message;
  FetchCategoriesError(this.message);
}

class CreateTeamInitial extends CommonState {}

class CreateTeamLoading extends CommonState {}

class CreateTeamSuccess extends CommonState {
  final CreateTeamResponseModelData? createTeamResponseModelData;
  CreateTeamSuccess(this.createTeamResponseModelData);
}

class CreateTeamError extends CommonState {
  final String message;
  CreateTeamError(this.message);
}

class CreatePlayerInitial extends CommonState {}

class CreatePlayerLoading extends CommonState {}

class CreatePlayerSuccess extends CommonState {
  final String message;
  CreatePlayerSuccess(this.message);
}

class CreatePlayerError extends CommonState {
  final String message;
  CreatePlayerError(this.message);
}

class UpdatePlayerInitial extends CommonState {}

class UpdatePlayerLoading extends CommonState {}

class UpdatePlayerSuccess extends CommonState {
  final String message;
  UpdatePlayerSuccess(this.message);
}

class UpdatePlayerError extends CommonState {
  final String message;
  UpdatePlayerError(this.message);
}

class DeletePlayerInitial extends CommonState {}

class DeletePlayerLoading extends CommonState {}

class DeletePlayerSuccess extends CommonState {
  final String message;
  DeletePlayerSuccess(this.message);
}

class DeletePlayerError extends CommonState {
  final String message;
  DeletePlayerError(this.message);
}

class CreateStaffInitial extends CommonState {}

class CreateStaffLoading extends CommonState {}

class CreateStaffSuccess extends CommonState {
  final String message;
  CreateStaffSuccess(this.message);
}

class CreateStaffError extends CommonState {
  final String message;
  CreateStaffError(this.message);
}

class CreatePrivateRoomAddParticipantInitial extends CommonState {}

class CreatePrivateRoomAddParticipantLoading extends CommonState {}

class CreatePrivateRoomAddParticipantSuccess extends CommonState {
  final String message;
  CreatePrivateRoomAddParticipantSuccess(this.message);
}

class CreatePrivateRoomAddParticipantError extends CommonState {
  final String message;
  CreatePrivateRoomAddParticipantError(this.message);
}

class CheckIfWeAreConnectedInitial extends CommonState {}

class CheckIfWeAreConnectedLoading extends CommonState {}

class CheckIfWeAreConnectedSuccess extends CommonState {
  final String message;
  CheckIfWeAreConnectedSuccess(this.message);
}

class CheckIfWeAreConnectedError extends CommonState {
  final String message;
  CheckIfWeAreConnectedError(this.message);
}

class VideoUploadInitial extends CommonState {}

class VideoUploadLoading extends CommonState {}

class VideoUploadSuccess extends CommonState {
  final String message;
  VideoUploadSuccess(this.message);
}

class VideoUploadError extends CommonState {
  final String message;
  VideoUploadError(this.message);
}

class CSVUploadInitial extends CommonState {}

class CSVUploadLoading extends CommonState {}

class CSVUploadSuccess extends CommonState {
  final String message;
  CSVUploadSuccess(this.message);
}

class CSVUploadError extends CommonState {
  final String message;
  CSVUploadError(this.message);
}

class RoomListInitial extends CommonState {}

class RoomListLoading extends CommonState {}

class RoomListSuccess extends CommonState {
  final String message;
  RoomListSuccess(this.message);
}

class RoomListError extends CommonState {
  final String message;
  RoomListError(this.message);
}

class AnalysedVideosSingletonInitial extends CommonState {}

class AnalysedVideosSingletonLoading extends CommonState {}

class AnalysedVideosSingletonSuccess extends CommonState {
  final String message;
  AnalysedVideosSingletonSuccess(this.message);
}

class AnalysedVideosSingletonError extends CommonState {
  final String message;
  AnalysedVideosSingletonError(this.message);
}

class LineUpInitial extends CommonState {}

class LineUpLoading extends CommonState {}

class LineUpSuccess extends CommonState {
  final String message;
  LineUpSuccess(this.message);
}

class LineUpError extends CommonState {
  final String message;
  LineUpError(this.message);
}
