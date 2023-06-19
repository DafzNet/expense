import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../models/expense_model.dart';
import '../screen/app/expense/expense_detail.dart';
import '../utils/capitalize.dart';
import '../utils/constants/colors.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseModel expenseModel;
  final String? index;

  final String? percent;

  final int? slidableKey;
  final VoidCallback? onDelete;

  const ExpenseTile({
    required this.expenseModel,
    this.percent,
    this.index,
    this.onDelete,
    this.slidableKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(

      // Specify a key if the Slidable is dismissible.
  key: ValueKey(slidableKey!),

  // The start action pane is the one at the left or the top side.
  endActionPane: ActionPane(
    // A motion is a widget used to control how the pane animates.
    motion: const ScrollMotion(),

    // A pane can dismiss the Slidable.
    dismissible: DismissiblePane(
      onDismissed: () {
      onDelete!();
    }),

    // All actions are defined in the children parameter.
    children: const [
    ],
  ),


      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: ExpenseDetail(expenseModel: expenseModel,),
    
              type: PageTransitionType.rightToLeft)
          );
        },
                        
        leading: ClipOval(
          child: Container(
            width: 50,
            height: 50,
            color: appOrange.shade200,
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                index??'',
    
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16
                ),
            
              ),
            ),
          ),
        ),
        title: Text(capitalize(expenseModel.title)),
        subtitle: Text(DateFormat.yMMMEd().format(expenseModel.date)),
                        
                        
        trailing: Text('$percent%'),
      ),
    );
  }
}