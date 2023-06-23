
// ignore_for_file: use_build_context_synchronously

import 'package:expense/models/income_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import '../../../../../dbs/expense.dart';
import '../../../../../models/expense_model.dart';
import '../../../../../procedures/expenses/expense_procedure.dart';
import '../../../../../providers/expense_provider.dart';
import '../../../../../utils/capitalize.dart';
import '../../../../../widgets/cards/expense_tile.dart';

class IncomeExpensesScreen extends StatefulWidget {

  final IncomeModel income;

  const IncomeExpensesScreen({
    required this.income,
    super.key});

  @override
  State<IncomeExpensesScreen> createState() => _IncomeExpensesScreenState();
}

class _IncomeExpensesScreenState extends State<IncomeExpensesScreen> {

  ExpenseDb expenseDb = ExpenseDb();

  List<ExpenseModel> expenses = [];

  void getExpensesByIncome() async{
    Filter filter = Filter.custom((record){
      final data = record.value as Map<String, dynamic>;
      IncomeModel myIncome = IncomeModel.fromMap(data['income']);

      return widget.income == myIncome;
    });

    expenses = await expenseDb.retrieveBasedOn(filter);

    expenses.sort((a,b){
      return b.date.compareTo(a.date);
    });

    setState(() {
      
    });
  }



  @override
  void initState() {
    getExpensesByIncome();
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
            
            title: Text('${widget.income.name!} Spendings'),
        
          ),
        ],

/////////////////////////////
////////////////////////////
        body: expenses.isNotEmpty ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              return ExpenseTile(
                expenseModel: expenses[index],
                index: '${index+1}',
                slidableKey: index,
                onDelete: ()async{
                  
                showDialog(
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
                              Provider.of<ExpenseProvider>(context, listen: false).subtract(expenses[index].amount);
                              await deleteExpenseProcedure(expenses[index]);
                              
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                  );
                },
                percent: double.parse(((expenses[index].amount/widget.income.amount)*100).toString()).toStringAsFixed(1),
              );
            },
            
          ),
        )
        :
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            Center(child: Text('No Expenses made with this income'))
          ],
        )
        
      ),

    );
  }
}
