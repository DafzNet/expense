
import 'package:expense/models/income_model.dart';
import 'package:expense/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sembast/sembast.dart';
import '../../../../../dbs/expense.dart';
import '../../../../../dbs/income_db.dart';
import '../../../../../models/expense_model.dart';
import '../../../../../utils/constants/colors.dart';

class IncomeExpensesScreen extends StatefulWidget {

  final IncomeModel income;

  const IncomeExpensesScreen({
    required this.income,
    super.key});

  @override
  State<IncomeExpensesScreen> createState() => _IncomeExpensesScreenState();
}

class _IncomeExpensesScreenState extends State<IncomeExpensesScreen> {

  ExpenseDb incomeDb = ExpenseDb();

  List<ExpenseModel> expenses = [];

  void getExpensesByIncome() async{
    Filter filter = Filter.custom((record){
      IncomeModel _income = IncomeModel.fromMap(record[Field])
    });
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: Text(widget.income.name!+' Spendings'),
        
          ),
        ],

/////////////////////////////
////////////////////////////
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.builder(
            
          ),
        )
        
        ),

    );
  }
}
