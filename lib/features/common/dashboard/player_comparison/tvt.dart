import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/models/response/TeamsListResponseModel.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/styles.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/features/common/dashboard/widgets/selectPlayersWidget.dart';
import 'package:sonalysis/features/common/dashboard/widgets/selectTeamsWidget.dart';
import 'package:sonalysis/features/common/models/PlayersInATeamModel.dart';
import 'package:sonalysis/widgets/player_grid_item.dart';
import 'package:sonalysis/widgets/team_grid_item.dart';

import '../../../../core/datasource/key.dart';
import '../../../../core/datasource/local_storage.dart';
import '../../../../core/models/response/UserResultModel.dart'
    as UserResultModel;
import '../../../../core/models/response/VideoListResponseModel.dart';
import '../../../../core/startup/app_startup.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/images.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/app_dropdown_modal.dart';
import '../../../../core/widgets/button.dart';
import '../../cubit/common_cubit.dart';
import '../../models/AllPlayerInUploadedVideoModel.dart' as videoModel;
import '../../models/ComparePlayersModel.dart';
import '../widgets/allPlayersModalWidget.dart';

class Tvt extends StatefulWidget {
  Function canCompare;
  Tvt({Key? key, required this.canCompare}) : super(key: key);

  @override
  State<Tvt> createState() => _TvtState();
}

class _TvtState extends State<Tvt> {
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
  List<Players> playersSelected = [];
  List<Players> listOfPlayers = [];
  List<TeamsListResponseModelData> listOfteams = [];
  String clubId = "";
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
    //load all teams
    clubId = userResultData!.user!.clubs![0].id!;
    setState(() {});
    // context.loaderOverlay.show();
  }

  @override
  void initState() {
    _getData();
    playerSelectionController.text = "";
    teamSelectionController.text = "";
    super.initState();
  }

  void doSelect(Players player) {
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

  List<String> getIdsToCompare(List<TeamsListResponseModelData> teams) {
    List<String> ids = [];
    for (var item in teams) {
      ids.add(item.teamName!);
    }
    return ids;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: BlocListener(
            bloc: serviceLocator.get<CommonCubit>(),
            listener: (_, state) {},
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
                              "Select team".tr(),
                              style: AppStyle.text3.copyWith(
                                  color: AppColors.sonaBlack,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "You can select more than one".tr(),
                              style: AppStyle.text0.copyWith(
                                  color: AppColors.sonaGrey3,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 10.h),
                            AppTextField(
                              hintText: "Select".tr(),
                              controller: teamSelectionController,
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
                                    SelectTeamsWidget(
                                        clubId: clubId,
                                        onTeamsAdded:
                                            (List<TeamsListResponseModelData>
                                                players) {
                                          setState(() {
                                            listOfteams = players;
                                            teamSelectionController.text =
                                                listOfteams.length.toString() +
                                                    " Selected";
                                          });
                                          bool canComp = players.length > 0;
                                          widget.canCompare(canComp, "TVT",
                                              getIdsToCompare(listOfteams));
                                        }));
                              },
                            ),
                            listOfteams.length > 0
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
                                        //childAspectRatio: 8.0 / 9.0,
                                        children: List.generate(
                                            listOfteams.length, (index) {
                                          return TeamGridItem(
                                              teamsListResponseModelItem:
                                                  listOfteams.elementAt(index),
                                              onTap: () {
                                                setState(() {});
                                              });
                                        }),
                                      )
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                        const SizedBox(height: 80),
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
