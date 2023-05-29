import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';

import '../core/utils/styles.dart';
import '../features/common/models/PlayersInATeamModel.dart';

class PlayerRowItem extends StatefulWidget {
  Players? player;
  Function? onSelect;

  PlayerRowItem({Key? key, this.player, this.onSelect}) : super(key: key);

  @override
  _PlayerRowItemState createState() => _PlayerRowItemState();
}

class _PlayerRowItemState extends State<PlayerRowItem> {
  Players? player;

  @override
  void initState() {
    player = widget.player;
    super.initState();
  }

  String gersi() {
    String ff = "Age ";
    if (player!.age == null) {
      ff = ff + "N/A";
    }

    ff = ff + " ~ No. ";
    if (player!.jerseyNo == null) {
      ff = ff + "N/A";
    } else {
      ff = ff + player!.jerseyNo!.substring(1);
    }

    if (player!.country == null) {
    } else {
      ff = ff + "~ " + player!.country!;
    }

    return ff;
  }

  String name() {
    print("player photo: ${player!.photo}");
    if (player!.firstName == null) {
      return "N/A";
    } else if (player!.lastName != null) {
      return player!.firstName!.substring(0, 1).toUpperCase() +
          player!.firstName!.substring(1);
    } else {
      return player!.firstName!.substring(0, 1).toUpperCase() +
          player!.firstName!.substring(1) +
          " " +
          player!.lastName!.substring(0, 1).toUpperCase() +
          player!.lastName!.substring(1);
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
                Players p = player!;
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
                              player!.photo == null ||
                                      !Uri.parse(player!.photo!).isAbsolute
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
                              )),
                              Text(
                                gersi(),
                                style: AppStyle.text2.copyWith(
                                    color: AppColors.sonaGrey3,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400),
                              ),
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
