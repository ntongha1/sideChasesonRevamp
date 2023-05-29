import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/features/common/messages/singleton/ChatScreenSingleton.dart';
import 'package:sonalysis/lang/strings.dart';

class NewChatAllList extends StatefulWidget{
  String name;
  String userID;
  String role;
  String imageUrl;
  bool isOnline;

  NewChatAllList({
    Key? key,
    required this.name,
    required this.userID,
    required this.role,
    required this.imageUrl,
    required this.isOnline
  }) : super(key: key);

  @override
  _NewChatAllListState createState() => _NewChatAllListState();
}

class _NewChatAllListState extends State<NewChatAllList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        pushNewScreen(
          context,
          screen: ChatScreenSingleton(name: widget.name, imageUrl: widget.imageUrl, isOnline: widget.isOnline, userID: widget.userID,
          ),
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
                                  imagesDir + '/chatOnlineIndicator.png',
                                  width: 15.w,
                                  height: 15.w,
                                )
                            )
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
                                  color: Colors.white
                              )),
                              const SizedBox(height: 7),
                              Text(widget.role,
                                style: const TextStyle(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}