import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/styles.dart';

class TeamRowItemGlobal extends StatefulWidget {
  Function onTap;
  var player;
  TeamRowItemGlobal({Key? key, this.player, required this.onTap})
      : super(key: key);

  @override
  _TeamRowItemGlobalState createState() => _TeamRowItemGlobalState();
}

class _TeamRowItemGlobalState extends State<TeamRowItemGlobal> {
  var player;

  @override
  void initState() {
    player = widget.player;
    super.initState();
  }

  String name() {
    return player["name"];
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
          onTap: () {
            print("here");
            widget.onTap();
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
                          player["logo"] == null ||
                                  !Uri.parse(player["logo"]).isAbsolute
                              ? AppConstants.defaultProfilePictures
                              : player["logo"],
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
              )
            ],
          ),
        ),
      ));
    }
  }
}
