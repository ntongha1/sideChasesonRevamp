import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/models/response/AnalysedVideosSingletonModel.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/features/common/dashboard/widgets/selectPillsWidget.dart';
import 'package:sonalysis/features/common/models/ComparePVPModel.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../../../core/models/response/UserResultModel.dart';
import '../../../../core/utils/styles.dart';
import '../CustomTabView.dart';

class Highlights extends StatefulWidget {
  AnalysedVideosSingletonModel? analysedVideosSingletonModel;

  Highlights({Key? key, this.analysedVideosSingletonModel}) : super(key: key);

  @override
  State<Highlights> createState() => _HighlightsState();
}

class _HighlightsState extends State<Highlights>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? videoPlayerController, videoPlayerController2;
  String? dropdownValue;
  late List<Tab> myTabs;
  int? initPosition = 0;
  UserResultData? userResultData;
  bool isLoading = true;
  List<PillModel> pills = [];
  int pillPos = 0;

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'bo5f-tdgA4Y',
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
    ),
  );

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

  @override
  void initState() {
    super.initState();

    widget.analysedVideosSingletonModel!.data!.actionsUrls!.forEach((e) {
      if (e.name != null &&
          e.videoUrl != null &&
          Uri.parse(e.videoUrl!).isAbsolute) {
        pills.add(PillModel(
            title: capitalizeSentence(removeUnderscoreSentence(e.name!)),
            key: capitalizeSentence(removeUnderscoreSentence(e.name!)),
            value: e.videoUrl!));
      }
    });

    setState(() {});
    _getData();
    _refreshController.loadComplete();
    // print("......1 "+widget.analysedVideosSingletonModel!.data!.fullVideo!);
    // print("......2 "+widget.analysedVideosSingletonModel!.data!.minimap!);
  }

  bool isYoutubeVideo(String url) {
    return url.contains("youtube") || url.contains("youtu.be");
  }

  Future<void> _getData() async {
    // videoPlayerController = VideoPlayerController.network(
    //     widget.analysedVideosSingletonModel!.data!.fullVideo!)
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });

    print("starting first video");
    videoPlayerController = VideoPlayerController.network(pills[0].value)
      ..initialize().then((_) {
        print("starting first video 2");
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    // videoPlayerController2 = VideoPlayerController.network(
    //     widget.analysedVideosSingletonModel!.data!.minimap!)
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Container(
          //     decoration: BoxDecoration(
          //         color: AppColors.sonaWhite,
          //         border: Border.all(
          //           color: AppColors.sonalysisMediumPurple,
          //         ),
          //         borderRadius: const BorderRadius.all(Radius.circular(8))),
          //     child: DropdownButton<String>(
          //       value: dropdownValue,
          //       hint: Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 10),
          //         child: Text(
          //           "choose_a_team".tr(),
          //           overflow: TextOverflow.ellipsis,
          //           style: AppStyle.text1.copyWith(color: AppColors.sonaBlack2),
          //         ), 
          //       ),
          //       icon: Icon(Icons.keyboard_arrow_down_sharp,
          //           color: AppColors.sonaBlack2),
          //       iconSize: 20.sp,
          //       elevation: 16,
          //       dropdownColor: AppColors.sonaWhite,
          //       underline: Container(
          //         height: 0,
          //         color: AppColors.sonaWhite,
          //       ),
          //       onChanged: (newValue) {
          //         setState(() {
          //           dropdownValue = newValue;
          //         });
          //       },
          //       items: <String>[
          //         widget.analysedVideosSingletonModel!.data!.clubStats!
          //             .elementAt(0)
          //             .tempTeamName!,
          //         widget.analysedVideosSingletonModel!.data!.clubStats!
          //             .elementAt(1)
          //             .tempTeamName!
          //       ].map<DropdownMenuItem<String>>((String value) {
          //         return DropdownMenuItem<String>(
          //             value: value,
          //             child: Row(
          //               children: [
          //                 Image.asset(AppAssets.clubLogo,
          //                     fit: BoxFit.contain,
          //                     repeat: ImageRepeat.noRepeat,
          //                     width: 60),
          //                 Column(
          //                   children: [
          //                     Text(
          //                       value.length == 0
          //                           ? widget.analysedVideosSingletonModel!.data!
          //                               .clubStats!
          //                               .elementAt(0)
          //                               .tempTeamName!
          //                           : value,
          //                       overflow: TextOverflow.ellipsis,
          //                       style: AppStyle.text1
          //                           .copyWith(color: AppColors.sonaBlack2),
          //                     ),
          //                     Text(
          //                       "Soccer League".tr(),
          //                       overflow: TextOverflow.ellipsis,
          //                       style: AppStyle.text1
          //                           .copyWith(color: AppColors.sonaBlack2),
          //                     )
          //                   ],
          //                 )
          //               ],
          //             ));
          //       }).toList(),
          //     )),
          const SizedBox(height: 10),
          Column(
            children: [
              SelectPillsWidget(
                pills: pills,
                onSelect: (v) {
                  setState(() {
                    pillPos = pills.indexOf(v);
                  });
                  // String urlll =
                  //     "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
                  String urlll = v.value;

                  // String videoId = YoutubePlayer.convertUrlToId(urlll)!;
                  // print("tried:  " + videoId);
                  // _controller.load(videoId);
                  // _controller.play();

                  print("tried:  " + urlll);
                  // changePill(v);
                  if (videoPlayerController != null) {
                    videoPlayerController!.dispose();
                  }
                  print("tried:  2" + urlll);

                  videoPlayerController = VideoPlayerController.network(urlll)
                    ..initialize().then((_) {
                      print("tried: context url now: " + urlll);
                      videoPlayerController!.play();
                      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                      setState(() {});
                    });
                },
                horizontal: true,
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: isYoutubeVideo(pills[pillPos].value)
                          ? Container(
                              child: Text("lol"),
                            )
                          : videoPlayerController != null &&
                                  videoPlayerController!.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio:
                                      videoPlayerController!.value.aspectRatio,
                                  child: Stack(
                                    children: [
                                      VideoPlayer(videoPlayerController!),
                                      Center(
                                        child: Container(
                                          width: videoPlayerController!
                                              .value.size.width,
                                          height: videoPlayerController!
                                              .value.size.height,
                                          decoration: BoxDecoration(
                                            color: videoPlayerController!
                                                    .value.isPlaying
                                                ? Colors.black.withOpacity(0.0)
                                                : Colors.black.withOpacity(0.5),
                                            // borderRadius: const BorderRadius.only(
                                            //   topLeft: Radius.circular(50.0),
                                            //   topRight: Radius.circular(50.0),
                                            //   bottomLeft: Radius.circular(50.0),
                                            //   bottomRight: Radius.circular(50.0),
                                            // )
                                          ),
                                          child: videoPlayerController!
                                                  .value.isBuffering
                                              ? Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 50),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              AppColors
                                                                  .sonaPurple1),
                                                    ),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      videoPlayerController!
                                                              .value.isPlaying
                                                          ? videoPlayerController!
                                                              .pause()
                                                          : videoPlayerController!
                                                              .play();
                                                    });
                                                  },
                                                  child: Icon(
                                                    videoPlayerController!
                                                            .value.isPlaying
                                                        ? Icons
                                                            .pause_circle_outline_outlined
                                                        : Icons
                                                            .play_circle_fill_outlined,
                                                    size: 60,
                                                    color:
                                                        videoPlayerController!
                                                                .value.isPlaying
                                                            ? Colors.black
                                                                .withOpacity(
                                                                    0.2)
                                                            : Colors.black
                                                                .withOpacity(
                                                                    0.6),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 50),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.sonaPurple1),
                                    ),
                                  ),
                                )),
                ],
              ),
            ],
          ),
          // Container(
          //   height: 320,
          //   child: CustomTabView(
          //     initPosition: initPosition,
          //     itemCount: widget
          //         .analysedVideosSingletonModel!.data!.actionsUrls!.length,
          //     tabBuilder: (context, index) => widget
          //                 .analysedVideosSingletonModel!
          //                 .data!
          //                 .actionsUrls![index]
          //                 .videoUrl!
          //                 .length ==
          //             0
          //         ? Container()
          //         : Container(
          //             child: Text(
          //               capitalizeSentence(removeUnderscoreSentence(widget
          //                   .analysedVideosSingletonModel!
          //                   .data!
          //                   .actionsUrls![index]
          //                   .name!)),
          //               style: AppStyle.text2.copyWith(
          //                   color: initPosition == index
          //                       ? Colors.white
          //                       : AppColors.sonaBlack2),
          //             ),
          //           ),
          //     pageBuilder: (context, index) => widget
          //                 .analysedVideosSingletonModel!
          //                 .data!
          //                 .actionsUrls![index]
          //                 .videoUrl!
          //                 .length ==
          //             0
          //         ? Container()
          //         : Column(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Container(
          //                   padding: const EdgeInsets.symmetric(vertical: 20),
          //                   child: videoPlayerController!.value.isInitialized
          //                       ? AspectRatio(
          //                           aspectRatio: videoPlayerController!
          //                               .value.aspectRatio,
          //                           child: Stack(
          //                             children: [
          //                               VideoPlayer(videoPlayerController!),
          //                               Center(
          //                                 child: Container(
          //                                   width: videoPlayerController!
          //                                       .value.size.width,
          //                                   height: videoPlayerController!
          //                                       .value.size.height,
          //                                   decoration: BoxDecoration(
          //                                     color: videoPlayerController!
          //                                             .value.isPlaying
          //                                         ? Colors.black
          //                                             .withOpacity(0.0)
          //                                         : Colors.black
          //                                             .withOpacity(0.5),
          //                                     // borderRadius: const BorderRadius.only(
          //                                     //   topLeft: Radius.circular(50.0),
          //                                     //   topRight: Radius.circular(50.0),
          //                                     //   bottomLeft: Radius.circular(50.0),
          //                                     //   bottomRight: Radius.circular(50.0),
          //                                     // )
          //                                   ),
          //                                   child: videoPlayerController!
          //                                           .value.isBuffering
          //                                       ? Container(
          //                                           margin: const EdgeInsets
          //                                                   .symmetric(
          //                                               vertical: 50),
          //                                           child: Center(
          //                                             child:
          //                                                 CircularProgressIndicator(
          //                                               valueColor:
          //                                                   AlwaysStoppedAnimation<
          //                                                           Color>(
          //                                                       AppColors
          //                                                           .sonaPurple1),
          //                                             ),
          //                                           ),
          //                                         )
          //                                       : GestureDetector(
          //                                           onTap: () {
          //                                             setState(() {
          //                                               videoPlayerController!
          //                                                       .value.isPlaying
          //                                                   ? videoPlayerController!
          //                                                       .pause()
          //                                                   : videoPlayerController!
          //                                                       .play();
          //                                             });
          //                                           },
          //                                           child: Icon(
          //                                             videoPlayerController!
          //                                                     .value.isPlaying
          //                                                 ? Icons
          //                                                     .pause_circle_outline_outlined
          //                                                 : Icons
          //                                                     .play_circle_fill_outlined,
          //                                             size: 60,
          //                                             color:
          //                                                 videoPlayerController!
          //                                                         .value
          //                                                         .isPlaying
          //                                                     ? Colors.black
          //                                                         .withOpacity(
          //                                                             0.2)
          //                                                     : Colors.black
          //                                                         .withOpacity(
          //                                                             0.6),
          //                                           ),
          //                                         ),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         )
          //                       : Container(
          //                           margin: const EdgeInsets.symmetric(
          //                               vertical: 50),
          //                           child: Center(
          //                             child: CircularProgressIndicator(
          //                               valueColor:
          //                                   AlwaysStoppedAnimation<Color>(
          //                                       AppColors.sonaPurple1),
          //                             ),
          //                           ),
          //                         )),
          //             ],
          //           ),
          //     onPositionChange: (index) {
          //       print('current position: $index');
          //       initPosition = index;
          //       videoPlayerController = VideoPlayerController.network(widget
          //           .analysedVideosSingletonModel!
          //           .data!
          //           .actionsUrls![initPosition!]
          //           .videoUrl!)
          //         ..initialize().then((_) {
          //           // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          //           setState(() {});
          //         });
          //     },
          //     // onScroll: (position) {
          //     //   print('current position: $position');
          //     //   initPosition = int.parse(position.toString());
          //     //   // videoPlayerController = VideoPlayerController.network(
          //     //   //     widget.analysedVideosSingletonModel!.data!.highlightReels![initPosition!].videoUrl!
          //     //   // )..initialize();
          //     //   setState(() {});
          //     // },
          //   ),
          // ),
          Text(
            widget.analysedVideosSingletonModel!.data!.clubStats!
                    .elementAt(0)
                    .tempTeamName! +
                " vs " +
                widget.analysedVideosSingletonModel!.data!.clubStats!
                    .elementAt(1)
                    .tempTeamName!,
            style: AppStyle.text2.copyWith(color: AppColors.sonaBlack2),
          ),
          const SizedBox(height: 5),
          Text(
              HighlightHelpers().formatTime(
                      widget.analysedVideosSingletonModel!.data!.videoLength) +
                  ' mins',
              style: AppStyle.text0.copyWith(
                color: AppColors.sonaGrey4,
              )),
          Divider(
            height: 30.h,
            thickness: 1,
            color: AppColors.sonaGrey6,
          ),
          Text("all_events".tr(),
              style: AppStyle.text2.copyWith(color: AppColors.sonaBlack2)),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(
                  widget.analysedVideosSingletonModel!.data!.actions!.length,
                  (index) => GestureDetector(
                    onTap: () {
                      videoPlayerController!.seekTo(Duration(
                          seconds: widget.analysedVideosSingletonModel!.data!
                              .actions![index].timeSeconds!));
                      //navigate(context, StreamingScreen(streamingLink: model.highlightPerCategoryModelGallery!.data!.highlightPerCategory![index].tvShowVideoUrl!));
                    },
                    child: Container(
                      width: 250.w,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          color: AppColors.sonaGrey6),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(right: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 90,
                            height: 60,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(9)),
                              child: Image.asset(
                                AppAssets.goalEvents,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                  widget.analysedVideosSingletonModel!.data!
                                          .actions![index].endTime!
                                          .toString() +
                                      "' " +
                                      widget.analysedVideosSingletonModel!.data!
                                          .actions![index].player!,
                                  style: AppStyle.text2
                                      .copyWith(color: AppColors.sonaBlack2)),
                              const SizedBox(height: 10),
                              // Row(
                              //   children: [
                              //     Text(
                              //       HighlightHelpers().formatTime(widget
                              //               .analysedVideosSingletonModel!
                              //               .data!
                              //               .actions![index]
                              //               .startTime) +
                              //           " - " +
                              //           HighlightHelpers().formatTime(widget
                              //               .analysedVideosSingletonModel!
                              //               .data!
                              //               .actions![index]
                              //               .endTime),
                              //       style: AppStyle.text0
                              //           .copyWith(color: AppColors.sonaGrey3),
                              //     ),
                              //     SizedBox(width: 70),
                              //     Icon(Icons.share,
                              //         color: AppColors.sonaGrey3, size: 22),
                              //   ],
                              // ),
                              Row(
                                children: [
                                  Text(
                                    widget.analysedVideosSingletonModel!.data!
                                        .actions![index].action!.name!,
                                    style: AppStyle.text0
                                        .copyWith(color: AppColors.sonaGrey3),
                                  ),
                                  SizedBox(width: 70),
                                  Icon(Icons.share,
                                      color: AppColors.sonaGrey3, size: 22),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Text("Minimap".tr(),
          //     style: AppStyle.text2.copyWith(color: AppColors.sonaBlack2)),
          // const SizedBox(height: 5),
          // Container(
          //     padding: const EdgeInsets.symmetric(vertical: 10),
          //     child: videoPlayerController2 != null &&
          //             videoPlayerController2!.value.isInitialized
          //         ? AspectRatio(
          //             aspectRatio: videoPlayerController2!.value.aspectRatio,
          //             child: Stack(
          //               children: [
          //                 VideoPlayer(videoPlayerController2!),
          //                 Center(
          //                   child: Container(
          //                     width: videoPlayerController2!.value.size.width,
          //                     height: videoPlayerController2!.value.size.height,
          //                     decoration: BoxDecoration(
          //                       color: videoPlayerController2!.value.isPlaying
          //                           ? Colors.black.withOpacity(0.0)
          //                           : Colors.black.withOpacity(0.5),
          //                       // borderRadius: const BorderRadius.only(
          //                       //   topLeft: Radius.circular(50.0),
          //                       //   topRight: Radius.circular(50.0),
          //                       //   bottomLeft: Radius.circular(50.0),
          //                       //   bottomRight: Radius.circular(50.0),
          //                       // )
          //                     ),
          //                     child: videoPlayerController2!.value.isBuffering
          //                         ? Container(
          //                             margin: const EdgeInsets.symmetric(
          //                                 vertical: 50),
          //                             child: Center(
          //                               child: CircularProgressIndicator(
          //                                 valueColor:
          //                                     AlwaysStoppedAnimation<Color>(
          //                                         AppColors.sonaPurple1),
          //                               ),
          //                             ),
          //                           )
          //                         : GestureDetector(
          //                             onTap: () {
          //                               setState(() {
          //                                 videoPlayerController2!
          //                                         .value.isPlaying
          //                                     ? videoPlayerController2!.pause()
          //                                     : videoPlayerController2!.play();
          //                               });
          //                             },
          //                             child: Icon(
          //                               videoPlayerController2!.value.isPlaying
          //                                   ? Icons
          //                                       .pause_circle_outline_outlined
          //                                   : Icons.play_circle_fill_outlined,
          //                               size: 60,
          //                               color: videoPlayerController2!
          //                                       .value.isPlaying
          //                                   ? Colors.black.withOpacity(0.2)
          //                                   : Colors.black.withOpacity(0.6),
          //                             ),
          //                           ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           )
          //         : Container(
          //             margin: const EdgeInsets.symmetric(vertical: 50),
          //             child: Center(
          //               child: CircularProgressIndicator(
          //                 valueColor: AlwaysStoppedAnimation<Color>(
          //                     AppColors.sonaPurple1),
          //               ),
          //             ),
          //           )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController!.dispose();
    videoPlayerController2!.dispose();
  }
}

class HighlightHelpers {
  String formatTime(int? seconds) {
    return '${(Duration(seconds: seconds!))}'.split('.')[0].padLeft(8, '0');
  }
}
