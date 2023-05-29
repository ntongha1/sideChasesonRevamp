import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dospace/dospace.dart';
import 'package:intl/intl.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:sonalysis/core/config/config.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/services/network_service.dart';

String convertDateTimeDisplay(String date) {
  // final DateFormat displayFormater = DateFormat('yyyy-MM-dd');
  // final DateFormat serverFormater = DateFormat('dd-MM-yyyy HH:mm:ss');
  try {
    final DateTime displayDate = DateFormat('yyyy-MM-dd').parse(date);
    return DateFormat.yMMMd().format(displayDate);
  } catch (err) {
    return date;
  }
}

String formatCurrency(String amount, {String symbol = "₦"}) {
  final oCcy = NumberFormat("#,##0.00", "en_US");
  try {
    return "$symbol${oCcy.format(double.parse(amount))}";
  } catch (err) {
    return "${symbol}0.00";
  }
}

String formatEuroCurrency(String amount, {String symbol = "\$"}) {
  final oCcy = NumberFormat("#,##0.00", "en_US");
  try {
    return "$symbol${oCcy.format(double.parse(amount))}";
  } catch (err) {
    return "${symbol}0.00";
  }
}

String getObscuredNumberWithSpaces(
    {required String string, String obscureValue = 'X', String space = ' '}) {
  assert(
      !(string.length < 8),
      ' $string must be more than 8 '
      'characters and above');
  assert(obscureValue != null && obscureValue.length == 1);
  var length = string.length;
  var buffer = StringBuffer();
  for (int i = 0; i < string.length; i++) {
    if (i < (length - 8)) {
      buffer.write(string[i]);
    } else {
      buffer.write(obscureValue);
    }
    var nonZeroIndex = i + 1;
    if (nonZeroIndex % 4 == 0 && nonZeroIndex != string.length) {
      buffer.write(space);
    }
  }
  return buffer.toString();
}

// Future<String?> uploadFile({
//   required String folder,
//   required String documentType,
//   required File? file,
// }) async {
//   String awsFolderPath = folder + "/" + documentType;
//   SimpleS3 _simpleS3 = SimpleS3();
//   try {
//     String urlResult = await _simpleS3.uploadFile(
//       file!, AppConfig.bucketName, AppConfig.poolId, AWSRegions.usEast1,
//       debugLog: true,
//       s3FolderPath: awsFolderPath,
//       fileName: file.path.split('/').last,
//       accessControl: S3AccessControl.publicRead,
//       // useTimeStamp: true,
//       // timeStampLocation: TimestampLocation.suffix,
//     );
//
//     return urlResult = urlResult.replaceAll(RegExp('https://s3-'), 'https://s3.');
//
//   } catch (e) {
//     debugPrint("Result : "+e.toString());
//     return "null";
//   }
// }

// Future<String?> uploadFile({
//   required String folderName,
//   required String bucketName,
//   required String documentType,
//   required File? file,
// }) async {
//   print("upload: starting");
//   String spacesFolderPath = folderName + "/" + documentType;
//   Spaces spaces = new Spaces(
//       region: AppConfig.spacesRegion,
//       accessKey: AppConfig.spacesAccessKey,
//       secretKey: AppConfig.spacesSecretKey,
//       endpointUrl: "https://nyc3.digitaloceanspaces.com");

//   for (String name in await spaces.listAllBuckets()) {
//     print('upload: bucket: ${name}');
//   }
//   String keyy = AppConfig.spacesSecretKey;
//   String keyys = AppConfig.spacesAccessKey;
//   try {
//     print("upload: $keyy");
//     print("upload: $keyy");
//     print("upload: $keyys");
//     String? urlResult = await spaces.bucket("sonalysis-media-space").uploadFile(
//         spacesFolderPath + '/' + file!.path.split('/').last,
//         file,
//         "text/plain",
//         Permissions.public);
//     print("upload: $urlResult");

//     await spaces.close();

//     return urlResult = "https://" +
//         bucketName +
//         "." +
//         AppConfig.spacesRegion +
//         ".digitaloceanspaces.com/" +
//         spacesFolderPath +
//         "/" +
//         file.path.split('/').last;
//   } catch (e) {
//     debugPrint("upload: " + e.toString());
//     return "null";
//   }
// }

Future<String?> uploadFile({
  required String folderName,
  required String bucketName,
  required String documentType,
  required File? file,
}) async {
  print("Lol I was here 33");
  Map<String, String> payload = {};
  print("upload: starting");
  String url = ApiConstants.baseUrl + "users/upload-image";
  // String url = "https://my-bubble.app/api/public_image";
  var res = await callAPIFile(
      url: url,
      requestType: RequestType.POST,
      payload: payload,
      file: file,
      field: 'photo');

  print("the imageer responsed liked this");
  print(res['data']['uploadUrl']);
  return res['data']['uploadUrl'];
}
