// ignore_for_file: use_build_context_synchronously

import 'package:expense/models/vault.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../dbs/saving_db.dart';
import '../../../dbs/vault_db.dart';
import '../../../models/savings_model.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/selection_sheet.dart';
import '../../../widgets/text_field.dart';

class AddFinancialGoalScreen extends StatefulWidget {
  final TargetSavingModel? targetSavingModel;
  const AddFinancialGoalScreen({
    this.targetSavingModel,
    super.key
    });

  @override
  State<AddFinancialGoalScreen> createState() => _AddFinancialGoalScreenState();
}

class _AddFinancialGoalScreenState extends State<AddFinancialGoalScreen> {


  final saingsDb = SavingsDb();
  final VaultDb vaultDb = VaultDb();

  final saingsForController = TextEditingController();
  final targetAmountController = TextEditingController();
  final initialAmountController = TextEditingController();
  final startDateController = TextEditingController();
  final durationController = TextEditingController();
  final vaultController = TextEditingController();
  final motivationController = TextEditingController();
  VaultModel? selctedVault;

  bool loading = false;

  List<VaultModel> vaults =[];

  void getVaults()async{
    vaults = await vaultDb.retrieveData();

    setState(() {
      
    });
  }

  void getSelectedVault(vault)async{
    vaultController.text = vault.name;
    selctedVault = vault;

    setState(() {
      
    });
  }

  DateTime _date = DateTime.now();

  @override
  void initState() {
    initialAmountController.text = '0';
    getVaults();
    startDateController.text = DateFormat.yMMMEd().format(_date);

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
          'Create Plan',
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
                                                      
                                  MyTextField(
                                    '',
                                    headerText: 'Savings for',
                                    controller: saingsForController,
                                  ),
                                                      
                                  const SizedBox(height: 30,),
                                  
                                  MyTextField(
                                    '',
                                    headerText: 'Target Amount',
                                    keyboardType: TextInputType.number,
                                    controller: targetAmountController,
                                  ),


                                  const SizedBox(height: 30,),

                                  MyTextField(
                                    '',
                                    headerText: 'Initial Amount',
                                    keyboardType: TextInputType.number,
                                    controller: initialAmountController,
                                  ),
                                                      
                                                      
                                  const SizedBox(height: 30,),
                                  
                                  MyTextField(
                                    DateFormat.yMMMEd().format(DateTime.now()),
                                    headerText: 'Starting from',
                                    makeButton: true,
                                    controller: startDateController,

                                    onTap: ()async{
                                      var d = await showDatePicker(
                                        context: context, 
                                        initialDate: DateTime.now(), 
                                        firstDate: DateTime.now().subtract(const Duration(days: 366)), 
                                        lastDate: DateTime.now().add(const Duration(days: 366)))??DateTime.now();

                                      _date = DateTime(d.year, d.month, d.day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);

                                      startDateController.text = DateFormat.yMMMEd().format(d);
                                      setState((){});
                                    },
                                  ),                      
                                                      
                                  const SizedBox(height: 30,),


                                  MyTextField(
                                    '',
                                    headerText: 'Duration (in Months)',
                                    keyboardType: TextInputType.number,
                                    controller: durationController,
                                  ),
                                                      
                                                      
                                  const SizedBox(height: 30,),
                                  
                                  MyTextField(
                                    'where is this savings kept',
                                    makeButton: true,
                                    headerText: 'Vault',
                                    controller: vaultController,

                                    onTap: ()async{
                                      await optionWidget(
                                        context,
                                        heading: 'Select Vault',
                                        options: vaults.isNotEmpty?vaults : [VaultModel(id: 1, name: 'No vault currently added', amountInVault: 000, dateCreated: DateTime.now())],

                                        onTap: vaults.isNotEmpty? getSelectedVault : null,
                                      );
                                    },
                                  ),
                                                      
                                                      
                                  const SizedBox(height: 30,),
                                  
                                  MyTextField(
                                    'optional',
                                    headerText: 'Motivation',
                                    maxLines: 3,
                                    controller: motivationController,
                                  ),
                                                      
                                                      
                                                      
                                   const SizedBox(height: 50,),
                                                      
                                                      
                                   DefaultButton(
                                    text: 'Submit',


                                    onTap: ()async{
                                      if(
                                        saingsForController.text.isNotEmpty&&
                                        targetAmountController.text.isNotEmpty&&
                                        durationController.text.isNotEmpty&&
                                        selctedVault != null &&
                                        double.parse(targetAmountController.text) >= double.parse(initialAmountController.text)
                                        
                                      ){
                                        setState(() {
                                          loading = true;
                                        });

                                      DateTime targetDate = _date.add(Duration(days: int.parse(durationController.text)*30));


                                      TargetSavingModel target = TargetSavingModel(
                                        id: DateTime.now().millisecondsSinceEpoch,
                                        vault: selctedVault,
                                        noOfMonth: int.parse(durationController.text),
                                        targetPurpose: saingsForController.text,
                                        motivation: motivationController.text,
                                        targetAmount: double.parse(targetAmountController.text), 
                                        currentAmount: double.parse(initialAmountController.text),
                                        lastAddedAmount: double.parse(initialAmountController.text),
                                        dateCreated: _date, 
                                        targetDate: targetDate,
                                        targetDay: targetDate.day,
                                        targetMonth: targetDate.month,
                                        targetYear: targetDate.year
                                      );


                                      if (widget.targetSavingModel != null) {
                                        TargetSavingModel updatedSavings = target.copyWith(id: widget.targetSavingModel!.id);
                                        await saingsDb.updateData(updatedSavings);
                                      } else {
                                        await saingsDb.addData(target);
                                      }

                                        Navigator.pop(context);

                                        setState(() {
                                          loading = false;
                                        });

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