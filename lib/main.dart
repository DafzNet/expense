
import 'package:expense/dbs/versions.dart';
import 'package:expense/providers/settings_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase/auth/auth.dart';
import 'models/version.dart';
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

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_)=>ExpenseProvider()),
        Provider(create: (_)=>SettingsProvider()),

        Provider(create: (_)=>PlannerProvider()),
        StreamProvider<User?>.value(value: FireAuth().authStateChange, initialData: null)
        //Provider(create: (_)=>FireAuth().authStateChange)
      ],
      child: const MyApp(),
    )
    );
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

    /// The code block `if (onboardedBefore != true)` checks if the variable `onboardedBefore` is not
    /// equal to `true`. If it is not equal to `true`, it means that the user has not onboarded before.
    ///
    if (onboardedBefore != true) {
      /// The code `final VersionDb versionDb = VersionDb();` creates an instance of the `VersionDb`
      /// class.
      final VersionDb versionDb = VersionDb();
      await versionDb.addData(
        VersionModel(
          id: DateTime.now().millisecondsSinceEpoch
        )
      );
      
    }



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
