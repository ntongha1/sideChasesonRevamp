import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/custom_button.dart';

class RevokeDialog extends StatefulWidget {

  final Map? data;

  const RevokeDialog({Key? key, this.data}) : super(key: key);

  @override
  _RevokeDialogState createState() => _RevokeDialogState();
}

class _RevokeDialogState extends State<RevokeDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: sonaLightBlack,
      content: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        //width: MediaQuery.of(context).size.width,
        height: 350,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  child: Text(widget.data!["title"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.normal))),
              Container(
                  alignment: Alignment.center,
                  height: 120,
                  child: widget.data!["image"] == null
              ? Image.asset(imagesDir + "/player_img.png",
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.noRepeat,
                      width: 120)
              : Image.network(widget.data!["image"],
                fit: BoxFit.cover,
                repeat: ImageRepeat.noRepeat,
                width: 120)),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  alignment: Alignment.center,
                  child: Text(widget.data!["subTitle"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp))),
              Container(
                child: CustomButton(
                  text: "I’M SURE",
                  color: sonaPurple1,
                  action: () async {
                   Navigator.of(context).pop();
                  },
                ),
              )
            ]),
      ),
    );
  }

  Future<void> _nextPage(BuildContext context) async {
    if (widget.data!["route"] != null && widget.data!["route"] != "teamCreated" && widget.data!["route"] != "playerEditedCreated") {
      Navigator.pushReplacementNamed(context, widget.data!["route"]);
    } else if (widget.data!["route"] == "teamCreated" || widget.data!["route"] == "afterCreatedStaff" || widget.data!["route"] == "playerEditedCreated") {
      Navigator.of(context).pop(true);
    } else if (widget.data!["route"] == "teamCreated") {
      Navigator.pushReplacementNamed(context, routeLoginScreen);
    }

  }
}
