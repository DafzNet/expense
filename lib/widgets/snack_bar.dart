import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';

SnackBar  financeSnackBar(String data, {VoidCallback? action, String? label}){
  return SnackBar(
    backgroundColor: Colors.white,

    action: action != null ? SnackBarAction(
      label: label??'' ,
      textColor: appOrange,
      onPressed: action
    ):null,

    content: Center(
      child: Text(
        data,

        style: const TextStyle(
          color: Colors.black,
          fontSize: 16
        ),
      ),
    )
  );
}