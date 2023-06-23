
import 'package:expense/models/expense_model.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';
import '../../../../../../dbs/expense.dart';
import '../../../../../../utils/constants/colors.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../../utils/month.dart';
import '../../../../expense/expense_detail.dart';


class IncomeReportScreen extends StatefulWidget {
  const IncomeReportScreen({super.key});

  @override
  State<IncomeReportScreen> createState() => _IncomeReportScreenState();
}

class _IncomeReportScreenState extends State<IncomeReportScreen> {
  int touchedIndex = -1;


  final ExpenseDb expenseDb = ExpenseDb();
  Set<String> expensesCats = <String>{};
  Map<String, List<ExpenseModel>> expensesByCat = {};
  Map<String, Color> expenseCatColor = {};
  Map<String, double> expenseCatTotal = {};
  String _selectedCategory = '';

  double _categoryAmount = 0;


  double expTotal = 0;
  List<PieChartSectionData> expCatsList = [];

  void getExps()async{
    final exps = await expenseDb.retrieveBasedOn(
      Filter.and([
        Filter.equals('month', Month().currentMonthNumber),
        Filter.equals('year', DateTime.now().year)
      ])
    );


    ////Get expenses categories
    for (ExpenseModel exp in exps) {
      expensesCats.add(exp.category!.name);
      expTotal += exp.amount;
    }


    ///create empty map lists for all cats
    for (var catStr in expensesCats) {
      expensesByCat[catStr] = [];
    }

    ///Separate all exps into their cats 
    for (ExpenseModel expen in exps) {
      expensesByCat[expen.category!.name]!.add(expen);
    }

    //Create each cats pieData
    int colorIndex = 1;
    _selectedCategory = expensesCats.first;
    

    for (String cat in expensesCats) {

      double catTotal = 0;

      for (final element in expensesByCat[cat]!) {
        catTotal += element.amount;
      }

    expenseCatTotal[cat] = catTotal;

    
     expCatsList.add(
       PieChartSectionData(
        color: reportColors[colorIndex],
        value: (catTotal/expTotal)*100,
        title: '${double.parse('${(catTotal/expTotal)*100}').toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      ) 
     );

     expenseCatColor[cat] = reportColors[colorIndex]!;
     colorIndex += 1;
    }

    _categoryAmount = expenseCatTotal[expensesCats.first]!;



    setState(() {
      
    });
  }

  @override
  void initState() {
    getExps();
    //getExpenseSections();
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 5, 182, 173),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: SizedBox(
                      height: 150,
                      child: Row(
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
                                Currency().wrapCurrencySymbol(expTotal.toString()),
                                    
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 25
                                ),
                              ),

                              const SizedBox(height: 10,),
                                    
                              
                            ],
                          ),

                          Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(width: 20,),
                                  Text(
                                    Currency().wrapCurrencySymbol(expTotal.toString()),
                                        
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 16
                                    ),
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          
          
             
            ],
          ),
        ),
      )
    );
  }
}
