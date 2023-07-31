import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screen/auth/signin.dart';
import 'screen/base_nav.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  // Future<InitializationStatus> _initGoogleMobileAds() {
  //   // TODO: Initialize Google Mobile Ads SDK
  //   return MobileAds.instance.initialize();
  // }


  @override
  Widget build(BuildContext context) {

    User? user = Provider.of<User?>(context);

    return user != null ? AppBaseNavigation(user: user) : const SignInScreen();
  }
}