import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:intl/intl.dart';

import '../core/navigation/keys.dart';
import '../core/navigation/navigation_service.dart';
import '../core/widgets/button.dart';
import '../style/styles.dart';
import 'auth/shared_preferences_class.dart';

SharedPreferencesClass sharedPreferencesClass = SharedPreferencesClass();

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
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text("Downloading"),
  ));
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
              height: 1.57,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
            )),
        actions: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.33,
            alignment: Alignment.center,
            child: AppButton(
                buttonText: "No".tr(),
                buttonType: ButtonType.secondary,
                onPressed: () {
                  serviceLocator.get<NavigationService>().pop();
                }),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.33,
              alignment: Alignment.center,
              child: AppButton(
                  buttonText: "Yes".tr(),
                  onPressed: () {
                    sharedPreferencesClass.clearAllExcept("loginEmail");
                    serviceLocator.get<NavigationService>().pop();
                    serviceLocator.get<NavigationService>().clearAllTo(RouteKeys.routeLoginScreen);
                  })),
        ],
      );
    },
  );
}

onBackPressed(BuildContext context, String title, String subTitle) {
  return showDialog<void>(
    context: context,
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
                      color: sonaBlack,
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
                    // color: sonaPurple1,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(5.0),
                    // ),
                    onPressed: () {},
                    child: InkWell(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: sonaPurple1,
                          fontSize: 18.0.sp,
                          height: 1.57,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () => Navigator.of(context)
                          .pushNamedAndRemoveUntil(routeLoginScreen,
                              (Route<dynamic> route) => false),
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
    'name': 'Team 3',
    'brand': 'team 3',
    'category': 'teams'
  },
  {
    'id': 'sk4',
    'name': 'Team 4',
    'brand': 'team 4',
    'category': 'teams'
  },
  {
    'id': 'sk5',
    'name': 'Team 5',
    'brand': 'team 5',
    'category': 'teams'
  },
];

Future<String> uploadToAWS(BuildContext context, String folder,
    String documentType, File fileToUpload) async {
  String result;

  String awsRegion = "us-east-1";
  String poolId = awsRegion + ":eefe909d-3fdf-43ab-b100-5f304bbf6837";
  String awsFolderPath = folder + "/" + documentType;
  String bucketName = "sonalysis-asset";
  String awsPath =
      "https://" + bucketName + ".s3." + awsRegion + ".amazonaws.com/";

  SimpleS3 _simpleS3 = SimpleS3();

  //await displayUploadDialog(context, _simpleS3);

  try {
    result = await _simpleS3.uploadFile(
        fileToUpload, bucketName, poolId, AWSRegions.usEast1,
        debugLog: true,
        s3FolderPath: awsFolderPath,
        fileName: fileToUpload.path.split('/').last,
        accessControl: S3AccessControl.publicRead,
        useTimeStamp: true,
        timeStampLocation: TimestampLocation.suffix);
    debugPrint("Result :" + awsPath + awsFolderPath + "/" + result);
  } on PlatformException {
    debugPrint("Result :''.");
  }

  print("Console::: server path " +
      awsPath +
      awsFolderPath +
      "/" +
      fileToUpload.path.split('/').last);
  return awsPath + awsFolderPath + "/" + fileToUpload.path.split('/').last;
}

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
