
import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
          

          actions: [
            GestureDetector(
              onTap: () {
                
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
                    children: const[
                      Text(
                        'Current Month'
                      ),
                
                      Icon(
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