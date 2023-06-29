

import 'package:expense/utils/currency/currency.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

class OverspentIncome extends StatefulWidget {
  const OverspentIncome({super.key});

  @override
  State<OverspentIncome> createState() => _OverspentIncomeState();
}

class _OverspentIncomeState extends State<OverspentIncome> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(width: .5, color: appSuccess),
            borderRadius: BorderRadius.circular(8)
          ),
        child: Column(
          children: [

            SizedBox(
              height: 40,
              width: 40,
              child: Container(
                padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: appDanger,
                    border: Border.all(width: .5, color: appSuccess),
                    borderRadius: BorderRadius.circular(30)
                  ),
                child: Center(
                  child: Text(
                    '83%',
                        
                    style: TextStyle(
                      color: Colors.white,
                      
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),

            Divider(height: 14,),

            Text(
              'of Salary spent',
        
              style: TextStyle(
                color: appSuccess.shade800,
                
                fontSize: 14,
              ),
            ),

            Divider(height: 14,),

            RichText(
                text: TextSpan(
                  text: 'Balance: ',
            
                  style: TextStyle(
                    color: appSuccess.shade800,
                    
                    fontSize: 10,
                  ),
            
                  children: [
                    
                    TextSpan(
                      text: Currency(context).wrapCurrencySymbol('30000'),
            
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
      ),
    );
  }
}