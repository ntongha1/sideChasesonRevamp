// const String _BOOLEAN_VALUE = 'sample_bool_value';
// const String _INT_VALUE = 'sample_int_value';
// const String _STRING_VALUE_IOS = 'current_ios_version';
// const String _STRING_VALUE_ANDROID = 'current_android_version';
// const String _STRING_VALUE_IOS_MANDATORY = 'ios_update_mandatory';
// const bool _STRING_VALUE_IOS_MANDATORY = ;
// https://github.com/FirebaseExtended/flutterfire/issues/4035
//import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigService {
  //final FirebaseRemoteConfig? remoteConfig;
  //RemoteConfigService({this.remoteConfig});

  final defaults = <String, dynamic>{
    'current_ios_version': '1.0.0',
    'current_android_version': '1.0.0',
    'ios_active': true,
    'android_active': true,
    'ios_deactivation_msg':
        "Dear Customer, Our services are unavailable at the moment. please contact support for more information.",
    'android_deactivation_msg':
        "Dear Customer, Our services are unavailable at the moment. please contact support for more information.",
    'android_update_mandatory': true,
    'ios_update_mandatory': true,
  };

  static RemoteConfigService? _instance;
  // static Future<RemoteConfigService?> getInstance() async {
  //   _instance ??= RemoteConfigService(remoteConfig: FirebaseRemoteConfig.instance);
  //   return _instance;
  // }

  // bool get getBoolValue => remoteConfig.getBool(_BOOLEAN_VALUE);
  // int get getIntValue => remoteConfig.getInt(_INT_VALUE);
  // String get getStringValue => _remoteConfig.getString(_STRING_VALUE);

  Future initialize() async {
    debugPrint("initing remote");
    try {
      //await remoteConfig!.setDefaults(defaults);
      await _fetchAndActivate();
    } catch (e) {
      debugPrint("Remeote Config fetch throttled: $e");
    }
  }

  Future _fetchAndActivate() async {
    // await remoteConfig!.fetch();
    // await remoteConfig!.activate();
    // activateFetched();
  }
}
