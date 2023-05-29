
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/helpers/modules/AdvancedSearch/advanced_search.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/comparison_player_video_grid_item.dart';

import '../core/models/response/VideoListResponseModel.dart';

// class AllPlayersForAVideoModalWidget extends StatefulWidget {
//   final DataList? dataList;
//
//   const AllPlayersForAVideoModalWidget({Key? key, this.dataList}) : super(key: key);
//
//   @override
//   _AllPlayersForAVideoModalWidgetState createState() => _AllPlayersForAVideoModalWidgetState();
// }
//
// class _AllPlayersForAVideoModalWidgetState extends State<AllPlayersForAVideoModalWidget> {
//
//   List<String?> playerList = [];
//
//   @override
//   Widget build(BuildContext context) {
//
//     print("videosListResponseModelData::: "+widget.dataList!.modelData!.teamA!.players!.length.toString());
//
//
//     if (widget.dataList != null) {
//       playerList = widget.dataList!.modelData!.teamA!.players!.map((el) => el.name).toList();
//     }
//
//     return Material(
//         child: CupertinoPageScaffold(
//           backgroundColor: Colors.transparent.withOpacity(0.9),
//     child: Container(
//       decoration: BoxDecoration(
//           color: sonaBlack,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(10.0),
//             topRight: Radius.circular(10.0),
//           )
//       ),
//       //height: 640.h,
//       height: MediaQuery.of(context).size.height * 0.9,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text("Select Player",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontSize: 17.sp)),
//                 InkWell(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                   child: Image.asset(
//                   imagesDir + '/modal_close_btn.png',
//                   fit: BoxFit.cover,
//                   repeat: ImageRepeat.noRepeat,
//                   width: 25,
//                 ))
//               ],
//             ),
//             Container(
//               margin: const EdgeInsets.only(top: 20.0),
//               child: AdvancedSearch(
//                 data: playerList,
//                 maxElementsToDisplay: 10,
//                 singleItemHeight: 50,
//                 borderColor: sonaBlack,
//                 minLettersForSearch: 0,
//                 selectedTextColor: sonaPurple2,
//                 fontSize: 14,
//                 borderRadius: 12.0,
//                 hintText: 'Search Players',
//                 cursorColor: Colors.white,
//                 autoCorrect: false,
//                 focusedBorderColor: sonaBlack,
//                 searchResultsBgColor: sonaLightBlack,
//                 disabledBorderColor: Colors.cyan,
//                 enabledBorderColor: Colors.white,
//                 enabled: true,
//                 caseSensitive: false,
//                 inputTextFieldBgColor: sonaLightBlack,
//                 clearSearchEnabled: true,
//                 itemsShownAtStart: 0,
//                 searchMode: SearchMode.CONTAINS,
//                 showListOfResults: true,
//                 unSelectedTextColor: Colors.white,
//                 verticalPadding: 10,
//                 horizontalPadding: 10,
//                 hideHintOnTextInputFocus: true,
//                 hintTextColor: Colors.grey,
//                 onItemTap: (index, value) {
//                   print("selected item Index is $index");
//                 },
//                 onSearchClear: () {
//                   print("Cleared Search");
//                 },
//                 onSubmitted: (value, value2) {
//                   print("Submitted: " + value);
//                 },
//                 onEditingProgress: (value, value2) {
//                   print("TextEdited: " + value);
//                   print("LENGTH: " + value2.length.toString());
//                 },
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (widget.dataList!.modelData!.teamA!.players!.isNotEmpty)
//               Expanded(
//                 child: GridView.count(
//                   crossAxisCount: 3,
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   childAspectRatio: 8.5 / 10.0,
//                   children: List.generate(widget.dataList!.modelData!.teamA!.players!.length, (index) {
//                     return ComparisonPlayerVideoGridItem(players: widget.dataList!.modelData!.teamA!.players!.elementAt(index));
//                   }),
//                 ),
//               ),
//             const SizedBox(height: 110),
//           ],
//         ),
//       ),
//       ),
//     ));
//   }
//
//
// }
