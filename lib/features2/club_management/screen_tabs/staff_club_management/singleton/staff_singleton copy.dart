
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/helpers/auth/shared_preferences_class.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/model/response/UserLoginResultModel.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/custom_button.dart';
import 'package:sonalysis/widgets/custom_outline_button.dart';

import '../add_edit_staff/addEditStaff.dart';

class StaffSingletonScreen extends StatefulWidget {
  const StaffSingletonScreen({Key? key}) : super(key: key);

  @override
  _StaffSingletonScreenState createState() => _StaffSingletonScreenState();
}

class _StaffSingletonScreenState extends State<StaffSingletonScreen> {


  SharedPreferencesClass sharedPreferencesClass = SharedPreferencesClass();
  UserLoginResultModel? userLoginResultModel;

  @override
  void initState(){
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    await sharedPreferencesClass.getUserModel().then((value) async {
      setState(() {
        userLoginResultModel = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      backgroundColor: Colors.transparent.withOpacity(0.9),
      child: Container(
        decoration: BoxDecoration(
            color: sonaBlack,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            )),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            ListTile(
              leading: GestureDetector(
                  onTap: ()=> Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.h)),
              title: Container(
                margin: const EdgeInsets.only(left: 70),
                child: Text(
                  "Club Management",
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white),
                ),
              ),
            ),
            Container(
                alignment: Alignment.center,
                height: 120,
                child: Image.asset(AppAssets.profileImage,
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    width: 120)),
            const SizedBox(height: 10),
            Align(
                alignment: Alignment.center,
                child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 0),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Michael Scott",
                      style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700),
                    ))),
            Container(
                margin: const EdgeInsets.only(top: 20, bottom: 0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    coachFeatures("Chief Coach"),
                    const SizedBox(width: 15),
                    coachFeatures("33yrs"),
                    const SizedBox(width: 15),
                    coachFeatures("United States")
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(top: 10, bottom: 0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    coachFeatures("Invite Pending"),
                  ],
                )),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.43,
                  child: CustomButton(
                    text: 'Send a message',
                    verticalPadding: 5,
                    color: sonaPurple1,
                    action: () {
                      // pushNewScreen(
                      //   context,
                      //   screen: const ChatScreenSingleton(),
                      //   withNavBar: false, // OPTIONAL VALUE. True by default.
                      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      // );
                      // showDialog(context: context, builder: (BuildContext context) => const RevokeDialog(data: {
                      //   "title":"Are you sure you want to revoke invite link?",
                      //   "subTitle": "Sonalysis will notify this staff of the changes made",
                      //   "image": imagesDir+"/coach_img.png",
                      // }));
                    },
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.43,
                  child: CustomOutlineButton(
                    text: 'Edit Profile',
                    verticalPadding: 5,
                    buttonIcon: const Icon(
                      FontAwesomeIcons.pencilAlt,
                      size: 12,
                      color: Colors.white,
                    ),
                    borderColor: Colors.white,
                    color: sonaPurple1,
                    action: () {
                      bottomSheet(context, AddEditStaffScreen(type: "edit"));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                  "Team(s) Assigned to",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: coachAssignedTeam(),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: coachAssignedTeam(),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Widget coachFeatures(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Text(text,
          textAlign: TextAlign.center,
          style:
              TextStyle(color: getColorHexFromStr("C4C4C4"), fontSize: 13.sp)),
    );
  }

  Widget coachAssignedTeam() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 60,
                  child: Image.asset(AppAssets.ppic_bg,
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.noRepeat,
                      width: 60)),
              Container(
                  alignment: Alignment.center,
                  //margin: const EdgeInsets.symmetric(vertical: 5),
                  //padding: const EdgeInsets.all(13),
                  height: 80,
                  child: Image.asset(AppAssets.profileImage,
                      fit: BoxFit.contain,
                      repeat: ImageRepeat.noRepeat,
                      width: 50)),
            ],
          ),
          const SizedBox(
              width: 80.0,
              child: Text(
                "Wolves B",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
          const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                "20 Players",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white),
              )),
          const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                "6 Staff",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white),
              )),
        ],
      ),
    );
  }
}
