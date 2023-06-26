import 'package:expense/dbs/budget_db.dart';
import 'package:expense/dbs/expense.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:expense/widgets/cards/budget_card.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

import '../../../../../../models/budget.dart';
import '../../../../../../models/category_model.dart';
import '../../../../../../utils/month.dart';



class BudgetReportScreen extends StatefulWidget {
  const BudgetReportScreen({super.key});

  @override
  State<BudgetReportScreen> createState() => _BudgetReportScreenState();
}

class _BudgetReportScreenState extends State<BudgetReportScreen> {

  int touchedIndex = -1;

  BudgetDb budgetDb = BudgetDb();
  ExpenseDb expenseDb = ExpenseDb();



  List<BudgetModel> budgets = [];
  double bugettedAmountForAllBudgets = 0;
  double actualAmountForAllBudgets = 0;


  Map<int, List<ExpenseModel>> expensesPerBudgets = {}; //sotre exps by their budgets
  List<ExpenseModel> allBudgetExps = [];


  
  void getBudget()async{
    //filter by category
    
    //filter to get budgets by month or time periiod 
    Filter filter =Filter.custom((record){
      final budg = record.value as Map<String, dynamic>;
      final myBudg = BudgetModel.fromMap(budg);

      if (myBudg.startDate == myBudg.endDate) {
        return myBudg.month == Month().currentMonthNumber && myBudg.year == DateTime.now().year;
      }else{
        return DateTime.now().isAfter(myBudg.startDate!) && DateTime.now().isBefore(myBudg.endDate!);
        } 
      }
    );

    budgets = await budgetDb.retrieveBasedOn(filter); //all budget

    for (var budget in budgets) {
      expensesPerBudgets[budget.id] = [];
      bugettedAmountForAllBudgets += budget.amount;
      actualAmountForAllBudgets += (budget.amount - budget.balance);
    }


    for (var budget in budgets) {
      expensesPerBudgets[budget.id] = await expenseDb.retrieveBasedOn(
          Filter.and(
            [
              Filter.custom((record){
                final data = record.value as Map<String, dynamic>;
                CategoryModel myCat = CategoryModel.fromMap(data['category']);

                return myCat == budget.category;
              }),

              Filter.or(
                [
                  Filter.and(
                    [
                      Filter.equals('month', Month().currentMonthNumber),
                      Filter.equals('year', DateTime.now().year),
                    ]
                  ),

                  Filter.and(
                    [
                      Filter.greaterThanOrEquals('date', budget.startDate!.millisecondsSinceEpoch),
                      Filter.lessThanOrEquals('date', budget.endDate!.millisecondsSinceEpoch)
                    ]
                  )
                ]
              )
            ]
          )
      );
    }

    for (var element in expensesPerBudgets.values) {
      allBudgetExps.addAll(element);
    }



    setState(() {
      
    });

  }


  @override
  void initState() {
    getBudget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
    
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),

        child: SingleChildScrollView(
          child: Column(
            children: [   
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Card(
                  elevation: 1,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 2, 68, 90),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: SizedBox(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                                    
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Number of Budgets: ',
                                        
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white
                                    ),
                                  ),

                                  Text(
                                    
                                    budgets.length.toString(),
                                    
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 25
                                    ),
                                  ),

                                ],
                              ),

                              const SizedBox(height: 10,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Budgeted Amount: ',
                                        
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white
                                    ),
                                  ),

                                  Text(
                                    
                                    Currency().wrapCurrencySymbol(bugettedAmountForAllBudgets.toString()),
                                    
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 20
                                    ),
                                  ),

                                ],
                              ),

                              const SizedBox(height: 10,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Actual Amount: ',
                                        
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white
                                    ),
                                  ),

                                  Text(
                                    
                                    Currency().wrapCurrencySymbol(actualAmountForAllBudgets.toString()),
                                    
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 20
                                    ),
                                  ),

                                ],
                              ),


                              const Divider(
                                height: 30,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Variance: ',
                                        
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: appOrange.shade100
                                    ),
                                  ),

                                  Text(
                                    
                                    Currency().wrapCurrencySymbol(
                                      (bugettedAmountForAllBudgets - actualAmountForAllBudgets)
                                    .toString()),
                                    
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: bugettedAmountForAllBudgets - actualAmountForAllBudgets < 0 ? appDanger :
                                        bugettedAmountForAllBudgets - actualAmountForAllBudgets == 0?
                                          appOrange : Colors.greenAccent,
                                      fontSize: 20
                                    ),
                                  ),

                                ],
                              ),

                              const SizedBox(height: 5,),

                              if(bugettedAmountForAllBudgets - actualAmountForAllBudgets < 0)...
                              [
                                Text(
                                  'Overall budget over spent by ${Currency().wrapCurrencySymbol((actualAmountForAllBudgets-bugettedAmountForAllBudgets).toString())}',

                                  style: TextStyle(
                                      color: appDanger,
                                      fontSize: 12
                                    ),
                                  
                                 )
                              ],

                              if(bugettedAmountForAllBudgets - actualAmountForAllBudgets > 0)...
                              [
                                Text(
                                  '${Currency().wrapCurrencySymbol((bugettedAmountForAllBudgets-actualAmountForAllBudgets).toString())} of overall budget saved',
                                  style: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 12
                                    ),
                                )
                              ],

                              if(bugettedAmountForAllBudgets - actualAmountForAllBudgets == 0)...
                              [
                                Text(
                                  'Overall budget spent exactly as planned',

                                  style: TextStyle(
                                      color: appOrange,
                                      fontSize: 12
                                    ),
                                )
                              ]

                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: const Text(
                            'View Expenses',

                             style: TextStyle(
                                color: Color.fromARGB(255, 1, 35, 46),
                                fontSize: 12
                              ),
                          ),
                        )
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10,),

              ...budgets.map((e) => BudgetCard(budget: e, ctx: context,)),

              // ...List.generate(expensesPerBudgets.length, (index){
              //   return Column(
              //     children: expensesPerBudgets.values.elementAt(index).map((e){
              //       return Text(e.title+expensesPerBudgets.keys.elementAt(index).toString());
              //     }).toList(),
              //   );
              // })
            ],
          ),
        ),
      )
    );
  }
}
