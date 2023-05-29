import 'dart:async';

generateBearerToken() async {
  // if (serviceLocator.isRegistered<User>()) {
  //   BusinessType loginType = serviceLocator.get<User>().loginType;
  //
  //   if (loginType == BusinessType.mutualFund) {
  //     await refreshIMToken();
  //   } else {
  //     await refreshUnifiedToken();
  //   }
  // }
}

Future refreshUnifiedToken() async {
  // if (!serviceLocator.isRegistered<UnifiedToken>()) return;
  // UnifiedToken unifiedToken = serviceLocator.get<UnifiedToken>();
  //
  // String authToken = unifiedToken.bearerToken;
  // String refreshToken = unifiedToken.refreshToken;
  //
  // Map<String, String> headers = {
  //   'Authorization': authToken,
  //   'Content-Type': 'application/json',
  // };
  //
  // Map payload = {
  //   "accessToken": authToken.replaceAll("Bearer", "").trim(),
  //   "refreshToken": refreshToken,
  // };
  // print("payload $payload");
  //
  // Response? response;
  // try {
  //   response = await Client().post(
  //     Uri.parse(ApiConstants.refreshUnifiedToken),
  //     headers: headers,
  //     body: jsonEncode(payload),
  //   );
  //
  //   if (response.statusCode == 201 || response.statusCode == 200) {
  //     dynamic body = jsonDecode(response.body);
  //     if (body['responseCode'] == 200) {
  //       print("========got here");
  //       Map responseMessage = body["responseMessage"];
  //       UnifiedToken token = UnifiedToken(
  //         bearerToken: responseMessage["accessToken"],
  //         refreshToken: responseMessage["refreshToken"],
  //       );
  //       if (serviceLocator.isRegistered<UnifiedToken>()) {
  //         serviceLocator.unregister<UnifiedToken>();
  //       }
  //       serviceLocator.registerSingleton<UnifiedToken>(token);
  //     }
  //   }
  // } catch (err) {}
}

refreshIMToken() async {
  // if (!serviceLocator.isRegistered<UnifiedToken>()) return;
  // UnifiedToken unifiedToken = serviceLocator.get<UnifiedToken>();
  //
  // String authToken = unifiedToken.bearerToken;
  // String refreshToken = unifiedToken.refreshToken;
  //
  // Map<String, String> headers = {
  //   'Authorization': authToken,
  //   'Content-Type': 'application/json',
  //   'RequestSource': 'Web',
  //   'accept': '/',
  // };
  //
  // Map payload = {
  //   "accessToken": authToken.replaceAll("Bearer", "").trim(),
  //   "refreshToken": refreshToken,
  // };
  //
  // Response? response;
  // try {
  //   response = await Client().post(
  //     Uri.parse(ApiConstants.refreshIMToken),
  //     headers: headers,
  //     body: jsonEncode(payload),
  //   );
  //
  //   dynamic body = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     Map authenticateResponse = body["authenticateResponse"];
  //     if (authenticateResponse['responseCode'] == 200) {
  //       UnifiedToken token = UnifiedToken(
  //         bearerToken: body["token"],
  //         refreshToken: body["refreshToken"],
  //       );
  //       if (serviceLocator.isRegistered<UnifiedToken>()) {
  //         serviceLocator.unregister<UnifiedToken>();
  //       }
  //       serviceLocator.registerSingleton<UnifiedToken>(token);
  //     }
  //   } else {
  //     // showSnackError(context, body['responseDescription']);
  //   }
  // } catch (err) {
  //   // Fluttertoast.showToast(msg: err.toString());
  // }
}
