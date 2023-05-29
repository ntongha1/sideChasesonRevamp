import 'package:http/http.dart';
import 'package:sonalysis/core/enums/request_type.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/network/network_service.dart';

class PasswordResetService {
  final NetworkService myService;

  PasswordResetService({
    required this.myService,
  });

  Future<Response?> submitResetEmail(var payload) async {
    return await myService(
        requestType: RequestType.post,
        url: ApiConstants.passwordresetrequest,
        payload: payload);
  }

  Future<Response?> submitResetOTP(var payload) async {
    return await myService(
        requestType: RequestType.post,
        url: ApiConstants.submitResetOTP,
        payload: payload);
  }

  Future<Response?> submitResetPassword(var payload) async {
    return await myService(
        requestType: RequestType.post,
        url: ApiConstants.submitResetChangePassword,
        payload: payload);
  }
}
