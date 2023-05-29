import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/utils/colors.dart';

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
import '../../../core/enums/user_type.dart';
import '../../../core/models/response/TeamsListResponseModel.dart';
import '../../../core/models/response/UserResultModel.dart';
import '../../../core/utils/response_message.dart';
import '../../../features/common/cubit/common_cubit.dart';
import '../widgets/allPlayersModalWidget.dart';

class Pvp extends StatefulWidget {
  Pvp({Key? key}) : super(key: key);

  @override
  State<Pvp> createState() => _PvpState();
}

class _PvpState extends State<Pvp> {
  bool isLoading = true;
  TeamsListResponseModel? teamsListResponseModel;
  //List<String?> searchableList = [];
  late UserResultData userResultData;
  String? myId, myClubId;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() async {
    getData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    getData();
    _refreshController.loadComplete();
  }

  Future<void> getData() async {
    userResultData = (await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs))!;

    if (userResultData.user!.role!.toLowerCase() == UserType.player.type) {
      //print(userResultData!.user!.players![0].id.toString());
      myId = userResultData.user!.players![0].id;
      myClubId = userResultData.user!.players![0].clubId;
    } else if (userResultData.user!.role!.toLowerCase() ==
        UserType.owner.type) {
      myId = userResultData.user!.id;
      myClubId = userResultData.user!.clubs![0].id;
    } else {
      myId = userResultData.user!.staff![0].id;
      myClubId = userResultData.user!.staff![0].clubId;
    }

    // print("Token::: "+userResultData!.user!.clubs!.length.toString());
    // print("Token2::: "+userResultData!.user!.clubs![0].id.toString());
    await serviceLocator<CommonCubit>().getTeamList(myClubId!);
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
              if (state is TeamListLoading) {
                setState(() {
                  isLoading = true;
                });
                context.loaderOverlay.show();
              }

              if (state is TeamListError) {
                setState(() {
                  isLoading = false;
                });
                context.loaderOverlay.hide();
                ResponseMessage.showErrorSnack(
                    context: context, message: state.message);
              }

              if (state is TeamListSuccess) {
                context.loaderOverlay.hide();
                setState(() {
                  isLoading = false;
                  teamsListResponseModel =
                      serviceLocator.get<TeamsListResponseModel>();
                });
              }
            },
            child: null));
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
