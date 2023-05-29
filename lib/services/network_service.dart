import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/helpers/auth/shared_preferences_class.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as fileUtil;

typedef void OnUploadProgressCallback(int totalBytes);
callAPI(
    {required String url,
    RequestType requestType = RequestType.GET,
    Map? payload,
    Map header = const {},
    BuildContext? context}) async {
  final sharedPreferencesClass = SharedPreferencesClass();
  var logger = Logger();

  String? vall = await serviceLocator
      .get<LocalStorage>()
      .readString(LocalStorageKeys.kTokenPrefs);
  print('token debug: token I just stored is: ' + vall!);

  var client = http.Client();
  String? authToken = AppConstants.server2Token;
  String loginType = await sharedPreferencesClass.getLoginType();
  print('token debug: 1' + authToken);
  authToken = await serviceLocator
      .get<LocalStorage>()
      .readString(LocalStorageKeys.kTokenPrefs);

  if (authToken == null) {
    print('token debug: 2 was null');

    authToken = AppConstants.server2Token;
  } else {
    print('token debug: 2 was not null');

    print(authToken);
    authToken = 'Bearer ' + authToken;
  }
  //logger.d(authToken);

  Map<String, String> headers = {
    'Authorization': authToken,
    'Content-Type': 'application/json',
    'accept': '/',
    ...header
  };

  late http.Response response;
  try {
    if (requestType == RequestType.GET) {
      response = await client.get(Uri.parse(url), headers: headers);
    } else if (requestType == RequestType.POST) {
      response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
    } else if (requestType == RequestType.PUT) {
      response = await client.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
    } else if (requestType == RequestType.DELETE) {
      response = await client.delete(Uri.parse(url), headers: headers);
    }

    Map<String, dynamic> mapRes = json.decode(response.body);
    // print("mapRes: "+mapRes["code"].toString());
    // print("mapRes: "+response.statusCode.toString());

    if (response.statusCode == 401 || mapRes["code"] == 401) {
      logger.d(url);
      logger.d(jsonEncode(payload));
      logger.d(response.body);
      logger.e("Token expired");
      sharedPreferencesClass.clearAll();

      //Navigator.pushNamedAndRemoveUntil(context, routeLoginScreen, (route) => false);
      // pushNewScreen(
      //   context,
      //   screen: const LoginScreen(),
      //   withNavBar: false, // OPTIONAL VALUE. True by default.
      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
      // );
      Fluttertoast.showToast(msg: "session expired.");
      //return null;
    }
    logger.d('++MAIN API');
    logger.d(url);
    logger.d('++MAIN BODY');
    logger.d(jsonEncode(payload));
    logger.d('++MAIN RESPONSE');
    logger.d(response.body);
    logger.d('++MAIN RESPONSE CODE');
    logger.d(response.statusCode);

    if (response.statusCode == 201 || response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      return body;
    }
    return jsonDecode(response.body);
  } catch (exceptionMessage) {
    logger.d("++MAIN ERROR");
    logger.d(url);
    logger.d(payload);
    logger.d(exceptionMessage);
    //Fluttertoast.showToast(msg: "Oops sorry we could not connect you");
    Fluttertoast.showToast(msg: exceptionMessage.toString());
    //return null;
  }
}

Future<String> readResponseAsString(HttpClientResponse response) {
  var completer = new Completer<String>();
  var contents = new StringBuffer();
  response.transform(utf8.decoder).listen((String data) {
    contents.write(data);
  }, onDone: () => completer.complete(contents.toString()));
  return completer.future;
}

