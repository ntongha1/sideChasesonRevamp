import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sonalysis/core/models/response/StaffListResponseModel.dart';

import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/features/common/models/StaffInATeamModel.dart';

import '../core/utils/styles.dart';

class StaffRowItem extends StatefulWidget {
  StaffListResponseModelData? player;
  Function? onSelect;

  StaffRowItem({Key? key, this.player, this.onSelect}) : super(key: key);

  @override
  _StaffRowItemState createState() => _StaffRowItemState();
}

class _StaffRowItemState extends State<StaffRowItem> {
  StaffListResponseModelData? player;

  @override
  void initState() {
    player = widget.player;
    super.initState();
  }

  String gersi() {
    String ff = 'N/A';

    if (player!.user!.country == null) {
    } else {
      ff = player!.user!.country!;
    }

    return ff;
  }

  String name() {
    if (player!.user!.firstName == null) {
      return "N/A";
    } else if (player!.user!.lastName != null) {
      return player!.user!.firstName!.substring(0, 1).toUpperCase() +
          player!.user!.firstName!.substring(1);
    } else {
      return player!.user!.firstName!.substring(0, 1).toUpperCase() +
          player!.user!.firstName!.substring(1) +
          " " +
          player!.user!.lastName!.substring(0, 1).toUpperCase() +
          player!.user!.lastName!.substring(1);
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
                              (player!.user!.photo == null ||
                                      player!.user!.photo == "same")
                                  ? AppConstants.defaultProfilePictures
                                  : player!.user!.photo!,
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
                      GestureDetector(
                          onTap: () {
                            widget.onSelect!(player!);
                            StaffListResponseModelData p = player!;
                            p.staff!.selected = !p.staff!.selected!;
                            setState(() {
                              player = p;
                            });
                          },
                          child: Container(
                              height: 20,
                              width: 20,
                              child: Container(
                                child: player!.staff!.selected!
                                    ? SvgPicture.asset(
                                        'assets/svgs/checkbox.svg')
                                    : SvgPicture.asset(
                                        'assets/svgs/checkbox_holder.svg'),
                              ))),
                    ],
                  )
                ],
              )),
        ),
      );
    }
  }
}
