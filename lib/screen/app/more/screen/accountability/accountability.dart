

// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:expense/dbs/budget_db.dart';
import 'package:expense/dbs/expense.dart';
import 'package:expense/dbs/income_db.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/models/income_model.dart';
import 'package:expense/models/user_model.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:expense/utils/constants/images.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:expense/utils/month.dart';
import 'package:expense/widgets/pdf/lifi_pdf.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sembast/sembast.dart';

import '../../../../../models/budget.dart';

class Accountability extends StatefulWidget {
  final LightUser user;
  const Accountability({
    required this.user,
    super.key});

  @override
  State<Accountability> createState() => _AccountabilityState();
}

class _AccountabilityState extends State<Accountability> {


  /////Create Pdfs
  LifiPDF lifiPDF = LifiPDF();






  bool reload = false;

  static String reportPeriod = "Current Month";
  var reportDate;
  String dateR = 'cm';

  DateTimeRange range = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());


  void updateReportPeriod(String newReportPeriod, newReportDate, {String p = 'cm'}) {
    setState(() {
      reportPeriod = newReportPeriod;
      reportDate = newReportDate;
      dateR = p;
      reload = true;
    });
  }


  ExpenseDb expenseDb = ExpenseDb();
  IncomeDb incomeDb = IncomeDb();
  BudgetDb budgetDb = BudgetDb();


  List<ExpenseModel> expenses = [];
  List<IncomeModel> incomes = [];
  List<BudgetModel> budgets = [];


  double incomeTotal = 0;

  Map<String, double> expByCat = {};
  double expTotal = 0;

  void getData(var date, String p)async{

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
  void initState() {
    reportDate = DateTime.now();
    dateR = 'cm';


    getData(DateTime.now(), 'cm');
    getIncomeData(DateTime.now(), 'cm');
    getBudgetData(DateTime.now(), 'cm');
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    if (reload) {
      expenses = [];
      incomes = [];
      budgets = [];

      incomeTotal = 0;

      expByCat = {};
      expTotal = 0;

      getData(reportDate, dateR);
      getIncomeData(reportDate, dateR);
      getBudgetData(reportDate, dateR);

      reload = false;

    }

    File myLogo = File('assets/icons/still/lifi_logo.png');



    return Scaffold(
      appBar: AppBar(

        title: const Text('Statements'),

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

      body: Stack(
        
        children: [

          Center(
            child: Opacity(
              opacity: .1,
              child: Image.asset(
                'assets/icons/still/lifi_logo.png',
            
                width: MediaQuery.of(context).size.width-100,
                height: MediaQuery.of(context).size.width-100,
            
                colorBlendMode: BlendMode.colorDodge,
            
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(
            children: [

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: appOrange
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'LiFi',
                  
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.user.firstName!} ${widget.user.lastName!}',
                    
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black
                          ),
                        ),

                        Image.asset(
                          lifiIcon,
                          height: 30,
                          width: 30,
                        )
                      ],
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width-30,
                          child: Text(
                            'Income and expense statement for the period of ${dateR == 'cm'? Month().currentMonth +' '+ DateTime.now().year.toString():
                                dateR == 'pa'? '${Month().getMonth(reportDate.month)} ${reportDate.year.toString()}':
                                  dateR == 'ya'?'${Month().getMonth(reportDate.month)} ${reportDate.year} till date':reportPeriod}',
                                            
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),



////////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [

                      

                      Container(
                        color: appOrange.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Text('Incomes',
                                style: TextStyle(
                                  fontSize: 16,
                                  
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            const DataColumn(label: Text('S/N')),
                            const DataColumn(label: Text('Title')),
                            DataColumn(label: Text(
                              'Amount' ' (${Currency(context).currencySymbol})'
                            )),
                            const DataColumn(label: Text('Source')),
                            const DataColumn(label: Text('Vault')),
                            const DataColumn(label: Text('Date')),
                          ], 
                          
                          rows: List.generate(incomes.length, (index){
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text((index+1).toString())
                                ),
                      
                                DataCell(
                                  Text(incomes[index].name!),
                                ),
                      
                                DataCell(
                                  Text(incomes[index].amount.toString())
                                ),
                      
                                DataCell(
                                  Text(incomes[index].source!)
                                ),
                      
                                DataCell(
                                  Text(incomes[index].incomeVault!.name)
                                ),
                      
                                DataCell(
                                  Text(
                                    DateFormat.yMMMd().format(incomes[index].date)
                                  )
                                )
                              ]
                            );
                          })
                          
                        ),
                      ),


                      ///////////////////////////////////////////////////////////
                      ///////////////////////////////////////////////////////////
                      Container(
                        color: appOrange.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Text('Budgets',
                                style: TextStyle(
                                  fontSize: 16,
                                  
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            const DataColumn(label: Text('S/N')),
                            const DataColumn(label: Text('Title')),
                            DataColumn(label: Text(
                              'Budget Amount' ' (${Currency(context).currencySymbol})'
                            )),
                            DataColumn(label: Text(
                              'Amount Spent' ' (${Currency(context).currencySymbol})')),

                            DataColumn(label: Text(
                              'Variance' ' (${Currency(context).currencySymbol})'
                            )),
                            const DataColumn(label: Text('Category')),
                            const DataColumn(label: Text('Period')),
                            const DataColumn(label: Text('Remark')),
                          ], 
                          
                          rows: List.generate(budgets.length, (index){
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text((index+1).toString())
                                ),
                      
                                DataCell(
                                  Text(budgets[index].name),
                                ),
                      
                                DataCell(
                                  Text(budgets[index].amount.toString())
                                ),
                      
                                DataCell(
                                  Text((budgets[index].amount-budgets[index].balance).toString())
                                ),

                                DataCell(
                                  Text(((budgets[index].amount - (budgets[index].amount-budgets[index].balance))).toString(),
                                    style: TextStyle(
                                      color: (budgets[index].amount - (budgets[index].amount-budgets[index].balance)) == 0 ?
                                        Colors.black :
                                            (budgets[index].amount - (budgets[index].amount-budgets[index].balance)) > 0? appSuccess : appDanger
                                    ),
                                  )
                                ),
                      
                                DataCell(
                                  Text(budgets[index].category!.name)
                                ),
                      
                                DataCell(
                                  Text(
                                    budgets[index].startDate == budgets[index].endDate?
                                      '${Month().getMonth(budgets[index].month)} ${budgets[index].year}' :
                                        budgets[index].startDate!.year == budgets[index].endDate!.year?
                                          '${DateFormat.MMMd().format(budgets[index].startDate!)} - ${DateFormat.yMMMd().format(budgets[index].endDate!)}':
                                            '${DateFormat.yMMMd().format(budgets[index].startDate!)} - ${DateFormat.yMMMd().format(budgets[index].endDate!)}', 
                                  )
                                ),

                                DataCell(
                                  Text(
                                    (budgets[index].amount - (budgets[index].amount-budgets[index].balance)) == 0 ?
                                        'Exact' :
                                            (budgets[index].amount - (budgets[index].amount-budgets[index].balance)) > 0? 'Saved' : 'Overspent',
                                    style: TextStyle(
                                      color: (budgets[index].amount - (budgets[index].amount-budgets[index].balance)) == 0 ?
                                        Colors.black :
                                            (budgets[index].amount - (budgets[index].amount-budgets[index].balance)) > 0? appSuccess : appDanger
                                    ),
                                  )
                                ),
                              ]
                            );
                          })
                          
                        ),
                      ),


                      Container(
                        color: appOrange.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Text('Expenses',
                                style: TextStyle(
                                  fontSize: 16,
                                  
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            const DataColumn(label: Text('S/N')),
                            const DataColumn(label: Text('Title')),
                            DataColumn(label: Text(
                              'Amount ${Currency(context).currencySymbol}'
                            )),
                            const DataColumn(label: Text('Income')),
                            const DataColumn(label: Text('Category')),
                            const DataColumn(label: Text('Date')),
                          ], 
                          
                          rows: List.generate(expenses.length, (index){
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text((index+1).toString())
                                ),
                      
                                DataCell(
                                  Text(expenses[index].title),
                                ),
                      
                                DataCell(
                                  Text(expenses[index].amount.toString())
                                ),
                      
                                DataCell(
                                  Text(expenses[index].income!.name!)
                                ),
                      
                                DataCell(
                                  Text(expenses[index].category!.name)
                                ),
                      
                                DataCell(
                                  Text(
                                    DateFormat.yMMMd().format(expenses[index].date)
                                  )
                                )
                              ]
                            );
                          })
                          
                        ),
                      ),

                      Divider(
                        thickness: 30,
                        color: appOrange.shade100,
                        height: 50,
                      ),


                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Number of Income(s): '
                                ),

                                Text(
                                  incomes.length.toString(),

                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Income (Revenue): '
                                ),

                                Text(
                                  Currency(context).wrapCurrencySymbol(incomeTotal.toString()),

                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const[
                                Text(
                                  'Expenses Categories '
                                ),
                              ],
                            ),

                            SizedBox(height: 5,),


                            Row(
                              children:[
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(expByCat.length, (index){
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            expByCat.keys.elementAt(index)
                                          ),
                                
                                          Text(
                                            Currency(context).wrapCurrencySymbol(expByCat.values.elementAt(index).toString())
                                          )
                                        ],
                                      );
                                    })
                                  ),
                                ),
                              ],
                            ),

                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                SizedBox(width: 100,),

                                SizedBox(
                                  width: 100,
                                  child: Divider(
                                    color: Colors.black,
                                  ))
                              ],
                            ),



                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Expenses: '
                                ),

                                Text(
                                  Currency(context).wrapCurrencySymbol(expTotal.toString()),

                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),

                            Divider(height: 20,),


                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Balance: '
                                ),

                                Text(
                                  Currency(context).wrapCurrencySymbol((incomeTotal - expTotal).toString()),

                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),
                            
                          ],
                        ),
                      ),
                      
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 60,
                child: Container(
                  color: appOrange.shade50,

                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                                      
                        children: [
                          GestureDetector(
                            onTap: () async{
                              await showMenu(
                                context: context, 
                                position: RelativeRect.fromLTRB(
                                  100, (MediaQuery.of(context).size.height/5)*4, 10, 10), 
                                items: [
                                 PopupMenuItem(
                                    child: Text('To PDF'),

                                    onTap: ()async{
                                      File myPdf = await lifiPDF.savePdf(
                                        'lifi.pdf', 
                                        Currency(context).currencySymbol, 
                                        dateR == 'cm'? Month().currentMonth +' '+ DateTime.now().year.toString():
                                          dateR == 'pa'?'${Month().getMonth(reportDate.month)} ${reportDate.year.toString()}':
                                            dateR == 'ya'?'${Month().getMonth(reportDate.month)} ${reportDate.year} till date':reportPeriod,
                                        incomes: incomes,
                                        expByCat: expByCat,
                                        ctx: context,
                                        incomeTotal: incomeTotal,
                                        expTotal: expTotal,
                                        expenses: expenses,
                                        budgets: budgets,
                                        logo:myLogo,
                                        username: '${widget.user.firstName} ${widget.user.lastName}');
                                      await lifiPDF.openPDF(myPdf);
                                    },
                                  ),

                                 PopupMenuItem(
                                    child: Text('To PDF'),
                                  ),


                                  
                                ]
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(
                                  MdiIcons.databaseExportOutline
                                ),
                                              
                                Text('Export')
                              ],
                            ),
                          ),
                    
                          
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}