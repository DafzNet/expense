// ignore_for_file: prefer_const_constructors

import 'package:dots_indicator/dots_indicator.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../widgets/default_button.dart';

class OnboarderTemplate extends StatefulWidget {
  final int dotPosition;
  final String topic;
  final String body;
  final String? buttonText;
  final String? button2text;
  final VoidCallback? onTap;
  final VoidCallback? onTap2;

  final String img;
  final Function(int)? onDotTap;

  const OnboarderTemplate({
    required this.dotPosition,
    required this.topic,
    required this.body,
    this.buttonText,
    this.button2text,
    this.onTap,
    this.onTap2,
    this.onDotTap,
    required this.img,
    super.key
    });

  @override
  State<OnboarderTemplate> createState() => _OnboarderTemplateState();
}

class _OnboarderTemplateState extends State<OnboarderTemplate> {



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width-60,
              height: MediaQuery.of(context).size.width-60,
              child: Image.asset(
                widget.img,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(
            children: [
              Center(
            child: DotsIndicator(
              dotsCount: 4,
              position: widget.dotPosition,

              decorator: DotsDecorator(
                spacing: EdgeInsets.all(10),
                color: appOrange.shade100,
                activeColor: appOrange,
                size: Size(12, 12),
                activeSize: Size(12, 12)
              ),

              onTap: widget.onDotTap,
            ),
          ),

          Text(
            widget.topic,

            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              height: 1.8
            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              widget.body,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                height: 1.3
              ),
            ),
          ),

          

          SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DefaultButton(
              text: widget.buttonText??'Next',
              onTap: widget.onTap,
            ),
          ),

          SizedBox(height: 15,),

          GestureDetector(
            onTap: widget.onTap2,
            child: Text(
              widget.button2text ?? '',

              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                height: 1.8,
                color: appOrange.shade700
              ),
            ),
          ),
            ],
          )
        ],
      ),
    );
  }
}