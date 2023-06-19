
import 'package:expense/models/income_model.dart';
import 'package:expense/screen/app/expense/add_expense.dart';
import 'package:expense/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../../procedures/income/income_procedure.dart';
import '../../../../../utils/capitalize.dart';
import '../../../../../utils/constants/colors.dart';
import 'income_exps.dart';

class IncomeDetailScreen extends StatefulWidget {

  final IncomeModel income;

  const IncomeDetailScreen({
    required this.income,
    super.key});

  @override
  State<IncomeDetailScreen> createState() => _IncomeDetailScreenState();
}

class _IncomeDetailScreenState extends State<IncomeDetailScreen> {

  @override
  void initState() {
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
            
            title: Text(widget.income.name!),

            actions: [

                IconButton(
                  onPressed: (){
                    showDialog(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    //backgroundColor: appOrange,
                    title: Text('Delete ${capitalize(widget.income.name!)}'),
                    content:  SingleChildScrollView(
                      child: ListBody(
                        children: const <Widget>[
                          Text('Deleting this income will delete all associated expenses'),
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
                          
                          await deleteIncomeProcedure(widget.income, context);
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );}
                );
                  }, 
                icon: Icon(
                  MdiIcons.delete,
                  color: appDanger,
                  ), 
              )
            ],
        
          ),
        ],

/////////////////////////////
////////////////////////////
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: [
              Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Divider(
                      color: appOrange,
                    ),

                    Center(
                      child: Container(
                        width: 120,
                        height: 40,
                        

                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 0.5,
                            color: appOrange
                          )
                        ),

                        child: Center(
                          child: Text(
                            DateFormat.yMMMMd()
                            .format(widget.income.date)
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20,),

              const Text('Income Source:'),

              Text(
                widget.income.source!,

                style: const TextStyle(
                  fontSize: 20
                ),
              ),

              const SizedBox(height: 20,),

              const Text('Vault:'),
              Text(
                widget.income.incomeVault != null ? widget.income.incomeVault!.name : 'NIL',

                style: const TextStyle(
                  fontSize: 20
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: const[
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Center(child: Text('Account: '))
                  ),

                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Center(child: Text('Balance: '))
                  )
                ],
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Center(
                      child: Text(
                        widget.income.amount.toString(),
                    
                        style: const TextStyle(
                          fontSize: 20
                        ),
                      ),
                    )
                  ),

                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Center(
                      child: Text(
                        widget.income.balance.toString(),
                    
                        style: const TextStyle(
                          fontSize: 20
                        ),
                      ),
                    )
                  )
                ],
              ),

              SizedBox(height: 20,),


              const Text('Note:'),

              Text(
                widget.income.note??'',

                style: const TextStyle(
                  fontSize: 20
                ),
              ),

              const SizedBox(
                height: 50,
              ),

              DefaultButton(
                onTap: (){
                  Navigator.push(
                    context,
                    PageTransition(
                      child: AddExpenseScreen(
                        income: widget.income,
                      ),

                      type: PageTransitionType.rightToLeft
                    )
                  );
                },
                text: 'Add New Spending',
              ),

              const SizedBox(
                height: 20,
              ),

              DefaultButton(
                onTap: (){
                  Navigator.push(
                    context,
                    PageTransition(
                      child: IncomeExpensesScreen(
                        income: widget.income,
                      ),

                      type: PageTransitionType.rightToLeft
                    )
                  );
                },
                text: 'View all Spendings',
              ),

              const SizedBox(
                height: 20,
              ),
            ]
          ),
        )
        
        ),

    );
  }
}
