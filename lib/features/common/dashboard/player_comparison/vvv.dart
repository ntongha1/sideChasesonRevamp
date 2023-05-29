import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/models/response/PlayerListResponseModel.dart';
import 'package:sonalysis/core/models/response/TeamsListResponseModel.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/styles.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/features/common/dashboard/widgets/selectPlayersWidgetClub.dart';
import 'package:sonalysis/features/common/models/PlayersInATeamModel.dart';
import 'package:sonalysis/features/common/models/SinglePlayerModel.dart' as sp;
import 'package:sonalysis/widgets/player_grid_item.dart';
import 'package:sonalysis/widgets/video_grid_item.dart';
// import 'package:sonalysis/widgets/video_grid_item.dart';

import '../../../../core/datasource/key.dart';
import '../../../../core/datasource/local_storage.dart';
import '../../../../core/models/response/UserResultModel.dart'
    as UserResultModel;
import '../../../../core/models/response/VideoListResponseModel.dart';
import '../../../../core/startup/app_startup.dart';
import '../../../../core/utils/helpers.dart';
import '../../cubit/common_cubit.dart';
import '../../models/AllPlayerInUploadedVideoModel.dart' as videoModel;
import '../../models/ComparePlayersModel.dart';

class Vvv extends StatefulWidget {
  Function canCompare;
  Vvv({Key? key, required this.canCompare}) : super(key: key);

  @override
  State<Vvv> createState() => _VvvState();
}

class _VvvState extends State<Vvv> {
  UserResultModel.UserResultData? userResultData;
  bool isLoading = false,
      showPlayerSelection = false,
      playerASelected = false,
      playerBSelected = false,
      submited = false;
  VideoListResponseModel? videoListResponseModel;
  TeamsListResponseModelData? _selectedVideo;
  String selectedTeamTitle = "";
  String selectedPlayersTitle = "";
  videoModel.AllPlayerInUploadedVideoModel? allPlayerInUploadedVideoModel;
  videoModel.Players? playerASelectedDetails, playerBSelectedDetails;
  TextEditingController playerSelectionController = TextEditingController();
  TextEditingController teamSelectionController = TextEditingController();
  ComparePlayersModel? comparePlayersModel;
  TeamsListResponseModel? teamList;
  bool playersLoading = false;
  PlayersInATeamModel? playersList;
  List<PlayerListResponseModelData> playersSelected = [];
  List<PlayerListResponseModelData> listOfPlayers = [];
  List<TeamsListResponseModelData> listOfteams = [];
  String clubId = "";
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  bool loadingVideos = false;
  final Client _httpClient = Client();

  List<dynamic> playersDetails = [];

  sp.Player? singlePlayer;
  sp.Videos? videos;
  List<dynamic> videosall = [];
  List<dynamic> videosselected = [];

  void _onRefresh() async {
    _getData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _getData();
    _refreshController.loadComplete();
  }

  Future<void> _getData() async {
    setState(() {
      loadingVideos = false;
    });
    videos = new sp.Videos();
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    //load all teams
    clubId = userResultData!.user!.clubs![0].id!;
    setState(() {});
    // context.loaderOverlay.show();
  }

  String name(PlayerListResponseModelData player) {
    if (player.firstName == null) {
      return "N/A";
    } else if (player.lastName != null) {
      return player.firstName!.substring(0, 1).toUpperCase() +
          player.firstName!.substring(1);
    } else {
      return player.firstName!.substring(0, 1).toUpperCase() +
          player.firstName!.substring(1) +
          " " +
          player.lastName!.substring(0, 1).toUpperCase() +
          player.lastName!.substring(1);
    }
  }

  @override
  void initState() {
    _getData();
    playerSelectionController.text = "";
    teamSelectionController.text = "";
    super.initState();
  }

  void doSelect(PlayerListResponseModelData player) {
    if (playersSelected.contains(player)) {
      playersSelected.remove(player);
    } else {
      playersSelected.add(player);
    }
    setState(() {});
  }

  List<String> getIds(List<TeamsListResponseModelData> teams) {
    List<String> ids = [];
    for (var item in teams) {
      ids.add(item.teamName!);
    }
    return ids;
  }

  List<String> getIdsToCompare(List<Players> teams) {
    List<String> ids = [];
    for (var item in teams) {
      ids.add(item.id!);
    }
    return ids;
  }

  void loadVideos(String id) async {
    // print("result + i was here");
    await serviceLocator<CommonCubit>().getSinglePlayerProfile(id);
  }

  void loadPlayerDetails(ps) async {
    for (var item in ps) {
      var playerr = await getPlayerDetails(item);
      var beforeVideos = videosall;
      var nowVideos = playerr['videos']['videos'];

      for (var i = 0; i < nowVideos.length; i++) {
        nowVideos[i]['player'] = playerr;
      }

      videosall = beforeVideos + nowVideos;
    }

    var dummyVideos = [
      {
        "id": "1",
        "title": "Video 1",
        "league": "Premier League",
        "uploaded": "2 days ago",
        "selected": false
      },
      {
        "id": "2",
        "title": "Video 2",
        "league": "Premier League",
        "uploaded": "2 days ago",
        "selected": false
      },
      {
        "id": "3",
        "title": "Video 3",
        "league": "Premier League",
        "uploaded": "2 days ago",
        "selected": false
      }
    ];

    setState(() {
      videosall = dummyVideos;

      loadingVideos = false;
    });

    print("videosall " + videosall.length.toString());
  }

