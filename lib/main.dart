import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:livestock/controllers/farm_tracker_controller.dart';

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
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  // request for location access
  bool isEnabled = await Geolocator.isLocationServiceEnabled();
  if (isEnabled == false) {
    bool openedLocationSettings = await Geolocator.openLocationSettings();
    if (openedLocationSettings) {
      LocationPermission checkPermission = await Geolocator.checkPermission();
      if (checkPermission == LocationPermission.denied) {
        LocationPermission permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showAdaptiveDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (context) => AlertDialog.adaptive(
              title: const Icon(
                Icons.warning_amber,
              ),
              content: Text(
                'Location permission denied',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              actions: [
                TextButton(
                  onPressed: () => Routes.popPage(),
                  child: Text(
                    "Okay",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          );
        }
      }
    }
  } else {
    LocationPermission checkPermission = await Geolocator.checkPermission();
    if (checkPermission == LocationPermission.denied) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied');
      }
    }
  }
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
