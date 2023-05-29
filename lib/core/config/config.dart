import 'package:simple_s3/simple_s3.dart';

enum Environment { staging, production }

class AppConfig {
  // WARNING: Do not modify this set values inside this file
  static late Environment environment;
  static late String version;
  static late String paystackSecretKey =
      'pk_test_abcf7cddf20eaf9fd8173413991e4762888afe11';

  static final String awsLocation = AWSRegions.usEast1.region;
  static final String poolId =
      awsLocation + ":eefe909d-3fdf-43ab-b100-5f304bbf6837";
  static final String bucketName = "sonalysis-asset";
  static final String awsPath =
      "https://" + bucketName + ".s3." + awsLocation + ".amazonaws.com/";
  static const String firebaseProjectId = 'sonalysis-cf3d7';
  static const String firebaseAppId =
      '1:576181436121:ios:45d5862524b5002f4bc8c8';
  static const String firebaseApiKey =
      'AIzaSyDCAP6GX0cyUIJE2jNaw5lyPBHapClMzfE';
  static const String firebaseMessagingSenderId = '576181436121';
  static const String liveKitUrl = 'wss://livekit.sonalysis.io';
  static const String liveKitToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2ODEzNTYxNTQsImlzcyI6IkFQSWtMdks4M2FpVDVRNyIsImp0aSI6InRvbnlfc3RhcmsiLCJuYW1lIjoiVG9ueSBTdGFyayIsIm5iZiI6MTY0NTM1NjE1NCwic3ViIjoidG9ueV9zdGFyayIsInZpZGVvIjp7InJvb20iOiJzdGFyay10b3dlciIsInJvb21Kb2luIjp0cnVlfX0.oQ8_VFMzru8T-oKTq353TCuyl1uLO9TdK5kg-XQdu-0';
  static final String spacesRegion = "nyc3";
  static final String spacesAccessKey = "DO00L23RW76JDYX9D9EV";
  static final String spacesSecretKey =
      "mhxJgt10pmDSqDtztLk5c7Ff/SxIYHBdsGbkX3e2nQA";
  static final String spacesUploadBucketName = "sonalysis-media-space";
  static final String spacesAnalysedBucketName = "sonalysis_analysed";
  static final String spacesMiscBucketName = "sonalysis_misc";
}
