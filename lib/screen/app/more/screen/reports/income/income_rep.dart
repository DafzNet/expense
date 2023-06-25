import 'package:expense/dbs/expense.dart';
import 'package:expense/dbs/income_db.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/models/income_model.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sembast/sembast.dart';

import '../../../../../../utils/month.dart';



class IncomeReportScreen extends StatefulWidget {
  const IncomeReportScreen({super.key});

  @override
  State<IncomeReportScreen> createState() => _IncomeReportScreenState();
}

class _IncomeReportScreenState extends State<IncomeReportScreen> {
  IncomeDb incomeDb = IncomeDb();
  ExpenseDb expenseDb = ExpenseDb();

  List<IncomeModel> allIncomesForPeriod = [];
  List<ExpenseModel> allExpensesForPeriod = [];

  Map<int, List<ExpenseModel>> expensesForIncome = {};
  Map<int, Map<String, double>> expensesCatTotalForIncome = {};
  Map<int, Set<String>> perIncomeExpCat = {};

  double totalIncome = 0;
  double incomeBalance = 0;
  double incomeSpent = 0;

  void getIncome()async{

    final filter = Filter.equals('month', Month().currentMonthNumber); //filter the db based on period

    final incomes = await incomeDb.retrieveBasedOn(filter); //get all incomes for the period
    final expenses = await expenseDb.retrieveBasedOn(filter); //get all expenses for samme period as income
    
    allIncomesForPeriod = incomes;

    for (var income in incomes) {
        expensesForIncome[income.id] = [];
      }

    //get all income balance and amount
    for (var income in incomes) {
      incomeBalance += income.balance;
      totalIncome += income.amount;

      //separate expenses by their income.

      for (var expense in expenses) {
        if (expense.income == income) {
          expensesForIncome[income.id]!.add(expense);
        } 
      }
    }

    for (var income in incomes) {
      expensesCatTotalForIncome[income.id] = {};
      perIncomeExpCat[income.id] = <String>{};
    }

    for (var income in incomes) {
      for (var exp in expensesForIncome[income.id]!) {
        expensesCatTotalForIncome[income.id]![exp.category!.name] = 0;
        //perIncomeExpCat[income.id]!.add(exp.category!.name);
      }

      for (var exp in expensesForIncome[income.id]!) {
        expensesCatTotalForIncome[income.id]![exp.category!.name] = expensesCatTotalForIncome[income.id]![exp.category!.name]! + exp.amount;
        perIncomeExpCat[income.id]!.add(exp.category!.name);
      }
    }
  
    incomeSpent = totalIncome - incomeBalance; //total income spent

    setState(() {
      
    });
  }


