import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sonalysis/features2/club_management/widgets/upload_csv_popup.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/style/styles.dart';

import '../screen_tabs/teams_club_management/create_team_flow/createStaffFlow.dart';

class NewExistingStaffModalQuiz extends StatelessWidget {
  String? teamId;

  NewExistingStaffModalQuiz({Key? key, this.teamId}) : super(key: key);

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
              title: Text('Create new staff'.tr(),
                  style: TextStyle(color: Colors.white)),
              leading:
                  const FaIcon(FontAwesomeIcons.userPlus, color: Colors.white),
              onTap: () {
                Navigator.of(context).pop();
                bottomSheet(
                    context,
                    CreateStaffFlowScreen(
                      teamId: teamId,
                      onPlayerCreated: () {
                        // TODO: show success mahev
                      },
                    ));
              },
            ),
            const Divider(color: Colors.white),
            ListTile(
              title: Text('Upload multiple staff'.tr(),
                  style: TextStyle(color: Colors.white)),
              leading: const FaIcon(FontAwesomeIcons.cloudUploadAlt,
                  color: Colors.white),
              onTap: () {
                Navigator.of(context).pop();
                bottomSheet(context,
                    UploadCSVPopUpScreen(teamId: teamId, userType: "STAFF"));
              },
            ),
            const Divider(color: Colors.white),
            ListTile(
              title: Text('Add existing staff'.tr(),
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
