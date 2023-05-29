//import 'package:firebase_analytics/firebase_analytics.dart';

//TODO change firebase file
class FirebaseConfig {
  static Future<void> sendAnalyticsEvent(String event, String value) async {
    // await AppConfig.analytics.logEvent(
    //   name: event,
    //   parameters: <String, dynamic>{
    //     value: value,
    //   },
    // );
  }

  static Future<void> setAnalyticsUserId(String emailId) async {
    // await AppConfig.analytics.setUserId(id: emailId);
  }

  static Future<void> setCurrentScreen(String screen, String fileName) async {
    // await AppConfig.analytics.setCurrentScreen(
    //   screenName: screen,
    //   screenClassOverride: fileName,
    // );
  }

  // static Future<void> setUserProperty(String propertyName, String propertyvalue, FirebaseAnalytics analytics) async {
  //   // await AppConfig.analytics
  //   //     .setUserProperty(name: propertyName, value: propertyvalue);
  // }
}