  @override
  void initState() {
    getIncome();
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
                      color: const Color.fromARGB(255, 62, 48, 2),
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
                                Currency().wrapCurrencySymbol(totalIncome.toString()),
                                    
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
                                children: [
                                  Text(
                                    Currency().wrapCurrencySymbol(incomeSpent.toString()),    
                                    style: const TextStyle(
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
                                children: [
                                  Text(
                                    Currency().wrapCurrencySymbol(incomeBalance.toString()),    
                                    style: const TextStyle(
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

              //////////////////////////////////////////////////
              //////////////////////////////////////////////////
              //////////////////////////////////////////////////
              ///
              Row(
                children: const[
                  Text('Individual Incomes'),
                ],
              ),
              const SizedBox(height: 10,),
              ...List.generate(allIncomesForPeriod.length, (index){
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: .3
                          )
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: appOrange.shade50,
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        MdiIcons.trendingUp,
                                        color: Color.fromARGB(255, 10, 135, 14),
                                        size: 16,
                                      ),
                                
                                      const SizedBox(width: 10,),
                                
                                      Text(
                                        allIncomesForPeriod.elementAt(index).name!,
                                
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                
                                      const SizedBox(width: 10,),
                                
                                      const Icon(
                                        MdiIcons.circle,
                                        size: 8,
                                        color: Color.fromARGB(255, 76, 75, 75),
                                      ),
                                
                                      const SizedBox(width: 10,),
                                
                                      Text(
                                        allIncomesForPeriod.elementAt(index).source!,
                                
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  DateTime.now().difference(allIncomesForPeriod.elementAt(index).date).inDays>0 ?
                                    '${DateTime.now().difference(allIncomesForPeriod.elementAt(index).date).inDays}d ago' : 
                                      '${DateTime.now().difference(allIncomesForPeriod.elementAt(index).date).inHours}h ago'
                                )
                              ],
                            ),

                            

                            const SizedBox(height: 10,),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 25,
                                ),

                                const Text(
                                  'Amount: ',

                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),

                                Container(
                                  color: appSuccess,
                                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                  child: Text(
                                    Currency().wrapCurrencySymbol('${allIncomesForPeriod.elementAt(index).amount}'),
                                
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),


                                Expanded(
                                  child: Text(
                                    '(contributed ${double.parse(((allIncomesForPeriod.elementAt(index).amount/totalIncome)*100).toString()).toStringAsFixed(1)}% to overall income)',
                                
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),


                            const Divider(

                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 25,
                                ),

                                const Text(
                                  'Spent:   ',

                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),

                                Text(
                                  Currency().wrapCurrencySymbol(
                                    '${allIncomesForPeriod.elementAt(index).amount-allIncomesForPeriod.elementAt(index).balance}  '),

                                  style: TextStyle(
                                    fontSize: 18,
                                    color: appDanger,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    '(${double.parse((((allIncomesForPeriod.elementAt(index).amount-allIncomesForPeriod.elementAt(index).balance)/
                                      allIncomesForPeriod.elementAt(index).amount)*100).toString()).toStringAsFixed(1)}% spent so far)',
                                
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),


                            const Divider(

                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 25,
                                ),

                                const Text(
                                  'Balance:   ',

                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),

                                Text(
                                  Currency().wrapCurrencySymbol(
                                    '${allIncomesForPeriod.elementAt(index).balance}  '),

                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 2, 133, 70)
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    '(${double.parse((((allIncomesForPeriod.elementAt(index).balance)/
                                      allIncomesForPeriod.elementAt(index).amount)*100).toString()).toStringAsFixed(1)}% saved)',
                                
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),

                            const SizedBox(height: 20,),

                            Row(
                              children: const [
                                SizedBox(width: 25,),
                                Text(
                                  'Spendings by Category:'
                                ),
                              ],
                            ),

                            Column(
                              children: List.generate(
                                perIncomeExpCat[allIncomesForPeriod[index].id]!.length, (i){
                                return Row(
                                  children: [
                                    const SizedBox(width: 30,),

                                    Expanded(
                                      child: ListTile(
                                        dense: true,
                                        minLeadingWidth: 20,
                                        leading: Icon(
                                          MdiIcons.trendingDown,
                                          color: appDanger,
                                          size: 18,
                                        ),

                                        trailing: Text(
                                         Currency().wrapCurrencySymbol(expensesCatTotalForIncome[allIncomesForPeriod.elementAt(index).id]![perIncomeExpCat[allIncomesForPeriod[index].id]!.elementAt(i)].toString())
                                        ,style: TextStyle(
                                            color: appDanger
                                          ),
                                        ),

                                        title: Text(
                                          perIncomeExpCat[allIncomesForPeriod[index].id]!.elementAt(i)
                                        ),

                                         subtitle: Text(
                                          double.parse(((expensesCatTotalForIncome[allIncomesForPeriod.elementAt(index).id]![perIncomeExpCat[allIncomesForPeriod[index].id]!.elementAt(i)]!/totalIncome)*100).toString()).toStringAsFixed(1)+'% spent from overall income\n'+
                                          double.parse(((expensesCatTotalForIncome[allIncomesForPeriod.elementAt(index).id]![perIncomeExpCat[allIncomesForPeriod[index].id]!.elementAt(i)]!/allIncomesForPeriod.elementAt(index).amount)*100).toString()).toStringAsFixed(1)+'% spent from this income'
                                        ),
                                      ),
                                    )
                                    
                                  ],
                                );
                              })
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,

                              children: const [
                                Text(
                                  'View individual Expenses',

                                  style: TextStyle(
                                            color: Colors.blueAccent
                                          ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
                )



            ],
          ),
        ),
      )
    );
  }
}
