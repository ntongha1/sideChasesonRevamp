import 'dart:ui';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/utils/colors.dart';

import '../startup/app_startup.dart';
import 'styles.dart';

String incomingCall = "incoming";
String outgoingCall = "outgoing";
String missedCall = "missed";
String audioCall = "audio";
String videoCall = "video";
String displayPicture =
    "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/1024px-User-avatar.svg.png";

String convertDateTimeDisplay(String date) {
  String formatted = date;
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd');
  final DateFormat serverFormater = DateFormat('dd-MM-yyyy HH:mm:ss');
  try {
    final DateTime displayDate = DateFormat('yyyy-MM-dd').parse(date);
    formatted = DateFormat.yMMMd().format(displayDate);
  } catch (err) {}
  return formatted;
}

String formatBalance(double n, int decimalDigits) {
  final oCcy =
      NumberFormat.currency(name: "\u{20A6}", decimalDigits: decimalDigits);
  return oCcy.format(n);
}

Future bottomSheet(BuildContext context, dynamic myWidget) {
  return showCupertinoModalBottomSheet(
    //enableDrag: false,
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    backgroundColor: Colors.black.withOpacity(0.5),
    useRootNavigator: true,
    builder: (context) => myWidget,
  );
}

String formatNumber(double n, int decimalDigits) {
  final oCcy = NumberFormat.currency(name: "", decimalDigits: decimalDigits);
  return oCcy.format(n);
}

String hideCharAt(String oldString, int index, String newChar) {
  return oldString.substring(0, index) +
      newChar +
      oldString.substring(index + 1);
}

Color getColorHexFromStr(String colorStr) {
  colorStr = "FF" + colorStr;
  colorStr = colorStr.replaceAll("#", "");
  int val = 0;
  int len = colorStr.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = colorStr.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw FormatException("An error occurred when converting a color");
    }
  }
  return Color(val);
}

void showToast(String msg, String type) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: type == "error" ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showSnackBar(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
  ));
}

InputDecoration inputDecoration() {
  return InputDecoration(
    labelText: 'Search',
    hintText: 'Start typing to search',
    hintStyle: AppStyle.text1,
    labelStyle: AppStyle.text1,
    prefixIcon: Icon(Icons.search, color: AppColors.sonaGrey3),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(color: AppColors.sonaGrey6)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(color: AppColors.sonaGrey6)),
  );
}

CountryListThemeData countryListThemeData() {
  return CountryListThemeData(
    flagSize: 25,
    backgroundColor: AppColors.sonaWhite,
    textStyle: AppStyle.text2.copyWith(color: AppColors.sonaBlack3),
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0),
    ),
    inputDecoration: inputDecoration(),
  );
}

bool validateEmail(String value) {
  String _emailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regex = new RegExp(_emailPattern);
  return (!regex.hasMatch(value)) ? false : true;
}

String greetingMessage(context) {
  bool is24HoursFormat = MediaQuery.of(context).alwaysUse24HourFormat;
  if (is24HoursFormat) {
    int timeNow = DateTime.now().hour;
    //print("timenow: " + DateTime.now().toString());
    if (timeNow <= 12) {
      return 'Good Morning, ';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon, ';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening, ';
    } else {
      return 'Good Night, ';
    }
  } else {
    int timeNow = DateTime.now().hour;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('hh:mm a').format(DateTime.now());
    //TimeOfDay now = TimeOfDay.now();
    TimeOfDay releaseTime = TimeOfDay(hour: timeNow, minute: 0); // 3:00pm
    if (formattedDate.contains("AM")) {
      return 'Good Morning, ';
    } else {
      return 'Good Day, ';
    }
  }
}

