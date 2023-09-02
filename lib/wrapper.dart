import 'package:expense/models/pin_model.dart';
import 'package:expense/providers/settings_provider.dart';
import 'package:expense/screen/auth/pinscreen.dart';
import 'package:expense/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'dbs/pin.dart';
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

    if (user != null) {
      if (Provider.of<SettingsProvider>(context, listen: false).mySettings.pin) {
        return PinScreen(
          header: 'Enter Pin to Continue',

          onCompleted: (p0, p1) {
            PinDb pinDb = PinDb();
            final _pin = Pin(p0);
            final pin = pinDb.fetch(_pin);

            if (pin != null) {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  child: AppBaseNavigation(user: user),
                  type: PageTransitionType.rightToLeft
                ) 
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                financeSnackBar('Wrong Pin')
              );
            }
          },
        );
      }
      return AppBaseNavigation(user: user);
    } else {
      return const SignInScreen();
    }
  }
}