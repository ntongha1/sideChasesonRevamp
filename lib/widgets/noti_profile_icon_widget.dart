import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/helpers/auth/shared_preferences_class.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/model/response/UserLoginResultModel.dart';
class NotiProfileIconWidget extends StatefulWidget {
  const NotiProfileIconWidget({Key? key}) : super(key: key);

  @override
  _NotiProfileIconWidgetState createState() => _NotiProfileIconWidgetState();
}

class _NotiProfileIconWidgetState extends State<NotiProfileIconWidget> {
  SharedPreferencesClass sharedPreferencesClass = SharedPreferencesClass();
  UserLoginResultModel? userLoginResultModel;

  @override
  void initState() {
    super.initState();
    _getData();
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
    return Row(
      children: [
        Image.asset(
          AppAssets.bell,
          fit: BoxFit.cover,
          repeat: ImageRepeat.noRepeat,
          width: 25,
          height: 25,
        ),
        const SizedBox(width: 20),
        InkWell(
          onTap: () {
            // pushNewScreen(
            //   context,
            //   screen: ClubManagementProfile(),
            //   withNavBar: false, // OPTIONAL VALUE. True by default.
            //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
            // );
          },
          child: userLoginResultModel != null &&
                  userLoginResultModel!.data!.user!.photo != ""
              ? CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: ClipOval(
                    child: SizedBox(
                        width: 30.0,
                        height: 30.0,
                        child: Image.network(
                          userLoginResultModel!.data!.user!.photo!,
                          fit: BoxFit.cover,
                          repeat: ImageRepeat.noRepeat,
                          width: 27,
                          height: 27,
                        )),
                  ))
              : Image.asset(
                  imagesDir + '/profile_image.png',
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.noRepeat,
                  width: 27,
                  height: 27,
                ),
        ),
      ],
    );
  }
}
