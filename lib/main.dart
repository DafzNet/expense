
import 'package:expense/providers/settings_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'firebase/auth/auth.dart';
import 'providers/expense_provider.dart';
import 'utils/constants/themes.dart';
import 'wrapper.dart';


import 'package:timezone/data/latest.dart' as tz;

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');

  final InitializationSettings initializationSettings =  InitializationSettings(
        android: initializationSettingsAndroid,
      //iOS: initializationSettingsDarwin,
      );
      
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
  );

  
  await Firebase.initializeApp();
  
  Provider.debugCheckInvalidValueType = null;

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_)=>ExpenseProvider()),
        Provider(create: (_)=>SettingsProvider()),

        //Provider(create: (_)=>CategoryDb().onCategories(catDb!)),
        StreamProvider<User?>.value(value: FireAuth().authStateChange, initialData: null)
        //Provider(create: (_)=>FireAuth().authStateChange)
      ],
      child: const MyApp(),
    )
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LiFi',
      theme: defaultTheme(context),
      home: const Wrapper(),
    );
  }
}
