

import 'package:expense/utils/currency/currency.dart';
import 'package:flutter/material.dart';

import '../../../../models/budget.dart';
import '../../../../utils/constants/colors.dart';

class OverspentBudget extends StatefulWidget {
  final BudgetModel budget;
  
  const OverspentBudget({
    required this.budget,
    super.key});

  @override
  State<OverspentBudget> createState() => _OverspentBudgetState();
}

class _OverspentBudgetState extends State<OverspentBudget> {
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
                    double.parse((((widget.budget.amount - widget.budget.balance)/widget.budget.amount)*100).toString()).toStringAsFixed(0)+'%',
                        
                    style: TextStyle(
                      color: Colors.white,
                      
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),

            Divider(height: 14,),

            Text(
              'of ${widget.budget.name}\'s spent',
        
              style: TextStyle(
                color: appSuccess.shade800,
                
                fontSize: 12,
              ),
            ),

            Divider(height: 14,),

            RichText(
                text: TextSpan(
                  text: 'Actual Spending: \n',
            
                  style: TextStyle(
                    color: appSuccess.shade800,
                    
                    fontSize: 10,
                  ),
            
                  children: [
                    
                    TextSpan(
                      text: Currency(context).wrapCurrencySymbol((widget.budget.amount-widget.budget.balance).toString()),
            
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