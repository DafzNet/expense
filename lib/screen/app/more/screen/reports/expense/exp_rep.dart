
import 'package:expense/models/expense_model.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';
import '../../../../../../dbs/expense.dart';
import '../../../../../../utils/constants/colors.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../../utils/month.dart';
import '../../../../expense/expense_detail.dart';


class ExpReportScreen extends StatefulWidget {
  const ExpReportScreen({super.key});

  @override
  State<ExpReportScreen> createState() => _ExpReportScreenState();
}

class _ExpReportScreenState extends State<ExpReportScreen> {
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
                      color: appSuccess.shade300,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: SizedBox(
                      height: 120,
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                                    
                            children: [
                              Text(
                                '${Month().currentMonth} Expense',
                                    
                                style: const TextStyle(
                                  fontSize: 16
                                ),
                              ),
                
                              const SizedBox(height: 10,),
                                    
                              Text(
                                Currency().wrapCurrencySymbol(expTotal.toString()),
                                    
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          
          
          
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: .5,
                    color: appOrange.shade50
                  )
                ),
                    
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text('Graphical View')
                        ],
                      ),
                    
                      const SizedBox(height: 20,),
                    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width/2,
                            width: (MediaQuery.of(context).size.width/3)*1.7,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  // touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                  //   setState(() {
                                  //     if (!event.isInterestedForInteractions ||
                                  //         pieTouchResponse == null ||
                                  //         pieTouchResponse.touchedSection == null) {
                                  //       touchedIndex = -1;
                                  //       return;
                                  //     }
                                  //     touchedIndex = pieTouchResponse
                                  //         .touchedSection!.touchedSectionIndex;
                                  //   });
                                  // },
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 1,
                                centerSpaceRadius: 40,
                                centerSpaceColor: appSuccess.shade50,
                                sections: expCatsList,
                              ),
                            ),
                          ),
                    
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(expensesCats.length, (index){
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                  
                                    children: [
                                      Icon(
                                        MdiIcons.circle,
                                        size: 16,
                                        color: expenseCatColor[expensesCats.elementAt(index)],
                                      ),
                                  
                                      Text(
                                        " ${expensesCats.elementAt(index)}",
                                
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                    
              ),
        
              const SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Expenses By Categories: '),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white
                    ),
                    child: Text(
                      Currency().wrapCurrencySymbol(_categoryAmount.toString())
                    ),
                  )
                ]
              ),

              const SizedBox(
                height: 15,
              ),
        
        
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(expensesCats.length, (index){
                    return GestureDetector(
                      onTap: () {
                        _selectedCategory = expensesCats.elementAt(index);
                        _categoryAmount = expenseCatTotal[expensesCats.elementAt(index)]!;
                        setState(() {
                          
                        });
                      },
                      child: SizedBox(
                          height: 80,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Card(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                      color: _selectedCategory == expensesCats.elementAt(index) ? Colors.white10 : expenseCatColor[expensesCats.elementAt(index)],
                    
                                      child: Center(
                                        child: Text(
                                          expensesCats.elementAt(index),
                    
                                          style:  TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: _selectedCategory == expensesCats.elementAt(index) ? Colors.black :Colors.white,
                                            shadows: _selectedCategory == expensesCats.elementAt(index) ? [] :[const Shadow(blurRadius: 4)]
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    );
                        }
                      ),
                    ),
                  ),


                    const SizedBox(
                      height: 15,
                    ),


                    Card(
                      child: Column(
                          children: expensesByCat[_selectedCategory]!.map((e){
                            return Padding(
                              padding: const EdgeInsets.only(bottom:5),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(context, 
                                    PageTransition(
                                      child: ExpenseDetail(
                                        expenseModel: e,
                                      ), type: PageTransitionType.fade ));
                                  },
                                  title: Text(
                                    e.title
                                  ),

                                  subtitle: Text(
                                    Currency().wrapCurrencySymbol(e.amount.toString())
                                  ),

                                  trailing: Text(
                                    DateFormat.yMMMd().format(e.date)
                                  ),

                                  leading: Icon(
                                    MdiIcons.trendingDown,
                                    color: appDanger,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ),
             
            ],
          ),
        ),
      )
    );
  }
}
