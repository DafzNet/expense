

import 'package:expense/utils/currency/currency.dart';
import 'package:flutter/material.dart';

import '../../../../models/income_model.dart';
import '../../../../utils/constants/colors.dart';

class OverspentIncome extends StatefulWidget {
  final IncomeModel income;
  const OverspentIncome({
    required this.income,
    super.key});

  @override
  State<OverspentIncome> createState() => _OverspentIncomeState();
}

class _OverspentIncomeState extends State<OverspentIncome> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.all(4),
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
                padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: appDanger,
                    border: Border.all(width: .5, color: appSuccess),
                    borderRadius: BorderRadius.circular(30)
                  ),
                child: Center(
                  child: Text(
                    '${double.parse((((widget.income.amount-widget.income.balance)/widget.income.amount)*100).toString()).toStringAsFixed(0)}%',
                        
                    style: const TextStyle(
                      color: Colors.white,
                      
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),

            const Divider(height: 14,),

            Text(
              'of ${widget.income.name} spent',

              maxLines: 1,
        
              style: TextStyle(
                color: appSuccess.shade800,
                
                fontSize: 14,
              ),
            ),

            const Divider(height: 14,),

            RichText(
                text: TextSpan(
                  text: 'Balance: ',
            
                  style: TextStyle(
                    color: appSuccess.shade800,
                    
                    fontSize: 10,
                  ),
            
                  children: [
                    
                    TextSpan(
                      text: Currency(context).wrapCurrencySymbol('${widget.income.balance}'),
            
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