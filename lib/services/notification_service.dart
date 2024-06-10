import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:livestock/controllers/farm_tracker_controller.dart';
// import '../controllers/farm_tracker_controller.dart';
import '../exports/exports.dart';

class NotificationService {
// initializing notifications plugin
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static int id = 0;
  static Timer? timer;
  static void requestPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  static void sendNotification(
      {required String title, required String body}) async {
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      vibrationPattern: Int64List.fromList([100, 400]),
      channelDescription: 'channel_description',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      enableLights: true,
      color: Colors.blue,
      colorized: true,
      fullScreenIntent: true,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id += 1,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  static Future<void> showBigTextNotification() async {
    const BigTextStyleInformation bigTextStyleInformation =
        BigTextStyleInformation(
      'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      htmlFormatBigText: true,
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true,
    );
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'big text channel id', 'big text channel name',
            channelDescription: 'big text channel description',
            styleInformation: bigTextStyleInformation);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id, 'big text title', 'silent body', notificationDetails);
  }

  static Future<void> showInboxNotification() async {
    final List<String> lines = <String>['line <b>1</b>', 'line <i>2</i>'];
    final InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        htmlFormatLines: true,
        contentTitle: 'overridden <b>inbox</b> context title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('inbox channel id', 'inboxchannel name',
            channelDescription: 'inbox channel description',
            styleInformation: inboxStyleInformation);
    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'inbox title', 'inbox body', notificationDetails);
  }

  static Future<void> showGroupedNotifications() async {
    const String groupKey = 'com.android.example.WORK_EMAIL';
    const String groupChannelId = 'grouped channel id';
    const String groupChannelName = 'grouped channel name';
    const String groupChannelDescription = 'grouped channel description';
    // example based on https://developer.android.com/training/notify-user/group.html
    const AndroidNotificationDetails firstNotificationAndroidSpecifics =
        AndroidNotificationDetails(groupChannelId, groupChannelName,
            channelDescription: groupChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey);
    const NotificationDetails firstNotificationPlatformSpecifics =
        NotificationDetails(android: firstNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(id++, 'Alex Faarborg',
        'You will not believe...', firstNotificationPlatformSpecifics);
    const AndroidNotificationDetails secondNotificationAndroidSpecifics =
        AndroidNotificationDetails(groupChannelId, groupChannelName,
            channelDescription: groupChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey);
    const NotificationDetails secondNotificationPlatformSpecifics =
        NotificationDetails(android: secondNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id++,
        'Jeff Chang',
        'Please join us to celebrate the...',
        secondNotificationPlatformSpecifics);

    // Create the summary notification to support older devices that pre-date
    /// Android 7.0 (API level 24).
    ///
    /// Recommended to create this regardless as the behaviour may vary as
    /// mentioned in https://developer.android.com/training/notify-user/group
    const List<String> lines = <String>[
      'Alex Faarborg  Check this out',
      'Jeff Chang    Launch Party'
    ];
    const InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        contentTitle: '2 messages',
        summaryText: 'janedoe@example.com');
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(groupChannelId, groupChannelName,
            channelDescription: groupChannelDescription,
            styleInformation: inboxStyleInformation,
            groupKey: groupKey,
            setAsGroupSummary: true);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'Attention', 'Two messages', notificationDetails);
  }

  static Future<void> showNotificationWithTag() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            tag: 'tag');
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
        id++, 'first notification', null, notificationDetails);
  }

  static Future<void> checkPendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return showDialog<void>(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content:
            Text('${pendingNotificationRequests.length} pending notification '
                'requests'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> showOngoingNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ongoing: true,
            autoCancel: false);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++,
        'ongoing notification title',
        'ongoing notification body',
        notificationDetails);
  }

// function to track cattle location
  static void trackCattleMovements(
      {required double startLatitude, required double startLongitude}) async {
    var farmController = Provider.of<CattleTracker>(context, listen: false);
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      double stopLatitude = farmController.currentLocation.latitude;
      double endLongitude = farmController.currentLocation.longitude;
      double distanceCovered = Geolocator.distanceBetween(
          startLatitude, startLongitude, stopLatitude, endLongitude);

      timer = timer;
      Provider.of<CattleTracker>(context, listen: false).cattleDistance =
          distanceCovered;
      print("distance covered => $distanceCovered");
      if (distanceCovered > farmController.farmSize) {
        NotificationService.sendNotification(
          title: 'Livestock',
          body: 'Animal 1 has moved $distanceCovered away from the farm',
        );
      }
    });
  }

// stop tracking service
  static void stopTrackingService() {
    if (timer != null) {
      timer?.cancel();
    }
  }

  static Future<void> showNotificationWithNoSound() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('no sound channel', 'no sound name',
            channelDescription: 'no sound description',
            playSound: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'no sound title', 'no sound body', notificationDetails);
  }

  static Future<void> showNotificationWithNoVibration() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('no vibration channel', 'no vibration name',
            channelDescription: 'no vibration description',
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'no vibration title', 'no vibration body', notificationDetails);
  }

  static Future<void> showNotificationWithCustomSound() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('custom sound channel', 'custom sound name',
            channelDescription: 'custom sound description',
            sound: RawResourceAndroidNotificationSound('slow_spring_board'),
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'custom sound title', 'custom sound body', notificationDetails);
  }

  static Future<void> repeatNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      id++,
      'repeating title',
      'repeating body',
      RepeatInterval.everyMinute,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// To test we don't validate past dates when using `matchDateTimeComponents`

  static Future<void> showNotificationWithNoBadge() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('no badge channel', 'no badge name',
            channelDescription: 'no badge description',
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'no badge title', 'no badge body', notificationDetails,
        payload: 'item x');
  }

  static Future<void> showProgressNotification() async {
    id++;
    final int progressId = id;
    const int maxProgress = 5;
    for (int i = 0; i <= maxProgress; i++) {
      await Future<void>.delayed(
        const Duration(seconds: 1),
        () async {
          final AndroidNotificationDetails androidNotificationDetails =
              AndroidNotificationDetails('progress channel', 'progress channel',
                  channelDescription: 'progress channel description',
                  channelShowBadge: false,
                  importance: Importance.max,
                  priority: Priority.high,
                  onlyAlertOnce: true,
                  showProgress: true,
                  maxProgress: maxProgress,
                  progress: i);
          final NotificationDetails notificationDetails =
              NotificationDetails(android: androidNotificationDetails);
          await flutterLocalNotificationsPlugin.show(
              progressId,
              'progress notification title',
              'progress notification body',
              notificationDetails,
              payload: 'item x');
        },
      );
    }
  }
}
