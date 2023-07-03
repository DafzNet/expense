import 'package:expense/dbs/income_db.dart';
import 'package:expense/models/income_model.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sembast/sembast.dart';

import '../models/vault.dart';
import '../procedures/income/income_procedure.dart';
import '../utils/capitalize.dart';
import '../utils/constants/colors.dart';

class VaultCard extends StatefulWidget {

  final VaultModel vault;
  final String index;
  final VoidCallback? onDelete;
  final BuildContext? ctx;

  const VaultCard({
    required this.vault,
    required this.index,
    this.onDelete,
    this.ctx,
    super.key});

  @override
  State<VaultCard> createState() => _VaultCardState();
}

class _VaultCardState extends State<VaultCard> {

  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 0.2,
              color: Colors.black26
            )
          ),
    
          child: ListTile(
            minLeadingWidth: 25,
            
            leading: Text(
              widget.index,
            
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: appOrange
              ),
            ),
    
            title: RichText(
              text: TextSpan(
                text: widget.vault.name,
            
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black
                //color: appOrange
              ),

              children: [
                TextSpan(
                  text: ' - ${widget.vault.type}',
              
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.black
                    //color: appOrange
                  ),
                ),
              ]
              ),
            ),
    
            subtitle: Row(
              children: [
                const Text(
                  'Balance: ',
                
                  style: TextStyle(
                    fontSize: 14,
                    //color: appOrange
                  ),
                ),
                Text(
                  Currency(context).wrapCurrencySymbol(widget.vault.amountInVault.toString()),
                
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold

                    //color: appOrange
                  ),
                ),
              ],
            ),
           
    
            trailing: deleting ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ) : SizedBox(
              width: 20,
              child: GestureDetector(
                onTap: ()async{
                  await showDialog(
                    context: widget.ctx!,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        //backgroundColor: appOrange,
                        title: Text('Delete ${capitalize(widget.vault.name)}?'),
                        content:  SingleChildScrollView(
                          child: ListBody(
                            children: const <Widget>[
                              Text('All incomes attached to this vault will be removed as well'),
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
                              
                              Navigator.pop(context);
                              setState(() {
                                deleting = true;
                              });


                              IncomeDb incomeDb = IncomeDb();

                              Filter filter = Filter.custom((record){
                                final d = record.value as Map<String, dynamic>;
                                final inc = IncomeModel.fromMap(d);

                                return inc.incomeVault == widget.vault;
                              });


                              final incomes =await incomeDb.retrieveBasedOn(filter);

                              for (var i in incomes) {
                                await deleteIncomeProcedure(i, context);
                              }

                              await vaultDb.deleteData(widget.vault);

                            },
                          ),
                        ],
                      );}
                    );
                },
                child: Icon(
                  MdiIcons.deleteOutline,
                  size: 22,
                  color: appDanger,
                ),
              ),
            ),
          ),
    
        
      ),
    );
  }
}