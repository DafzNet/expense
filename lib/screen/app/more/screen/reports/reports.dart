
import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/material.dart';

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
          bottom: TabBar(
            padding: const EdgeInsets.symmetric(horizontal: 5),
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

        body: TabBarView(
          children: [
            const ExpReportScreen(),
            const IncomeReportScreen(),
            Container()
          ],
        ),
      ),
    );
  }
}