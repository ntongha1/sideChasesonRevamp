import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/style/styles.dart';

import '../singleton/GroupChatScreenSingleton.dart';

class GroupChatConversationList extends StatefulWidget{
  String name;
  String messageText;
  String imageUrl;
  String time;
  int count;
  bool isMessageRead, isOnline;

  GroupChatConversationList({
    Key? key,
    required this.name,
    required this.messageText,
    required this.imageUrl,
    required this.time,
    required this.count,
    required this.isMessageRead,
    required this.isOnline
  }) : super(key: key);

  @override
  _GroupChatConversationListState createState() => _GroupChatConversationListState();
}

class _GroupChatConversationListState extends State<GroupChatConversationList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushNewScreen(
          context,
          screen: GroupChatScreenSingleton(name: widget.name, imageUrl: widget.imageUrl, isOnline: widget.isOnline),
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
                              const SizedBox(height: 6),
                              Text(widget.messageText,style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                //fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal
                              ),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                children: [
                Text(widget.time,style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  //fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal
                  )),
                const SizedBox(height: 5),
                  widget.count > 0
                  ? Container(
                  padding: const EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
                  decoration: BoxDecoration(
                      color: sonaPurple1,
                      border: Border.all(
                        color: sonaPurple1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(100))),
                  child: Text(widget.count.toString(),
                      style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    //fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal
                  )),
                )
                  : const SizedBox.shrink()
                ],
                )
              ],
            ),
          ),
          const Divider(color: Colors.white, thickness: 0.1)
        ],
      ),
    );
  }
}