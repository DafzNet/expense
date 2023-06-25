
// ignore_for_file: use_build_context_synchronously

import 'package:expense/dbs/saving_db.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../models/savings_model.dart';
import '../../../utils/currency/currency.dart';
import 'add_money.dart';

class SavingDetail extends StatefulWidget {
  final TargetSavingModel savingModel;
  const SavingDetail({
    required this.savingModel,
    super.key});

  @override
  State<SavingDetail> createState() => _SavingDetailState();
}

class _SavingDetailState extends State<SavingDetail> {

  SavingsDb savingsDb = SavingsDb();


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
            onPressed: ()async{
              showDialog(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    //backgroundColor: appOrange,
                    title: const Text('Delete this Saving?'),
                    content:  SingleChildScrollView(
                      child: ListBody(
                        children: const <Widget>[
                          Text('You will not be able to recover it after it\'s been deleted'),
          
                          // SizedBox(height: 15,),
          
                          // Row(
                          //   children: [
                          //     Checkbox(
                          //       value: _del, onChanged: (v){
                          //       _del = !v!;
                          //       setState(() {
                                  
                          //       });
                          //     }),
          
                          //     Text('Don\'t ask again '),
                          //   ],
                          // ),
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
                          
                          await savingsDb.deleteData(widget.savingModel);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                  }
                );
            }, 
            icon: const Icon(MdiIcons.delete, color: Colors.white,))
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
                                    // Row(
                                    //   children: const [
                                    //     Text(
                                    //       'Purpose:',

                                    //       style: TextStyle(
                                    //         fontSize: 16,
                                    //         letterSpacing: 1.1
                                    //       ),
                                    //       )
                                    //   ],
                                    // ),

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

                                Divider(
                                  color: appOrange.shade200
                                ),

                                

                                const SizedBox(height: 30,),
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
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 5),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: appOrange.shade100,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: appOrange.shade300
                                            )
                                          ),
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
                                      ),
                                    ),

                                Flexible(
                                  flex: 5,
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: appOrange.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: appOrange.shade300
                                        )
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: const [
                                              Text(
                                                'To:',
                                                                    
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
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: appSuccess
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                Currency().wrapCurrencySymbol('${widget.savingModel.targetAmount} '),
                                                                                    
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  letterSpacing: 1.3,
                                                  color: appSuccess.shade50,
                                                  fontWeight: FontWeight.w600
                                                ),
                                              ),

                                              Icon(
                                                MdiIcons.arrowUpCircleOutline,
                                                color: appSuccess.shade50,
                                              )
                                            ],
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Flexible(
                                          flex: 5,
                                          child: Text(
                                            'Amount Saved:',
                                        
                                            style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 1.1
                                            ),
                                            ),
                                        ),

                                        Flexible(
                                          flex: 5,
                                          child: Text(
                                            'Amount To Go:',
                                        
                                            style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 1.1
                                            ),
                                            ),
                                        )
                                      ],
                                    ),

                                    const SizedBox(height: 10,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: (MediaQuery.of(context).size.width/2)-25,
                                          child: Text(
                                            Currency().wrapCurrencySymbol('${widget.savingModel.currentAmount}'),
                                        
                                            style: TextStyle(
                                              fontSize: 25,
                                              letterSpacing: 1.3,
                                              color: appSuccess,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),


                                        SizedBox(
                                          width: (MediaQuery.of(context).size.width/2)-25,
                                          child: Text(
                                            Currency().wrapCurrencySymbol('${widget.savingModel.targetAmount - widget.savingModel.currentAmount}'),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              letterSpacing: 1.3,
                                              color: Color.fromARGB(255, 233, 182, 16),
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