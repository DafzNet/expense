// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:expense/dbs/expense.dart';
import 'package:expense/dbs/income_db.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/models/income_model.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';
import '../../income/income_exps.dart';



class IncomeReportScreen extends StatefulWidget {
  final GlobalKey<IncomeReportScreenState> reportKey;
  final period;
   final String dateR;
  const IncomeReportScreen(
      this.reportKey,
      
      {Key? key, this.period, required this.dateR}
    ):super(key: key);
  
  @override
  State<IncomeReportScreen> createState() => IncomeReportScreenState();
}

class IncomeReportScreenState extends State<IncomeReportScreen> {


  int touchedIndex = -1;
  IncomeDb incomeDb = IncomeDb();
  ExpenseDb expenseDb = ExpenseDb();

  List<IncomeModel> allIncomesForPeriod = [];
  List<ExpenseModel> allExpensesForPeriod = [];

  Map<int, List<ExpenseModel>> expensesForIncome = {}; //exps per individual income
  Map<int, Map<String, double>> expensesCatTotalForIncome = {}; //exps category total per individual income
  Map<int, Set<String>> perIncomeExpCat = {}; //exps categories in any individual income


  Map<String, double> allIncomeExpCatsAndTotal = {}; /// all exps categories for all incomes

  double totalIncome = 0;
  double incomeBalance = 0;
  double incomeSpent = 0;

  getIncome(var date, String p)async{ //filter the db based on period

    List<IncomeModel> incomes = []; //get all incomes for the period
    List<ExpenseModel> expenses = []; //get all expenses for samme period as income
    
    if (p == 'cm' || p == 'pm') {
      expenses = await expenseDb.retrieveBasedOn(
        Filter.and([
          Filter.equals('month', date.month),
          Filter.equals('year', date.year)
        ])
      );

      incomes = await incomeDb.retrieveBasedOn(
        Filter.and([
          Filter.equals('month', date.month),
          Filter.equals('year', date.year)
        ])
      );
    }

    if (p == 'ya') {
      expenses = await expenseDb.retrieveBasedOn(
        Filter.custom((record){
          final data = record.value as Map<String, dynamic>;
          final recordExp = ExpenseModel.fromMap(data);

          return recordExp.date.isAfter(date);
        })
      );

      incomes = await incomeDb.retrieveBasedOn(
        Filter.custom((record){
          final data = record.value as Map<String, dynamic>;
          final recordExp = IncomeModel.fromMap(data);

          return recordExp.date.isAfter(date);
        })
      );
    }


    if (p == 'range') {

      expenses = await expenseDb.retrieveBasedOn(
        Filter.custom((record){
            final data = record.value as Map<String, dynamic>;
            final recordExp = ExpenseModel.fromMap(data);

            return recordExp.date.isAfter(date.start) && recordExp.date.isBefore(date.end);
          })
      );

      incomes = await incomeDb.retrieveBasedOn(
        Filter.custom((record){
            final data = record.value as Map<String, dynamic>;
            final recordExp = IncomeModel.fromMap(data);

            return recordExp.date.isAfter(date.start) && recordExp.date.isBefore(date.end);
          })
      );
    }

    allIncomesForPeriod = incomes;

    if(incomes.isEmpty){return null;}

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

    for (var expense in expenses) {
      allIncomeExpCatsAndTotal[expense.category!.name]=0;
    }


    for (var expense in expenses) {
      allIncomeExpCatsAndTotal[expense.category!.name] = allIncomeExpCatsAndTotal[expense.category!.name]! + expense.amount;
    }
  
    incomeSpent = totalIncome - incomeBalance; //total income spent

    setState(() {
      
    });
  }

   var _initial;

  @override
  void initState() {
    getIncome(widget.period, widget.dateR);
    _initial = widget.period;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

   if (_initial != widget.period) {

      allIncomesForPeriod = [];
      allExpensesForPeriod = [];

      expensesForIncome = {}; //exps per individual income
      expensesCatTotalForIncome = {}; //exps category total per individual income
      perIncomeExpCat = {}; //exps categories in any individual income

      allIncomeExpCatsAndTotal = {}; /// all exps categories for all incomes

      totalIncome = 0;
      incomeBalance = 0;
      incomeSpent = 0;


      getIncome(widget.period, widget.dateR);
      _initial = widget.period;
    }
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
    
      body: allIncomesForPeriod.isEmpty ? 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            MdiIcons.informationOffOutline,

            size: 35,
            color: appDanger,
          ),

