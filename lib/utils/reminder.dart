import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> setReminder(int millisecondsSinceEpoch) async{
  print('got here');
  // Initialize the plugin.
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

    print('got here');


  // Create a notification details object.
  final NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'lifi_id',
      'Lifi',
      channelDescription: 'Your Channel Description',
      importance: Importance.high,
      priority: Priority.max
    ),
  );

  // Schedule the notification.
  await flutterLocalNotificationsPlugin.zonedSchedule(
    DateTime.now().microsecond,
    'LiFi',
    'Update your daily transactions',
    tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, millisecondsSinceEpoch),
    notificationDetails,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}
