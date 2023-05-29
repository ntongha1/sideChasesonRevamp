import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/response_message.dart';

import '../../../../core/datasource/key.dart';
import '../../../../core/datasource/local_storage.dart';
import '../../../../core/models/response/UserResultModel.dart' as UserResultModel;
import '../../../../core/models/response/VideoListResponseModel.dart';
import '../../../../core/startup/app_startup.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/images.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/app_dropdown_modal.dart';
import '../../../../core/widgets/button.dart';
import '../../../features/common/cubit/common_cubit.dart';
import '../../../features/common/models/AllPlayerInUploadedVideoModel.dart';
import '../../../features/common/models/ComparePlayersModel.dart';
import '../widgets/allPlayersModalWidget.dart';

class Pvp extends StatefulWidget {
  Pvp({Key? key}) : super(key: key);

  @override
  State<Pvp> createState() => _PvpState();
}

class _PvpState extends State<Pvp> {
  UserResultModel.UserResultData? userResultData;
  bool isLoading = true, showPlayerSelection = false, playerASelected = false, playerBSelected = false, submited = false;
  VideoListResponseModel? videoListResponseModel;
  VideoListResponseModelData? _selectedVideo;
  AllPlayerInUploadedVideoModel? allPlayerInUploadedVideoModel;
  Players? playerASelectedDetails, playerBSelectedDetails;
  ComparePlayersModel? comparePlayersModel;

  RefreshController _refreshController = RefreshController(initialRefresh: true);

