
import 'package:expense/providers/report_period.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:expense/utils/month.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

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

  DateTimeRange range = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());


  static GlobalKey<ExpReportScreenState> expReportKey = GlobalKey();
  static GlobalKey<IncomeReportScreenState> incReportKey = GlobalKey();
  static GlobalKey<BudgetReportScreenState> budgetReportKey = GlobalKey();

  void updateReportPeriod(String newReportPeriod, newReportDate) {
    setState(() {
      reportPeriod = newReportPeriod;
      reportDate = newReportDate;
      
    });

    // Update the report period in the ExpReportScreen
    // expReportKey.currentState?.updateReportPeriod(newReportPeriod, newReportDate);
    incReportKey.currentState?.updateReportPeriod(newReportPeriod, newReportDate);
    budgetReportKey.currentState?.updateReportPeriod(newReportPeriod, newReportDate);
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

                                Provider.of<ReportProvider>(context, listen: false).changePeriod(rPrd, rDate);
                                updateReportPeriod(rPrd, rDate);

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
                                String rPrd = Month().currentMonthNumber == 1 ? Month().getMonth(12) +', '+ (DateTime.now().year-1).toString() : Month().getMonth(Month().currentMonthNumber-1);
                                var rDate = Month().currentMonthNumber == 1 ? DateTime(DateTime.now().year-1, 12, 1) : DateTime(DateTime.now().year, DateTime.now().month-1, DateTime.now().day);


                                Provider.of<ReportProvider>(context, listen: false).changePeriod(rPrd, rDate);
                                updateReportPeriod(rPrd, rDate);

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

                                Provider.of<ReportProvider>(context, listen: false).changePeriod(rPrd, rDate);
                                updateReportPeriod(rPrd, rDate);

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
                                  lastDate: range.end,
                                  initialDateRange: range,
                                  helpText: 'Decide Report Range',
                                  confirmText: 'Confirm',
                                  cancelText: 'Cancel',
                                  initialEntryMode: DatePickerEntryMode.inputOnly
                                
                                );

                                if (dateRange != null) {
                                  range = dateRange;
                                  String newReportDate = '${dateRange.start.year == DateTime.now().year? DateFormat.MMMd().format(dateRange.start): DateFormat.yMMMd().format(dateRange.start)} - ${dateRange.end.year == DateTime.now().year? DateFormat.MMMd().format(dateRange.end): DateFormat.yMMMd().format(dateRange.end)}';

                                  Provider.of<ReportProvider>(context, listen: false).changePeriod(newReportDate,dateRange);
                                  updateReportPeriod(newReportDate, dateRange);
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

        body: const TabBarView(
          children: [
            ExpReportScreen(),
            IncomeReportScreen(),
            BudgetReportScreen()
          ],
        ),
      ),
    );





  }
}