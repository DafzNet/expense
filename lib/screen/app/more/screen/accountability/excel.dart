import 'package:expense/utils/constants/images.dart';
import 'package:expense/widgets/generate/excel.dart';
import 'package:expense/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sembast/sembast.dart';

import '../../../../../dbs/budget_db.dart';
import '../../../../../dbs/expense.dart';
import '../../../../../dbs/income_db.dart';
import '../../../../../models/budget.dart';
import '../../../../../models/expense_model.dart';
import '../../../../../models/income_model.dart';
import '../../../../../models/plan_exp.dart';
import '../../../../../models/plan_model.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/month.dart';

class ExcelOptions extends StatefulWidget {
  const ExcelOptions({super.key});

  @override
  State<ExcelOptions> createState() => _ExcelOptionsState();
}

class _ExcelOptionsState extends State<ExcelOptions> {


  static String reportPeriod = "Current Month";
  // ignore: prefer_typing_uninitialized_variables
  var reportDate;
  String dateR = 'cm';

  DateTimeRange range = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());


  void updateReportPeriod(String newReportPeriod, newReportDate, {String p = 'cm'}) async{
    setState(() {
      reportPeriod = newReportPeriod;
      reportDate = newReportDate;
      dateR = p;
      //reload = true;
    });

    getExpenses(newReportDate, p);
    getBudgetData(newReportDate, p);
    getIncomeData(newReportDate, p);
  }

  ExpenseDb expenseDb = ExpenseDb();
  IncomeDb incomeDb = IncomeDb();
  BudgetDb budgetDb = BudgetDb();


  List<ExpenseModel> expenses = [];
  List<IncomeModel> incomes = [];
  List<BudgetModel> budgets = [];
  List<PlannerModel> planners = [];
  List<PlanExpModel> planExps = [];


  double incomeTotal = 0;

  Map<String, double> expByCat = {};
  double expTotal = 0;

  void getExpenses(var date, String p)async{

    if (p == 'cm' || p == 'pm') {
      expenses = await expenseDb.retrieveBasedOn(
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
    }


    if (p == 'range') {

      expenses = await expenseDb.retrieveBasedOn(
          Filter.custom((record){
            final data = record.value as Map<String, dynamic>;
            final recordExp = ExpenseModel.fromMap(data);

            return recordExp.date.isAfter(date.start) && recordExp.date.isBefore(date.end);
          })
      );
    }


    for (var exp in expenses) {
      expByCat[exp.category!.name] = 0.0;
      expTotal += exp.amount;
    }

    for (var exp in expenses) {
      expByCat[exp.category!.name] = expByCat[exp.category!.name]! + exp.amount;
    }

    setState(() {
      
    });
  }


/////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////

   void getBudgetData(var date, String p)async{
    
    Filter? filter;


    if (p == 'cm' || p == 'pm') {
      filter = Filter.custom((record){
        final budg = record.value as Map<String, dynamic>;
        final myBudg = BudgetModel.fromMap(budg);

        if (myBudg.startDate == myBudg.endDate) {
          return myBudg.month == date.month && myBudg.year == date.year;
        }else{
          return date.isAfter(myBudg.startDate!) && date.isBefore(myBudg.endDate!);
          } 
        }
      );
    }

    if (p == 'ya') {
      filter = Filter.custom((record){
        final budg = record.value as Map<String, dynamic>;
        final myBudg = BudgetModel.fromMap(budg);

        if (myBudg.startDate == myBudg.endDate) {
          return myBudg.startDate!.isAfter(date);
        }else{
          return myBudg.startDate!.isAfter(date) || myBudg.endDate!.isAfter(date);
          } 
        }
      );
    }

    if (p == 'range') {
      DateTimeRange _date = date as DateTimeRange;

      filter = Filter.custom((record){
        final budg = record.value as Map<String, dynamic>;
        final myBudg = BudgetModel.fromMap(budg);

        if (myBudg.startDate == myBudg.endDate) {
          return myBudg.startDate!.isAfter(_date.start) && myBudg.startDate!.isBefore(_date.end);
        }else{
          return myBudg.startDate!.isAfter(_date.start) &&  myBudg.startDate!.isBefore(_date.end)||myBudg.endDate!.isAfter(_date.start) &&  myBudg.endDate!.isBefore(_date.end);
          } 
        }
      );
    }


    budgets = await budgetDb.retrieveBasedOn(filter!); //all budget



    setState(() {
      
    });
  }

////////////////////////////////////////////////
///////////////////////////////////////////
  void getIncomeData(var date, String p)async{

    if (p == 'cm' || p == 'pm') {

      incomes = await incomeDb.retrieveBasedOn(
        Filter.and([
          Filter.equals('month', date.month),
          Filter.equals('year', date.year)
        ])
      );
    }

    if (p == 'ya') {

      incomes = await incomeDb.retrieveBasedOn(
        Filter.custom((record){
          final data = record.value as Map<String, dynamic>;
          final recordExp = IncomeModel.fromMap(data);

          return recordExp.date.isAfter(date);
        })
      );
    }


    if (p == 'range') {
      incomes = await incomeDb.retrieveBasedOn(
        Filter.custom((record){
            final data = record.value as Map<String, dynamic>;
            final recordExp = IncomeModel.fromMap(data);

            return recordExp.date.isAfter(date.start) && recordExp.date.isBefore(date.end);
          })
      );
    }



    for (var i in incomes) {
      incomeTotal += i.amount;
    }

    setState(() {
      
    });
  }
















  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Export to Excel'
        ),


        actions: [
          GestureDetector(
              onTap: () async{
                await showModalBottomSheet(
                  context: context, 
                  builder: (context){
                    return ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Container(
                        height:300,
                        color: Colors.white,

                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),

                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                String rPrd = 'Current Month';
                                var rDate =DateTime.now();

                                
                                updateReportPeriod(rPrd, rDate, p: 'cm');

                                Navigator.pop(context);

                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                            
                                  ),
                            
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          MdiIcons.calendarTodayOutline,
                                          size: 18,
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          'Current Month',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      MdiIcons.chevronRightCircleOutline
                                    )
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 15,),


                             GestureDetector(
                              onTap: () {
                                String rPrd = Month().currentMonthNumber == 1 ? '${Month().getMonth(12)}, ${DateTime.now().year-1}' : Month().getMonth(Month().currentMonthNumber-1);
                                var rDate = Month().currentMonthNumber == 1 ? DateTime(DateTime.now().year-1, 12, 1) : DateTime(DateTime.now().year, DateTime.now().month-1, DateTime.now().day);


                                
                                updateReportPeriod(rPrd, rDate, p: 'pm');
                                
                                Navigator.pop(context);

                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                            
                                  ),
                            
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          MdiIcons.calendar,
                                          size: 18,
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          'Previous Month',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      MdiIcons.chevronRightCircleOutline
                                    )
                                  ],
                                ),
                              ),
                            ),


                            const SizedBox(height: 15,),


                            GestureDetector(
                              onTap: () {
                                String rPrd = 'One Year ago';
                                var rDate = DateTime.now().subtract(const Duration(days: 365));

                                
                                updateReportPeriod(rPrd, rDate, p: 'ya');

                                Navigator.pop(context);

                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                            
                                  ),
                            
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          MdiIcons.calendar,
                                          size: 18,
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          'One Year ago',
                                          style: TextStyle(
                                            fontSize: 18,
                                            
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      MdiIcons.chevronRightCircleOutline
                                    )
                                  ],
                                ),
                              ),
                            ),


                            const SizedBox(height: 15,),


                            GestureDetector(
                              onTap: () async{

                                Navigator.pop(context);

                                final dateRange = await showDateRangePicker(
                                  context: context, 
                                  firstDate: DateTime(2023, 1, 1, 0, 0, 0),
                                  lastDate: DateTime.now(),
                                  initialDateRange: DateTimeRange(start: DateTime(2023, 1, 1), end: DateTime.now()),
                                  helpText: 'Decide Report Range',
                                  confirmText: 'Confirm',
                                  cancelText: 'Cancel',
                                  initialEntryMode: DatePickerEntryMode.input
                                
                                );

                                if (dateRange != null) {
                                  range = dateRange;
                                  String newReportDate = '${dateRange.start.year == DateTime.now().year? DateFormat.MMMd().format(dateRange.start): DateFormat.yMMMd().format(dateRange.start)} - ${dateRange.end.year == DateTime.now().year? DateFormat.MMMd().format(dateRange.end): DateFormat.yMMMd().format(dateRange.end)}';

                                  
                                  updateReportPeriod(newReportDate, dateRange, p: 'range');
                                }

                                // String rPrd = 'One Year ago';
                                // var rDate = DateTime.now().subtract(Duration(days: 365)).millisecondsSinceEpoch;

                                // updateReportPeriod(rPrd, rDate);

                                // Navigator.pop(context);

                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                            
                                  ),
                            
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          MdiIcons.calendar,
                                          size: 18,
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          'Select Date Range',
                                          style: TextStyle(
                                            fontSize: 18,
                                            
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      MdiIcons.chevronRightCircleOutline
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      Text(
                        reportPeriod
                      ),
                
                      const Icon(
                        MdiIcons.chevronDown
                      )
                    ],
                  ),
                ),
              ),
            )
        ],

      ),

      body: Column(
        children: [
          Divider(height: 3,),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: ListView(
                children: [

                  ListTile(
                    onTap: ()async {
                      if (expenses.isNotEmpty) {

                        List<List<dynamic>> exps = [];
                        exps.add(['Title', 'Amount', 'Income', 'Category', 'Date']);
                        for (var e in expenses) {
                          List exp = [e.title, e.amount, e.income!.name, e.category!.name, DateFormat.yMMMEd().format(e.date)];
                          exps.add(exp);
                        }

                        await generateExcel(context, exps, name: 'expenses');

                        ScaffoldMessenger.of(context).showSnackBar(
                          financeSnackBar('Successfully exported expenses to excel')
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          financeSnackBar('No data to export')
                        );
                      }
                    },
                    leading: Icon(
                      MdiIcons.wallet
                    ),

                    title: Text(
                      'Expenses to Excel'
                    ),
                  ),

                  ListTile(
                    onTap: ()async {
                      if (incomes.isNotEmpty) {

                        List<List<dynamic>> incs = [];
                        incs.add(['Title', 'Amount', 'Source', 'Vault', 'Date']);

                        for (var i in incomes) {
                          List inc = [i.name, i.amount, i.source, i.incomeVault, DateFormat.yMMMEd().format(i.date)];
                          incs.add(inc);
                        }

                        await generateExcel(context, incs, name: 'incomes');

                        ScaffoldMessenger.of(context).showSnackBar(
                          financeSnackBar('Successfully exported incomes to excel')
                        );

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          financeSnackBar('No data to export')
                        );
                      }
                    },
                    leading: ImageIcon(
                      AssetImage(incomeIcon)
                    ),

                    title: Text(
                      'Incomes to Excel'
                    ),
                  ),


                  ListTile(
                    onTap: ()async {
                      if (budgets.isNotEmpty) {

                        List<List<dynamic>> budgs = [];
                        budgs.add(['Title', 'Amount Budgeted', 'Amount Spent', 'Category', 'Period']);

                        for (var b in budgets) {
                          List inc = [
                            b.name, 
                            b.amount, 
                            b.amount-b.balance, 
                            b.category!.name,
                            b.startDate == b.endDate?
                              '${Month().getMonth(b.month)} ${b.year}' :
                                b.startDate!.year == b.endDate!.year?
                                  '${DateFormat.MMMd().format(b.startDate!)} - ${DateFormat.yMMMd().format(b.endDate!)}':
                                    '${DateFormat.yMMMd().format(b.startDate!)} - ${DateFormat.yMMMd().format(b.endDate!)}' 
                  
                          ];
                          budgs.add(inc);
                        }

                        await generateExcel(context, budgs, name: 'budgets');

                        ScaffoldMessenger.of(context).showSnackBar(
                          financeSnackBar('Successfully exported budgets to excel')
                        );

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          financeSnackBar('No data to export')
                        );
                      }
                    },
                    leading: ImageIcon(
                      AssetImage(budgetIcon)
                    ),

                    title: Text(
                      'Budgets to Excel'
                    ),
                  ),

                  // ListTile(
                  //   leading: Icon(
                  //     MdiIcons.menuOpen
                  //   ),

                  //   title: Text(
                  //     'Planners to Excel'
                  //   ),
                  // ),


                  // ListTile(
                  //   leading: Icon(
                  //     MdiIcons.bullseyeArrow
                  //   ),

                  //   title: Text(
                  //     'Active savings to Excel'
                  //   ),
                  // ),

                  // ListTile(
                  //   leading: Icon(
                  //     MdiIcons.selectGroup
                  //   ),

                  //   title: Text(
                  //     'Expenses, Incomes, Budgets'
                  //   ),
                  // ),
                ],
              )
            ),
          )


        ],
      ),
    );
  }
}

class ExcelExportButton extends StatelessWidget {
  const ExcelExportButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: appOrange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: appOrange.shade100)
      ),

      child: Text(
        'Income',

        style: TextStyle(
          fontSize: 20
        ),
      ),
    );
  }
}