import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/style/styles.dart';


class ComingSoonScreen extends StatelessWidget {
  final BuildContext? menuScreenContext;
  final Function? onScreenHideButtonPressed;
  final bool? hideStatus;


  const ComingSoonScreen(
      {Key? key,
        this.menuScreenContext,
        this.onScreenHideButtonPressed,
        this.hideStatus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Scaffold(
          backgroundColor: sonaBlack,
          body: const Center(
              child: Text(
                "Coming soon",
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
          // body: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: <Widget>[
          //     const Padding(
          //       padding: EdgeInsets.symmetric(
          //           horizontal: 30.0, vertical: 20.0),
          //       child: TextField(
          //         decoration: InputDecoration(hintText: "Test Text Field "),
          //       ),
          //     ),
          //     Center(
          //       child: ElevatedButton(
          //         onPressed: () {
          //           pushNewScreenWithRouteSettings(
          //             context,
          //             settings: const RouteSettings(name: '/home'),
          //             screen: const MainScreen2(),
          //             pageTransitionAnimation:
          //             PageTransitionAnimation.scaleRotate,
          //           );
          //         },
          //         child: const Text(
          //           "Go to Second Screen ->",
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       ),
          //     ),
          //     Center(
          //       child: ElevatedButton(
          //         onPressed: () {
          //           showModalBottomSheet(
          //             context: context,
          //             backgroundColor: Colors.white,
          //             useRootNavigator: true,
          //             builder: (context) => Center(
          //               child: ElevatedButton(
          //                 onPressed: () {
          //                   Navigator.pop(context);
          //                 },
          //                 child: const Text(
          //                   "Exit",
          //                   style: TextStyle(color: Colors.white),
          //                 ),
          //               ),
          //             ),
          //           );
          //         },
          //         child: const Text(
          //           "Push bottom sheet on TOP of Nav Bar",
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       ),
          //     ),
          //     Center(
          //       child: ElevatedButton(
          //         onPressed: () {
          //           showModalBottomSheet(
          //             context: context,
          //             backgroundColor: Colors.white,
          //             useRootNavigator: false,
          //             builder: (context) => Center(
          //               child: ElevatedButton(
          //                 onPressed: () {
          //                   Navigator.pop(context);
          //                 },
          //                 child: const Text(
          //                   "Exit",
          //                   style: TextStyle(color: Colors.white),
          //                 ),
          //               ),
          //             ),
          //           );
          //         },
          //         child: const Text(
          //           "Push bottom sheet BEHIND the Nav Bar",
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       ),
          //     ),
          //     Center(
          //       child: ElevatedButton(
          //         onPressed: () {
          //           this.onScreenHideButtonPressed();
          //         },
          //         child: Text(
          //           this.hideStatus
          //               ? "Unhide Navigation Bar"
          //               : "Hide Navigation Bar",
          //           style: const TextStyle(color: Colors.white),
          //         ),
          //       ),
          //     ),
          //     Center(
          //       child: ElevatedButton(
          //         onPressed: () {
          //           Navigator.of(this.menuScreenContext).pop();
          //         },
          //         child: const Text(
          //           "<- Main Menu",
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 60.0,
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}