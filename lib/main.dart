
// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:expense/providers/settings_provider.dart';
import 'package:expense/providers/subscribe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase/auth/auth.dart';
import 'providers/expense_provider.dart';
import 'providers/planner_provider.dart';
import 'screen/onboarding/onboardingscreen.dart';
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

  const InitializationSettings initializationSettings =  InitializationSettings(
        android: initializationSettingsAndroid,
      //iOS: initializationSettingsDarwin,
      );
      
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
  );

  
  await Firebase.initializeApp();
  
  Provider.debugCheckInvalidValueType = null;
  await MobileAds.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_)=>ExpenseProvider()),
        Provider(create: (_)=>SettingsProvider()),
        Provider(create: (_)=>SubscriptionProvider()),
        Provider(create: (_)=>PlannerProvider()),
        StreamProvider<User?>.value(value: FireAuth().authStateChange, initialData: null)
        //Provider(create: (_)=>FireAuth().authStateChange)
      ],
      child: const MyApp(),
    )
  );

  FlutterBackgroundService().startService();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool? onboardedBefore; 
    
  void getStarted() async{
    
    SharedPreferences pref = await SharedPreferences.getInstance();
    onboardedBefore =  pref.getBool('boarded');

    setState(() {
      
    });

  }

  @override
  void initState() {
    getStarted();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LiFi',
      theme: defaultTheme(context),
      home: onboardedBefore != true ? const OnboardingScreen() : const Wrapper(),
    );
  }
}
