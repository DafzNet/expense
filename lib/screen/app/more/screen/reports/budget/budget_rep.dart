import 'package:expense/dbs/budget_db.dart';
import 'package:expense/dbs/expense.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:expense/widgets/cards/budget_card.dart';
import 'package:expense/widgets/cards/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 2, 68, 90),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: SizedBox(
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                                    
                            children: [
                              const Text(
                                'Total Income',
                                    
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white
                                ),
                              ),
                
                              const SizedBox(height: 10,),
                                    
                              Text(
                                Currency().wrapCurrencySymbol('0000'),
                                    
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 25
                                ),
                              ),

                              const SizedBox(height: 10,),
                            ],
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Text(
                                    'Spent:',    
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Text(
                                    '2222',    
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.redAccent,
                                      fontSize: 16
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Text(
                                    'Balance:',    
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: 14
                                    ),
                                  ),
                                ],
                              ),                 

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const[
                                  Text(
                                    '0000',    
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.greenAccent,
                                      fontSize: 16
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10,),

              ...budgets.map((e) => BudgetCard(budget: e)),

              ...List.generate(expensesPerBudgets.length, (index){
                return Column(
                  children: expensesPerBudgets.values.elementAt(index).map((e){
                    return Text(e.title+expensesPerBudgets.keys.elementAt(index).toString());
                  }).toList(),
                );
              })
            ],
          ),
        ),
      )
    );
  }
}
