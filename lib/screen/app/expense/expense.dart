// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:expense/dbs/expense.dart';
import 'package:expense/screen/app/expense/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import '../../../models/expense_model.dart';
import '../../../procedures/expenses/expense_procedure.dart';
import '../../../providers/expense_provider.dart';
import '../../../utils/capitalize.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/currency/currency.dart';
import '../../../utils/month.dart';
import '../../../widgets/cards/expense_tile.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {



  static String reportPeriod = "Current Month";
  var reportDate;
  String dateR = 'cm';

  DateTimeRange range = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());

  getExps(var date, String p)async{

    List<ExpenseModel> exps = [];

    if (p == 'cm' || p == 'pm') {
      exps = await expenseDb.retrieveBasedOn(
        Filter.and([
          Filter.equals('month', date.month),
          Filter.equals('year', date.year)
        ])
      );
    }

    if (p == 'ya') {
        exps = await expenseDb.retrieveBasedOn(
        Filter.custom((record){
          final data = record.value as Map<String, dynamic>;
          final recordExp = ExpenseModel.fromMap(data);

          return recordExp.date.isAfter(date);
        })
      );
    }


    if (p == 'range') {

      exps = await expenseDb.retrieveBasedOn(
          Filter.custom((record){
            final data = record.value as Map<String, dynamic>;
            final recordExp = ExpenseModel.fromMap(data);

            return recordExp.date.isAfter(date.start) && recordExp.date.isBefore(date.end);
          })
      );
    }

    expenseTotal = 0;

    for (var exp in exps) {
      expenseTotal += exp.amount;
    }

      expenseList = exps;
    }


  void updateReportPeriod(String newReportPeriod, newReportDate, {String p = 'cm'}) {

    setState(() {
      reportPeriod = newReportPeriod;
      reportDate = newReportDate;
      dateR = p;

      getExps(newReportDate, p);
    });
  }



  final ExpenseDb expenseDb = ExpenseDb();
  double expenseTotal = 0;

  //Map percentages = {};


  Database? _db;

  var deletedRecord;
  
  List<ExpenseModel> expenseList = [];

   void dbOpen()async{
    _db = await expenseDb.openDb();
    setState(() {
      
    });
  }


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    dbOpen();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        actions: [
        ], 

        backgroundColor: Colors.black,
        toolbarHeight: 50,

        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light
        ),
      ),

      body: Column(
        children: [
           SizedBox(
            height: 110,
             child: Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.only(left: 30, bottom: 10),
                   child: Row(
                     children: [
                       const Text(
                          'TOTAL EXPENSES FOR ',
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),
                        ),
                 
                        Text(
                          expenseList.isNotEmpty? reportPeriod : Month().currentMonth.toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.4,
                            fontWeight: FontWeight.w700,
                            color: appOrange
                          ),
                        ),
                     ],
                   ),
                 ),
           
                Text(
                  expenseList.isNotEmpty? Currency(context).wrapCurrencySymbol(expenseTotal.toString()) :Currency(context).wrapCurrencySymbol('${Provider.of<ExpenseProvider>(context).totalExpenseAmnt}'),
                  style: const TextStyle(
                    fontSize: 45,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Colors.white
                  ),
                ),
           
                const SizedBox(height: 10,)
           
               ],
             ),
           ),

            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                child: _db != null ?  Container(
                  color: Colors.white,

                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            
                            const Text(
                              'Expense List',
                              style: TextStyle(
                                fontSize: 20,
                                height: 1.4,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: Colors.black
                              ),
                            ),

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
                                                        MdiIcons.chevronRightCircleOutline,
                                                        
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
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(color:Colors.white),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        reportPeriod,

                                        style: TextStyle(
                                        ),
                                      ),
                                
                                      const Icon(
                                        MdiIcons.chevronDown,
                                      )
                                    ],
                                  ),
                                ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 10,),

                      Expanded(
                        child:expenseList.isNotEmpty?

                        ListView.builder(
                              itemCount: expenseList.length,
                              itemBuilder: (context, index){
                                
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: ExpenseTile(
                                    slidableKey: index,

                                    onDelete:  ()async{
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            //backgroundColor: appOrange,
                                            title: Text('Delete ${capitalize(expenseList[index].title)}'),
                                            content:  SingleChildScrollView(
                                              child: ListBody(
                                                children: const <Widget>[
                                                  Text('Deleting this will remove it from the expenses list'),

                                                  
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text(
                                                  'Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Confirm'),
                                                onPressed: () async {

                                                  await deleteExpenseProcedure(expenseList[index]);
                                                  
                                                  Provider.of<ExpenseProvider>(context, listen: false).subtract(expenseList[index].amount);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );}
                                        );
                                    },
                                    
                                    expenseModel: expenseList[index],
                                    percent:  double.parse(((expenseList[index].amount/expenseTotal)*100).toString()).toStringAsFixed(1),//percentages[expenseList[index].id].toString(),
                                    index: '${index+1}',
                                  ),
                                );
                              })
                              :

                         StreamBuilder<List<ExpenseModel>>(
                          stream: expenseDb.onExpenses(_db!),
                          // ignore: prefer_const_literals_to_create_immutables
                          initialData: [
                            
                          ],
                          builder: (context, snapshot){

                            if (snapshot.hasData) {
                              final expenses = snapshot.data!;

                              expenses.sort((a,b){
                                return b.date.compareTo(a.date);
                              });

                              if (expenses.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No Expense added yet'
                                  )
                                );
                              }

                              return ListView.builder(
                              itemCount: expenses.length,
                              itemBuilder: (context, index){
                                
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: ExpenseTile(
                                    slidableKey: index,

                                    onDelete:  ()async{
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            //backgroundColor: appOrange,
                                            title: Text('Delete ${capitalize(expenses[index].title)}'),
                                            content:  SingleChildScrollView(
                                              child: ListBody(
                                                children: const <Widget>[
                                                  Text('Deleting this will remove it from the expenses list'),

                                                  
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text(
                                                  'Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Confirm'),
                                                onPressed: () async {

                                                  await deleteExpenseProcedure(expenses[index]);
                                                  
                                                  Provider.of<ExpenseProvider>(context, listen: false).subtract(expenses[index].amount);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );}
                                        );
                                    },
                                    
                                    expenseModel: expenses[index],
                                    percent: double.parse(((expenses[index].amount/Provider.of<ExpenseProvider>(context).totalExpenseAmnt)*100).toString()).toStringAsFixed(1),//percentages[expenseList[index].id].toString(),
                                    index: '${index+1}',
                                  ),
                                );
                              });
                            }else if(snapshot.connectionState == ConnectionState.waiting || snapshot.hasError ){
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return const Center(child: CircularProgressIndicator(),);

                          }
                        )
                      ),
                    ],
                  ),
                )
                :
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              )
            )

        ],
      ),
      
      

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            PageTransition(
              child: const AddExpenseScreen(
                
              ),

              type: PageTransitionType.bottomToTop
            )
          );
        },

        backgroundColor: appOrange,
        elevation: 3,

        shape: const CircleBorder(

        ),

         child: const Icon(
          MdiIcons.plus,
          color: Colors.white,
        ),
      ),
    );
  }
}
