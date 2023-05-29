import 'package:http/http.dart';
import 'package:sonalysis/core/enums/request_type.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/network/network_service.dart';

class SignupService {
  final NetworkService myService;

  SignupService({
    required this.myService,
  });

  Future<Response?> submitRegisterClub(var payload) async {
    return await myService(
        requestType: RequestType.post,
        url: ApiConstants.registerUrl,
        payload: payload);
  }

  Future<Response?> submitUpdateUserPayment(var payload, String userID) async {
    return await myService(
        requestType: RequestType.put,
        url: ApiConstants.updateUser + userID,
        payload: payload);
  }

  Future<Response?> sendOTPTOEmail(var payload) async {
    return await myService(
        requestType: RequestType.post,
        url: ApiConstants.submitResetEmail,
        payload: payload);
  }

  Future<Response?> sendOTPTOEmailNewFlow(var payload) async {
    return await myService(
        requestType: RequestType.post,
        url: ApiConstants.submitResetEmailNewFlow,
        payload: payload);
  }

  Future<Response?> submitVerifyOTP(var payload) async {
    return await myService(
        requestType: RequestType.post,
        url: ApiConstants.submitResetOTP,
        payload: payload);
  }

  Future<Response?> submitVerifyOTPNewFlow(var payload) async {
    return await myService(
        requestType: RequestType.post,
        url: ApiConstants.submitResetOTPNewFlow,
        payload: payload);
  }

  Future<Response?> submitRegisterPlayer(var payload) async {
    return await myService(
        requestType: RequestType.post,
        url: ApiConstants.registerUrl,
        payload: payload);
  }

  Future<Response?> doesUserExistEmailVerify(var payload) async {
    return await myService(
        requestType: RequestType.post,
        url: ApiConstants.doesUserExistEmailVerify,
        payload: payload);
  }
}
