
// ignore_for_file: use_build_context_synchronously

import 'package:expense/dbs/income_db.dart';
import 'package:expense/models/income_model.dart';
import 'package:expense/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../../dbs/vault_db.dart';
import '../../../../../models/vault.dart';
import '../../../../../utils/currency/currency.dart';
import '../../../../../widgets/default_button.dart';
import '../../../../../widgets/loading.dart';
import '../../../../../widgets/selection_sheet.dart';
import '../../../../../widgets/text_field.dart';


class AddIncomeScreen extends StatefulWidget {

  const AddIncomeScreen({
    super.key
    });

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {

  final VaultDb vaultDb = VaultDb();
  final IncomeDb incomeDb = IncomeDb();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final sourceController = TextEditingController();
  final noteController = TextEditingController();
  final vaultController = TextEditingController();
  
  DateTime? _date = DateTime.now();

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

  @override
  void initState() {
    getVaults();
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
          'Add Income',
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
                                    headerText: 'Income title',
                                    controller: titleController,
                                  ),
                                                      
                                  const SizedBox(height: 30,),

                                  MyTextField(
                                    '',
                                    headerText: 'Income Source',
                                    controller: sourceController,
                                  ),
                                                      
                                  const SizedBox(height: 30,),
                                  
                                  MyTextField(
                                    Currency(context).currencySymbol,
                                    headerText: 'Amount',
                                    keyboardType: TextInputType.number,
                                    controller: amountController,
                                  ),
                                                      
                                                      
                                  const SizedBox(height: 30,),
                                  
                                  MyTextField(
                                    DateFormat.yMMMEd().format(DateTime.now()),
                                    headerText: 'Date Received',
                                    makeButton: true,
                                    controller: dateController,

                                    onTap: ()async{
                                      var d = await showDatePicker(
                                        context: context, 
                                        initialDate: DateTime.now(), 
                                        firstDate: DateTime.now().subtract(const Duration(days: 366)), 
                                        lastDate: DateTime.now().add(const Duration(days: 366)))??DateTime.now();

                                      _date = DateTime(d.year, d.month, d.day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);

                                      dateController.text = DateFormat.yMMMEd().format(d);
                                      setState((){});
                                    },
                                  ),


                                  const SizedBox(height: 30,),

                                  MyTextField(
                                    'where is this income kept',
                                    makeButton: true,
                                    headerText: 'Vault',
                                    controller: vaultController,

                                    onTap: ()async{
                                      await optionWidget(
                                        context,
                                        options: vaults.isNotEmpty ? vaults : [VaultModel(id: 1, name: 'No vault currently added', amountInVault: 000, dateCreated: DateTime.now())],
                                        heading: 'Select Vault',
                                        onTap: getSelectedVault//vaults.isNotEmpty ? getSelectedVault : null,
                                      );
                                    },
                                  ),
                                                      
                                                      
                                  const SizedBox(height: 30,),
                                  
                                  MyTextField(
                                    'optional',
                                    headerText: 'Note',
                                    maxLines: 3,
                                    controller: noteController,
                                  ),
                                                      
                                                      
                                                      
                                   const SizedBox(height: 50,),
                                                      
                                                      
                                   DefaultButton(
                                    onTap: () async{

                                      if (titleController.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          financeSnackBar('Title is missing')
                                        );
                                      }else if (sourceController.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          financeSnackBar('please proide income source')
                                        );
                                      }else if (amountController.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          financeSnackBar('Income amount is required')
                                        );
                                      }else if (vaultController.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          financeSnackBar('Provide a vault for this income')
                                        );
                                      }else{
                                        loading = true;

                                        setState(() {
                                          
                                        });

                                        IncomeModel income = IncomeModel(
                                          id: DateTime.now().millisecondsSinceEpoch, 
                                          amount: double.parse(amountController.text), 
                                          balance: double.parse(amountController.text), 
                                          date: _date!,
                                          name: titleController.text,
                                          source: sourceController.text,
                                          incomeVault: selctedVault,
                                          day: _date!.day,
                                          month: _date!.month,
                                          year: _date!.year,
                                          note: noteController.text
                                        );

                                        final updatedVaultBal = selctedVault!.copyWith(
                                          amountInVault: selctedVault!.amountInVault + double.parse(amountController.text)
                                        );


                                        await incomeDb.addData(income);
                                        await vaultDb.updateData(updatedVaultBal);

                                        loading = false;
                                        
                                        setState(() {
                                          
                                        });

                                        Navigator.pop(context);

                                      }

                                      
                                    },
                                   )
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