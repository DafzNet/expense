import 'package:expense/models/budget.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../utils/currency/currency.dart';
import '../../utils/month.dart';

class BudgetCard extends StatefulWidget {

  final BudgetModel budget;
  final VoidCallback? onDelete;

  const BudgetCard({
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
          child: Container(
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
        
                          ClipOval(
                            child: GestureDetector(
                              onTap: widget.onDelete,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                color: appDanger,
                                child: const Icon(
                                  MdiIcons.deleteOutline,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
                          text: Currency().wrapCurrencySymbol(widget.budget.amount.toString()),

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
                                        size: 14,
                                        color: Color.fromARGB(255, 2, 142, 6),
                                      ),
                                      Text(
                                        ' Budget Balance',

                                        style: TextStyle(
                                          fontSize: 14
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
                                        size: 14,
                                        color: Color.fromARGB(255, 250, 13, 13),
                                      ),
                                      Text(
                                        ' Budget Spent    ',

                                        style: TextStyle(
                                          fontSize: 14
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
                  ),





                ],
              ),
            ),
            
          ),
        ),
      ),
    );
  }
}