import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import '../../../../../../core/models/response/UserResultModel.dart';
import '../../../core/datasource/key.dart';
import '../../../core/datasource/local_storage.dart';
import '../../../core/enums/button.dart';
import '../../../core/models/response/VideoListResponseModel.dart';
import '../../../core/navigation/keys.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/utils/styles.dart';
import '../../../core/widgets/GradientProgressBar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/empty_response.dart';
import '../../../features/common/cubit/common_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../widgets/inprogress_popup.dart';
import '../widgets/verify_team_popup.dart';

class pendingAnalytics extends StatefulWidget {
  const pendingAnalytics({Key? key}) : super(key: key);

  @override
  _pendingAnalyticsState createState() => _pendingAnalyticsState();
}

class _pendingAnalyticsState extends State<pendingAnalytics>
    with SingleTickerProviderStateMixin {
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
                              0)
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        InProgressPopUpScreen(data: {
                                          "title": "verifying".tr(),
                                          "subTitle": "verifying_exp".tr(),
                                          "filename": videoListResponseModel!
                                              .videoListResponseModelData!
                                              .elementAt(i)
                                              .lastMediaUrl!,
                                          "progress": 40,
                                        }));
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
                                      const SizedBox(width: 20, height: 5),
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
                                                0)
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "verifying".tr(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppStyle.text0
                                                            .copyWith(
                                                                fontSize:
                                                                    10.sp),
                                                      ),
                                                      SizedBox(width: 75.h),
                                                      Text(
                                                        "40%",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppStyle.text0
                                                            .copyWith(
                                                                fontSize: 10.sp,
                                                                color: AppColors
                                                                    .sonaBlack2),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  SizedBox(
                                                    width: 130.h,
                                                    child: GradientProgressBar(
                                                      percent: 40,
                                                      gradient: AppColors
                                                          .sonalysisGradient,
                                                      backgroundColor:
                                                          AppColors.sonaGrey4,
                                                    ),
                                                  ),
                                                ],
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