logoutDialog(BuildContext contextt, String title, String subTitle) {
  return showDialog<void>(
    context: contextt,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: Text(subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0.sp,
              height: 1.2,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
            )),
        actions: <Widget>[
          InkWell(
            onTap: () => Navigator.of(context).pop(false),
            child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.3,
                height: 45,
                alignment: Alignment.center,
                child: Text(
                  "no".tr(),
                  style: TextStyle(
                    color: AppColors.sonaBlack,
                    fontSize: 16.0.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          ),
          InkWell(
            onTap: () {
              serviceLocator
                  .get<LocalStorage>()
                  .clearAllExcept(LocalStorageKeys.kLoginEmailPrefs);
              serviceLocator
                  .get<NavigationService>()
                  .clearAllTo(RouteKeys.routeLoginScreen);
            },
            child: Container(
                color: AppColors.sonaPurple1,
                width: MediaQuery.of(context).size.width * 0.3,
                height: 45,
                alignment: Alignment.center,
                child: Text(
                  "yes".tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          ),
        ],
      );
    },
  );
}

onBackPressed(BuildContext? context, String title, String subTitle) {
  return showDialog<void>(
    context: context!,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: Text(subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0.sp,
              height: 1.57,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
            )),
        actions: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.33,
            alignment: Alignment.center,
            child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.32,
                child: OutlinedButton(
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(5.0),
                  // ),
                  child: Text(
                    "No",
                    style: TextStyle(
                      color: AppColors.sonaBlack,
                      fontSize: 18.0.sp,
                      height: 1.57,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  //color: Colors.white,
                )),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.33,
            alignment: Alignment.center,
            child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.32,
                child: OutlinedButton(
                    // color: AppColors.sonaPurple1,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(5.0),
                    // ),
                    onPressed: () {},
                    child: InkWell(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: AppColors.sonaPurple1,
                          fontSize: 18.0.sp,
                          height: 1.57,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () => serviceLocator
                          .get<NavigationService>()
                          .clearAllTo(RouteKeys.routeOnboarding),
                    ))),
          ),
        ],
      );
    },
  );
}

showSnackSuccess(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.green,
    content: Text(
      message,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15.sp,
      ),
    ),
    duration: const Duration(seconds: 10),
    // action: SnackBarAction(
    //   label: 'ACTION',
    //   onPressed: () { },
    // ),
  ));
}

showSnackError(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(
      error,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15.sp,
      ),
    ),
    duration: const Duration(seconds: 3),
    // action: SnackBarAction(
    //   label: 'ACTION',
    //   onPressed: () { },
    // ),
  ));
}

List<Map<String, dynamic>> smartphones = [
  {
    'id': 'sk3',
    'name': 'Samsung Keystone 3',
    'brand': 'Samsung',
    'category': 'Budget Phone'
  },
  {
    'id': 'n106',
    'name': 'Nokia 106',
    'brand': 'Nokia',
    'category': 'Budget Phone'
  },
  {
    'id': 'n150',
    'name': 'Nokia 150',
    'brand': 'Nokia',
    'category': 'Budget Phone'
  },
  {
    'id': 'r7a',
    'name': 'Redmi 7A',
    'brand': 'Xiaomi',
    'category': 'Mid End Phone'
  },
  {
    'id': 'ga10s',
    'name': 'Galaxy A10s',
    'brand': 'Samsung',
    'category': 'Mid End Phone'
  },
  {
    'id': 'rn7',
    'name': 'Redmi Note 7',
    'brand': 'Xiaomi',
    'category': 'Mid End Phone'
  },
  {
    'id': 'ga20s',
    'name': 'Galaxy A20s',
    'brand': 'Samsung',
    'category': 'Mid End Phone'
  },
  {
    'id': 'mc9',
    'name': 'Meizu C9',
    'brand': 'Meizu',
    'category': 'Mid End Phone'
  },
  {
    'id': 'm6',
    'name': 'Meizu M6',
    'brand': 'Meizu',
    'category': 'Mid End Phone'
  },
  {
    'id': 'ga2c',
    'name': 'Galaxy A2 Core',
    'brand': 'Samsung',
    'category': 'Mid End Phone'
  },
  {
    'id': 'r6a',
    'name': 'Redmi 6A',
    'brand': 'Xiaomi',
    'category': 'Mid End Phone'
  },
  {
    'id': 'r5p',
    'name': 'Redmi 5 Plus',
    'brand': 'Xiaomi',
    'category': 'Mid End Phone'
  },
  {
    'id': 'ga70',
    'name': 'Galaxy A70',
    'brand': 'Samsung',
    'category': 'Mid End Phone'
  },
  {
    'id': 'ai11',
    'name': 'iPhone 11 Pro',
    'brand': 'Apple',
    'category': 'Flagship Phone'
  },
  {
    'id': 'aixr',
    'name': 'iPhone XR',
    'brand': 'Apple',
    'category': 'Flagship Phone'
  },
  {
    'id': 'aixs',
    'name': 'iPhone XS',
    'brand': 'Apple',
    'category': 'Flagship Phone'
  },
  {
    'id': 'aixsm',
    'name': 'iPhone XS Max',
    'brand': 'Apple',
    'category': 'Flagship Phone'
  },
  {
    'id': 'hp30',
    'name': 'Huawei P30 Pro',
    'brand': 'Huawei',
    'category': 'Flagship Phone'
  },
  {
    'id': 'ofx',
    'name': 'Oppo Find X',
    'brand': 'Oppo',
    'category': 'Flagship Phone'
  },
  {
    'id': 'gs10',
    'name': 'Galaxy S10+',
    'brand': 'Samsung',
    'category': 'Flagship Phone'
  },
];

