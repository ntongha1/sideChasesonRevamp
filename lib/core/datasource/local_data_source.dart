import 'package:get_it/get_it.dart';

import 'key.dart';
import 'local_storage.dart';

// Future<bool> getIsBiometricEnrolled(BusinessType businessType) async {
//   bool isBiometricEnrolled = false;
//   if (businessType == BusinessType.unified) {
//     isBiometricEnrolled =   serviceLocator.get<LocalStorage>().readBool(LocalStorageKeys.kIsBiometricEnrolledUnified) ?? false;
//   } else if (businessType == BusinessType.mutualFund) {
//     isBiometricEnrolled =serviceLocator.get<LocalStorage>().readBool(LocalStorageKeys.kIsBiometricEnrolledIM) ?? false;
//   } else if (businessType == BusinessType.pension) {
//     isBiometricEnrolled = serviceLocator.get<LocalStorage>().readBool(LocalStorageKeys.kIsBiometricEnrolledPension) ?? false;
//   }
//   return isBiometricEnrolled;
// }
//
//
//
// Future<bool>? setBiometricEnrolled(BusinessType businessType, bool value) async {
//
//   Future<bool>? isBiometricEnrolled;
//   if (businessType == BusinessType.unified) {
//     isBiometricEnrolled =   serviceLocator.get<LocalStorage>().writeBool(LocalStorageKeys.kIsBiometricEnrolledUnified, value);
//   } else if (businessType == BusinessType.mutualFund) {
//     isBiometricEnrolled =serviceLocator.get<LocalStorage>().writeBool(LocalStorageKeys.kIsBiometricEnrolledIM, value);
//   } else if (businessType == BusinessType.pension) {
//     isBiometricEnrolled = serviceLocator.get<LocalStorage>().writeBool(LocalStorageKeys.kIsBiometricEnrolledPension, value);
//   }
//   return await  isBiometricEnrolled!;
// }