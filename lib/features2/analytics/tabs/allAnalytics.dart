import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
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

class AllAnalytics extends StatefulWidget {
  AllAnalytics({Key? key}) : super(key: key);

  @override
  State<AllAnalytics> createState() => _AllAnalyticsState();
}

class _AllAnalyticsState extends State<AllAnalytics> {
  VideoListResponseModel? videoListResponseModel;
  UserResultData? userResultData;
  late List<String?> searchableList;
  List<VideoListResponseModelData> allVideosBefore = [];
  List<VideoListResponseModelData> allVideos = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  TextEditingController filterController = TextEditingController();

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

  void searchNow(String? v) {
    List<VideoListResponseModelData> all = allVideosBefore;
    String value = "";
    if (v == null || v == "")
      value = "";
    else
      value = v.trim().toLowerCase();
    if (v == "") {
      setState(() {
        allVideos = all;
      });
      return;
    }
    List<VideoListResponseModelData> temp = all.where((element) {
      String fname =
          element.filename == null ? "" : element.filename!.toLowerCase();

      return fname.contains(value);
    }).toList();

    print('was here' + temp.length.toString());
    setState(() {
      allVideos = temp;
    });
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
                  allVideosBefore =
                      videoListResponseModel!.videoListResponseModelData!;
                  allVideos = allVideosBefore;
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
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              searchNow(value);
                            },
                            style: AppStyle.text2,
                            decoration: InputDecoration(
                              fillColor: AppColors.sonaGrey6,
                              isDense: true,
                              filled: true,
                              prefixIcon: Icon(
                                Boxicons.bx_search,
                                color: AppColors.sonaGrey3,
                                size: 30,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.normalRadius),
                                  borderSide:
                                      BorderSide(color: AppColors.sonaGrey6)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.h, horizontal: 12.w),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintText: "Search here",
                              hintStyle: AppStyle.text2,
                            ),
                          ),
                        ),
                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 20),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       SizedBox(
                        //         width: MediaQuery.of(context).size.width * 0.44,
                        //         child: AppTextField(
                        //           onTap: () {},
                        //           readOnly: true,
                        //           suffixWidget: Container(
                        //               width: 20.w,
                        //               height: 20.h,
                        //               margin: EdgeInsets.only(right: 20),
                        //               child: SvgPicture.asset(
                        //                   'assets/svgs/drop_grey.svg')),
                        //           controller: filterController,
                        //           hintText: "Filter".tr(),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         width: MediaQuery.of(context).size.width * 0.44,
                        //         child: Container(),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 20.h),
                        const SizedBox(height: 10),
                        if (allVideos.isEmpty)
                          EmptyResponseWidget(
                              msg: "No video uploaded",
                              iconData: Iconsax.menu_board5),
                        for (int i = 0; i < allVideos.length; i++)
                          InkWell(
                            onTap: () {
                              if (allVideos.elementAt(i).analysed! == 0) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        InProgressPopUpScreen(data: {
                                          "title": "verifying".tr(),
                                          "subTitle": "verifying_exp".tr(),
                                          "filename": allVideos
                                              .elementAt(i)
                                              .lastMediaUrl!,
                                          "progress": 40,
                                        }));
                              } else if (allVideos.elementAt(i).firstView! ==
                                  0) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        VerifyTeamPopUpScreen(
                                          videoID: allVideos.elementAt(i).id,
                                          onSuccess: () {
                                            _onRefresh();
                                          },
                                        ));
                              } else {
                                serviceLocator
                                    .get<NavigationService>()
                                    .toWithPameter(
                                        routeName: RouteKeys
                                            .routeAnalysedVideosSingletonScreen,
                                        data: {
                                      "analyticsId": allVideos.elementAt(i).id
                                    });
                              }
                            },
                            child: Center(
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                        color: AppColors.sonaGrey6,
                                        border: Border.all(
                                          color: AppColors.sonaGrey6,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0.w, vertical: 20.0.h),
                                    margin: EdgeInsets.only(bottom: 10.0.h),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.sonaGrey5,
                                                border: Border.all(
                                                  color: AppColors.sonaGrey5,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/svgs/video_icon.svg',
                                                width: 40,
                                                height: 40,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          allVideos
                                                              .elementAt(i)
                                                              .filename!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: AppStyle.text2
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: AppColors
                                                                      .sonaBlack2),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                                                      .sonaGrey2),
                                                        ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 0),
                                                          child: Text(
                                                            timeago.format(DateTime
                                                                .parse(allVideos
                                                                    .elementAt(
                                                                        i)
                                                                    .createdAt!)),
                                                            style: AppStyle.text0.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .sonaGrey3),
                                                          )),
                                                    ],
                                                  ),

                                                  // should be here
                                                  const SizedBox(height: 10),
                                                  if (allVideos
                                                          .elementAt(i)
                                                          .analysed! ==
                                                      0)
                                                    const SizedBox(height: 10),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3.0.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        if (allVideos
                                                                .elementAt(i)
                                                                .analysed! ==
                                                            1)
                                                          SizedBox(
                                                            height: 20.h,
                                                            width: 150.w,
                                                            child: AppButton(
                                                                buttonType:
                                                                    ButtonType
                                                                        .tertiary,
                                                                buttonText:
                                                                    "view_analytics"
                                                                        .tr(),
                                                                vertical: 0,
                                                                onPressed: () {
                                                                  if (allVideos
                                                                          .elementAt(
                                                                              i)
                                                                          .firstView! ==
                                                                      0) {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder: (BuildContext
                                                                                context) =>
                                                                            VerifyTeamPopUpScreen(
                                                                              videoID: allVideos.elementAt(i).id,
                                                                              onSuccess: () {
                                                                                _onRefresh();
                                                                              },
                                                                            ));
                                                                  } else {
                                                                    serviceLocator
                                                                        .get<
                                                                            NavigationService>()
                                                                        .toWithPameter(
                                                                            routeName:
                                                                                RouteKeys.routeAnalysedVideosSingletonScreen,
                                                                            data: {
                                                                          "analyticsId": allVideos
                                                                              .elementAt(i)
                                                                              .id
                                                                        });
                                                                  }
                                                                }),
                                                          ),
                                                        if (allVideos
                                                                .elementAt(i)
                                                                .analysed! ==
                                                            0)
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
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
                                                                    "verifying"
                                                                        .tr(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: AppStyle
                                                                        .text0
                                                                        .copyWith(
                                                                            fontSize:
                                                                                10.sp),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          75.h),
                                                                  Text(
                                                                    "40%",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: AppStyle.text0.copyWith(
                                                                        fontSize: 10
                                                                            .sp,
                                                                        color: AppColors
                                                                            .sonaBlack2),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 5.h),
                                                              SizedBox(
                                                                width: 130.h,
                                                                child:
                                                                    GradientProgressBar(
                                                                  percent: 40,
                                                                  gradient:
                                                                      AppColors
                                                                          .sonalysisGradient,
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .sonaGrey4,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        const SizedBox(
                                                            width: 20),
                                                        // InkWell(
                                                        //   onTap: () {},
                                                        //   child: Icon(
                                                        //     Icons.share,
                                                        //     size: 18.w,
                                                        //     color: AppColors
                                                        //         .sonaGrey3,
                                                        //   ),
                                                        // ),
                                                        // const SizedBox(
                                                        //     width: 20),
                                                        // InkWell(
                                                        //   onTap: () {},
                                                        //   child: Icon(
                                                        //     Iconsax.trash,
                                                        //     size: 18.w,
                                                        //     color: AppColors
                                                        //         .sonaRed,
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))),
                          ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  )));
  }
}
