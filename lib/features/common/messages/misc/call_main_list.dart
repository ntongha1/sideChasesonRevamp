import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/features/common/call/audio_call/audio_call.dart';
import 'package:sonalysis/features/common/call/video_call/outgoing_video_call.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/style/styles.dart';

class CallMainList extends StatefulWidget{
  String name;
  String callType;
  String userId;
  String callActivityType;
  String imageURL;
  String timeAgo;
  String time;
  bool isOnline;

  CallMainList({
    Key? key,
    required this.name,
    required this.callType,
    required this.userId,
    required this.callActivityType,
    required this.imageURL,
    required this.timeAgo,
    required this.time,
    required this.isOnline,
  }) : super(key: key);

  @override
  _CallMainListState createState() => _CallMainListState();
}

class _CallMainListState extends State<CallMainList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callType == audioCall
            ? serviceLocator.get<NavigationService>().replaceWithPameter(routeName: RouteKeys.routeAudioCallScreen, data: {
          "name": widget.name,
          "userId": widget.userId,
          "imageUrl": widget.imageURL,
          "isOnline": widget.isOnline,
          "isOutgoing":true
        })
            : pushNewScreen(
              context,
              screen: OutGoingVideocall(name: widget.name, imageUrl: widget.imageURL, isOnline: widget.isOnline),
              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
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
                                widget.imageURL,
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
                                )
                            )
                                : const SizedBox.shrink()
                          ],
                        ),
                      ),
                      const SizedBox(width: 16,),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.name, style:
                              const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                              ),),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                      widget.callActivityType == incomingCall
                                      ? Icons.call_received_outlined
                                      : widget.callActivityType == outgoingCall
                                          ? Icons.call_made_outlined
                                          : Icons.call_missed_outlined,
                                      color:  widget.callActivityType == incomingCall
                                      ? getColorHexFromStr("FD7972")
                                      : widget.callActivityType == outgoingCall
                                          ? getColorHexFromStr("28C345")
                                          : getColorHexFromStr("FD7972"),
                                      size: 15),
                                  const SizedBox(width: 5),
                                  Text(widget.timeAgo,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      //fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal
                                    )),
                                  const Icon(Icons.arrow_right_outlined,
                                      color: Colors.white,
                                      size: 15),
                                Text(widget.time,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        //fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                    widget.callType == audioCall
                     ? Icons.call
                     : Icons.photo_camera_front,
                    color: sonaPurple2,
                    size: 25)
              ],
            ),
          ),
          const Divider(color: Colors.white, thickness: 0.1)
        ],
      ),
    );
  }
}