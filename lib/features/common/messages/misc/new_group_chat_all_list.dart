import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/features/common/messages/singleton/ChatScreenSingleton.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/custom_button.dart';
import 'package:sonalysis/widgets/custom_outline_button.dart';

class NewGroupChatAllList extends StatefulWidget{
  String name;
  String role;
  String imageUrl;
  bool isOnline;

  NewGroupChatAllList({
    Key? key,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.isOnline
  }) : super(key: key);

  @override
  _NewGroupChatAllListState createState() => _NewGroupChatAllListState();
}

class _NewGroupChatAllListState extends State<NewGroupChatAllList> {

  bool userAdded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        pushNewScreen(
          context,
          screen: ChatScreenSingleton(),
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
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: userAdded
                              ? CustomButton(
                                text: "Remove",
                                color: sonaPurple1,
                                verticalPadding: 5,
                                action: () async {
                                  setState(() {
                                    userAdded = false;
                                  });
                                },
                                )
                              : CustomOutlineButton(
                                color: Colors.white,
                                text: 'Add',
                                verticalPadding: 5,
                                action: () {
                                  setState(() {
                                    userAdded = true;
                                  });
                              }
                          )


                      )
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