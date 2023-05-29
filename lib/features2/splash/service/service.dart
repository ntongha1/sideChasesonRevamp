import 'package:http/http.dart';
import 'package:sonalysis/core/enums/request_type.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/network/network_service.dart';

class SplashService {
  final NetworkService newServerService;

  SplashService({
    required this.newServerService,
  });

  Future<Response?> submitDeviceToken(var payload, String userId) async {
    return await newServerService(
        requestType: RequestType.put,
        url: ApiConstants.submitPersonalInfo + userId,
        payload: payload
    );
  }


Future<Response?> getUserProfile(String userId) async {
    return await newServerService(
        requestType: RequestType.get,
        url: ApiConstants.getUserProfile + userId,
    );
  }
}