          const Center(
            child: Text(
              'No Income found for this period',

              style: TextStyle(
                fontSize: 18,

              ),
            ),
          )
        ],
      )
      :
      Padding(
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
                                Currency(context).wrapCurrencySymbol(totalIncome.toString()),
                                    
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
                                    Currency(context).wrapCurrencySymbol(incomeSpent.toString()),    
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
                                    Currency(context).wrapCurrencySymbol(incomeBalance.toString()),    
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


              Row(
                children: const  [
                  Text('Expense Category against overall Income'),
                ],
              ),

              const SizedBox(height: 10,),

              Container(
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(
                    color: appOrange.shade200
                  )
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 240,
                          child: AspectRatio(
                            aspectRatio: 0.9,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection == null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 1,
                                centerSpaceRadius: 40,
                                centerSpaceColor: appSuccess.shade50,
                                sections: List.generate(allIncomeExpCatsAndTotal.length, (i) {
                                  final isTouched = i == touchedIndex;
                                  final fontSize = isTouched ? 25.0 : 16.0;
                                  final radius = isTouched ? 70.0 : 60.0;
                                  const shadows = [Shadow(color: Color.fromARGB(255, 106, 69, 69), blurRadius: 2)];
                                              
                                  return PieChartSectionData(
                                      color: reportColors[i+1],
                                      value: (allIncomeExpCatsAndTotal.values.elementAt(i)/totalIncome)*100,
                                        title: '${double.parse(((allIncomeExpCatsAndTotal.values.elementAt(i)/totalIncome)*100).toString()).toStringAsFixed(1)}%',
                                        radius: radius,
                                        titleStyle: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: shadows,
                                        ),
                                      );
                                     }
                                  )
                                 )
                                  
                            ),
                          ),
                        ),
              
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              allIncomeExpCatsAndTotal.values.length, (iC) => Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      MdiIcons.circle,
                                      color: reportColors[iC+1],
                                      size: 14,
                                    ),
                              
                                    const SizedBox(width: 5,),
                                                
                                    Text(
                                      allIncomeExpCatsAndTotal.keys.elementAt(iC),
                              
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            )
                          ),
                        )          
                      ],
                    ),

                    Divider(
                      color: appOrange,
                    ),

                    ...List.generate(allIncomeExpCatsAndTotal.length, (index){
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.trendingDown,
                              color: appDanger,
                              size: 12,
                            ),
                            const SizedBox(width: 5,),

                            Flexible(
                              flex: 3,
                              fit: FlexFit.tight,
                              child: Text(
                                allIncomeExpCatsAndTotal.keys.elementAt(index)
                              ),
                            ),

                            Flexible(
                              flex: 5,
                              //fit: FlexFit.tight,
                              child: Text(
                                Currency(context).wrapCurrencySymbol(allIncomeExpCatsAndTotal.values.elementAt(index).toString()),

                                style: TextStyle(
                                  fontSize: 14,
                                  color: appDanger,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })


                  ],
                ),
              ),

              const SizedBox(height: 20,),

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
                                    Currency(context).wrapCurrencySymbol('${allIncomesForPeriod.elementAt(index).amount}'),
                                
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
                                  Currency(context).wrapCurrencySymbol(
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
                                  Currency(context).wrapCurrencySymbol(
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
                                         Currency(context).wrapCurrencySymbol(expensesCatTotalForIncome[allIncomesForPeriod.elementAt(index).id]![perIncomeExpCat[allIncomesForPeriod[index].id]!.elementAt(i)].toString())
                                        ,style: TextStyle(
                                            color: appDanger
                                          ),
                                        ),

                                        title: Text(
                                          perIncomeExpCat[allIncomesForPeriod[index].id]!.elementAt(i)
                                        ),

                                         subtitle: Text(
                                          '${double.parse(((expensesCatTotalForIncome[allIncomesForPeriod.elementAt(index).id]![perIncomeExpCat[allIncomesForPeriod[index].id]!.elementAt(i)]!/totalIncome)*100).toString()).toStringAsFixed(1)}% spent from overall income\n${double.parse(((expensesCatTotalForIncome[allIncomesForPeriod.elementAt(index).id]![perIncomeExpCat[allIncomesForPeriod[index].id]!.elementAt(i)]!/allIncomesForPeriod.elementAt(index).amount)*100).toString()).toStringAsFixed(1)}% spent from this income'
                                        ),
                                      ),
                                    )
                                    
                                  ],
                                );
                              })
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,

                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: IncomeExpensesScreen(
                                        income: allIncomesForPeriod.elementAt(index),
                                      
                                      )
                                    )
                                   );
                                  },
                                  child: const Text(
                                    'View individual Expenses',
                                
                                    style: TextStyle(
                                              color: Colors.blueAccent
                                            ),
                                  ),
                                )
                              ],
                            ),

                            const Divider(),


                      Row(      
                      children: [
                        SizedBox(
                          height: 120,
                          width: 160,
                          child: AspectRatio(
                            aspectRatio: 0.9,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection == null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 1,
                                centerSpaceRadius: 20,
                                centerSpaceColor: appSuccess.shade50,
                                sections: List.generate(expensesCatTotalForIncome[allIncomesForPeriod.elementAt(index).id]!.length, (i) {
                                  final isTouched = i == touchedIndex;
                                  final fontSize = isTouched ? 16.0 : 10.0;
                                  final radius = isTouched ? 40.0 : 30.0;
                                  const shadows = [Shadow(color: Color.fromARGB(255, 106, 69, 69), blurRadius: 2)];
                                              
                                  return PieChartSectionData(
                                      color: reportColors[i+1],
                                      value: (expensesCatTotalForIncome[allIncomesForPeriod.elementAt(index).id]!.values.elementAt(i)/allIncomesForPeriod.elementAt(index).amount)*100,
                                        title: '${double.parse(((expensesCatTotalForIncome[allIncomesForPeriod.elementAt(index).id]!.values.elementAt(i)/allIncomesForPeriod.elementAt(index).amount)*100).toString()).toStringAsFixed(1)}%',
                                        radius: radius,
                                        titleStyle: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: shadows,
                                        ),
                                      );
                                     }
                                  )
                                 )
                                  
                            ),
                          ),
                        ),
              
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              expensesCatTotalForIncome[allIncomesForPeriod.elementAt(index).id]!.keys.length, (iC) => Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  children: [
                                    Icon(
                                      MdiIcons.circle,
                                      color: reportColors[iC+1],
                                      size: 10,
                                    ),
                              
                                    const SizedBox(width: 5,),
                                                
                                    Text(
                                      expensesCatTotalForIncome[allIncomesForPeriod.elementAt(index).id]!.keys.elementAt(iC),
                              
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            )
                          ),
                        )          
                      ],
                    ),


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
