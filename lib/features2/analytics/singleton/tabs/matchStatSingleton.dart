import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/models/response/AnalysedVideosSingletonModel.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/images.dart';

import '../../../../core/utils/styles.dart';

class MatchStatSingleton extends StatefulWidget {
  AnalysedVideosSingletonModel? analysedVideosSingletonModel;

  MatchStatSingleton({Key? key, this.analysedVideosSingletonModel}) : super(key: key);

  @override
  State<MatchStatSingleton> createState() =>
      _MatchStatSingletonState();
}

class _MatchStatSingletonState extends State<MatchStatSingleton> {

  @override
  Widget build(BuildContext context) {
    return widget.analysedVideosSingletonModel!.data!.clubStats!.isNotEmpty && widget.analysedVideosSingletonModel!.data!.actionsUrls!.isNotEmpty
        ? Container(
        margin: EdgeInsets.all(10.sp),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        decoration: BoxDecoration(
            color: AppColors.sonaGrey6,
            // border: Border.all(
            //   color: AppColors.sonaGrey6,
            // ),
            borderRadius: const BorderRadius.all(Radius.circular(AppConstants.circularRadius))),
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset(
                    AppAssets.clubLogo,
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).tempTeamName!,
                    textAlign: TextAlign.center,
                    style: AppStyle.text1.copyWith(
                      color: AppColors.sonaBlack2
                    ),
                  ),
                ],
              ),
              Text(
                widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).goals!.toString() + "-" + widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).goals!.toString(),
                textAlign: TextAlign.center,
                style: AppStyle.text2.copyWith(
                    color: AppColors.sonaBlack2
                ),
              ),
              Column(
                children: [
                  Image.asset(
                    AppAssets.clubLogo,
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).tempTeamName!.toString(),
                    textAlign: TextAlign.center,
                    style: AppStyle.text1.copyWith(
                        color: AppColors.sonaBlack2
                    ),
                  ),
                ],
              )
            ],
        ),
        const SizedBox(height: 30),
        playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).goals.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).goals.toString(), "goals_scored".tr()),
        const SizedBox(height: 30),
        playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).shots.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).shots.toString(), "shot_attempts".tr()),
        const SizedBox(height: 30),
        playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).ballPossession.toString()+"%", widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).ballPossession.toString()+"%", "ball_possession".tr()),
        const SizedBox(height: 30),
        playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).freeKick.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).freeKick.toString(), "free_kicks".tr()),
        const SizedBox(height: 30),
        playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).yellowCards.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).yellowCards.toString(), "yellow_cards".tr(), image:  AppAssets.yellowCard),
        const SizedBox(height: 30),
        playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).redCards.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).redCards.toString(), "red_cards".tr(),  image: AppAssets.redCard),
        const SizedBox(height: 30),
        playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).penalty.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).penalty.toString(), "penalty".tr()),
        const SizedBox(height: 30),
        playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).shortPass.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).shortPass.toString(), "short_pass".tr()),
        const SizedBox(height: 30),
        playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).longPass.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).longPass.toString(), "long_pass".tr()),
        const SizedBox(height: 30),
        playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).cross.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).cross.toString(), "cross".tr()),
        const SizedBox(height: 30),
       playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).corners.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).corners.toString(), "corner_kick".tr()),
        const SizedBox(height: 30),
      playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).freeThrow.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).freeThrow.toString(), "free_throw".tr()),
        const SizedBox(height: 30),
      playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).foul.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).foul.toString(), "foul".tr()),
        const SizedBox(height: 30),
      playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).saves.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).saves.toString(), "save".tr()),
        const SizedBox(height: 30),
      playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).dribble.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).dribble.toString(), "dribble".tr()),
        const SizedBox(height: 30),
      playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).tackles.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).tackles.toString(), "tackle".tr()),
          const SizedBox(height: 30),
      playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).interceptions.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).interceptions.toString(), "interceptions".tr()),
          const SizedBox(height: 30),
      playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).offside.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).offside.toString(), "offside".tr()),
          const SizedBox(height: 30),
      playerFeatures(widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(0).pitchSide.toString(), widget.analysedVideosSingletonModel!.data!.clubStats!.elementAt(1).pitchSide.toString(), "pitchSide".tr()),
        const SizedBox(height: 100),
      ],
    ))
        : Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Image.asset(
              AppAssets.cannot_load_data,
              fit: BoxFit.contain,
              repeat: ImageRepeat.noRepeat,
              width: 60),
        );
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(firstText!,
              textAlign: TextAlign.center,
              style: AppStyle.text0.copyWith(
                color: AppColors.sonaBlack2
              )),
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
                  style: AppStyle.text0.copyWith(
                      color: AppColors.sonaBlack2
                  )),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 25),
              Text(text!,
                  textAlign: TextAlign.center,
                  style: AppStyle.text0.copyWith(
                      color: AppColors.sonaBlack2
                  )),
            ],
          ),
          Text(secondText!,
              textAlign: TextAlign.center,
              style: AppStyle.text0.copyWith(
                  color: AppColors.sonaBlack2
              )),
        ],
      ),
    );
  }
}
