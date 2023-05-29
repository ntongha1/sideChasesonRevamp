import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/models/response/VideoListResponseModel.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/lang/strings.dart';

import '../../../../core/utils/images.dart';

class ComparisonVideoGridItem extends StatefulWidget {
  final VideoListResponseModelData? videoListResponseModelData;

  const ComparisonVideoGridItem({Key? key, this.videoListResponseModelData})
      : super(key: key);

  @override
  _ComparisonVideoGridItemState createState() =>
      _ComparisonVideoGridItemState();
}

class _ComparisonVideoGridItemState extends State<ComparisonVideoGridItem> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            _selected = true;
          });
          Navigator.of(context).pop(widget.videoListResponseModelData);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    AppAssets.analyticsImage,
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    //width: 100,
                    //height: 80,
                  ),
                  _selected
                      ? Image.asset(AppAssets.pickedOverlay2, fit: BoxFit.cover, repeat: ImageRepeat.noRepeat)
                      : Container()
                ],
              ),
              // Container(
              //   margin: const EdgeInsets.only(top: 5),
              //   padding: const EdgeInsets.all(5),
              //   child: Text.rich(
              //     TextSpan(
              //       style: TextStyle(fontSize: 13.sp, color: Colors.white, background: Paint()..color = Colors.black
              //         ..strokeWidth = 10
              //         ..style = PaintingStyle.stroke),
              //       children: [
              //         const TextSpan(text: "Teams: ",
              //           style: TextStyle(fontWeight: FontWeight.normal)),
              //         TextSpan(
              //           text: "Team A",
              //           style: const TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //         const TextSpan(
              //           text: " vs ",
              //           style: TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //         TextSpan(
              //           //text: widget.dataList.modelData.teamB.players.elementAt(0).team,
              //           text: "Team B",
              //           style: const TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //       ],
              //     ),
              //   )
              //
              //
              //
              // ),
              // Container(
              //   margin: const EdgeInsets.only(top: 5),
              //   padding: const EdgeInsets.all(5),
              //   child: Text.rich(
              //     TextSpan(
              //         style: TextStyle(fontSize: 13.sp, color: Colors.white, background: Paint()..color = Colors.black
              //           ..strokeWidth = 10
              //           ..style = PaintingStyle.stroke),
              //       children: const [
              //         TextSpan(text: "Competition: ",
              //           style: TextStyle(fontWeight: FontWeight.normal)),
              //         TextSpan(
              //           //text: widget.videosListResponseModelData.modelData.teamA.players.elementAt(0).team,
              //           text: "Premier League",
              //           style: TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //       ],
              //     ),
              //   )
              // ),
            ],
          ),
        ));
  }
}
