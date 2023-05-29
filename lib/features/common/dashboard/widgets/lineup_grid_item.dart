import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/features/common/models/LineUpModel.dart';

import '../../../../core/utils/colors.dart';
import '../../../../features2/club_management/screen_tabs/players_club_management/singleton/player_line_up_singleton.dart';
import '../../../../features2/analytics/widgets/verify_player_popup.dart';

class LineUpPlayerGridItem extends StatefulWidget {
  final Data? lineupData;

  const LineUpPlayerGridItem({Key? key, this.lineupData}) : super(key: key);
  @override
  _LineUpPlayerGridItemState createState() => _LineUpPlayerGridItemState();
}

class _LineUpPlayerGridItemState extends State<LineUpPlayerGridItem> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
          onTap: () {
            //if (widget.lineupData!.players!.profileUpdated == 0) {
            // showDialog(
            //     context: context,
            //     barrierDismissible: false,
            //     builder: (BuildContext context) => VerifyPlayerPopUpScreen(
            //         playerID: widget.lineupData!.playerId!)).then((value) {
            //   if (value) {
            //     pushNewScreen(
            //       context,
            //       screen: PlayerLineUpSingletonScreen(
            //           playerID: widget.lineupData!.playerId!),
            //       withNavBar: false, // OPTIONAL VALUE. True by default.
            //       pageTransitionAnimation: PageTransitionAnimation.cupertino,
            //     );
            //   }
            // });
            // } else {
            //   pushNewScreen(
            //    context,
            //    screen: PlayerLineUpSingletonScreen(players: widget.lineupData!.players!),
            //    withNavBar: false, // OPTIONAL VALUE. True by default.
            //    pageTransitionAnimation: PageTransitionAnimation.cupertino,
            //    );
            // }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: BoxDecoration(
                // color: Colors.black,
                // border: Border.all(
                //   color: Colors.black,
                // ),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        //margin: const EdgeInsets.symmetric(vertical: 5),
                        //padding: const EdgeInsets.all(13),
                        height: 70,
                        child: CircleAvatar(
                            radius: 30,
                            // backgroundColor: AppColors.sonaBlack,
                            child: ClipOval(
                              child: Image.network(
                                widget.lineupData!.players![0].photo! != null
                                    ? widget.lineupData!.players![0].photo!
                                    : AppConstants.defaultProfilePictures,
                                fit: BoxFit.cover,
                                repeat: ImageRepeat.noRepeat,
                                width: 55.w,
                                height: 55.h,
                              ),
                            ))),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                    width: 150.0,
                    child: Text(
                      widget.lineupData!.players![0].firstName!
                              .substring(0, 1)
                              .toUpperCase() +
                          widget.lineupData!.players![0].lastName!.substring(1),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.sonaBlack,
                          fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 5),
                Text(
                  widget.lineupData!.players![0].position != null
                      ? widget.lineupData!.players![0].position!
                      : "Unknown",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.sonaBlack),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.lineupData!.players![0].jerseyNumber == ""
                      ? ""
                      : "No. " + widget.lineupData!.players![0].jerseyNumber!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.sonaBlack),
                ),
              ],
            ),
          )),
    );
  }
}
