import 'package:expense/dbs/budget_db.dart';
import 'package:expense/dbs/expense.dart';
import 'package:expense/models/budget.dart';
import 'package:expense/models/category_model.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sembast/sembast.dart';

import '../../dbs/category_db.dart';
import '../../procedures/expenses/expense_procedure.dart';
import '../../utils/capitalize.dart';
import '../../utils/constants/colors.dart';


class CategoryCard extends StatefulWidget {

  final CategoryModel category;
  final String index;
  final VoidCallback? onDelete;
  final BuildContext? ctx;

  const CategoryCard({
    required this.category,
    required this.index,
    this.onDelete,
    this.ctx,
    super.key});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {

  final expenseDb = ExpenseDb();
  final budgetDb = BudgetDb();
  final categoryDb = CategoryDb(); 


  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 0.2,
              color: Colors.black26
            )
          ),
    
          child: ListTile(
            minLeadingWidth: 25,
            
            leading: Text(
              widget.index,
            
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: appOrange
              ),
            ),
    
            title: Text(
              widget.category.name,
            
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                //color: appOrange
              ),
            ),
    
            subtitle: Text(
              widget.category.description,
            
              style: const TextStyle(
                fontSize: 14,
                //color: appOrange
              ),
            ),
    
            trailing: deleting? const SizedBox(
              width: 20,
              height: 20,

              child: CircularProgressIndicator(),
            ) : SizedBox(
              width: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async{
                      Filter filterExp = Filter.custom((record){
                        var exp = record.value as Map<String, dynamic>;
                        ExpenseModel expense = ExpenseModel.fromMap(exp);

                        return expense.category == widget.category && expense.month == DateTime.now().month && expense.year == DateTime.now().year;

                      });

                      Filter filterBudget = Filter.custom((record){
                        var exp = record.value as Map<String, dynamic>;
                        BudgetModel budget = BudgetModel.fromMap(exp);

                        return budget.category == widget.category && budget.month == DateTime.now().month && budget.year == DateTime.now().year;

                      });


                      List<ExpenseModel> expenses = await expenseDb.retrieveBasedOn(filterExp);
                      List<BudgetModel> budgets = await budgetDb.retrieveBasedOn(filterBudget);

                      if (expenses.isEmpty && budgets.isEmpty) {
                        CategoryModel hiddenCat = widget.category.copyWith(
                          hidden: true
                        );

                        await categoryDb.updateData(hiddenCat);

                      } else {
                        ScaffoldMessenger.of(widget.ctx!).showSnackBar(
                          financeSnackBar(
                            '${widget.category.name} has data associated with it'
                          )
                        );
                      }


                    },
                    child: const Icon(
                      MdiIcons.eyeOffOutline,
                      size: 22,
                    ),
                  ),
    
                  const SizedBox(
                    height: 10,
                  ),
    
                  GestureDetector(
                    onTap: widget.onDelete??(){
                      showDialog(
                        context: widget.ctx!,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            //backgroundColor: appOrange,
                            title: Text('Delete ${capitalize(widget.category.name)}?'),
                            content:  SingleChildScrollView(
                              child: ListBody(
                                children: const <Widget>[
                                  Text('Deleting this category will remove it and all expenses and budgets from the database'),
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
                                  
                                  Navigator.pop(context);

                                  setState(() {
                                    deleting = true;
                                  });

                                  Filter filterExp = Filter.custom((record){
                                    final d = record.value as Map<String, dynamic>;
                                    final exp = ExpenseModel.fromMap(d);

                                    return exp.category == widget.category;
                                  });

                                  Filter filterBud = Filter.custom((record){
                                    final d = record.value as Map<String, dynamic>;
                                    final bud = BudgetModel.fromMap(d);

                                    return bud.category == widget.category;
                                  });


                                  ExpenseDb expenseDb = ExpenseDb();
                                  BudgetDb budgetDb = BudgetDb();

                                  final expsForCat = await expenseDb.retrieveBasedOn(filterExp);
                                  final budgetsForCat = await budgetDb.retrieveBasedOn(filterBud);

                                  for (var e in expsForCat) {
                                    await deleteExpenseProcedure(e);
                                  } 

                                  for (var b in budgetsForCat) {
                                    await budgetDb.deleteData(b);
                                  }


                                  await categoryDb.deleteData(widget.category);

                                  

                                },
                              ),
                            ],
                          );}
                        );
                    },
                    child: Icon(
                      MdiIcons.deleteOutline,
                      size: 22,
                      color: appDanger,
                    ),
                  )
                ],
              ),
            ),
          ),
    
        
      ),
    );
  }
}