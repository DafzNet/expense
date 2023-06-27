
// ignore_for_file: use_build_context_synchronously

import 'package:expense/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../../procedures/expenses/expense_procedure.dart';
import '../../../../../../providers/expense_provider.dart';
import '../../../../../../utils/capitalize.dart';
import '../../../../../../widgets/cards/expense_tile.dart';

class BudgetExpensesScreen extends StatefulWidget {

  final List<ExpenseModel> expenses;
  final double total;

  const BudgetExpensesScreen({
    required this.expenses,
    required this.total,
    super.key});

  @override
  State<BudgetExpensesScreen> createState() => _BudgetExpensesScreenState();
}

class _BudgetExpensesScreenState extends State<BudgetExpensesScreen> {





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
            
            title: const Text('Budget Spendings'),
        
          ),
        ],

/////////////////////////////
////////////////////////////
        body: widget.expenses.isNotEmpty ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.builder(
            itemCount: widget.expenses.length,
            itemBuilder: (context, index) {
              return ExpenseTile(
                expenseModel: widget.expenses[index],
                index: '${index+1}',
                slidableKey: index,
                onDelete: ()async{
                  
                showDialog(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        //backgroundColor: appOrange,
                        title: Text('Delete ${capitalize(widget.expenses[index].title)}'),
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
                              Provider.of<ExpenseProvider>(context, listen: false).subtract(widget.expenses[index].amount);
                              await deleteExpenseProcedure(widget.expenses[index]);
                              
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                  );
                },
                percent: double.parse(((widget.expenses[index].amount/widget.total)*100).toString()).toStringAsFixed(1),
              );
            },
            
          ),
        )
        :
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            Center(child: Text('No Expense for this budget'))
          ],
        )
        
      ),

    );
  }
}
