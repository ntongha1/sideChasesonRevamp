import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/utils/response_message.dart';

import '../../../../core/datasource/key.dart';
import '../../../../core/datasource/local_storage.dart';
import '../../../../core/models/response/AnalysedVideosSingletonModel.dart';
import '../../../../core/models/response/UserResultModel.dart';
import '../../../../core/models/response/VideoListResponseModel.dart';
import '../../../../core/startup/app_startup.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/app_dropdown_modal.dart';
import '../../../../core/widgets/button.dart';
import '../../../../features2/analytics/singleton/tabs/matchStatSingleton.dart';
import '../../cubit/common_cubit.dart';

class Tvt extends StatefulWidget {
  Tvt({Key? key}) : super(key: key);

  @override
  State<Tvt> createState() => _TvtState();
}

class _TvtState extends State<Tvt> {
  UserResultData? userResultData;
  bool isLoading = true, submited = false;
  VideoListResponseModel? videoListResponseModel;
  VideoListResponseModelData? _selectedVideo;
  AnalysedVideosSingletonModel? analysedVideosSingletonModel;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() async {
    _getData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _getData();
    _refreshController.loadComplete();
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    //load all analysed videos
    await serviceLocator<CommonCubit>()
        .getAllUploadedVideos(userResultData!.user!.id!);
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
              if (state is AnalysedVideosLoading ||
                  state is AnalysedVideosSingletonLoading) {
                isLoading = true;
                context.loaderOverlay.show();
              }

              if (state is AnalysedVideosError ||
                  state is AnalysedVideosSingletonLoading) {
                isLoading = false;
                context.loaderOverlay.hide();
                ResponseMessage.showErrorSnack(
                    context: context, message: AppConstants.exceptionMessage);
              }

              if (state is AnalysedVideosSuccess) {
                isLoading = false;
                context.loaderOverlay.hide();
                videoListResponseModel = state.videoListResponseModel;
                //print(videoListResponseModel.toString());
                setState(() {});
              }

              if (state is AnalysedVideosSingletonLoading) {
                isLoading = false;
                context.loaderOverlay.hide();
                analysedVideosSingletonModel =
                    serviceLocator.get<AnalysedVideosSingletonModel>();
                submited = true;
                setState(() {});
              }
            },
            child: isLoading
                ? Container()
                : Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        videoListResponseModel!
                                    .videoListResponseModelData!.length >
                                0
                            ? AppDropdownModal(
                                options: videoListResponseModel!
                                    .videoListResponseModelData!,
                                value: _selectedVideo,
                                hasSearch: false,
                                onChanged: (val) async {
                                  _selectedVideo =
                                      val as VideoListResponseModelData;
                                  print(_selectedVideo!.id!);
                                  //load all analysed videos
                                  await serviceLocator<CommonCubit>()
                                      .getAnalysedVideosSingleton(
                                          _selectedVideo!.id!);
                                  setState(() {});
                                },
                                validator: Validator.requiredValidator,
                                modalHeight:
                                    MediaQuery.of(context).size.height * 0.7,
                                headerText: "Select a video".tr(),
                                hintText: "Select and option".tr(),
                              )
                            : Text(
                                "No video is uploaded yet".tr().toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey)),
                        if (videoListResponseModel!
                                .videoListResponseModelData!.isNotEmpty &&
                            !submited)
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 30),
                            child: AppButton(
                                buttonText: "Continue".tr(),
                                onPressed: () async {
                                  submited = true;
                                  setState(() {});
                                }),
                          ),
                        if (submited)
                          SingleChildScrollView(
                            child: MatchStatSingleton(
                                analysedVideosSingletonModel:
                                    analysedVideosSingletonModel),
                          ),
                        const SizedBox(height: 50),
                      ],
                    ))));
  }
}
