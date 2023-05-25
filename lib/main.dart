import 'package:expense/screen/auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/expense_provider.dart';
import 'utils/constants/themes.dart';

void main() async{

  runApp(
    ChangeNotifierProvider(
        create: (_)=>ExpenseProvider(),
        child: const MyApp()
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
      title: 'Light Expense',
      theme: defaultTheme(context),
      home: SignInScreen(),
    );
  }
}
