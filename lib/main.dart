import 'dart:async';
import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart'
    as connectyCube;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loggy/loggy.dart';
import 'package:sonalysis/core/config/config.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/models/response/FirebaseNotificationModel.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/startup/generate_bearer_token.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'core/datasource/key.dart';
import 'core/navigation/generate_route.dart';
import 'core/navigation/keys.dart';
import 'core/navigation/navigation_service.dart';
import 'core/network/http_overrider.dart';
import 'core/startup/app_startup.dart';
import 'core/utils/images.dart';
import 'core/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'features2/splash/cubit/splash_cubit.dart';

late Timer rootTimer;

FirebaseNotificationModel? _firebaseNotificationModel;

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> _messageHandler(RemoteMessage event) async {
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: AppConfig.firebaseApiKey,
          appId: AppConfig.firebaseAppId,
          messagingSenderId: AppConfig.firebaseMessagingSenderId,
          projectId: AppConfig.firebaseProjectId));
  print("ROOT: Console::: Handling a background message: ${event.messageId}");
  //logDebug("ROOT2: Console::: Handling a background message: ${event.data}");
  print("ROOT: Console::: Handling a background message: ${event.data}");
  handleCallkitIncoming(event);
}

Future<void> listenerEvent(Function? callback) async {
  try {
    FlutterCallkitIncoming.onEvent.listen((event) async {
      print("ROOT: $event");

      switch (event!.name) {
        case CallEvent.ACTION_CALL_INCOMING:
          // TODO: received an incoming call
          break;
        case CallEvent.ACTION_CALL_START:
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          break;
        case CallEvent.ACTION_CALL_ACCEPT:
          // TODO: accepted an incoming call
          // TODO: show screen calling in Flutter
          // TODO: It may not be possible to navigate here because the App Widget has not been rendered. can save data call to local or use activeCalls() and check it in 'WidgetsBinding.instance?.addPostFrameCallback'
          //save this call instance securely
          serviceLocator.get<LocalStorage>().writeString(
              key: LocalStorageKeys.kUserIncomingCallPrefsNameCaller,
              value: event.body["nameCaller"]);
          serviceLocator.get<LocalStorage>().writeString(
              key: LocalStorageKeys.kUserIncomingCallPrefsId,
              value: event.body["id"]);
          serviceLocator.get<LocalStorage>().writeString(
              key: LocalStorageKeys.kUserIncomingCallPrefsAvatar,
              value: event.body["avatar"]);
          serviceLocator.get<LocalStorage>().writeString(
              key: LocalStorageKeys.kUserIncomingCallPrefsCallType,
              value: event.body["type"].toString());
          serviceLocator.get<LocalStorage>().writeString(
              key: LocalStorageKeys.kUserIncomingCallPrefsLiveKitToken,
              value: event.body["livekitToken"].toString());
          print("ROOT: Answered call " + event.body["livekitToken"]);
          break;
        case CallEvent.ACTION_CALL_DECLINE:
          // TODO: declined an incoming call
          print("ROOT: Declined call");
          break;
        case CallEvent.ACTION_CALL_ENDED:
          // TODO: ended an incoming/outgoing call
          print("ROOT: Ended call");
          break;
        case CallEvent.ACTION_CALL_TIMEOUT:
          // TODO: missed an incoming call
          print("ROOT: Timeout call");
          break;
        case CallEvent.ACTION_CALL_CALLBACK:
          // TODO: only Android - click action `Call back` from missed call notification
          break;
        case CallEvent.ACTION_CALL_TOGGLE_HOLD:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_MUTE:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_DMTF:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_GROUP:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_AUDIO_SESSION:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
          // TODO: only iOS
          break;
      }
      if (callback != null) {
        callback(event);
      }
    });
  } on Exception {}
}

Future<void> handleCallkitIncoming(RemoteMessage event) async {
  listenerEvent(null);
  _firebaseNotificationModel = FirebaseNotificationModel.fromJson(event.data);
  //handle message
  var params = <String, dynamic>{
    'id': _firebaseNotificationModel!.userID,
    'nameCaller': _firebaseNotificationModel!.userName,
    'appName': AppConstants.appName,
    'avatar': _firebaseNotificationModel!.userImage,
    'handle': _firebaseNotificationModel!.userRole,
    'type': 0,
    'textAccept': 'Accept',
    'textDecline': 'Decline',
    'textMissedCall': 'Missed call',
    'textCallback': 'Call back',
    'duration': 30000,
    'extra': <String, dynamic>{
      'userId': _firebaseNotificationModel!.userID,
      "livekitToken": _firebaseNotificationModel!.livekitToken
    },
    'headers': <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    'android': <String, dynamic>{
      'isCustomNotification': true,
      'isShowLogo': false,
      'isShowCallback': true,
      'ringtonePath': 'ringtone_default', //system_ringtone_default
      'backgroundColor': "#A257FF",
      'backgroundUrl': _firebaseNotificationModel!.userImage,
      'actionColor': "#131313"
    },
    'ios': <String, dynamic>{
      'iconName': AppConstants.appName,
      'handleType': 'generic',
      'supportsVideo': true,
      'maximumCallGroups': 2,
      'maximumCallsPerCallGroup': 1,
      'audioSessionMode': 'default',
      'audioSessionActive': true,
      'audioSessionPreferredSampleRate': 44100.0,
      'audioSessionPreferredIOBufferDuration': 0.005,
      'supportsDTMF': true,
      'supportsHolding': true,
      'supportsGrouping': false,
      'supportsUngrouping': false,
      'ringtonePath': 'system_ringtone_default'
    }
  };
  //print('Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
  //print(":::: "+_firebaseNotificationModel!.notificationType.toString());
  if (_firebaseNotificationModel!.notificationType == "audio") {
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  } else if (_firebaseNotificationModel!.notificationType == "video") {
    // await showNotifications("newVideoBroadcast", "New Video Broadcast", "New Video Broadcast", "You have a new care request. Click to view...");
  }
  ;
}

