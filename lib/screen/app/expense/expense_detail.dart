
// ignore_for_file: use_build_context_synchronously

import 'package:expense/dbs/expense.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/providers/expense_provider.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../utils/capitalize.dart';

class ExpenseDetail extends StatefulWidget {
  final ExpenseModel expenseModel;
  const ExpenseDetail({
    required this.expenseModel,
    super.key});

  @override
  State<ExpenseDetail> createState() => _ExpenseDetailState();
}

class _ExpenseDetailState extends State<ExpenseDetail> {

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
          'Expense Details',
          style: TextStyle(
            color: Colors.white
          ),
        ),

        actions: [

          IconButton(
            onPressed: (){

             showDialog(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    //backgroundColor: appOrange,
                    title: Text('Delete ${capitalize(widget.expenseModel.title)}'),
                    content:  SingleChildScrollView(
                      child: ListBody(
                        children: const <Widget>[
                          Text('Deleting this will remove it from the expenses list'),

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
                          Provider.of<ExpenseProvider>(context, listen: false).subtract(widget.expenseModel.amount);
                          await expenseDb.deleteData(widget.expenseModel);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );}
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
                                    Row(
                                      children: const [
                                        Text(
                                          'Title:',

                                          style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.1
                                          ),
                                          )
                                      ],
                                    ),

                                    const SizedBox(height: 10,),

                                    Text(
                                      capitalize(widget.expenseModel.title),
                                      
                                      style: const TextStyle(
                                        fontSize: 28,
                                        letterSpacing: 1.1,
                                        fontWeight: FontWeight.w800
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(height: 15,),
                                //////Date 
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
                                            .format(widget.expenseModel.date)
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(height: 35,),
                                //Amount

                                Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Amount:',

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
                                          '₦${widget.expenseModel.amount}',

                                          style: const TextStyle(
                                            fontSize: 32,
                                            letterSpacing: 1.3,
                                            fontWeight: FontWeight.w500
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
                                          'Income Spent:',

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
                                            widget.expenseModel.income != null ? '${widget.expenseModel.income!.name}':'Unspecified',
                                        
                                            style: const TextStyle(
                                              fontSize: 28,
                                              letterSpacing: 1.3,
                                              fontWeight: FontWeight.w500
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
                                          'Category:',

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
                                            widget.expenseModel.category != null ? widget.expenseModel.category!.name:'Unspecified',
                                        
                                            style: const TextStyle(
                                              fontSize: 28,
                                              letterSpacing: 1.3,
                                              fontWeight: FontWeight.w500
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
                                          'Note:',

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
                                            '${widget.expenseModel.note}',
                                        
                                            style: const TextStyle(
                                              fontSize: 18,
                                              letterSpacing: 1.3,
                                              fontWeight: FontWeight.w500
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