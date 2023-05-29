import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/custom_button.dart';

class PopUpPageScreen extends StatefulWidget {

  final Map? data;

  const PopUpPageScreen({Key? key, this.data}) : super(key: key);

  @override
  _PopUpPageScreenState createState() => _PopUpPageScreenState();
}

class _PopUpPageScreenState extends State<PopUpPageScreen> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: sonaLightBlack,
      content: Container(
        decoration: BoxDecoration(
            color: sonaLightBlack,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        width: MediaQuery.of(context).size.width,
        height: 320,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset(
                lottieDir + '/success.json',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              Image.asset(
                imagesDir + widget.data!["image"],
                fit: BoxFit.contain,
                repeat: ImageRepeat.noRepeat,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: CustomButton(
                  text: widget.data!["buttonText"].toUpperCase() ?? "CONTINUE",
                  color: sonaPurple1,
                  action: () async {
                    _nextPage(context);
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
