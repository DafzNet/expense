// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:expense/dbs/expense.dart';
import 'package:expense/screen/app/expense/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import '../../../models/expense_model.dart';
import '../../../providers/expense_provider.dart';
import '../../../utils/capitalize.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/month.dart';
import 'expense_detail.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {

  final ExpenseDb expenseDb = ExpenseDb();
  double expenseForMonth = 0;

  Map percentages = {};


  Database? _db;

  var deletedRecord;
  
  List<ExpenseModel> expenseList = [];

   void dbOpen()async{
    _db = await expenseDb.openDb();
    setState(() {
      
    });
  }


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    dbOpen();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        backgroundColor: Colors.black,
        toolbarHeight: 50,

        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light
        ),
      ),

      body: Column(
        children: [
           SizedBox(
            height: 110,
             child: Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.only(left: 30, bottom: 10),
                   child: Row(
                     children: [
                       const Text(
                          'TOTAL EXPENSES FOR ',
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),
                        ),
                 
                        Text(
                          Month().currentMonth.toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.4,
                            fontWeight: FontWeight.w700,
                            color: appOrange
                          ),
                        ),
                     ],
                   ),
                 ),
           
                Text(
                  '₦${Provider.of<ExpenseProvider>(context).totalExpenseAmnt}',
                  style: const TextStyle(
                    fontSize: 45,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Colors.white
                  ),
                ),
           
                const SizedBox(height: 10,)
           
               ],
             ),
           ),

            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                child: _db != null ?  Container(
                  color: Colors.white,

                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      Row(
                        children: const [
                          SizedBox(width: 30,),
                          Text(
                            'Expense List',
                            style: TextStyle(
                              fontSize: 20,
                              height: 1.4,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: Colors.black
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10,),

                      Expanded(
                        child: StreamBuilder(
                          stream: expenseDb.onExpenses(_db!),
                          initialData: const <ExpenseModel>[],
                          builder: (context, snapshot){

                            if (snapshot.hasData) {
                              List<ExpenseModel> expenses = snapshot.data!;

                              expenses.sort((a,b){
                                return b.date.compareTo(a.date);
                              });

                              if (expenses.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No Expense added yet'
                                  )
                                );
                              }

                              return ListView.builder(
                              itemCount: expenses.length,
                              itemBuilder: (context, index){
                                
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: ExpenseTile(
                                    slidableKey: index,

                                    onDelete:  ()async{
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            //backgroundColor: appOrange,
                                            title: Text('Delete ${capitalize(expenses[index].title)}'),
                                            content:  SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text('Deleting this will remove it from the expenses list'),

                                                  
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
                                                  Provider.of<ExpenseProvider>(context, listen: false).subtract(expenses[index].amount);
                                                  await expenseDb.deleteData(expenses[index]);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );}
                                        );
                                    },
                                    
                                    expenseModel: expenses[index],
                                    percent: double.parse(((expenses[index].amount/Provider.of<ExpenseProvider>(context).totalExpenseAmnt)*100).toString()).toStringAsFixed(1),//percentages[expenseList[index].id].toString(),
                                    index: '${index+1}',
                                  ),
                                );
                              });
                            }else if(snapshot.connectionState == ConnectionState.waiting || snapshot.hasError ){
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return const Center(child: CircularProgressIndicator(),);

                          }
                        )
                      ),
                    ],
                  ),
                )
                :
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              )
            )

        ],
      ),
      
      

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            PageTransition(
              child: const AddExpenseScreen(
                
              ),

              type: PageTransitionType.bottomToTop
            )
          );
        },

        backgroundColor: appOrange,
        elevation: 3,

        shape: const CircleBorder(

        ),

         child: const Icon(
          MdiIcons.plus,
          color: Colors.white,
        ),
      ),
    );
  }
}






class ExpenseTile extends StatelessWidget {
  final ExpenseModel expenseModel;
  final String? index;

  final String? percent;

  final int? slidableKey;
  final VoidCallback? onDelete;

  const ExpenseTile({
    required this.expenseModel,
    this.percent,
    this.index,
    this.onDelete,
    this.slidableKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(

      // Specify a key if the Slidable is dismissible.
  key: ValueKey(slidableKey!),

  // The start action pane is the one at the left or the top side.
  endActionPane: ActionPane(
    // A motion is a widget used to control how the pane animates.
    motion: const ScrollMotion(),

    // A pane can dismiss the Slidable.
    dismissible: DismissiblePane(
      onDismissed: () {
      onDelete!();
    }),

    // All actions are defined in the children parameter.
    children: const [
    ],
  ),


      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: ExpenseDetail(expenseModel: expenseModel,),
    
              type: PageTransitionType.rightToLeft)
          );
        },
                        
        leading: ClipOval(
          child: Container(
            width: 50,
            height: 50,
            color: appOrange.shade200,
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                index??'',
    
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16
                ),
            
              ),
            ),
          ),
        ),
        title: Text(capitalize(expenseModel.title)),
        subtitle: Text(DateFormat.yMMMEd().format(expenseModel.date)),
                        
                        
        trailing: Text('$percent%'),
      ),
    );
  }
}