// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../utils/constants/colors.dart';


class DefaultButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData? icon;
  final String text;

  final bool textOnly;

  final Color? textColor;
  final double? width;
  final bool active;

  const DefaultButton({
    this.onTap,
    this.icon,
    this.text = 'Proceed',
    this.textOnly=true,
    this.width,
    this.textColor,
    this.active = true,
    super.key});

  @override
  Widget build(BuildContext context) {

    return !textOnly ? TextButton.icon(
      onPressed: active?onTap??(){}:null, 
      
      icon: Icon(
        icon??MdiIcons.minus,
        color: appOrange,
        ),
      
      
      label: Text(
        text,
        style: TextStyle(
          color: textColor??Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600
        ),
      ),

      style: TextButton.styleFrom(
        fixedSize: Size(width??(MediaQuery.of(context).size.width), 52),
        backgroundColor: active? appOrange.shade600:Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)
        )
      ),
    )
  
    :

    TextButton(
      onPressed: active?onTap??(){}:null,

      style: TextButton.styleFrom(
        fixedSize: Size(width??(MediaQuery.of(context).size.width), 52),
        backgroundColor: active? appOrange:Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)
        )
      ),  
      
      child: Text(
        text,
        style: TextStyle(
          color: textColor??Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}