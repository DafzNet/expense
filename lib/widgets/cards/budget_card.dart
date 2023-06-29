import 'package:expense/dbs/budget_db.dart';
import 'package:expense/models/budget.dart';
import 'package:expense/screen/app/expense/add_expense.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../utils/capitalize.dart';
import '../../utils/currency/currency.dart';
import '../../utils/month.dart';

class BudgetCard extends StatefulWidget {

  final BudgetModel budget;
  final VoidCallback? onDelete;

  final BuildContext ctx;

  const BudgetCard({
    required this.ctx,
    required this.budget,
    this.onDelete,
    super.key});

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        //height: 200,
        child: GestureDetector(
          onTap: () {
            
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 0.2,
                    color: Colors.black26
                  )
                ),
        
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
        
                    children: [

                      Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    MdiIcons.circle,
                                    size: 10,
                                  ),
        
                                  const SizedBox(width: 10,),
        
                                  Text(
                                    widget.budget.name,
        
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
        
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),

                                  Text(
                                    widget.budget.category!=null ?
                                      widget.budget.category!.name.length <=20 ? ' - ${widget.budget.category!.name}' : ' - ${widget.budget.category!.name.substring(0, 10)}...'
                                    :'',
        
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
        
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
        
                              Row(
                                children: [
                                  
                                  ClipOval(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: AddExpenseScreen(
                                              category: widget.budget.category
                                            ),

                                            type: PageTransitionType.rightToLeft
                                          )
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        color: appSuccess,
                                        child: const Icon(
                                          MdiIcons.plus,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 5,),


                                  ClipOval(
                                    child: GestureDetector(
                                      onTap: widget.onDelete??(){
                                        showDialog(
                                          context: widget.ctx,
                                          barrierDismissible: false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              //backgroundColor: appOrange,
                                              title: Text('Delete ${capitalize(widget.budget.name)}?'),
                                              content:  SingleChildScrollView(
                                                child: ListBody(
                                                  children: const <Widget>[
                                                    Text('Deleting this budget will remove it from the database'),
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
                                                    
                                                    await BudgetDb().deleteData(widget.budget);
                                                    
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        color: appDanger,
                                        child: const Icon(
                                          MdiIcons.deleteOutline,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),

                      const SizedBox(height: 15,),

                      RichText(
                        text: TextSpan(
                          text: '    Total: ',

                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87
                          ),

                          children: [
                            TextSpan(
                              text: Currency(context).wrapCurrencySymbol(widget.budget.amount.toString()),

                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black
                              ),
                            )
                          ]
                        ),
                      ),

                      const SizedBox(height: 15,),

                      RichText(
                        text: TextSpan(
                          text: widget.budget.startDate == widget.budget.endDate ? '    Duration: ':'    Start: ',

                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87
                          ),

                          children: [
                            TextSpan(
                              text: widget.budget.startDate == widget.budget.endDate ? Month().getMonth(widget.budget.month):
                                 DateFormat.MMMMd()
                                .format(widget.budget.startDate!),

                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black
                              ),
                            ),

                            if(!(widget.budget.startDate == widget.budget.endDate))...
                              [
                                const TextSpan(
                                  text: '         End: ',
                                    
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                  ),
                                ),

                                TextSpan(
                                  text: DateFormat.MMMMd()
                                          .format(widget.budget.endDate!),
                                    
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black
                                  ),
                                ),
                              ]



                          ]
                        ),
                      ),

                      const SizedBox(height: 15,),


                      Center(
                        child: SizedBox(
                          height: 60,
                      
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LinearPercentIndicator(
                                  progressColor: const Color.fromARGB(255, 2, 142, 6),
                                  //width: MediaQuery.of(context).size.width-60,
                                  lineHeight: 6.0,
                                  percent: ((widget.budget.balance/widget.budget.amount)*100)/100<0?0:((widget.budget.balance/widget.budget.amount)*100)/100,
                                  barRadius: const Radius.circular(5),
                                  backgroundColor: const Color.fromARGB(255, 250, 13, 13),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        
                                        children: const[
                                          Icon(
                                            MdiIcons.square,
                                            size: 8,
                                            color: Color.fromARGB(255, 2, 142, 6),
                                          ),
                                          Text(
                                            ' Budget Balance',

                                            style: TextStyle(
                                              fontSize: 10
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: const[
                                          Icon(
                                            MdiIcons.square,
                                            size: 8,
                                            color: Color.fromARGB(255, 250, 13, 13),
                                          ),
                                          Text(
                                            ' Budget Spent    ',

                                            style: TextStyle(
                                              fontSize: 10
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                
              ),


              Positioned(
                bottom: 10,
                left: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 50,
                          child: Text(
                            'Budget:',
                        
                            style: TextStyle(
                              fontSize: 12
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 3,
                          width: 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: appOrange.shade600
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 5,),

                    Row(
                      children: [
                        const SizedBox(
                          width: 50,
                          child: Text(
                            'Actual:',
                            style: TextStyle(
                              fontSize: 12
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 3,
                          width: ((widget.budget.amount-widget.budget.balance)/widget.budget.amount)*100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.budget.amount-widget.budget.balance >
                                widget.budget.amount ? appDanger : appSuccess
                            ),
                          ),
                        ),

                        Text(
                          ' ${double.parse((((widget.budget.amount-widget.budget.balance)/widget.budget.amount)*100).toString()).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 10
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}