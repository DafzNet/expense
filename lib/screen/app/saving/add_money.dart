// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../dbs/saving_db.dart';
import '../../../models/savings_model.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/text_field.dart';

class AddMoneyScreen extends StatefulWidget {
  final TargetSavingModel targetSavingModel;
  const AddMoneyScreen({
    required this.targetSavingModel,
    super.key
    });

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {

  final saingsDb = SavingsDb();

  final targetAmountController = TextEditingController();



  bool loading = false;
  double _total = 0;

  @override
  void initState() {
    _total = widget.targetSavingModel.currentAmount;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    //_edit();

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
          'Add Money',
          style: TextStyle(
            color: Colors.white
          ),
        ),

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
                            child: LoadingIndicator(
                              loading: loading,
                              child: Column(
                                children: [
                                const SizedBox(height: 30,),

                                Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Saving Purpose:',

                                          style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.1
                                          ),
                                          )
                                      ],
                                    ),

                                    const SizedBox(height: 5,),

                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width-60,
                                          child: Text(
                                            '${widget.targetSavingModel.targetPurpose}',
                                        
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


                                const SizedBox(height: 30,),

                                Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Previous Savings:',

                                          style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.1
                                          ),
                                          )
                                      ],
                                    ),

                                    const SizedBox(height: 5,),

                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width-60,
                                          child: Text(
                                            '₦${widget.targetSavingModel.currentAmount}',
                                        
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

                                const SizedBox(height: 30,),

                                MyTextField(
                                    '',
                                    headerText: 'Amount to add:',
                                    keyboardType: TextInputType.number,
                                    controller: targetAmountController,

                                    onChanged: () {
                                      _total = widget.targetSavingModel.currentAmount + double.parse(targetAmountController.text);

                                      setState(() {
                                        
                                      });
                                    },
                                  ),

                                  const SizedBox(height: 80,),

                                const Divider(),

                                const SizedBox(height: 20,),

                                Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Total:',

                                          style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.1
                                          ),
                                          )
                                      ],
                                    ),

                                    const SizedBox(height: 5,),

                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width-60,
                                          child: Text(
                                            _total<=widget.targetSavingModel.targetAmount?'₦$_total':'exceeded target',
                                    
                                        
                                            style: TextStyle(
                                              fontSize: _total<=widget.targetSavingModel.targetAmount?40:20,
                                              letterSpacing: 1.3,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),

                                const SizedBox(height: 30,),
                 
                                                      
                                   DefaultButton(
                                    text: 'Save',


                                    onTap: ()async{
                                      if(_total<=widget.targetSavingModel.targetAmount){if(
                                        targetAmountController.text.isNotEmpty
                                        
                                      ){
                                        setState(() {
                                          loading = true;
                                        });

                                       TargetSavingModel target = widget.targetSavingModel.copyWith(
                                        currentAmount: _total,
                                        lastAddedAmount: double.parse(targetAmountController.text)
                                       );
                                          


                                        await saingsDb.updateData(target);

                                        setState(() {
                                          loading = false;
                                        });

                                        Navigator.pop(context);

                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.white,
                                            content: Text(
                                              'Amount to add should not be empty',
                                              style: TextStyle(
                                                color: Colors.black
                                              ),
                                              ))
                                        );
                                      }
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.white,
                                            content: Text(
                                              'Exceeded target by ${_total-widget.targetSavingModel.targetAmount}',
                                              style: const TextStyle(
                                                color: Colors.black
                                              ),
                                              ))
                                        );
                                      }
                                    }
                                   ),

                                   const SizedBox(height: 20,)
                                ],
                              ),
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