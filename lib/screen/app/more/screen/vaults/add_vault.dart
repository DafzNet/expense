
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../dbs/vault_db.dart';
import '../../../../../models/vault.dart';
import '../../../../../widgets/default_button.dart';
import '../../../../../widgets/loading.dart';
import '../../../../../widgets/text_field.dart';


class AddVaultScreen extends StatefulWidget {

  const AddVaultScreen({
    super.key
    });

  @override
  State<AddVaultScreen> createState() => _AddVaultScreenState();
}

class _AddVaultScreenState extends State<AddVaultScreen> {

  final vaultDb = VaultDb();

  final titleController = TextEditingController();
  final typeController = TextEditingController();


  bool loading = false;


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
          'Add Vault',
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
                          padding: const EdgeInsets.symmetric(horizontal: 25,),
                          child: SingleChildScrollView(
                            child: LoadingIndicator(
                              loading: loading,
                              child: Column(
                                children: [
                                  const SizedBox(height: 30,),
                                  
                                  
                                  MyTextField(
                                    '',
                                    headerText: 'Name',
                                    maxLines: 3,
                                    controller: titleController,
                                  ),

                                  const SizedBox(height: 30,),
                                  
                                  
                                  MyTextField(
                                    'e.g Bank(Account Number)',
                                    headerText: 'Type',
                                    controller: typeController,
                                    bottomHint: 'Indicate vault type (Bank, cash)',
                                  ),
                                  
                                                      
                                  const SizedBox(height: 50,),
                                                      
                                                      
                                   DefaultButton(
                                    text: 'Add Vault',

                                    onTap: ()async{
                                      if (titleController.text.isEmpty) {
                                        
                                      } else {
                                        loading = true;
                                        setState(() {
                                          
                                        });

                                        VaultModel vault = VaultModel(
                                          id: DateTime.now().millisecondsSinceEpoch, 
                                          name: titleController.text,
                                          type: typeController.text,
                                          amountInVault: 0,
                                          dateCreated: DateTime.now()
                                        );


                                        await vaultDb.addData(vault);

                                        loading = false;

                                        setState(() {
                                          
                                        });

                                        Navigator.pop(context);

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