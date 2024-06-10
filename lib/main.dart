import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:livestock/services/notification_service.dart';
import '/controllers/farm_tracker_controller.dart';

import 'exports/exports.dart';

var navigatorKey = GlobalKey<NavigatorState>();
BuildContext context = navigatorKey.currentContext!;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [],
  );
  // request for notification permission
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  // final StreamController<ReceivedNotification>
  //     didReceiveLocalNotificationStream =
  //     StreamController<ReceivedNotification>.broadcast();

  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    notificationAppLaunchDetails!.notificationResponse?.payload;
  }

// notification service
  NotificationService.requestPermission();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('android12splash'); //android12splash
  // iOS settings
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  // initialization settings for both Android and iOS
  InitializationSettings initializationSettings = const InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {});
  // request for location access
  // bool isEnabled = await Geolocator.isLocationServiceEnabled();
  // if (isEnabled == false) {
  // bool openedLocationSettings = await Geolocator.openLocationSettings();
  // LocationPermission checkPermission = await Geolocator.checkPermission();
  // if (checkPermission == LocationPermission.denied) {
  // await Geolocator.openLocationSettings();
  await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied) {
  //     showAdaptiveDialog(
  //       // ignore: use_build_context_synchronously
  //       context: context,
  //       builder: (context) => AlertDialog.adaptive(
  //         title: const Icon(
  //           Icons.warning_amber,
  //         ),
  //         content: Text(
  //           'Location permission denied',
  //           style: Theme.of(context).textTheme.bodyLarge,
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Routes.popPage(),
  //             child: Text(
  //               "Okay",
  //               style: Theme.of(context).textTheme.bodyLarge,
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }
  // } else {
  //   // LocationPermission checkPermission = await Geolocator.checkPermission();
  //   // if (checkPermission == LocationPermission.denied) {
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied) {
  //     await GeolocatorPlatform.instance.requestPermission();
  //   }
  //   // }
  // }
  //system ui mode
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black12,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DataController(),
        ),
        ChangeNotifierProvider(
          create: (context) => CattleTracker(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Lyvstk app',
        theme: Themes.lightTheme,
        initialRoute: Routes.splash,
        routes: Routes().routes,
      ),
    ),
  );
}
