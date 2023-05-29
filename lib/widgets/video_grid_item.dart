import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/features/common/models/SinglePlayerModel.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/players_club_management/add_edit_player/addEditPlayer.dart';
import 'package:sonalysis/features2/club_management/screen_tabs/players_club_management/singleton/player_singleton.dart';
import 'package:sonalysis/helpers/helpers.dart';

import '../core/models/response/PlayerListResponseModel.dart';
import '../core/models/response/TeamsListResponseModel.dart';
import '../core/navigation/keys.dart';
import '../core/navigation/navigation_service.dart';
import '../core/utils/styles.dart';
import '../features/common/models/PlayersInATeamModel.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

class VideoGridItem extends StatefulWidget {
  dynamic video;
  Function(bool) onSelect;

  VideoGridItem({Key? key, this.video, required this.onSelect})
      : super(key: key);

  @override
  _VideoGridItemState createState() => _VideoGridItemState();
}

class _VideoGridItemState extends State<VideoGridItem> {
  dynamic video;

  bool selected = false;

  @override
  void initState() {
    video = widget.video;
    super.initState();
  }

  // String name() {
  //   if (player!.teamName == null) {
  //     return "N/A";
  //   } else {
  //     return player!.teamName!.substring(0, 1).toUpperCase() +
  //         player!.teamName!.substring(1);
  //   }
  // }

  // Future<File> genThumbnailFile(String path) async {
  //   final fileName = await VideoThumbnail.thumbnailFile(
  //     video: path,
  //     imageFormat: ImageFormat.PNG,
  //     maxHeight: 100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
  //     quality: 75,
  //   );

  //   // fileName

  //   return file;
  // }

  @override
  Widget build(BuildContext context) {
    {
      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3),
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          decoration: BoxDecoration(
              color: AppColors.sonaGrey6,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      child: Stack(
                        children: [
                          Image.asset('assets/images/videos.png'),
                          Positioned(
                              top: 50,
                              width: MediaQuery.of(context).size.width * 0.44,
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/svgs/player_icon.svg',
                                  width: 30,
                                  height: 30,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video["title"],
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppStyle.text1
                              .copyWith(color: AppColors.sonaBlack),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          video["league"],
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppStyle.text0
                              .copyWith(color: AppColors.sonaGrey3),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            widget.onSelect(selected);

                            setState(() {
                              selected = !selected;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                video["uploaded"],
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: AppStyle.text0
                                    .copyWith(color: AppColors.sonaBlack),
                              ),
                              Container(
                                height: 20,
                                width: 20,
                                child: Container(
                                  child: selected
                                      ? SvgPicture.asset(
                                          'assets/svgs/checkbox.svg')
                                      : SvgPicture.asset(
                                          'assets/svgs/checkbox_holder.svg'),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  //const SizedBox(height: 10)
                ],
              )),
        ),
      );
    }
  }
}
