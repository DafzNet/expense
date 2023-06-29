

import 'package:expense/utils/constants/colors.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeSummary extends StatefulWidget {
  const HomeSummary({super.key});

  @override
  State<HomeSummary> createState() => _HomeSummaryState();
}

class _HomeSummaryState extends State<HomeSummary> {

  final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide())
              ),
              child: RichText(
                text: TextSpan(
                  text: 'Daily Spending Habit Since ',
            
                  style: TextStyle(
                    color: Colors.black,
                    
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
            
                  children: [
                    TextSpan(
                      text: DateFormat.yMMMd().format(DateTime.now()),
            
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      )
                )
                  ]
                ),                  
              ),
            ),
          ],
        ),

        Expanded(
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (i) => Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ((i+1)*10).toString()+'%',
                        style: TextStyle(
                          fontSize: 10
                        ),
                      ),
                      SizedBox(
                        height: (i+1)*20,
                        width: 10,
                        child: Container(
                          color: appDanger,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(days[i].substring(0,3))
                    ],
                  ), )
              ),

              Positioned(
                top: 20,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    border: Border.all(width: .3, color: appSuccess),
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Highest spending Day: ',
                    
                          style: TextStyle(
                            color: appSuccess.shade800,
                            
                            fontSize: 9,
                          ),
                    
                          children: [
                            TextSpan(
                              text: 'Saturday - ',
                    
                              style: TextStyle(
                                color: appSuccess.shade800,
                                fontSize: 10,
                              )
                            ),

                            TextSpan(
                              text: Currency(context).wrapCurrencySymbol('30000'),
                    
                              style: TextStyle(
                                color: appSuccess.shade800,
                                fontSize: 10,
                              )
                            ),

                            TextSpan(
                              text: ' (70%)',
                    
                              style: TextStyle(
                                color: appOrange.shade800,
                                fontSize: 10,
                              )
                            )
                          ]
                        ),
                      ),

                      SizedBox(height: 3,),


                      RichText(
                        text: TextSpan(
                          text: 'Highest spending Day: ',
                    
                          style: TextStyle(
                            color: appSuccess.shade800,
                            
                            fontSize: 9,
                          ),
                    
                          children: [
                            TextSpan(
                              text: 'Sunday - ',
                    
                              style: TextStyle(
                                color: appSuccess.shade800,
                                fontSize: 10,
                              )
                            ),

                            TextSpan(
                              text: Currency(context).wrapCurrencySymbol('30000'),
                    
                              style: TextStyle(
                                color: appSuccess.shade800,
                                fontSize: 10,
                              )
                            ),

                            TextSpan(
                              text: ' (10%)',
                    
                              style: TextStyle(
                                color: appOrange.shade800,
                                fontSize: 10,
                              )
                            )
                          ]
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),

        Divider(height: 20,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                RichText(
                  text: TextSpan(
                    text: 'Income since start:    ',

                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11
                    ),

                    children: [
                      TextSpan(
                        text: Currency(context).wrapCurrencySymbol('1234567890'),

                        style: TextStyle(
                          color: appSuccess.shade700,
                          fontSize: 15
                        )
                  )
                    ]
                  ),                  
                ),

                SizedBox(height: 3,),


                RichText(
                  text: TextSpan(
                    text: 'Expense since start:  ',

                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11
                    ),

                    children: [
                      TextSpan(
                        text: Currency(context).wrapCurrencySymbol('1234567890'),

                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15
                        )
                  )
                    ]
                  ),

                  
                ),

              ],
            ),

            SizedBox(
              width: 100,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: appSuccess.shade700,
                  border: Border.all(width: .3, color: appSuccess),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Center(
                  child: Text(
                     Currency(context).wrapCurrencySymbol('20000000'),

                     style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                     ),
                  ),
                )
              ),
            )
          ],
        )
      ],
    );
  }
}