import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> setReminder(int millisecondsSinceEpoch) async{
  // Initialize the plugin.
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


  // Create a notification details object.
  final NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      DateTime.now().millisecondsSinceEpoch.toString(),
      'Lifi',
      channelDescription: 'Your Channel Description',
      importance: Importance.high,
      priority: Priority.max
    ),
  );

  // Schedule the notification.
  await flutterLocalNotificationsPlugin.zonedSchedule(
    DateTime.now().millisecondsSinceEpoch,
    'LiFi',
    'Update your daily transactions',
    tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, millisecondsSinceEpoch),
    notificationDetails,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}
