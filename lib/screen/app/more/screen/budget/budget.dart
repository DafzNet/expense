
import 'package:expense/dbs/budget_db.dart';
import 'package:expense/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/month.dart';
import '../../../../../widgets/cards/budget_card.dart';
import 'add_budget.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {

  final BudgetDb budgetDb = BudgetDb();
  Database? db;

  void getBudgetDB()async{
    db = await budgetDb.openDb();
    setState(() {
      
    });
  }


    static String reportPeriod = "Current Month";
  var reportDate;
  String dateR = 'cm';

  DateTimeRange range = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());


    void getBudget(var date, String p)async{
    //filter by category
    
    //filter to get budgets by month or time periiod 
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


    _budgets = await budgetDb.retrieveBasedOn(filter!); //all budget

  _budgets!.sort((a,b){
      return b.startDate!.compareTo(a.startDate!);
    });

  }

  void updateReportPeriod(String newReportPeriod, newReportDate, {String p = 'cm'}) {

    setState(() {
      reportPeriod = newReportPeriod;
      reportDate = newReportDate;
      dateR = p;

      getBudget(newReportDate, p);
      
    });
  }



  List<BudgetModel>? _budgets; 






  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getBudgetDB();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: const Text('Budgets'),
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
          )
        ],

/////////////////////////////
////////////////////////////
        body: 
        _budgets != null?
        ListView.builder(
          itemCount: _budgets!.length,

          itemBuilder: (context, index){
            return BudgetCard(budget: _budgets![index], ctx: context,);
          }
        )
        :
        db != null ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: StreamBuilder<List<BudgetModel>>(
            initialData:[],
            stream: budgetDb.onBudgets(db!),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Column();
              }
              
              final budgetForMonth = snapshot.data;
              budgetForMonth?.sort((a,b){
                return b.startDate!.compareTo(a.startDate!);
              });

              return budgetForMonth!.isNotEmpty ?  ListView.builder(
                itemCount: budgetForMonth.length,

                itemBuilder: (context, index){
                  return BudgetCard(budget: budgetForMonth[index], ctx: context,);
                }
              )
              :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text('No Budgets added yet'),
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
              child: const AddBudgetScreen(),
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
