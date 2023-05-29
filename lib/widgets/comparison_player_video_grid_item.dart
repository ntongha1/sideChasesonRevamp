import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/lang/strings.dart';

import '../core/models/response/VideoListResponseModel.dart';


// class ComparisonPlayerVideoGridItem extends StatefulWidget {
//   const ComparisonPlayerVideoGridItem({Key? key, this.players}) : super(key: key);
//
//   final Players? players;
//
//   @override
//   _ComparisonPlayerVideoGridItemState createState() => _ComparisonPlayerVideoGridItemState();
// }
//
// class _ComparisonPlayerVideoGridItemState extends State<ComparisonPlayerVideoGridItem> {
//
//   bool _selected = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 3),
//         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//         // decoration: BoxDecoration(
//         //     color: Colors.black,
//         //     border: Border.all(
//         //       color: Colors.black,
//         //     ),
//         //     borderRadius: const BorderRadius.all(Radius.circular(8))),
//         child: InkWell(
//             onTap: () {
//               setState(() {
//                 _selected = true;
//               });
//               Navigator.of(context).pop(widget.players!.name);
//             },
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Stack(
//                   children: [
//                     Container(
//                         alignment: Alignment.center,
//                         //margin: const EdgeInsets.symmetric(vertical: 5),
//                         //padding: const EdgeInsets.all(13),
//                         height: 70,
//                         child: Image.network(widget.players!.image!,
//                             fit: BoxFit.contain,
//                             repeat: ImageRepeat.noRepeat,
//                             width: 90)),
//                     _selected
//                     ? Container(
//                         alignment: Alignment.center,
//                         margin: const EdgeInsets.symmetric(vertical: 2),
//                         height: 70,
//                         child: Image.asset(imagesDir + '/picked_overlay.png',
//                             fit: BoxFit.cover,
//                             repeat: ImageRepeat.noRepeat,
//                             width: 70))
//                     : Container()
//                   ],
//                 ),
//                 SizedBox(
//                     width: 200.0,
//                     child: Text(
//                       widget.players!.name!.substring(0, 1).toUpperCase() + widget.players!.name!.substring(1),
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontSize: 13.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                     )),
//                 Padding(
//                     padding: const EdgeInsets.only(top: 5),
//                     child: Text(
//                       widget.players!.team!,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 12, color: Colors.white),
//                     )),
//               ],
//             )),
//       ),
//     );
//   }
// }