  void _onRefresh() async{
    _getData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    _getData();
    _refreshController.loadComplete();
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator.get<LocalStorage>().readSecureObject(LocalStorageKeys.kUserPrefs);
    //load all analysed videos
    await serviceLocator<CommonCubit>().getAllUploadedVideos(userResultData!.user!.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
    controller: _refreshController,
    onRefresh: _onRefresh,
    onLoading: _onLoading,
    child: BlocListener(
        bloc: serviceLocator.get<CommonCubit>(),
        listener: (_, state) {
          if (state is AnalysedVideosLoading || state is AllPlayerInUploadedVideoLoading || state is ComparePlayersLoading) {
            isLoading = true;
            context.loaderOverlay.show();
          }

          if (state is AnalysedVideosError || state is AllPlayerInUploadedVideoError || state is ComparePlayersError) {
            isLoading = false;
            context.loaderOverlay.hide();
            ResponseMessage.showErrorSnack(context: context, message: AppConstants.exceptionMessage);
          }

          if (state is AnalysedVideosSuccess) {
            isLoading = false;
            context.loaderOverlay.hide();
              videoListResponseModel = state.videoListResponseModel;
              //print(videoListResponseModel.toString());
              setState(() {});
          }

          if (state is AllPlayerInUploadedVideoSuccess) {
            isLoading = false;
            context.loaderOverlay.hide();
              allPlayerInUploadedVideoModel = state.allPlayerInUploadedVideoModel;
              showPlayerSelection = true;
              //print(videoListResponseModel.toString());
              setState(() {});
        }
        if (state is ComparePlayersSuccess) {
            isLoading = false;
            context.loaderOverlay.hide();
              comparePlayersModel = state.comparePlayersModel;
              submited = true;
              setState(() {});
        }
          },
        child: isLoading
            ? Container()
            :  Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  videoListResponseModel!.videoListResponseModelData!.length > 0
                      ? AppDropdownModal(
                      options: videoListResponseModel!.videoListResponseModelData!,
                      value: _selectedVideo,
                      hasSearch: false,
                      onChanged: (val) async {
                        _selectedVideo = val as VideoListResponseModelData;
                        //load all analysed videos
                        await serviceLocator<CommonCubit>().getAllPlayerInUploadedVideo(_selectedVideo!.id!);
                        setState(() {});
                      },
                      validator: Validator.requiredValidator,
                      modalHeight: MediaQuery.of(context).size.height * 0.7,
                      headerText: "Select a video".tr(),
                      hintText: "Select and option".tr(),
                    )
                      : Text("No video is uploaded yet".tr().toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey
                      )),
                  showPlayerSelection //video selected
                  ? allPlayerInUploadedVideoModel!.data!.teamA == null || allPlayerInUploadedVideoModel!.data!.teamB == null //no players
                  ? Text("No Player in the selected video".tr().toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey
                      ))
                  : Column(
                    children: [
                      Text("Select a player".tr().toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey
                          )),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                bottomSheet(
                                    context,
                                    AllPlayerModalWidget(
                                        teamType: "A",
                                        teamAPlayersList: allPlayerInUploadedVideoModel!.data!.teamA!
                                    ))
                                    .then((playerDetails) {
                                  if (playerDetails != null) {
                                    print(playerDetails!.firstName! + " " + playerDetails!.lastName!);
                                    playerASelected = true;
                                    playerASelectedDetails = playerDetails;
                                    setState(() {});
                                  }


                                });
                              },
                              child: Column(
                                children: [
                                  playerASelected
                                  ? CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                      NetworkImage(playerASelectedDetails!.photo == null
                                          ? AppConstants.defaultProfilePictures
                                          : playerASelectedDetails!.photo!
                                      ))
                                  : Image.asset(
                                    AppAssets.comparePlaceholderPlus,
                                    fit: BoxFit.cover,
                                    repeat: ImageRepeat.noRepeat,
                                    width: 100,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                      playerASelected
                                      ? playerASelectedDetails!.firstName! + " " + playerASelectedDetails!.lastName!
                                      : "Choose Player A",
                                      style: const TextStyle(color: Colors.white))
                                ],
                              ),
                            ),
                            const SizedBox(width: 50),
                            InkWell(
                                onTap: () {
                                  bottomSheet(
                                      context,
                                      AllPlayerModalWidget(
                                          teamType: "B",
                                          teamBPlayersList: allPlayerInUploadedVideoModel!.data!.teamB!
                                      ))
                                      .then((playerDetails) {
                                        if (playerDetails != null) {
                                          print(playerDetails!.firstName! + " " + playerDetails!.lastName!);
                                          playerBSelected = true;
                                          playerBSelectedDetails = playerDetails;
                                          setState(() {});
                                        }

                                  });
                                },
                                child: Column(
                                  children: [
                                    playerBSelected
                                        ? CircleAvatar(
                                        radius: 60,
                                        backgroundImage:
                                        NetworkImage(playerBSelectedDetails!.photo == null
                                            ? AppConstants.defaultProfilePictures
                                            : playerBSelectedDetails!.photo!
                                        ))
                                        : Image.asset(
                                      AppAssets.comparePlaceholderPlus,
                                      fit: BoxFit.cover,
                                      repeat: ImageRepeat.noRepeat,
                                      width: 100,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        playerBSelected
                                            ? playerBSelectedDetails!.firstName! + " " + playerBSelectedDetails!.lastName!
                                            : "Choose Player A",
                                        style:
                                        const TextStyle(color: Colors.white))
                                  ],
                                )),
                          ],
                        ),
                      ),
                      if (playerASelected && playerBSelected && !submited)
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
                          child: AppButton(
                              buttonText: "Continue".tr(),
                              onPressed: () async {
                                await serviceLocator<CommonCubit>().comparePlayers(_selectedVideo!.id!, playerASelectedDetails!.id!, playerBSelectedDetails!.id!);
                              }),
                        ),
                      const SizedBox(height: 30),
                      if (submited)
                      Container(
                          //margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 5),
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                child: Text("Comparison Stats".tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.sp)),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  playerAnalytics(
                                      comparePlayersModel != null
                                          ? comparePlayersModel!.data![0].speed!
                                          : 0,
                                      "Speed".tr()),
                                  const SizedBox(width: 50),
                                  playerAnalytics(
                                      comparePlayersModel != null
                                          ? comparePlayersModel!.data![1].speed!
                                          : 0,
                                      "Speed".tr()),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  playerAnalytics(
                                      comparePlayersModel != null
                                          ? comparePlayersModel!.data![0].longPass!
                                          : 0.0,
                                      "Long Pass".tr()),
                                  const SizedBox(width: 50),
                                  playerAnalytics(
                                      comparePlayersModel != null
                                          ? comparePlayersModel!.data![1].longPass!
                                          : 0.0,
                                      "Long Pass".tr()),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  playerAnalytics(
                                      comparePlayersModel != null
                                          ? comparePlayersModel!.data![0].shortPass!
                                          : 0.0,
                                      "Short Pass"),
                                  const SizedBox(width: 50),
                                  playerAnalytics(
                                      comparePlayersModel != null
                                          ? comparePlayersModel!.data![1].shortPass!
                                          : 0.0,
                                      "Short Pass"),
                                ],
                              ),
                              const SizedBox(height: 40),
                              playerFeatures(
                                  comparePlayersModel != null
                                      ? comparePlayersModel!.data![0].goal!.toString()
                                      : "0",
                                  comparePlayersModel != null
                                      ? comparePlayersModel!.data![1].goal!.toString()
                                      : "0",
                                  "Goals Scored"),
                              const SizedBox(height: 20),
                              playerFeatures(
                                  comparePlayersModel != null
                                      ? comparePlayersModel!.data![0].freeKick!.toString()
                                      : "0",
                                  comparePlayersModel != null
                                      ? comparePlayersModel!.data![1].freeKick!.toString()
                                      : "0",
                                  "FreeKick"),
                              const SizedBox(height: 20),
                              playerFeatures(
                                  comparePlayersModel != null
                                      ? comparePlayersModel!.data![0].penalty!.toString()
                                      : "0",
                                  comparePlayersModel != null
                                      ? comparePlayersModel!.data![1].penalty!.toString()
                                      : "0",
                                  "Penalty"),
                              const SizedBox(height: 20),
                              playerFeatures(
                                  comparePlayersModel != null
                                      ? comparePlayersModel!.data![0].yellowCard!.toString()
                                      : "0",
                                  comparePlayersModel != null
                                      ? comparePlayersModel!.data![1].yellowCard!.toString()
                                      : "0",
                                  "Yellow Cards",
                                  image: AppAssets.yellowCard),
                              const SizedBox(height: 20),
                              playerFeatures(
                                  comparePlayersModel != null
                                      ? comparePlayersModel!.data![0].redCard!.toString()
                                      : "0",
                                  comparePlayersModel != null
                                      ? comparePlayersModel!.data![1].redCard!.toString()
                                      : "0",
                                  "Red Cards",
                                  image: AppAssets.redCard)
                            ],
                          ),
                        ),
                      const SizedBox(height: 70),
                    ],
                  )
                  : SizedBox.shrink(),
                  const SizedBox(height: 10),
                ],
              ))));
  }

  Widget playerAnalytics(dynamic value, String text) {
    return SizedBox(
        width: 90,
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 8.0,
              percent: value / 100,
              center: Text(value.toString() + "%",
                  style: const TextStyle(color: Colors.white)),
              progressColor: AppColors.sonaPurple1,
            ),
            const SizedBox(height: 10),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: getColorHexFromStr("C4C4C4"), fontSize: 13.sp)),
          ],
        ));
  }

  Widget playerFeatures(String firstText, String secondText, String text,
      {String? image}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
      decoration: BoxDecoration(
          color: AppColors.sonaBlack,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(firstText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13.sp)),
          image != null
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image,
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.noRepeat,
                  width: 15),
              const SizedBox(width: 5),
              Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold)),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 25),
              Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Text(secondText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13.sp)),
        ],
      ),
    );
  }
}
