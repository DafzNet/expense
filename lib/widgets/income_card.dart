import 'package:expense/models/income_model.dart';
import 'package:expense/screen/app/more/screen/income/income_detail.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

class IncomeCard extends StatefulWidget {
  final IncomeModel income;
  final VoidCallback? onDelete; 

  const IncomeCard({
    required this.income,
    this.onDelete,

    super.key});

  @override
  State<IncomeCard> createState() => _IncomeCardState();
}

class _IncomeCardState extends State<IncomeCard> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: 150,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                child: IncomeDetailScreen(income: widget.income),
                type: PageTransitionType.rightToLeft
              )
            );
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
        
                children: [
                  Column(
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
                                widget.income.name!,
        
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
        
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
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
        
                      const SizedBox(height: 7,),
        
                      Row(
                        children: [
                          const SizedBox(width: 20,),
                          Expanded(
                            child: Text(
                              widget.income.source!,
                          
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                          
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
        
                      Divider(
                        height: 30,
                        thickness: 0.3,
                        color: appOrange,
                      ),
        
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 20,),
                              const Text(
                                'Amount: ',
                              
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
        
                              Text(
                                widget.income.amount.toString().substring(0, widget.income.amount.toString().length>=7? 7:widget.income.amount.toString().length) + "${widget.income.amount.toString().length>=7 ? '..':''}",
                      
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
        
        
                          Row(
                            children: [
                              const SizedBox(width: 20,),
                              const Text(
                                'Balance: ',
                              
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
        
                              Text(
                                widget.income.balance.toString().substring(0, widget.income.balance.toString().length>=7? 7:widget.income.balance.toString().length)+"${widget.income.balance.toString().length>=7 ? '..':''}",
                              
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              
                                style: TextStyle(
                                  fontSize: 18,
                                  color: (widget.income.balance/widget.income.amount)*100 < 20 ? Colors.red: const Color.fromARGB(255, 6, 146, 11)
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
        
        
                    ],
                  )
                ],
              ),
            ),
            
          ),
        ),
      ),
    );
  }
}