

import 'package:expense/utils/currency/currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/savings_model.dart';
import '../../../../utils/capitalize.dart';
import '../../../../utils/constants/colors.dart';

class SavingsAproachingDeadline extends StatefulWidget {
  final TargetSavingModel saving;
  const SavingsAproachingDeadline({
    required this.saving,
    super.key});

  @override
  State<SavingsAproachingDeadline> createState() => _SavingsAproachingDeadlineState();
}

class _SavingsAproachingDeadlineState extends State<SavingsAproachingDeadline> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(width: .5, color: appSuccess.shade100),
            borderRadius: BorderRadius.circular(8)
          ),
        child: Column(
          children: [

            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    capitalize(widget.saving.targetPurpose??''),

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                        
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),



            Divider(height: 14,),

            Row(
              children: [
                RichText(
                    text: TextSpan(
                      text: 'Started: ',
                
                      style: TextStyle(
                        color: appSuccess.shade800,
                        
                        fontSize: 10,
                      ),
                
                      children: [
                        
                        TextSpan(
                          text: widget.saving.dateCreated.year == DateTime.now().year ? DateFormat.MMMd().format(widget.saving.dateCreated):DateFormat.yMMMd().format(widget.saving.dateCreated),
                
                          style: TextStyle(
                            color: appSuccess.shade800,
                            fontSize: 12,
                          )
                        ),

                      ]
                    ),
                  ),
              ],
            ),

            SizedBox(height: 5,),

            Row(
              children: [
                RichText(
                    text: TextSpan(
                      text: 'Ending: ',
                
                      style: TextStyle(
                        color: appSuccess.shade800,
                        
                        fontSize: 10,
                      ),
                
                      children: [
                        
                        TextSpan(
                          text: widget.saving.targetDate.year == DateTime.now().year ? DateFormat.MMMd().format(widget.saving.targetDate):DateFormat.yMMMd().format(widget.saving.targetDate),
                
                          style: TextStyle(
                            color: appSuccess.shade800,
                            fontSize: 12,
                          )
                        ),

                      ]
                    ),
                  ),
              ],
            ),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                color: appOrange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text:  TextSpan(
                          text: (widget.saving.targetDate.difference(DateTime.now()).inDays).toString(),
                    
                          style: TextStyle(
                            color: Colors.white,
                            
                            fontSize: 16,
                          ),
                    
                          children: [
                            
                            TextSpan(
                              text: ' Days to go',
                    
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              )
                            ),
                          
                          ]
                        ),
                      ),
                  ],
                ),
              ),
            ),

            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                        text: Currency(context).wrapCurrencySymbol(''),
                  
                        style: TextStyle(
                          color: appSuccess,
                          
                          fontSize: 18,
                        ),
                  
                        children: [
                          
                          TextSpan(
                            text: (widget.saving.currentAmount).toString(),
                  
                            style: TextStyle(
                              color: appSuccess,
                              fontSize: 16,
                            )
                          ),

                          TextSpan(
                            text: ' saved',
                  
                            style: TextStyle(
                              color: Colors.black
                              ,
                              fontSize: 10,
                            )
                          ),
                        
                        ]
                      ),
                    ),
                ],
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}