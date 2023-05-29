import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/lang/strings.dart';

import '../core/utils/constants.dart';
import '../features/common/models/AllPlayerInUploadedVideoModel.dart';


class ComparisonPlayerGridItem extends StatefulWidget {
  const ComparisonPlayerGridItem({Key? key, this.teamType, this.teamAPlayersList, this.teamBPlayersList}) : super(key: key);

  final String? teamType;
  final TeamA? teamAPlayersList;
  final TeamB? teamBPlayersList;

  @override
  _ComparisonPlayerGridItemState createState() => _ComparisonPlayerGridItemState();
}

class _ComparisonPlayerGridItemState extends State<ComparisonPlayerGridItem> {

  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        // decoration: BoxDecoration(
        //     color: Colors.black,
        //     border: Border.all(
        //       color: Colors.black,
        //     ),
        //     borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: InkWell(
            onTap: () {
              setState(() {
                _selected = true;
              });
              if (widget.teamType == "A") {
                Navigator.of(context).pop(widget.teamAPlayersList!.players);
              }

              if (widget.teamType == "B") {
                Navigator.of(context).pop(widget.teamBPlayersList!.players);
              }

            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    if (widget.teamType == "A")
                    Container(
                        alignment: Alignment.center,
                        //margin: const EdgeInsets.symmetric(vertical: 5),
                        //padding: const EdgeInsets.all(13),
                        height: 70,
                        child:
                        widget.teamAPlayersList!.players!.photo != null
                            ? CircleAvatar(
                            radius: 110,
                            backgroundImage:
                            NetworkImage(widget.teamAPlayersList!.players!.photo == null
                                ? AppConstants.defaultProfilePictures
                                : widget.teamAPlayersList!.players!.photo!
                            ))
                            : Image.asset(AppAssets.placeholder,
                            fit: BoxFit.contain,
                            repeat: ImageRepeat.noRepeat,
                            width: 90)),
                    if (widget.teamType == "B")
                    Container(
                        alignment: Alignment.center,
                        //margin: const EdgeInsets.symmetric(vertical: 5),
                        //padding: const EdgeInsets.all(13),
                        height: 70,
                        child:
                        widget.teamBPlayersList!.players!.photo != null
                            ? CircleAvatar(
                            radius: 110,
                            backgroundImage:
                            NetworkImage(widget.teamBPlayersList!.players!.photo == null
                                ? AppConstants.defaultProfilePictures
                                : widget.teamBPlayersList!.players!.photo!
                            ))
                            :
                        Image.asset(AppAssets.placeholder,
                            fit: BoxFit.contain,
                            repeat: ImageRepeat.noRepeat,
                            width: 90)),
                    _selected
                    ? Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        height: 70,
                        child: Image.asset(AppAssets.pickedOverlay,
                            fit: BoxFit.cover,
                            repeat: ImageRepeat.noRepeat,
                            width: 70))
                    : Container()
                  ],
                ),
                const SizedBox(height: 5),
                if (widget.teamType == "A")
                SizedBox(
                    width: 200.0,
                    child: Text(
                      widget.teamAPlayersList!.players!.firstName! + " " + widget.teamAPlayersList!.players!.lastName!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                if (widget.teamType == "B")
                SizedBox(
                    width: 200.0,
                    child: Text(
                      widget.teamBPlayersList!.players!.firstName! + " " + widget.teamBPlayersList!.players!.lastName!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                if (widget.teamType == "A")
                Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      widget.teamAPlayersList!.players!.position == null
                          ? ""
                          : widget.teamAPlayersList!.players!.position!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    )),
               if (widget.teamType == "B")
                Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                    widget.teamBPlayersList!.players!.position == null
                    ? ""
                    : widget.teamBPlayersList!.players!.position!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    )),
              ],
            )),
      ),
    );
  }
}
