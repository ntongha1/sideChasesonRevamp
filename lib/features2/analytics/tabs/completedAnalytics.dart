import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/models/response/VideoListResponseModel.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/helpers.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/datasource/key.dart';
import '../../../../core/datasource/local_storage.dart';
import '../../../../core/models/response/UserResultModel.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/widgets/GradientProgressBar.dart';
import '../../../../core/widgets/empty_response.dart';
import '../../../../features2/analytics/widgets/inprogress_popup.dart';
import '../../../../features2/analytics/widgets/verify_team_popup.dart';

class CompletedAnalytics extends StatefulWidget {
  CompletedAnalytics({Key? key}) : super(key: key);

  @override
  State<CompletedAnalytics> createState() => _CompletedAnalyticsState();
}

class _CompletedAnalyticsState extends State<CompletedAnalytics> {
  VideoListResponseModel? videoListResponseModel;
  UserResultData? userResultData;
  late List<String?> searchableList;
  bool isLoading = true;

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
    await serviceLocator<CommonCubit>()
        .getAllUploadedVideos(userResultData!.user!.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (videoListResponseModel != null) {
      searchableList = videoListResponseModel!.videoListResponseModelData!
          .map((el) => el.filename)
          .toList();
    }

    return SmartRefresher(
        enablePullDown: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: BlocListener(
            bloc: serviceLocator.get<CommonCubit>(),
            listener: (_, state) {
              if (state is AnalysedVideosLoading) {
                isLoading = true;
                context.loaderOverlay.show();
              }

              if (state is AnalysedVideosError) {
                isLoading = false;
                context.loaderOverlay.hide();
                ResponseMessage.showErrorSnack(
                    context: context, message: state.message);
              }

              if (state is AnalysedVideosSuccess) {
                isLoading = false;
                context.loaderOverlay.hide();
                setState(() {
                  videoListResponseModel =
                      serviceLocator.get<VideoListResponseModel>();
                  //print("filename:::::: "+videoListResponseModel!.videoListResponseModelData![0].toString());
                });
              }
            },
            child: isLoading
                ? Container()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   margin: const EdgeInsets.only(top: 20.0),
                        //   child: CustomSearch(
                        //     labelText: "search_videos".tr(),
                        //     searchableList: isLoading ? [] : searchableList,
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        if (videoListResponseModel!
                            .videoListResponseModelData!.isEmpty)
                          EmptyResponseWidget(
                              msg: "No video uploaded",
                              iconData: Iconsax.menu_board5),
                        for (int i = 0;
                            i <
                                videoListResponseModel!
                                    .videoListResponseModelData!.length;
                            i++)
                          if (videoListResponseModel!
                                  .videoListResponseModelData!
                                  .elementAt(i)
                                  .analysed! ==
                              1)
                            InkWell(
                              onTap: () {
                                if (videoListResponseModel!
                                        .videoListResponseModelData!
                                        .elementAt(i)
                                        .firstView! ==
                                    0) {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) =>
                                          VerifyTeamPopUpScreen(
                                              videoID: videoListResponseModel!
                                                  .videoListResponseModelData!
                                                  .elementAt(i)
                                                  .id));
                                } else {
                                  serviceLocator
                                      .get<NavigationService>()
                                      .toWithPameter(
                                          routeName: RouteKeys
                                              .routeAnalysedVideosSingletonScreen,
                                          data: {
                                        "analyticsId": videoListResponseModel!
                                            .videoListResponseModelData!
                                            .elementAt(i)
                                            .id
                                      });
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.sonaGrey6,
                                      border: Border.all(
                                        color: AppColors.sonaGrey6,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0.w, vertical: 10.0.h),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10.0.w, vertical: 3.0.w),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(7.0),
                                            decoration: BoxDecoration(
                                              color: AppColors.sonaGrey5,
                                              border: Border.all(
                                                color: AppColors.sonaGrey5,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            child: Icon(
                                              Iconsax.video5,
                                              color: AppColors.sonaGrey3,
                                              size: 18.sp,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    width: 220.0,
                                                    child: Text(
                                                      videoListResponseModel!
                                                          .videoListResponseModelData!
                                                          .elementAt(i)
                                                          .filename!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AppStyle.text2
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .sonaBlack2),
                                                    )),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    if (userResultData!
                                                            .user!.role !=
                                                        "player")
                                                      Text(
                                                        "Uploaded by " +
                                                            userResultData!
                                                                .user!
                                                                .lastName! +
                                                            " " +
                                                            userResultData!
                                                                .user!
                                                                .firstName! +
                                                            " ",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: AppStyle.text0
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .sonaGrey3),
                                                      ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 0),
                                                        child: Text(
                                                          timeago.format(DateTime.parse(
                                                              videoListResponseModel!
                                                                  .videoListResponseModelData!
                                                                  .elementAt(i)
                                                                  .createdAt!)),
                                                          style: AppStyle.text0
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: AppColors
                                                                      .sonaGrey3),
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10, height: 5),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 40.0.w,
                                            vertical: 3.0.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (videoListResponseModel!
                                                    .videoListResponseModelData!
                                                    .elementAt(i)
                                                    .analysed! ==
                                                1)
                                              SizedBox(
                                                height: 20.h,
                                                width: 150.w,
                                                child: AppButton(
                                                    buttonType:
                                                        ButtonType.tertiary,
                                                    buttonText:
                                                        "view_analytics".tr(),
                                                    vertical: 0,
                                                    onPressed: () {
                                                      if (videoListResponseModel!
                                                              .videoListResponseModelData!
                                                              .elementAt(i)
                                                              .firstView! ==
                                                          0) {
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                VerifyTeamPopUpScreen(
                                                                    videoID: videoListResponseModel!
                                                                        .videoListResponseModelData!
                                                                        .elementAt(
                                                                            i)
                                                                        .id)).then(
                                                            (value) =>
                                                                {_onRefresh()});
                                                      } else {
                                                        serviceLocator
                                                            .get<
                                                                NavigationService>()
                                                            .toWithPameter(
                                                                routeName: RouteKeys
                                                                    .routeAnalysedVideosSingletonScreen,
                                                                data: {
                                                              "analyticsId":
                                                                  videoListResponseModel!
                                                                      .videoListResponseModelData!
                                                                      .elementAt(
                                                                          i)
                                                                      .id
                                                            });
                                                      }
                                                    }),
                                              ),
                                            const SizedBox(width: 20),
                                            // InkWell(
                                            //   onTap: () {

                                            //   },
                                            //   child: Icon(
                                            //     Icons.share,
                                            //     size: 18.w,
                                            //     color: AppColors.sonaGrey3,
                                            //   ),
                                            // ),
                                            // const SizedBox(width: 20),
                                            // InkWell(
                                            //   onTap: () {

                                            //   },
                                            //   child: Icon(
                                            //     Iconsax.trash,
                                            //     size: 18.w,
                                            //     color: AppColors.sonaRed,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  )));
  }
}
