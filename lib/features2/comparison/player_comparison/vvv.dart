import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/response_message.dart';

import '../../../../core/datasource/key.dart';
import '../../../../core/datasource/local_storage.dart';
import '../../../../core/models/response/UserResultModel.dart';
import '../../../../core/models/response/VideoListResponseModel.dart';
import '../../../../core/startup/app_startup.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/images.dart';
import '../../../../core/widgets/button.dart';
import '../../../features/common/cubit/common_cubit.dart';
import '../../../features/common/models/CompareVideosModel.dart';
import '../widgets/allVideosModalWidget.dart';

class Vvv extends StatefulWidget {
  Vvv({Key? key}) : super(key: key);

  @override
  State<Vvv> createState() => _VvvState();
}

class _VvvState extends State<Vvv> {
  UserResultData? userResultData;
  bool isLoading = true, videoASelected = false, videoBSelected = false, submited = false;
  VideoListResponseModel? videoListResponseModel;
  CompareVideosModel? compareVideosModel;
  VideoListResponseModelData? videoASelectedDetails, videoBSelectedDetails;

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
          if (state is AnalysedVideosLoading || state is CompareVideosLoading) {
            isLoading = true;
            context.loaderOverlay.show();
          }

          if (state is AnalysedVideosError || state is CompareVideosError) {
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

        if (state is CompareVideosSuccess) {
            isLoading = false;
            context.loaderOverlay.hide();
            compareVideosModel = state.compareVideosModel;
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
                      ? Column(
                    children: [
                      Text("Select a video".tr().toUpperCase(),
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
                                    AllVideosModalWidget(
                                        videosListResponseModel: videoListResponseModel
                                    ))
                                    .then((videoDetails) {
                                  if (videoDetails != null) {
                                    //print(videoDetails!.f!);
                                    videoASelected = true;
                                    videoASelectedDetails = videoDetails;
                                    setState(() {});
                                  }
                                });
                              },
                              child: Column(
                                children: [
                                  videoASelected
                                      ?  Image.asset(
                                    AppAssets.analyticsImage,
                                    fit: BoxFit.cover,
                                    repeat: ImageRepeat.noRepeat,
                                    width: 100,
                                    height: 80,
                                  )
                                      : Image.asset(
                                    AppAssets.addVideo,
                                    fit: BoxFit.cover,
                                    repeat: ImageRepeat.noRepeat,
                                    width: 100,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                      videoASelected
                                          ? "Change Video A".tr()
                                          : "Choose Video A".tr(),
                                      style: const TextStyle(color: Colors.white))
                                ],
                              ),
                            ),
                            const SizedBox(width: 50),
                            InkWell(
                                onTap: () {
                                  bottomSheet(
                                      context,
                                      AllVideosModalWidget(
                                          videosListResponseModel: videoListResponseModel
                                      )).then((videoDetails) {
                                    if (videoDetails != null) {
                                      //print(videoDetails!.f!);
                                      videoBSelected = true;
                                      videoBSelectedDetails = videoDetails;
                                      setState(() {});
                                    }
                                  });
                                },
                                child: Column(
                                  children: [
                                    videoBSelected
                                        ?  Image.asset(
                                      AppAssets.analyticsImage,
                                      fit: BoxFit.cover,
                                      repeat: ImageRepeat.noRepeat,
                                      width: 100,
                                      height: 80,
                                    )
                                        : Image.asset(
                                      AppAssets.addVideo,
                                      fit: BoxFit.cover,
                                      repeat: ImageRepeat.noRepeat,
                                      width: 100,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        videoBSelected
                                            ? "Change Video B".tr()
                                            : "Choose Video B".tr(),
                                        style: const TextStyle(color: Colors.white))
                                  ],
                                )),
                          ],
                        ),
                      ),
                      if (videoASelected && videoBSelected && !submited)
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
                          child: AppButton(
                              buttonText: "Continue".tr(),
                              onPressed: () async {
                                await serviceLocator<CommonCubit>().compareVideos(videoASelectedDetails!.id!, videoBSelectedDetails!.id!);
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
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].ballPossession!.toString(), compareVideosModel!.compareVideosModelData![1].ballPossession!.toString(), "Ball Possession".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].longPass!.toString(), compareVideosModel!.compareVideosModelData![1].longPass!.toString(), "Long Pass".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].corners!.toString(), compareVideosModel!.compareVideosModelData![1].corners!.toString(), "Corners".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].cross!.toString(), compareVideosModel!.compareVideosModelData![1].cross!.toString(), "Cross".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].dribble!.toString(), compareVideosModel!.compareVideosModelData![1].dribble!.toString(), "Dribble".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].foul!.toString(), compareVideosModel!.compareVideosModelData![1].foul!.toString(), "Foul".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].freeThrow!.toString(), compareVideosModel!.compareVideosModelData![1].freeThrow!.toString(), "Free Throw".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].interceptions!.toString(), compareVideosModel!.compareVideosModelData![1].interceptions!.toString(), "Interceptions".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].offside!.toString(), compareVideosModel!.compareVideosModelData![1].offside!.toString(), "Offside".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].pitchSide!.toString(), compareVideosModel!.compareVideosModelData![1].pitchSide!.toString(), "Pitch Side".tr()),const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].saves!.toString(), compareVideosModel!.compareVideosModelData![1].saves!.toString(), "Saves".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].shots!.toString(), compareVideosModel!.compareVideosModelData![1].shots!.toString(), "Shots".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].shortPass!.toString(), compareVideosModel!.compareVideosModelData![1].shortPass!.toString(), "Short Pass".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].goals!.toString(), compareVideosModel!.compareVideosModelData![1].goals!.toString(), "Goals Scored".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].freeKick!.toString(), compareVideosModel!.compareVideosModelData![1].freeKick!.toString(), "Free Kick".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].penalty!.toString(), compareVideosModel!.compareVideosModelData![1].penalty!.toString(), "Penalty".tr()),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].yellowCards!.toString(), compareVideosModel!.compareVideosModelData![1].yellowCards!.toString(), "yellow_cards".tr(), image:  AppAssets.yellowCard),
                              const SizedBox(height: 30),
                              playerFeatures(compareVideosModel!.compareVideosModelData![0].redCards!.toString(), compareVideosModel!.compareVideosModelData![1].redCards!.toString(), "red_cards".tr(),  image: AppAssets.redCard),
                              const SizedBox(height: 30)
                            ],
                          ),
                        ),
                      const SizedBox(height: 70),
                    ],
                  )
                      : Text("No video is uploaded yet".tr().toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey
                      )),
                  const SizedBox(height: 10),
                ],
              ))));
  }

  Widget playerFeatures(
      String? firstText,
      String? secondText,
      String? text,
      {String? image}
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
      decoration: BoxDecoration(
          color: AppColors.sonaBlack,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(firstText!,
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
              Text(text!,
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
              Text(text!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.normal)),
            ],
          ),
          Text(secondText!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13.sp)),
        ],
      ),
    );
  }
}
