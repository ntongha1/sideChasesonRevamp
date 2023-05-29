import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:sonalysis/core/utils/images.dart';
import "package:sonalysis/lang/strings.dart";
import "package:sonalysis/style/styles.dart";

class StartComparisonModalQuiz extends StatelessWidget {
  const StartComparisonModalQuiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
          top: false,
          child: Container(
            color: sonaLightBlack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('Player vs Player'.tr(), style: TextStyle(color: Colors.white, fontSize: 14)),
                  leading: Image.asset(
                    AppAssets.pvp,
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    width: 30,
                  ),
                  onTap: () {
                    Navigator.of(context).pop("pvp");
                  },
                ),
                const Divider(color: Colors.white),
                ListTile(
                  title: Text('Team vs Team'.tr(), style: TextStyle(color: Colors.white, fontSize: 14)),
                  leading: Image.asset(
                    AppAssets.pv,
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    width: 30,
                  ),
                  onTap: () => Navigator.of(context).pop("tvt"),
                ),
                // const Divider(color: Colors.white),
                // ListTile(
                //   title: Text('Video vs Video'.tr(), style: TextStyle(color: Colors.white, fontSize: 14)),
                //   leading: Image.asset(
                //     AppAssets.tvt,
                //     fit: BoxFit.cover,
                //     repeat: ImageRepeat.noRepeat,
                //     width: 30,
                //   ),
                //   onTap: () => Navigator.of(context).pop("vvv"),
                // ),
                // const Divider(color: Colors.white),
                // ListTile(
                //   title: const Text('Close', style: TextStyle(color: Colors.white, fontSize: 14)),
                //   leading: const SizedBox(),
                //   onTap: () => Navigator.of(context).pop(),
                // ),
              ],
            ),
          ),
        ));
  }
}