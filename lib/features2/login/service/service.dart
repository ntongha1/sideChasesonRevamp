import 'package:http/http.dart';
import 'package:sonalysis/core/enums/request_type.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/network/network_service.dart';

class LoginUserService {
  final NetworkService oldServerService;
  final NetworkService newServerService;

  LoginUserService({
    required this.oldServerService,
    required this.newServerService,
  });

  Future<Response?> submitLoginUser(var payload) async {
    return await newServerService(
        requestType: RequestType.post,
        url: ApiConstants.loginUrl,
        payload: payload
    );
  }

}
