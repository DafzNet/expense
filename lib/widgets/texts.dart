// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';


Widget BodyText(
  String data,
  {Color? color,
  TextAlign? align,
  double? fontSize,
  double? wordSpacing,
  double? height,
  FontWeight? weight,
  double? letterSpacing,
  int? maxLines,

  }
  ){
  return Text(
    data,
    textAlign: align,
    maxLines: maxLines,

    style: TextStyle(
      fontSize: fontSize,
      height: height??1.2,
      wordSpacing: wordSpacing ?? 1.4,
      color: color,
      fontWeight: weight,
      overflow: TextOverflow.ellipsis,
      letterSpacing: letterSpacing??1,
    ),
  );
}

