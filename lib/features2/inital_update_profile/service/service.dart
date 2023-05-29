import 'package:http/http.dart';
import 'package:sonalysis/core/enums/request_type.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/network/network_service.dart';

class InitialUpdateProfileService {
  final NetworkService myService;

  InitialUpdateProfileService({
    required this.myService,
  });

  Future<Response?> submitChangeUserPassword(var payload, String userID) async {
    return await myService(
        requestType: RequestType.put,
        url: ApiConstants.submitPersonalInfo + userID,
        payload: payload);
  }

  Future<Response?> submitUpdateUserProfile(var payload, String userID) async {
    return await myService(
        requestType: RequestType.put,
        url: ApiConstants.submitUpdateUserProfile + userID,
        payload: payload);
  }

  Future<Response?> submitUpdateUserProfileLite(
      var payload, String userID) async {
    return await myService(
        requestType: RequestType.put,
        url: ApiConstants.updateUser + userID,
        payload: payload);
  }
}
