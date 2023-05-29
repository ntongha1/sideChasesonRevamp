import 'dart:convert';

import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:sonalysis/core/models/base_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonalysis/core/models/call/IncomingCallModel.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';

class LocalStorage {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage flutterSecureStorage;

  LocalStorage({
    required this.sharedPreferences,
    required this.flutterSecureStorage,
  });

  Future<bool> writeBool(String key, bool value) async {
    return await sharedPreferences.setBool(key, value);
  }

  bool? readBool(String key) {
    return sharedPreferences.getBool(key) ?? false;
  }

  Future writeString({required String key, required String value}) async {
    if (key == "authorization") {
      print("token debug: writeString: $key, $value");
    }
    await sharedPreferences.setString(key, value);
  }

  String? readString(String key) {
    return sharedPreferences.getString(key);
  }

  Future writeObject(
      {required String key, required AuthResultModel value}) async {
    await sharedPreferences.setString(key, jsonEncode(value.toJson()));
  }

  Future writeSecureString({required String key, required String value}) async {
    await flutterSecureStorage.write(key: key, value: value);
  }

  Future<String?> readSecureString(String key) async {
    return flutterSecureStorage.read(key: key);
  }

  Future writeSecureObject(
      {required String key, required UserResultData? value}) async {
    await flutterSecureStorage.write(
        key: key, value: jsonEncode(value!.toJson()));
  }

  Future<UserResultData?> readSecureObject(String key) async {
    String? user = await flutterSecureStorage.read(key: key);
    //return UserResultData.fromJson(jsonDecode(flutterSecureStorage.read(key: key).toString()));
    return UserResultData.fromJson(jsonDecode(user!));
  }

  /// ----------------------------------------------------------
  /// Method that clears all shared preference
  /// ----------------------------------------------------------
  Future<bool> clearAll() async {
    return sharedPreferences.clear();
  }

  /// ----------------------------------------------------------
  /// Method that clears all shared preference except
  /// ----------------------------------------------------------
  Future<bool> clearAllExcept(String myKey) async {
    for (String key in sharedPreferences.getKeys()) {
      if (key != myKey) {
        sharedPreferences.remove(key);
      }
    }
    return true;
  }

  /// ----------------------------------------------------------
  /// Method that clears selected shared preference
  /// ----------------------------------------------------------
  Future<bool> clearOnly(String mKey) async {
    return sharedPreferences.remove(mKey);
  }
}
