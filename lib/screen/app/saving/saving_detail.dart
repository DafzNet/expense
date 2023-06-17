
import 'package:expense/dbs/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../models/savings_model.dart';
import 'add_money.dart';
import 'add_saving.dart';

class SavingDetail extends StatefulWidget {
  final TargetSavingModel savingModel;
  const SavingDetail({
    required this.savingModel,
    super.key});

  @override
  State<SavingDetail> createState() => _SavingDetailState();
}

class _SavingDetailState extends State<SavingDetail> {

  final ExpenseDb expenseDb = ExpenseDb();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        automaticallyImplyLeading: false,

        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(
            MdiIcons.arrowLeft,
            color: Colors.white
          )),

        title: const Text(
          'Saving Details',
          style: TextStyle(
            color: Colors.white
          ),
        ),

        actions: [

          IconButton(
            onPressed: (){
              Navigator.pushReplacement(context, 
                PageTransition(
                  child: AddMoneyScreen(
                    targetSavingModel: widget.savingModel,
                  ),

                  type: PageTransitionType.fade
                )
              );
            }, 
            icon: const Icon(MdiIcons.plusCircleOutline, color: Colors.white,)),

          IconButton(
            onPressed: (){
              Navigator.pushReplacement(context, 
                PageTransition(
                  child: AddFinancialGoalScreen(
                    targetSavingModel: widget.savingModel,
                  ),

                  type: PageTransitionType.fade
                )
              );
            }, 
            icon: const Icon(MdiIcons.noteEditOutline, color: Colors.white,))
        ],

        backgroundColor: Colors.black,
        //toolbarHeight: 50,

        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light
        ),
      ),

      body: Column(
        children: [
           
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                child: Container(
                  color: Colors.white,

                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Purpose:',

                                          style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.1
                                          ),
                                          )
                                      ],
                                    ),

                                    const SizedBox(height: 10,),

                                    Text(
                                      widget.savingModel.targetPurpose!,

                                      style: const TextStyle(
                                        fontSize: 28,
                                        letterSpacing: 1.1,
                                        fontWeight: FontWeight.w800
                                      ),
                                    )
                                  ],
                                ),

                                

                                const SizedBox(height: 45,),
                                //Amount

                                Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Duration:',

                                          style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.1
                                          ),
                                          )
                                      ],
                                    ),

                                    const SizedBox(height: 10,),

                                    Row(
                                      children: [
                                        Text(
                                          '${widget.savingModel.noOfMonth} Month${widget.savingModel.noOfMonth>1?'s':''}',

                                          style: const TextStyle(
                                            fontSize: 30,
                                            letterSpacing: 1.3,
                                            fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                
                                const SizedBox(height: 35,),


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 5,
                                      fit: FlexFit.tight,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: const [
                                              Text(
                                                'Starting From:',
                                    
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  letterSpacing: 1.1
                                                ),
                                                )
                                            ],
                                          ),
                                    
                                          const SizedBox(height: 10,),
                                    
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width/3,
                                                child: Text(
                                                  DateFormat.yMMMd().format(widget.savingModel.dateCreated),
                                              
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    letterSpacing: 1.3,
                                                    fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                Flexible(
                                  flex: 5,
                                  fit: FlexFit.tight,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: const [
                                          Text(
                                            'To',
                                
                                            style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 1.1
                                            ),
                                            )
                                        ],
                                      ),
                                
                                      const SizedBox(height: 10,),
                                
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width/3,
                                            child: Text(
                                              DateFormat.yMMMd().format(widget.savingModel.targetDate),
                                          
                                              style: const TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.3,
                                                fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                  ],
                                ),


                                const SizedBox(height: 35,),


                                Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Target Amount:',

                                          style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.1
                                          ),
                                          )
                                      ],
                                    ),

                                    const SizedBox(height: 10,),

                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width-60,
                                          child: Text(
                                            '₦${widget.savingModel.targetAmount}',
                                        
                                            style: const TextStyle(
                                              fontSize: 40,
                                              letterSpacing: 1.3,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),


                                const SizedBox(height: 35,),

                                Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Amount Saved:',

                                          style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.1
                                          ),
                                          )
                                      ],
                                    ),

                                    const SizedBox(height: 10,),

                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width-60,
                                          child: Text(
                                            '₦${widget.savingModel.currentAmount}',
                                        
                                            style: const TextStyle(
                                              fontSize: 40,
                                              letterSpacing: 1.3,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),


                              
                                const SizedBox(height: 35,),


                                Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Savings Vault',

                                          style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.1
                                          ),
                                          )
                                      ],
                                    ),

                                    const SizedBox(height: 10,),

                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width-60,
                                          child: Text(
                                            widget.savingModel.vault!.name,
                                        
                                            style: const TextStyle(
                                              fontSize: 30,
                                              letterSpacing: 1.3,
                                              fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),

                                const SizedBox(height: 35,),
                                
                                Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Motivation:',

                                          style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.1
                                          ),
                                          )
                                      ],
                                    ),

                                    const SizedBox(height: 10,),

                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width-60,
                                          child: Text(
                                            widget.savingModel.motivation!,
                                        
                                            style: const TextStyle(
                                              fontSize: 20,
                                              letterSpacing: 1.1,
                                              fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),



                              ],
                            ),
                          ),
                        )
                      )
                    ],
                  ),
                ),
              )
            )

        ],
      )
    );
  }
}