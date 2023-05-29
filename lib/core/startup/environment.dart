
import 'dart:io';

import 'package:sonalysis/core/config/config.dart';
import 'package:sonalysis/core/network/keys.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';

setupConfig() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  AppConfig.version = packageInfo.version;
  // Do not change the order of the 2 lines below this
  AppConfig.environment = Environment.staging;
  ApiConstants();
  // Do not change the order of the 2 lines above this

  try {
    if (Platform.isIOS) {
      //await Firebase.initializeApp(options: AppConfig.iosFirebaseOptions);
    } else {
      //await Firebase.initializeApp();
    }
  } catch (ex) {
    debugPrint(ex.toString());
  }
}
