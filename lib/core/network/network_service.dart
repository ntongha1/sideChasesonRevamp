import 'dart:convert';

import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/request_type.dart';
import 'package:sonalysis/core/enums/server_type.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:sonalysis/core/utils/constants.dart';

import 'network_info.dart';

class NetworkService {
  final ServerType serverType;
  final Client _httpClient = Client();
  // final bool noAuth;
  Map<String, String> header = {};
  bool? _isLogedin = false;

  NetworkService(
    this.serverType,
  );

  Future<Response?> call({
    required String url,
    required RequestType requestType,
    Map? payload,
    bool? isMultipart,
  }) async {
    String? authToken = '';
    _isLogedin = (await serviceLocator
        .get<LocalStorage>()
        .readBool(LocalStorageKeys.kLoginPrefs))!;
    if (_isLogedin!) {
      if (serviceLocator.isRegistered<UserResultData>()) {
        authToken = await serviceLocator
            .get<LocalStorage>()
            .readString(LocalStorageKeys.kTokenPrefs);
      }
    }

    header = {
      'Authorization': serverType == ServerType.newServer
          ? "Bearer " + authToken!
          : "Bearer " + AppConstants.server2Token,
      'Content-Type': 'application/json',
      'accept': '*/*',
    };

    late Response response;
    try {
      Uri uri = Uri.parse(url);

      bool hasInternetConnection =
          await serviceLocator.get<NetworkInfo>().isConnected;
      if (!hasInternetConnection) {
        Fluttertoast.showToast(msg: "No internet connection");
        return null;
      }
      if (requestType == RequestType.get) {
        response = await _getRequest(uri);
      } else if (requestType == RequestType.post) {
        response = await _postRequest(uri, payload);
      } else if (requestType == RequestType.put) {
        response = await _putRequest(uri, payload);
      } else if (requestType == RequestType.patch) {
        response = await _putRequest(uri, payload);
      } else if (requestType == RequestType.delete) {
        response = await _deleteRequest(uri);
      }

      if (response.statusCode == 401 && serviceLocator.isRegistered<User>()) {
        serviceLocator
            .get<NavigationService>()
            .clearAllTo(RouteKeys.routeLoginScreen);
      }

      debugPrint(response.body);
      debugPrint(header.toString());
      debugPrint(requestType.toString());
      debugPrint(url);
      debugPrint(jsonEncode(payload));
      debugPrint('RESHELP statusCode: ' + response.statusCode.toString());
      debugPrint('RESHELP body: ' + response.body);

      //return jsonDecode(response.body);
      return response;
      // if (response.isSuccessful) return jsonDecode(response.body);
      // return null;
    } catch (ex) {
      debugPrint(ex.toString());
      return null;
    }
  }

  Future<Response> _getRequest(Uri url) async {
    return await _httpClient.get(url, headers: header);
  }

  Future<Response> _postRequest(Uri uri, Map? payload) async {
    return await _httpClient.post(uri,
        headers: header, body: jsonEncode(payload));
  }

  Future<Response> _putRequest(Uri uri, Map? payload) async {
    return await _httpClient.put(uri,
        headers: header, body: jsonEncode(payload));
  }

  Future<Response> _deleteRequest(Uri uri) async {
    return await _httpClient.delete(uri, headers: header);
  }
}

extension ResponseExt on Response {
  bool get isSuccessful => statusCode == 200 || statusCode == 201;
}
