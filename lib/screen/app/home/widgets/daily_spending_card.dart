

import 'package:expense/models/income_model.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../dbs/expense.dart';
import '../../../../dbs/income_db.dart';
import '../../../../models/expense_model.dart';

class HomeSummary extends StatefulWidget {
  
  const HomeSummary({super.key});

  @override
  State<HomeSummary> createState() => _HomeSummaryState();
}

class _HomeSummaryState extends State<HomeSummary> {

  final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  
  ExpenseDb expenseDb = ExpenseDb();
  IncomeDb incomeDb = IncomeDb();

  DateTime expStartDate = DateTime.now();

  Map<String, double> daysOfExps = {'Sunday':0, 'Monday':0, 'Tuesday':0, 'Wednesday':0, 'Thursday':0, 'Friday':0, 'Saturday':0};

  double _height = 100;

  List<ExpenseModel> expensesAllTime = [];
  double totalExpAllTime = 0;

  String highestSpenderDay = 'Monday ';
  double highestSpenderDayAmount = 0;

  String lowestSpenderDay = '';
  double lowestSpenderDayAmount = 0;



  void getAllTimeExpenses()async{
    expensesAllTime = await expenseDb.retrieveData();

    for (var element in expensesAllTime) {
      lowestSpenderDayAmount = element.amount;
      totalExpAllTime += element.amount;
      //Get exp total based on days
      daysOfExps[DateFormat.EEEE().format(element.date)] = daysOfExps[DateFormat.EEEE().format(element.date)]! + element.amount;
      //Get start date
      expStartDate = element.date.isBefore(expStartDate)? element.date:expStartDate;
    }


    for (var element in daysOfExps.keys) {

      if (highestSpenderDayAmount < daysOfExps[element]!) {
        highestSpenderDay = element;
        highestSpenderDayAmount = daysOfExps[element]!;
      }

      if (lowestSpenderDayAmount > daysOfExps[element]!) {
        lowestSpenderDay = element;
        lowestSpenderDayAmount = daysOfExps[element]!;
      }
    }

    double maxSpendingDayPercent = 0;

    for (var amt in daysOfExps.values) {
      if(((amt/totalExpAllTime)*100)>maxSpendingDayPercent){
        maxSpendingDayPercent = (amt/totalExpAllTime)*100;
      }      
    }

     if (maxSpendingDayPercent <= 30) {
      _height = 4.2; 
    }
    else if (maxSpendingDayPercent > 30 && maxSpendingDayPercent <= 50) {
      _height = 3.2; 
    } else if(maxSpendingDayPercent > 50 && maxSpendingDayPercent <= 70) {
      _height = 2.2;
    }else{
      _height = 1.6;
    }

    setState(() {
      
    });
  }


  List<IncomeModel> incomesAllTime = [];
  double incomeTotal = 0;

  void getAllTimeIncomes()async{
    incomesAllTime = await incomeDb.retrieveData();

    for (var element in incomesAllTime) {
      incomeTotal += element.amount;
      //Get exp total based on days
      
    }

    setState(() {
      
    });
  }

  @override
  void initState() {
    getAllTimeExpenses();
    getAllTimeIncomes();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return expensesAllTime.isNotEmpty? Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide())
              ),
              child: RichText(
                text: TextSpan(
                  text: 'Daily Spending Habit Since ',
            
                  style: const TextStyle(
                    color: Colors.black,
                    
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
            
                  children: [
                    TextSpan(
                      text: expStartDate.year == DateTime.now().year? DateFormat.MMMd().format(expStartDate) : DateFormat.yMMMd().format(expStartDate),
            
                      style: const TextStyle(
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
                        '${double.parse(((daysOfExps[days.elementAt(i)]!/totalExpAllTime)*100).toString()).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 9
                        ),
                      ),
                      SizedBox(
                        height: ((daysOfExps[days.elementAt(i)]!/totalExpAllTime)*100)*_height,
                        width: 8,
                        child: Container(
                          color: appDanger,
                        ),
                      ),

                      const SizedBox(height: 2,),
                      Text(days[i].substring(0,3))

                      
                    ],
                  ), )
              ),

              Positioned(
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    border: Border.all(width: .3, color: appSuccess),
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Highest spender: ',
                    
                          style: TextStyle(
                            color: appSuccess.shade800,
                            
                            fontSize: 9,
                          ),
                    
                          children: [
                            TextSpan(
                              text: highestSpenderDay,
                    
                              style: TextStyle(
                                color: appSuccess.shade800,
                                fontSize: 10,
                              )
                            ),

                            TextSpan(
                              text:' ${Currency(context).wrapCurrencySymbol(highestSpenderDayAmount.toString())}',
                    
                              style: TextStyle(
                                color: appSuccess.shade800,
                                fontSize: 10,
                              )
                            ),

                            TextSpan(
                              text: ' (${double.parse(((highestSpenderDayAmount/totalExpAllTime)*100).toString()).toStringAsFixed(0)}%)',
                    
                              style: TextStyle(
                                color: appOrange.shade800,
                                fontSize: 10,
                              )
                            )
                          ]
                        ),
                      ),

                      const SizedBox(height: 3,),


                      RichText(
                        text: TextSpan(
                          text: 'Least Spender: ',
                    
                          style: TextStyle(
                            color: appSuccess.shade800,
                            
                            fontSize: 9,
                          ),
                    
                          children: [
                            TextSpan(
                              text: '$lowestSpenderDay ',
                    
                              style: TextStyle(
                                color: appSuccess.shade800,
                                fontSize: 10,
                              )
                            ),

                            TextSpan(
                              text: Currency(context).wrapCurrencySymbol(lowestSpenderDayAmount.toString()),
                    
                              style: TextStyle(
                                color: appSuccess.shade800,
                                fontSize: 10,
                              )
                            ),

                            TextSpan(
                              text: ' (${double.parse(((lowestSpenderDayAmount/totalExpAllTime)*100).toString()).toStringAsFixed(0)}%)',
                    
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

        const Divider(height: 20,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                RichText(
                  text: TextSpan(
                    text: 'Income since start:    ',

                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11
                    ),

                    children: [
                      TextSpan(
                        text: Currency(context).wrapCurrencySymbol(incomeTotal.toString()),

                        style: TextStyle(
                          color: appSuccess.shade700,
                          fontSize: 15
                        )
                  )
                    ]
                  ),                  
                ),

                const SizedBox(height: 3,),


                RichText(
                  text: TextSpan(
                    text: 'Expense since start:  ',

                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11
                    ),

                    children: [
                      TextSpan(
                        text: Currency(context).wrapCurrencySymbol(totalExpAllTime.toString()),

                        style: const TextStyle(
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
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: appSuccess.shade700,
                  border: Border.all(width: .3, color: appSuccess),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                         'Balance:',

                         style: TextStyle(
                          color: Color.fromARGB(255, 194, 249, 148),
                          fontWeight: FontWeight.bold,
                          fontSize: 8
                         ),
                      ),
                      Text(
                         Currency(context).wrapCurrencySymbol((incomeTotal-totalExpAllTime).toString()),

                         style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                         ),
                      ),
                    ],
                  ),
                )
              ),
            )
          ],
        )
      ],
    ):
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'A Summary of all your\nfinances willbe displayed here',
              textAlign: TextAlign.center,
            ),
          ],
        )
      ],
    );
  }
}