callAPIFileDio(
    {required String url,
    RequestType requestType = RequestType.GET,
    required Map<String, String> payload,
    Map header = const {},
    BuildContext? context,
    File? file,
    required String field,
    required OnUploadProgressCallback onUploadProgress}) async {
  String uploadurl = url;
  FormData formdata = FormData.fromMap({
    field: await MultipartFile.fromFile(file!.path,
        filename: fileUtil.basename(file.path)),
  });
  Response response;
  Dio dio = new Dio();

  response = await dio.post(
    uploadurl,
    data: formdata,
    onSendProgress: (int sent, int total) {
      int percentage = (sent / total * 100).toInt();
      print("percentage: $percentage");
      // convert to int
      onUploadProgress(percentage);
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print(response.toString());
    dynamic body = (response);
    return body;
    //print response from server
  } else {
    print("Error during connection to server.");
  }
}

callAPIFile(
    {required String url,
    RequestType requestType = RequestType.GET,
    required Map<String, String> payload,
    Map header = const {},
    BuildContext? context,
    File? file,
    required String field}) async {
  final sharedPreferencesClass = SharedPreferencesClass();
  var logger = Logger();

  String? authToken = AppConstants.server2Token;
  print('token debug: 1' + authToken);
  authToken = await serviceLocator
      .get<LocalStorage>()
      .readString(LocalStorageKeys.kTokenPrefs);

  if (authToken == null) {
    print('token debug: 2 was null');

    authToken = AppConstants.server2Token;
  } else {
    print('token debug: 2 was not null');

    print(authToken);
    authToken = 'Bearer ' + authToken;
  }
  //logger.d(authToken);

  Map<String, String> headers = {
    'Authorization': authToken,
    'Content-Type': 'multipart/form-data',
    'accept': '/',
    ...header
  };

  late http.StreamedResponse response;
  try {
    print("good til here");

    var request = http.MultipartRequest(
        requestType == RequestType.POST ? 'POST' : "PUT", Uri.parse(url));
    request.headers.addAll(headers);
    request.fields.addAll(payload);
    request.fields.addAll({'token': '9446bc3dedb27fcd897b56d5e47e30b1'});

    if (file != null) {
      File imageFile = File(file.path);

      var stream = http.ByteStream(imageFile.openRead());
      stream.cast();

      print("real stream: ");
      print(stream);

      // request.files.add(await http.MultipartFile(
      //   'photo',
      //   stream,
      //   length,
      // ));

      request.files.add(http.MultipartFile(
          field,
          File(file.path).readAsBytes().asStream(),
          File(file.path).lengthSync(),
          filename: file.path.split("/").last));
    }

    response = (await request.send());

    print("photo response");
    print(response.statusCode);
    String rr = await response.stream.bytesToString();
    print('bytesteam');
    print(rr);

    Map<String, dynamic> mapRes = json.decode(rr);
    // print("mapRes: "+mapRes["code"].toString());
    // print("mapRes: "+response.statusCode.toString());

    if (response.statusCode == 401 || mapRes["code"] == 401) {
      logger.d(url);
      logger.d(jsonEncode(payload));
      logger.d(rr);
      logger.e("Token expired");
      sharedPreferencesClass.clearAll();

      //Navigator.pushNamedAndRemoveUntil(context, routeLoginScreen, (route) => false);
      // pushNewScreen(
      //   context,
      //   screen: const LoginScreen(),
      //   withNavBar: false, // OPTIONAL VALUE. True by default.
      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
      // );
      Fluttertoast.showToast(msg: "session expired.");
      //return null;
    }
    logger.d('++MAIN API');
    logger.d(url);
    logger.d('++MAIN BODY');
    logger.d(jsonEncode(payload));
    logger.d('++MAIN RESPONSE');
    logger.d(rr);
    logger.d('++MAIN RESPONSE CODE');
    logger.d(response.statusCode);

    if (response.statusCode == 201 || response.statusCode == 200) {
      dynamic body = jsonDecode(rr);
      return body;
    }
    return jsonDecode(rr);
  } catch (exceptionMessage) {
    logger.d("++MAIN ERROR");
    logger.d(url);
    logger.d(payload);
    logger.d(exceptionMessage);
    //Fluttertoast.showToast(msg: "Oops sorry we could not connect you");
    Fluttertoast.showToast(msg: exceptionMessage.toString());
    //return null;
  }
}

enum RequestType { GET, POST, PUT, DELETE }
