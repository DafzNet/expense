// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';


ThemeData defaultTheme(BuildContext context) 
{ return    ThemeData(
      primarySwatch: appOrange,
      scaffoldBackgroundColor: bgColor,

      useMaterial3: true,

      //default app bar settings
      appBarTheme: AppBarTheme(
        backgroundColor: bgColor,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,

        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark
        ),

        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),


      // //Input Decoration Theme
      // inputDecorationTheme: InputDecorationTheme(
      //   border: InputBorder.none,
      //   focusedBorder: InputBorder.,
      //   hintStyle: TextStyle(
      //     fontSize: bodyTextSize
      //   )
      // ),

      //textTheme: 

      typography: Typography.material2021(),

    );}