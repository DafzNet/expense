import 'package:expense/dbs/budget_db.dart';
import 'package:expense/dbs/expense.dart';
import 'package:expense/models/budget.dart';
import 'package:expense/models/category_model.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sembast/sembast.dart';

import '../dbs/category_db.dart';
import '../utils/constants/colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.all(10),
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
    
            trailing: SizedBox(
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
                            widget.category.name + ' has data associated with it'
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
                    onTap: widget.onDelete,
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