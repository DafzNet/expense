
import 'package:expense/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../../../utils/constants/colors.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../dbs/budget_db.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  final ExpenseDb expenseDb = ExpenseDb();

  List<ExpenseModel> expenses = []; 

  void getExps()async{
    List exps = await expenseDb.retrieveData();
    expenses = exps.map((e){
      return ExpenseModel.fromMap(e);
    }).toList();

    setState(() {
      
    });
  }


  @override
  void initState() {
    getExps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        toolbarHeight: 50,

        title: Text(
          'Reports'
        ),

        // leading: IconButton(
        //   onPressed: (){
        //     Navigator.pop(context);
        //   }, 
        //   icon: const Icon(Icons.arrow_back, color: Colors.white)
        // ),

        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark
        ),
      ),

      body: Column(
        children: [

          Expanded(
            child: PieChart(
              
              PieChartData(
                sections: List.generate(
                  expenses.length, 
                  (index) =>  PieChartSectionData(
                      value: expenses[index].amount,
                    ),
                  ),

                centerSpaceRadius: 100,
                centerSpaceColor: appOrange
                // read about it in the PieChartData section
              ),
              swapAnimationDuration: Duration(milliseconds: 150), // Optional
              swapAnimationCurve: Curves.linear, // Optional
            ),
          )
        ],
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          
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
