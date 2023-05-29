import 'dart:convert';

//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonalysis/model/response/UserLoginResultModel.dart';

class SharedPreferencesClass {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  final String _kLoginPrefs = "loginChecker";
  final String _kLoginEmailPrefs = "loginEmail";
  final String _khasOpenedAppBeforeKey = "hasOpenedAppBeforeKey";
  final String _kTokenPrefs = "authorization";
  final String _kLoginTypePrefs = "loginType";
  final String _kUserPrefs = "loginUser";


  /// ------------------------------------------------------------
  /// Method that returns the user is logged-in or not
  /// ------------------------------------------------------------
  Future<bool> getLoginChecker() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoginPrefs) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves the user is logged-in or not
  /// ----------------------------------------------------------
  Future<bool> setLoginChecker(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_kLoginPrefs, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns the user email used to login
  /// ------------------------------------------------------------
  Future<String> getLoginEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kLoginEmailPrefs) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user email used to login
  /// ----------------------------------------------------------
  Future<bool> setLoginEmail(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kLoginEmailPrefs, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns the user is logged-in or not
  /// ------------------------------------------------------------
  Future<bool> getHasOpenedAppBefore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_khasOpenedAppBeforeKey) ?? true;
  }

  /// ----------------------------------------------------------
  /// Method that saves the user is logged-in or not
  /// ----------------------------------------------------------
  Future<bool> setHasOpenedAppBefore(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_khasOpenedAppBeforeKey, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns the user login token
  /// ------------------------------------------------------------
  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTokenPrefs) ?? '';
    // const flutterSecureStorage = FlutterSecureStorage();
    // return await flutterSecureStorage.read(key: _kTokenPrefs);
  }

  /// ----------------------------------------------------------
  /// Method that saves the user login token
  /// ----------------------------------------------------------
  Future<bool> setToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kTokenPrefs, "Bearer "+value);
    // const flutterSecureStorage = FlutterSecureStorage();
    // await flutterSecureStorage.write(
    //     key: _kTokenPrefs,
    //     value: "Bearer "+value
    // );
  }

  /// ------------------------------------------------------------
  /// Method that returns the username
  /// ------------------------------------------------------------
  Future<String> getLoginType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kLoginTypePrefs) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that saves the username
  /// ----------------------------------------------------------
  Future<bool> setLoginType(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kLoginTypePrefs, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns the users model
  /// ------------------------------------------------------------
  Future<UserLoginResultModel> getUserModel() async {
    String user = await getUser();
    return UserLoginResultModel.fromJson(jsonDecode(user));
  }

  /// ------------------------------------------------------------
  /// Method that returns the user details
  /// ------------------------------------------------------------
  Future<String> getUser() async {
    // const flutterSecureStorage = FlutterSecureStorage();
    // return await flutterSecureStorage.read(key: _kUserPrefs);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserPrefs) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user details
  /// ----------------------------------------------------------
  Future<bool> setUser(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kUserPrefs, value);
    // const flutterSecureStorage = FlutterSecureStorage();
    // await flutterSecureStorage.write(
    //     key: _kUserPrefs,
    //     value: value
    // );
  }




  /// ----------------------------------------------------------
  /// Method that clears all shared preference
  /// ----------------------------------------------------------
  Future<bool> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  /// ----------------------------------------------------------
  /// Method that clears all shared preference except
  /// ----------------------------------------------------------
  Future<bool> clearAllExcept(String myKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for(String key in prefs.getKeys()) {
      if(key != myKey) {
        prefs.remove(key);
      }
    }
    return true;
  }

  /// ----------------------------------------------------------
  /// Method that clears selected shared preference
  /// ----------------------------------------------------------
  Future<bool> clearOnly(String mKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(mKey);
  }
}
