
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/models/response/VideoListResponseModel.dart';
import 'package:sonalysis/helpers/modules/AdvancedSearch/advanced_search.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/style/styles.dart';

import 'comparison_video_grid_item.dart';

class AllVideosModalWidget extends StatefulWidget {
  const AllVideosModalWidget({Key? key, this.videosListResponseModel}) : super(key: key);

  final VideoListResponseModel? videosListResponseModel;

  @override
  _AllVideosModalWidgetState createState() => _AllVideosModalWidgetState();
}

class _AllVideosModalWidgetState extends State<AllVideosModalWidget> {

  List<String?> videoList = [];

  @override
  Widget build(BuildContext context) {
    print(widget.videosListResponseModel!.videoListResponseModelData!.length.toString());

    if (widget.videosListResponseModel != null) {
      videoList = widget.videosListResponseModel!.videoListResponseModelData!.map((el) => el.filename).toList();//.filename
    }

    //print(widget.videosListResponseModel!.videoListResponseModelData!.isNotEmpty);


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
                Text("Select Video",
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
                    color: Colors.white,
                    size: 30,
                  ))
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: AdvancedSearch(
                data: videoList,
                maxElementsToDisplay: 10,
                singleItemHeight: 50,
                borderColor: sonaBlack,
                minLettersForSearch: 0,
                selectedTextColor: sonaPurple2,
                fontSize: 14,
                borderRadius: 12.0,
                hintText: 'Search Videos',
                cursorColor: Colors.white,
                autoCorrect: false,
                focusedBorderColor: sonaBlack,
                searchResultsBgColor: sonaLightBlack,
                disabledBorderColor: Colors.cyan,
                enabledBorderColor: Colors.white,
                enabled: true,
                caseSensitive: false,
                inputTextFieldBgColor: sonaLightBlack,
                clearSearchEnabled: true,
                itemsShownAtStart: 0,
                searchMode: SearchMode.CONTAINS,
                showListOfResults: true,
                unSelectedTextColor: Colors.white,
                verticalPadding: 10,
                horizontalPadding: 10,
                hideHintOnTextInputFocus: true,
                hintTextColor: Colors.grey,
                onItemTap: (index, value) {
                  print("selected item Index is $index");
                },
                onSearchClear: () {
                  print("Cleared Search");
                },
                onSubmitted: (value, value2) {
                  print("Submitted: " + value);
                },
                onEditingProgress: (value, value2) {
                  print("TextEdited: " + value);
                  print("LENGTH: " + value2.length.toString());
                },
              ),
            ),
            const SizedBox(height: 20),
            if (widget.videosListResponseModel!.videoListResponseModelData!.isNotEmpty)
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  //padding: const EdgeInsets.symmetric(vertical: 4),
                  //childAspectRatio: 20.0 / 20.0,
                  children: List.generate(widget.videosListResponseModel!.videoListResponseModelData!.length, (index) {
                    return ComparisonVideoGridItem(videoListResponseModelData: widget.videosListResponseModel!.videoListResponseModelData!.elementAt(index));
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
