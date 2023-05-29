
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/comparison_player_grid_item.dart';
import '../../models/AllPlayerInUploadedVideoModel.dart';


class AllPlayerModalWidget extends StatefulWidget {
  const AllPlayerModalWidget({Key? key, this.teamType, this.teamAPlayersList, this.teamBPlayersList}) : super(key: key);

  final String? teamType;
  final List<TeamA>? teamAPlayersList;
  final List<TeamB>? teamBPlayersList;

  @override
  _AllPlayerModalWidgetState createState() => _AllPlayerModalWidgetState();
}

class _AllPlayerModalWidgetState extends State<AllPlayerModalWidget> {

  @override
  void initState() {
    super.initState();
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
          )
      ),
      //height: 640.h,
      height: MediaQuery.of(context).size.height * 0.9,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Select a player".tr(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17.sp)),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Boxicons.bx_x,
                      size: 34,
                      color: Colors.white,
                    ))
              ],
            ),
            // Container(
            //   margin: const EdgeInsets.only(top: 20.0),
            //   child: AdvancedSearch(
            //     data: widget.teamType == "A" ? widget.teamAPlayersList : widget.teamBPlayersList,
            //     maxElementsToDisplay: 10,
            //     singleItemHeight: 50,
            //     borderColor: sonaBlack,
            //     minLettersForSearch: 0,
            //     selectedTextColor: sonaPurple2,
            //     fontSize: 14,
            //     borderRadius: 12.0,
            //     hintText: 'Search Players',
            //     cursorColor: Colors.white,
            //     autoCorrect: false,
            //     focusedBorderColor: sonaBlack,
            //     searchResultsBgColor: sonaLightBlack,
            //     disabledBorderColor: Colors.cyan,
            //     enabledBorderColor: Colors.white,
            //     enabled: true,
            //     caseSensitive: false,
            //     inputTextFieldBgColor: sonaLightBlack,
            //     clearSearchEnabled: true,
            //     itemsShownAtStart: 0,
            //     searchMode: SearchMode.CONTAINS,
            //     showListOfResults: true,
            //     unSelectedTextColor: Colors.white,
            //     verticalPadding: 10,
            //     horizontalPadding: 10,
            //     hideHintOnTextInputFocus: true,
            //     hintTextColor: Colors.grey,
            //     onItemTap: (index, value) {
            //       print("selected item Index is $index");
            //     },
            //     onSearchClear: () {
            //       print("Cleared Search");
            //     },
            //     onSubmitted: (value, value2) {
            //       print("Submitted: " + value);
            //     },
            //     onEditingProgress: (value, value2) {
            //       print("TextEdited: " + value);
            //       print("LENGTH: " + value2.length.toString());
            //     },
            //   ),
            // ),
            const SizedBox(height: 20),
              if (widget.teamType == "A")
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    childAspectRatio: 8.5 / 10.0,
                    children: List.generate(widget.teamAPlayersList!.length, (index) {
                      return ComparisonPlayerGridItem(
                          teamAPlayersList: widget.teamAPlayersList!.elementAt(index),
                          teamBPlayersList: null,
                          teamType: widget.teamType
                      );
                    }),
                  ),
                ),
            if (widget.teamType == "B")
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  childAspectRatio: 8.5 / 10.0,
                  children: List.generate(widget.teamBPlayersList!.length, (index) {
                    return ComparisonPlayerGridItem(
                        teamAPlayersList: null,
                        teamBPlayersList: widget.teamBPlayersList!.elementAt(index),
                        teamType: widget.teamType
                    );
                  }),
                ),
              ),
            const SizedBox(height: 110),
          ],
        ),
      ),
    ),
    ));
  }


}
