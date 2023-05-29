import 'package:http/http.dart';
import 'package:sonalysis/core/enums/request_type.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/network/network_service.dart';

class SettingsService {
  final NetworkService newServerService;

  SettingsService({
    required this.newServerService,
  });

  Future<Response?> submitPersonalInfo(var payload, String userID) async {
    return await newServerService(
        requestType: RequestType.put,
        url: ApiConstants.submitUpdateUserProfile + userID,
        payload: payload
    );
  }

}
