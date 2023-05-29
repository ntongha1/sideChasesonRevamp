import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/features/common/call/audio_call/audio_call.dart';
import 'package:sonalysis/style/styles.dart';

import '../../messages/singleton/ChatScreenSingleton.dart';
import '../video_call/outgoing_video_call.dart';

class NewCallAllList extends StatefulWidget {
  String name;
  String userId;
  String role;
  String imageUrl;
  bool isOnline;

  NewCallAllList(
      {Key? key,
      required this.name,
      required this.userId,
      required this.role,
      required this.imageUrl,
      required this.isOnline})
      : super(key: key);

  @override
  _NewCallAllListState createState() => _NewCallAllListState();
}

class _NewCallAllListState extends State<NewCallAllList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        pushNewScreen(
          context,
          screen: const ChatScreenSingleton(),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 50,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                widget.imageUrl,
                              ),
                              backgroundColor: Colors.white,
                              maxRadius: 20,
                            ),
                            widget.isOnline
                                ? Positioned(
                                    left: 32,
                                    top: 20,
                                    child: Image.asset(
                                      AppAssets.chatOnlineIndicator,
                                      width: 15.w,
                                      height: 15.w,
                                    ))
                                : const SizedBox.shrink()
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.name,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white)),
                              const SizedBox(height: 7),
                              Text(
                                widget.role,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  //fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                    onTap: () {
                      pushNewScreen(
                        context,
                        screen: OutGoingVideocall(name: widget.name, userId: widget.userId, imageUrl: widget.imageUrl, isOnline: widget.isOnline),
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                    child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      AppAssets.videoCall,
                      width: 23,
                      fit: BoxFit.contain,
                      repeat: ImageRepeat.noRepeat,
                      color: sonaPurple2,
                    ))),
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
                  child: Image.asset(
                      AppAssets.audioCall,
                      width: 23,
                      fit: BoxFit.contain,
                      repeat: ImageRepeat.noRepeat,
                      color: sonaPurple2,
                  ),
                  ),
              ],
            ),
          ),
          const Divider(color: Colors.white)
        ],
      ),
    );
  }
}
