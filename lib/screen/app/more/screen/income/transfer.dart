import 'package:expense/dbs/vault_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../models/income_model.dart';
import '../../../../../models/vault.dart';
import '../../../../../widgets/default_button.dart';
import '../../../../../widgets/selection_sheet.dart';
import '../../../../../widgets/text_field.dart';

class IncomeTransfer extends StatefulWidget {
  final IncomeModel income;
  const IncomeTransfer(this.income, {super.key});

  @override
  State<IncomeTransfer> createState() => _IncomeTransferState();
}
 
class _IncomeTransferState extends State<IncomeTransfer> {

  VaultDb vaultDb = VaultDb();


  VaultModel? vaultFrom;
  VaultModel? vaultTo;

  final vaultFromField = TextEditingController();
  final vaultToField = TextEditingController();
  final feeController = TextEditingController();


  @override
  void initState() {
    vaultFrom = widget.income.incomeVault;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: Text('Withdrawal'),
        
          ),
        ],

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              MyTextField(
                widget.income.incomeVault!.name,
                headerText: 'From',
                makeButton: true,
                controller: vaultFromField,


                 onTap: ()async{
                  await optionWidget(
                    context,
                    heading: 'Select Vault',
                    options: await vaultDb.retrieveData(),

                    onTap: (i){
                      vaultFrom = i;
                      vaultFromField.text = i.name;
                    }
                  );
                },

              ),

              const SizedBox(height: 15,),

              MyTextField(
                'Select vault',
                headerText: 'To',
                makeButton: true,
                controller: vaultToField,

                onTap: ()async{
                  await optionWidget(
                    context,
                    heading: 'Select Vault',
                    options: await vaultDb.retrieveData(),

                    onTap: (i){
                      vaultTo = i;
                      vaultToField.text = i.name;
                    }
                  );
                },

              ),


              const SizedBox(height: 15,),

              MyTextField(
                '',
                headerText: 'Transfer Fee',
                controller: feeController,
                keyboardType: TextInputType.number,

              ),

              const SizedBox(height: 55,),

              DefaultButton()
            ],
          ),
        )
      )
    );
  }
}