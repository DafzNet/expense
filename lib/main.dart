import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase/auth/auth.dart';
import 'providers/expense_provider.dart';
import 'utils/constants/themes.dart';
import 'wrapper.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  Provider.debugCheckInvalidValueType = null;

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_)=>ExpenseProvider()),
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
