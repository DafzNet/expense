
// ignore_for_file: use_build_context_synchronously

import 'package:expense/dbs/income_db.dart';
import 'package:expense/models/income_model.dart';
import 'package:expense/screen/app/more/screen/income/add_income.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';
import '../../../../../dbs/vault_db.dart';
import '../../../../../models/vault.dart';
import '../../../../../procedures/income/income_procedure.dart';
import '../../../../../utils/capitalize.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/month.dart';
import '../../../../../widgets/cards/income_card.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});
  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {

  static String reportPeriod = "Current Month";
  var reportDate;
  String dateR = 'cm';

  DateTimeRange range = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());



  getIncome(var date, String p)async{ //filter the db based on period

    List<IncomeModel> incomes = []; //get all incomes for the period
      
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

    _incomes = incomes;

    _incomes?.sort((a,b){
      return b.date.compareTo(a.date);
    });

    }

  void updateReportPeriod(String newReportPeriod, newReportDate, {String p = 'cm'}) {

    setState(() {
      reportPeriod = newReportPeriod;
      reportDate = newReportDate;
      dateR = p;

      getIncome(newReportDate, p);
      
    });
  }

  List<IncomeModel>? _incomes; 

  final IncomeDb incomeDb = IncomeDb();
  Database? db;

  void getIncomDB()async{
    db = await incomeDb.openDb();
    setState(() {
      
    });
  }


  Future<void> broughtDown() async {
  final vaultDb = VaultDb();
  final incomeDb = IncomeDb();
  final vaults = await vaultDb.retrieveData();

  DateTime previousMonthDate = DateTime.now().subtract(Duration(days: DateTime.now().day));
  String previousMonth = Month().getMonth(previousMonthDate.month);

  double broughtDownBalance = 0;
  List<String> notes = [];
  int incomeCounter = 1;

  List<IncomeModel> incomes = await incomeDb.retrieveBasedOn(
    Filter.and([
      Filter.equals('month', previousMonthDate.month),
      Filter.equals('year', previousMonthDate.year),
      Filter.greaterThan('balance', 0.0),
      Filter.equals('carriedOverIncome', false),
    ]),
  );

  for (var income in incomes) {
    broughtDownBalance += income.balance;
    notes.add('$incomeCounter. ${income.name}\n  source: ${income.source}\n  amount: ${income.balance}');
    incomeCounter++;

    final incomeUpdated = income.copyWith(
      carriedOverIncome: true,
    );

    final vaultToUpdate = vaults.firstWhere((vault) => vault == income.incomeVault);
    await vaultDb.updateData(
      vaultToUpdate.copyWith(
        amountInVault: vaultToUpdate.amountInVault - income.balance,
      ),
    );

    await incomeDb.updateData(incomeUpdated);
  }

  if (broughtDownBalance > 0.0) {
    final incomeBroughtDown = IncomeModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: 'Brought Down',
      source: previousMonth,
      amount: broughtDownBalance,
      balance: broughtDownBalance,
      date: DateTime.now(),
      broughtDownIncome: true,
      incomeVault: incomes.first.incomeVault,
      day: DateTime.now().day,
      month: DateTime.now().month,
      year: DateTime.now().year,
      note: 'This income is generated from last month\'s balances. The following are the incomes from which this was taken:\n${notes.join('\n')}',
    );

    await addIncomeProcedure(incomeBroughtDown);
  }
}


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    getIncomDB();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: const Text('Income'),

            actions: [

              // TextButton(
              //   onPressed:()async{
              //     await broughtDown();
              //   } , 
              //   child: Text('bd inc')
              // ),

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
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(),
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
        ],

/////////////////////////////
////////////////////////////
        body:
          _incomes != null?
          ListView.builder(
                itemCount: _incomes?.length,

                itemBuilder: (context, index){
                  return IncomeCard(
                    onDelete: (){
                      showDialog(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            //backgroundColor: appOrange,
                            title: Text('Delete ${capitalize(_incomes![index].name!)}'),
                            content:  SingleChildScrollView(
                              child: ListBody(
                                children: const <Widget>[
                                  Text('Deleting this income will delete all associated expenses'),
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
                                  
                                  await deleteIncomeProcedure(_incomes![index], context);//expenseDb.deleteData(widget.expenseModel);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );}
                        );
                    },


                    income: _incomes![index]
                  );
                }
              ):
        
         db != null ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: StreamBuilder<List<IncomeModel>>(
            initialData: [],
            stream: incomeDb.onIncome(db!),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Column();
              }
              
              final incomesForMonth = snapshot.data;

              incomesForMonth?.sort((a,b){
                return b.date.compareTo(a.date);
              });

              return incomesForMonth!.isNotEmpty ?  ListView.builder(
                itemCount: incomesForMonth.length,

                itemBuilder: (context, index){
                  return IncomeCard(
                    onDelete: (){
                      showDialog(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            //backgroundColor: appOrange,
                            title: Text('Delete ${capitalize(incomesForMonth[index].name!)}'),
                            content:  SingleChildScrollView(
                              child: ListBody(
                                children: const <Widget>[
                                  Text('Deleting this income will delete all associated expenses'),
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
                                  
                                  await deleteIncomeProcedure(incomesForMonth[index], context);//expenseDb.deleteData(widget.expenseModel);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );}
                        );
                    },


                    income: incomesForMonth[index]
                  );
                }
              )
              :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text('No Income added yet'),
                  )
                ],
              );
            }
          )
        ) 
        
        :

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        )
        
        ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            PageTransition(
              child: const AddIncomeScreen(),
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
