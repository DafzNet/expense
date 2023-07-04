
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:expense/utils/constants/colors.dart';
import 'package:expense/utils/month.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'budget/budget_rep.dart';
import 'expense/exp_rep.dart';
import 'income/income_rep.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  static String reportPeriod = "Current Month";
  var reportDate;
  String dateR = 'cm';

  DateTimeRange range = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());


  static GlobalKey<ExpReportScreenState> reportKey = GlobalKey();
  static GlobalKey<IncomeReportScreenState> incReportKey = GlobalKey();
  static GlobalKey<BudgetReportScreenState> budgetReportKey = GlobalKey();

  void updateReportPeriod(String newReportPeriod, newReportDate, {String p = 'cm'}) {
    setState(() {
      reportPeriod = newReportPeriod;
      reportDate = newReportDate;
      dateR = p;
    });

    // Update the report period in the ExpReportScreen
    reportKey.currentState?.setState(() {
      
    });
    incReportKey.currentState?.setState(() {});
    budgetReportKey.currentState?.setState(() {});
  }



  @override
  void initState() {
    reportPeriod = "Current Month";
    reportDate = DateTime.now();
    dateR = 'cm';
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
          

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


          bottom: TabBar(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
            indicator: BoxDecoration(
              color: appOrange.shade900,
              borderRadius: BorderRadius.circular(25)
            ),
            tabs: const [
               Tab(text: 'Expense',),
               Tab(text: 'Income',),
               Tab(text: 'Budget',)
            ]),
        ),

        body:  TabBarView(
          children: [
            ExpReportScreen(reportKey, period: reportDate, dateR: dateR,),
            IncomeReportScreen(incReportKey, period: reportDate, dateR: dateR,),
            BudgetReportScreen(budgetReportKey, period: reportDate, dateR: dateR,)
          ],
        ),
      ),
    );





  }
}