import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../utils/month.dart';

class HomeTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double? percentage;
  final String? targetBudget;

  const HomeTile({
    this.title = 'Target Budget',
    this.subtitle,
    this.percentage,
    this.targetBudget,
    super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Card(
        elevation: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: const Color.fromARGB(255, 243, 243, 243),
            padding: const EdgeInsets.all(10),
              
            child: Stack(
              fit: StackFit.expand,
              
              children: [
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            height: 1.4,
                            fontWeight: FontWeight.w600
                          ),
                        ),


                        const SizedBox(width: 5,),


                        Text(
                          '(${Month().currentMonth})',
                          style: const TextStyle(
                            fontSize: 24,
                            height: 1.4,
                            //fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),


                    Row(
                      children: [
                        Text(
                          subtitle??'',

                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            letterSpacing: 1.3
                          ),
                        ),
                      ],
                    ),


                    const SizedBox(
                      height: 25,
                    ),

                    if(percentage != null)...
                    [
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width-80,
                      lineHeight: 5.0,
                      percent: percentage!,
                      center: const Text(
                        '',
                        style: TextStyle(fontSize: 12.0),
                      ),
                      
                      barRadius: const Radius.circular(5),
                      backgroundColor: Colors.grey,
                      progressColor: Colors.blue,
                    ),]
                  ],
                ),

                Positioned(
                  right: 5,
                  bottom: 5,

                  child: Text(
                    targetBudget??'',

                    style: const TextStyle(
                      fontSize: 24,
                      height: 1.4,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                )
              ],
            ),
            
          ),
        ),
      ),
    );
  }
}