import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/features/common/call/audio_call/audio_call.dart';
import 'package:sonalysis/features/common/call/video_call/outgoing_video_call.dart';
import 'package:sonalysis/helpers/auth/shared_preferences_class.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/model/response/UserLoginResultModel.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class UserChatSingletonScreen extends StatefulWidget {

  final String? name;
  final String? imageUrl;
  final String? userId;
  final bool? isOnline;

  const UserChatSingletonScreen(
      {Key? key,
        this.name,
        this.imageUrl,
        this.userId,
        this.isOnline})
      : super(key: key);

  @override
  _UserChatSingletonScreenState createState() => _UserChatSingletonScreenState();
}

class _UserChatSingletonScreenState extends State<UserChatSingletonScreen> with SingleTickerProviderStateMixin {
  TooltipBehavior? _tooltipBehavior;

  SharedPreferencesClass sharedPreferencesClass = SharedPreferencesClass();
  UserLoginResultModel? userLoginResultModel;
  TabController? tabController;
  int _selectedIndex = 0;

  @override
  void initState(){
    _tooltipBehavior = TooltipBehavior(enable: true);
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      setState(() {
        _selectedIndex = tabController!.index;
      });
      print("Selected Index: " + tabController!.index.toString());
    });
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
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: GestureDetector(
                  onTap: ()=> Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 23.h)),
              ),
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                  widget.imageUrl!,
              ),
              maxRadius: 60,
            ),
            Align(
                alignment: Alignment.center,
                child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      widget.name!,
                      style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w700),
                    ))),
            Align(
                alignment: Alignment.center,
                child: Text(
                  widget.isOnline! ? "online" : "Last seen 8:25PM",
                  style: TextStyle(
                      color: widget.isOnline! ? getColorHexFromStr("2E9B8D") : getColorHexFromStr("969696"),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.normal),
                )),
            Container(
                margin: const EdgeInsets.only(top: 20, bottom: 0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: () {
                          serviceLocator.get<NavigationService>().replaceWithPameter(routeName: RouteKeys.routeAudioCallScreen, data: {
                            "name": widget.name,
                            "userId": widget.userId,
                            "imageUrl": widget.imageUrl,
                            "isOnline": widget.isOnline,
                            "isOutgoing":true
                          });
                        },
                        child: playerAttributes("/audioCall.png", "audio")),
                    const SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    pushNewScreen(
                      context,
                      screen: OutGoingVideocall(name: widget.name!, imageUrl: widget.imageUrl!, isOnline: widget.isOnline!),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  child: playerAttributes("/videoCall.png", "video")),
                    const SizedBox(width: 5),
                    playerAttributes("/bell2.png", "mute"),
                    const SizedBox(width: 5),
                    playerAttributes("/3dots.png", "more"),
                  ],
                )
            ),
            Container(
                margin: const EdgeInsets.only(top: 30, bottom: 0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    playerFeatures("Wolves B Team"),
                    const SizedBox(width: 5),
                    playerFeatures("Forward"),
                    const SizedBox(width: 5),
                    playerFeatures("23yrs")
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    playerFeatures("United States"),
                  ],
                )),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: TabBar(
                controller: tabController,
                indicatorWeight: 1,
                indicatorColor: Colors.black,
                onTap: (index) {
                  // Tab index when user select it, it start from zero
                },
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      decoration: _selectedIndex == 0
                          ? BoxDecoration(
                          color: sonaPurple1,
                          border: Border.all(
                            color: sonaPurple1,
                          ),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(8)))
                          : const BoxDecoration(),
                      child: const Text("Media",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      decoration: _selectedIndex == 1
                          ? BoxDecoration(
                          color: sonaPurple1,
                          border: Border.all(
                            color: sonaPurple1,
                          ),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(8)))
                          : const BoxDecoration(),
                      child: const Text("Links",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                child: TabBarView(
                  controller: tabController,
                  children:  [
                    Center(
                      child: Text(
                        "Coming Soon",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: const Color(0xFFFFFFFF),
                            fontSize: 27.sp,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Coming Soon",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: const Color(0xFFFFFFFF),
                            fontSize: 27.sp,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    ));
  }

  Widget playerFeatures(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Text(text,
          textAlign: TextAlign.center,
          style:
              TextStyle(color: getColorHexFromStr("C4C4C4"), fontSize: 14.sp)),
    );
  }

  Widget playerAttributes(String image, String text) {
    return Container(
      width: 75,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          Image.asset(
            imagesDir + image,
            width: 23,
            fit: BoxFit.contain,
            repeat: ImageRepeat.noRepeat,
          ),
          const SizedBox(height: 5),
          Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: getColorHexFromStr("C4C4C4"), fontSize: 13.sp))
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