//
// Future<String> uploadToAWS(BuildContext context, String folder, String documentType, File? fileToUpload) async {
//   String? result;
//
//   String awsRegion = "us-east-1";
//   String poolId = awsRegion + ":eefe909d-3fdf-43ab-b100-5f304bbf6837";
//   String awsFolderPath = folder + "/" + documentType;
//   String bucketName = "sonalysis-asset";
//   String awsPath = "https://" + bucketName + ".s3." + awsRegion + ".amazonaws.com/";
//
//
//   SimpleS3 _simpleS3 = SimpleS3();
//
//   //await displayUploadDialog(context, _simpleS3);
//
//   try {
//     result = await _simpleS3.uploadFile(
//         fileToUpload!,
//         bucketName,
//         poolId,
//         AWSRegions.usEast1,
//         debugLog: true,
//         s3FolderPath: awsFolderPath,
//         fileName: fileToUpload.path.split('/').last,
//         accessControl: S3AccessControl.publicRead,
//         useTimeStamp: true,
//         timeStampLocation: TimestampLocation.suffix
//     );
//     debugPrint("Result :" + awsPath + awsFolderPath + "/" + result);
//   } on PlatformException {
//     debugPrint("Result :'$result'.");
//   }
//
//   print("Console::: server path " + awsPath + awsFolderPath + "/" + fileToUpload!.path.split('/').last);
//   return awsPath + awsFolderPath + "/" + fileToUpload.path.split('/').last;
// }

// Future displayUploadDialog(BuildContext context, AwsS3 awsS3) {
//   return showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) => StreamBuilder(
//       stream: awsS3.getUploadStatus,
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         return buildFileUploadDialog(snapshot, context);
//       },
//     ),
//   );
// }
//
// AlertDialog buildFileUploadDialog(AsyncSnapshot snapshot, BuildContext context) {
//   return AlertDialog(
//     title: Container(
//       padding: const EdgeInsets.all(6),
//       child: LinearProgressIndicator(
//         value: (snapshot.data != null) ? snapshot.data / 100 : 0,
//         valueColor:
//         AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColorDark),
//       ),
//     ),
//     content: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Expanded(child: Text('Uploading...')),
//           Text("${snapshot.data ?? 0}%"),
//         ],
//       ),
//     ),
//   );
// }
//

String capitalizeSentence(String s) => s[0].toUpperCase() + s.substring(1);
String removeUnderscoreSentence(String s) =>
    s.replaceAll(RegExp('[\\W_]+'), ' ');

handleCameraAndMicAndBluetooth() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.microphone,
    Permission.camera,
    Permission.bluetooth,
  ].request();
  return statuses;
}

handleMicAndBluetoothPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.microphone,
    Permission.camera,
    Permission.bluetooth,
  ].request();
  return statuses;
}

calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

String convertToAgo(String dateTime) {
  DateTime input =
      DateFormat('yyyy-MM-DDTHH:mm:ss.SSSSSSZ').parse(dateTime, true);
  Duration diff = DateTime.now().difference(input);

  if (diff.inDays >= 1) {
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
  } else if (diff.inSeconds >= 1) {
    return '${diff.inSeconds} second${diff.inSeconds == 1 ? '' : 's'} ago';
  } else {
    return 'just now';
  }
}

PersistentBottomNavBarItem persistentBottomNavBarItem(
    String title, String iconData, String iconDataInactive) {
  return PersistentBottomNavBarItem(
    icon: SvgPicture.asset(
      iconData,
      width: 30,
      height: 30,
    ),
    inactiveIcon: SvgPicture.asset(iconDataInactive),
    iconSize: 100,
    title: title.tr(),
    textStyle:
        AppStyle.text1.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w400),
    activeColorPrimary: AppColors.sonalysisMediumPurple,
    activeColorSecondary: AppColors.sonalysisMediumPurple,
    inactiveColorPrimary: AppColors.sonaGrey2,
    inactiveColorSecondary: AppColors.sonaGrey2,
  );
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .split(" ")
      .map((str) => str[0].toUpperCase() + str.substring(1))
      .join(" ");
}