  dynamic getPlayerDetails(p) async {
    setState(() {
      loadingVideos = true;
    });
    String url = ApiConstants.getSinglePlayerInfo + p.id;

    Map<String, String> header = {};
    header = {'Content-Type': 'application/json', 'accept': '*/*'};
    print("dataDD " + url);

    Response? res = await _httpClient.get(Uri.parse(url), headers: header);
    print("dataDD " + res.statusCode.toString());

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      print('dataDD:' + data['data'].toString());
      return data['data']['player'];
    } else {
      return null;
    }
  }

  void makeNamesList(ps) {
    List<String> names = [];

    for (var item in ps) {
      names.add(item.firstName);
    }

    // join the list with comma
    String namesString = names.join(', ');

    print("names " + ps.length.toString());

    playerSelectionController.text = namesString;

    setState(() {});
  }

  void removeSelection(index) {
    var videoInContext = videosall[index];

    // remove that video from the videosselected
    videosselected
        .removeWhere((element) => element['id'] == videoInContext['id']);
    if (videosselected.length > 0) {
      widget.canCompare(
          true, {"videos": videosselected, "players": playersSelected});
    } else {
      widget.canCompare(
          false, {"videos": videosselected, "players": playersSelected});
    }
    setState(() {});
  }

  void addSelection(index) {
    var videoInContext = videosall[index];

    // add that video to the videosselected
    videosselected.add(videoInContext);

    if (videosselected.length > 0) {
      widget.canCompare(
          true, {"videos": videosselected, "players": playersSelected});
    } else {
      widget.canCompare(
          false, {"videos": videosselected, "players": playersSelected});
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocListener(
        bloc: serviceLocator.get<CommonCubit>(),
        listener: (_, state) {
          if (state is GetSinglePlayerProfileInitial) {
            setState(() {
              loadingVideos = true;
            });
          }

          if (state is GetSinglePlayerProfileError) {
            setState(() {
              loadingVideos = false;
            });
            context.loaderOverlay.hide();
            ResponseMessage.showErrorSnack(
                context: context, message: state.message);
          }

          if (state is GetSinglePlayerProfileSuccess) {
            context.loaderOverlay.hide();
            sp.SinglePlayerModel spp =
                serviceLocator.get<sp.SinglePlayerModel>();
            print("result +" + spp.data!.videos!.videos!.length.toString());
            print(spp.data!.videos!.videos!.length);
            setState(() {
              loadingVideos = false;
              singlePlayer =
                  serviceLocator.get<sp.SinglePlayerModel>().data!.player!;
              videos = serviceLocator.get<sp.SinglePlayerModel>().data!.videos!;
            });
          }
        },
        child: isLoading
            ? Container()
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40.h),
                        Text(
                          "Select players".tr(),
                          style: AppStyle.text3.copyWith(
                              color: AppColors.sonaBlack,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 10.h),
                        AppTextField(
                          hintText: "Select".tr(),
                          controller: playerSelectionController,
                          readOnly: true,
                          suffixWidget: Container(
                              width: 20.w,
                              height: 20.h,
                              margin: EdgeInsets.only(right: 20),
                              child: SvgPicture.asset(
                                  'assets/svgs/drop_grey.svg')),
                          onTap: () {
                            bottomSheet(
                                context,
                                SelectPlayersWidgetClub(
                                    single: true,
                                    clubId: clubId,
                                    onPlayersAdded:
                                        (List<PlayerListResponseModelData>
                                            players) {
                                      // print("works againt too");
                                      setState(() {
                                        listOfPlayers = players;
                                        loadPlayerDetails(players);
                                        makeNamesList(players);
                                      });
                                      // loadVideos(players[0].id!);
                                    }));
                          },
                        ),
                      ],
                    ),
                    playerSelectionController.text != "" //video selected
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 40.h),
                              Text(
                                "Videos".tr() +
                                    " (" +
                                    videosselected.length.toString() +
                                    ")",
                                style: AppStyle.text3.copyWith(
                                    color: AppColors.sonaBlack,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "You can select more than two".tr(),
                                style: AppStyle.text0.copyWith(
                                    color: AppColors.sonaGrey3,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 10.h),
                              (videosall.isEmpty && playersDetails.isEmpty) &&
                                      !loadingVideos
                                  ? Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Center(
                                        child: Text(
                                            "No videos uploaded for these players"),
                                      ),
                                    )
                                  : Container(),
                              loadingVideos
                                  ? Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Center(
                                          child: CircularProgressIndicator()))
                                  : Container(),
                            ],
                          )
                        : SizedBox.shrink(),
                    const SizedBox(height: 10),
                    !videosall.isEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                padding: const EdgeInsets.only(top: 4),
                                childAspectRatio: 1 / 1.4,
                                children:
                                    List.generate(videosall.length, (index) {
                                  return VideoGridItem(
                                    onSelect: (s) {
                                      if (s) {
                                        removeSelection(index);
                                      } else {
                                        addSelection(index);
                                      }
                                    },
                                    video: videosall.elementAt(index),
                                    // onTap: () {
                                    //   setState(() {});
                                    // },
                                  );
                                }),
                              )
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
    );
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
