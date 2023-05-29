import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/helpers/modules/AdvancedSearch/advanced_search.dart';
import 'package:sonalysis/style/styles.dart';

class CustomSearch extends StatelessWidget {
  final String labelText;
  final List<String?> searchableList;

  const CustomSearch({
    Key? key,
    required this.labelText,
    required this.searchableList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdvancedSearch(
      data: searchableList,
      maxElementsToDisplay: 10,
      singleItemHeight: 50,
      borderColor: sonaBlack,
      minLettersForSearch: 0,
      selectedTextColor: sonaPurple2,
      fontSize: 14,
      borderRadius: 12.0,
      hintText: labelText,
      cursorColor: Colors.white,
      autoCorrect: false,
      focusedBorderColor: sonaBlack,
      searchResultsBgColor: sonaLightBlack,
      disabledBorderColor: Colors.cyan,
      enabledBorderColor: sonaBlack,
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
    );
  }
}
