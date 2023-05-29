import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/style/styles.dart';

import '../screen_tabs/teams_club_management/create_team_flow/createPlayerFlow.dart';
import 'upload_csv_popup.dart';

class NewExistinPlayerModalQuiz extends StatelessWidget {
  String? teamId;

  NewExistinPlayerModalQuiz({Key? key, this.teamId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Container(
        //margin: const EdgeInsets.only(bottom: 50),
        color: sonaLightBlack,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("create_new_player".tr(),
                  style: TextStyle(color: Colors.white)),
              leading:
                  const FaIcon(FontAwesomeIcons.userPlus, color: Colors.white),
              onTap: () {
                Navigator.of(context).pop();
                bottomSheet(
                    context,
                    CreatePlayerFlowScreen(
                      teamId: teamId,

                      // TODO: show success mahev
                      onPlayerCreated: () {},
                    ));
              },
            ),
            const Divider(color: Colors.white),
            ListTile(
                title: Text("Upload multiple players".tr(),
                    style: TextStyle(color: Colors.white)),
                leading: const FaIcon(FontAwesomeIcons.cloudUploadAlt,
                    color: Colors.white),
                onTap: () {
                  Navigator.of(context).pop();
                  bottomSheet(context,
                      UploadCSVPopUpScreen(teamId: teamId, userType: "PLAYER"));
                }),
            const Divider(color: Colors.white),
            ListTile(
              title: Text("add_existing_player".tr(),
                  style: TextStyle(color: Colors.white)),
              leading:
                  const FaIcon(FontAwesomeIcons.users, color: Colors.white),
              onTap: () => Navigator.of(context).pop(),
            ),
            const Divider(color: Colors.white),
            ListTile(
              title: const Text('Close', style: TextStyle(color: Colors.white)),
              leading: const SizedBox(width: 20),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    ));
  }
}
