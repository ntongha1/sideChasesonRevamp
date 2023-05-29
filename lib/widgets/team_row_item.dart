import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sonalysis/core/models/response/TeamsListResponseModel.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';

import '../core/utils/styles.dart';
import '../features/common/models/PlayersInATeamModel.dart';

class TeamRowItem extends StatefulWidget {
  TeamsListResponseModelData? player;
  Function? onSelect;

  TeamRowItem({Key? key, this.player, this.onSelect}) : super(key: key);

  @override
  _TeamRowItemState createState() => _TeamRowItemState();
}

class _TeamRowItemState extends State<TeamRowItem> {
  TeamsListResponseModelData? player;

  @override
  void initState() {
    player = widget.player;
    super.initState();
  }

  String name() {
    if (player!.teamName == null) {
      return "N/A";
    } else {
      return player!.teamName!.substring(0, 1).toUpperCase() +
          player!.teamName!.substring(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    {
      return Center(
          child: Container(
        width: MediaQuery.of(context).size.width,
        // padding: const EdgeInsets.symmetric(vertical: 3),
        margin: const EdgeInsets.only(bottom: 20),
        child: InkWell(
          onTap: () {},
          child: GestureDetector(
              onTap: () {
                widget.onSelect!(player!);
                TeamsListResponseModelData p = player!;
                p.selected = !p.selected!;
                setState(() {
                  player = p;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        //margin: const EdgeInsets.symmetric(vertical: 5),
                        //padding: const EdgeInsets.all(13),
                        height: 30,
                        width: 30,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.sonaBlack,
                          child: ClipOval(
                            child: Image.network(
                              (player!.photo == null ||
                                      player!.photo == "null" ||
                                      player!.photo == "" ||
                                      player!.photo == "same")
                                  ? AppConstants.defaultProfilePictures
                                  : player!.photo!,
                              fit: BoxFit.cover,
                              repeat: ImageRepeat.noRepeat,
                              width: 30.w,
                              height: 30.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  child: Text(
                                name(),
                                overflow: TextOverflow.ellipsis,
                                style: AppStyle.text2.copyWith(
                                    color: AppColors.sonaBlack,
                                    fontWeight: FontWeight.w400),
                              ))
                            ]),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          height: 20,
                          width: 20,
                          child: Container(
                            child: player!.selected!
                                ? SvgPicture.asset('assets/svgs/checkbox.svg')
                                : SvgPicture.asset(
                                    'assets/svgs/checkbox_holder.svg'),
                          )),
                    ],
                  )
                ],
              )),
        ),
      ));
    }
  }
}