void main() async {
  // enableFlutterDriverExtension();

  Loggy.initLoggy(logPrinter: const PrettyPrinter());
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  //notifications init.
  AndroidInitializationSettings androidInitialize =
      AndroidInitializationSettings('@drawable/ic_notification');
  IOSInitializationSettings iosInitialize = IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitialize, iOS: iosInitialize);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  HttpOverrides.global = AppHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initLocator();

  //
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: AppConfig.firebaseApiKey,
          appId: AppConfig.firebaseAppId,
          messagingSenderId: AppConfig.firebaseMessagingSenderId,
          projectId: AppConfig.firebaseProjectId));

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title, // description
    importance: Importance.high,
  );

  //flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  rootTimer = Timer.periodic(const Duration(minutes: 4, seconds: 30), (timer) {
    print("tickk ${rootTimer.tick}");
    generateBearerToken();
  });
  runZonedGuarded<Future<void>>(() async {
    runApp(
      DevicePreview(
          enabled: false,
          builder: (context) => EasyLocalization(
                supportedLocales: [Locale('en', 'US')],
                path: 'assets/translations',
                fallbackLocale: Locale('en', 'US'),
                child: const MyApp(),
              )),
    );
  }, (error, stackTrace) async {
    if (AppConfig.environment != Environment.staging) {
      // final Event event = await getSentryEvent(error, stackTrace: stackTrace);
      // sentry.capture(event: event);
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? deviceToken;
  bool _isLogedin = false;
  UserResultData? userResultData;
  late final FirebaseMessaging _firebaseMessaging;
  var connectionListener;
  bool hasInternetConnection = false;

  @override
  void initState() {
    super.initState();
    data();
    // actively listen for status updates
    // this will cause InternetConnectionChecker to check periodically
    // with the interval specified in InternetConnectionChecker().checkInterval
    // until listener.cancel() is called
    connectionListener =
        InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          setState(() {
            hasInternetConnection = true;
          });
          print('Data connection is available.');
          break;
        case InternetConnectionStatus.disconnected:
          setState(() {
            hasInternetConnection = false;
          });
          print('You are disconnected from the internet.');
          break;
      }
    });
    //print("isActivelyChecking: ${InternetConnectionChecker().isActivelyChecking}");
  }

  data() async {
    if (serviceLocator.isRegistered<LocalStorage>()) {
      await _isLogedinCheck();
    }
  }

  Future<bool> _isLogedinCheck() async {
    print("login check:: ");
    _isLogedin = (await serviceLocator
        .get<LocalStorage>()
        .readBool(LocalStorageKeys.kLoginPrefs))!;
    print("login check:: " + _isLogedin.toString());
    print("Token: " + _isLogedin.toString());
    if (_isLogedin) {
      print("login check:: 1");

      registerNotification();
      userResultData = await serviceLocator
          .get<LocalStorage>()
          .readSecureObject(LocalStorageKeys.kUserPrefs);
      //
      deviceToken = await connectyCube
          .ConnectycubeFlutterCallKit.onTokenRefreshed!
          .toString();
      _updateDeviceToken();
    } else {
      print("login check:: 2");
    }
    return _isLogedin;
  }

  Future<void> _updateDeviceToken() async {
    await serviceLocator<SplashCubit>().updateDeviceToken(
      userResultData!.user!.id,
      deviceToken,
    );
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _firebaseMessaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
        //logDebug("ROOT2: Console::: Handling a background message: ${remoteMessage.data}");
        print(
            'Message title: ${remoteMessage.notification?.title}, body: ${remoteMessage.notification?.body}, data: ${remoteMessage.data}');
        //listenerEvent(null);
        handleCallkitIncoming(remoteMessage);
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    //context.setLocale(Locale('en', 'US'));

    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (context, widget) {
          return
              // AdaptiveTheme(
              //     light: ThemeData(
              //       // brightness: Brightness.light,
              //       colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
              //           .copyWith(secondary: Colors.amber),
              //     ),
              //     dark: ThemeData(
              //       // brightness: Brightness.dark,
              //       colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
              //           .copyWith(secondary: Colors.amber),
              //       // accent
              //     ),
              //     initial: AdaptiveThemeMode.light,
              //     builder: (theme, darkTheme) =>

              MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppTheme.lightThemeData(),
            debugShowCheckedModeBanner: false,
            // AppConfig.environment == Environment.staging,
            themeMode: ThemeMode.light,
            builder: (context, widget) {
              // ScreenUtil.init(context);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: GlobalLoaderOverlay(
                    overlayColor: Colors.black,
                    overlayOpacity: 0.8,
                    useDefaultLoading: false,
                    overlayWidget: SizedBox(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            height: 80.0,
                            width: 80.0,
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            height: 80.0,
                            width: 80.0,
                            padding: const EdgeInsets.all(15),
                            child: Image.asset(
                              AppAssets.loader,
                              height: 50.0,
                              width: 50.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    // child: hasInternetConnection
                    //     ? widget!
                    //     : ConnectionFailedScreen(),
                    child: widget!),
              );
            },
            navigatorObservers: const [
              // TODO
              // FirebaseAnalyticsObserver(analytics: AppConfig.analytics),
            ],
            onGenerateRoute: generateRoute,
            initialRoute: RouteKeys.routeSplash,
            navigatorKey: serviceLocator.get<NavigationService>().navigatorKey,
            // )
          );
        });
  }
}
