import "package:flutter/material.dart";
import 'package:sonalysis/core/utils/images.dart';
import "package:sonalysis/lang/strings.dart";
import "package:sonalysis/style/styles.dart";

class AttachWhatModal extends StatelessWidget {
  const AttachWhatModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            color: sonaLightBlack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  AppAssets.attachCamera,
                  width: 60,
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.noRepeat,
                ),
                const SizedBox(width: 15),
              Image.asset(
                AppAssets.attachAudio,
                  width: 60,
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.noRepeat,
                ),
                const SizedBox(width: 15),
              Image.asset(
                AppAssets.attachDocs,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.noRepeat,
                ),
                const SizedBox(width: 15),
              Image.asset(
                  AppAssets.attachGallery,
                  width: 60,
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.noRepeat,
                ),
              ],
            ),
          ),
        ));
  }
}