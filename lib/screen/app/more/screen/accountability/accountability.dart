

import 'package:expense/dbs/expense.dart';
import 'package:expense/dbs/income_db.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/models/income_model.dart';
import 'package:expense/models/user_model.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:expense/utils/constants/images.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Accountability extends StatefulWidget {
  final LightUser user;
  const Accountability({
    required this.user,
    super.key});

  @override
  State<Accountability> createState() => _AccountabilityState();
}

class _AccountabilityState extends State<Accountability> {

  ExpenseDb expenseDb = ExpenseDb();
  IncomeDb incomeDb = IncomeDb();


  List<ExpenseModel> expenses = [];
  List<IncomeModel> incomes = [];

  void getData()async{
    incomes = await incomeDb.retrieveData();
    expenses = await expenseDb.retrieveData();

    setState(() {
      
    });
  }


  int index = 0;


  @override
  void initState() {
    getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Statements'),

        actions: [
          Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Choose Period'
                      ),
                
                      const Icon(
                        MdiIcons.chevronDown
                      )
                    ],
                  ),
                ),
              ),
        ],

      ),

      body: Stack(
        
        children: [

          Center(
            child: Opacity(
              opacity: .1,
              child: Image.asset(
                'assets/icons/still/lifi_logo.png',
            
                width: MediaQuery.of(context).size.width-100,
                height: MediaQuery.of(context).size.width-100,
            
                colorBlendMode: BlendMode.colorDodge,
            
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(
            children: [

              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: appOrange
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'LiFi',
                  
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.user.firstName! + ' '+ widget.user.lastName!,
                    
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black
                          ),
                        ),

                        Image.asset(
                          lifiIcon,
                          height: 30,
                          width: 30,
                        )
                      ],
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:const[
                        Text(
                          'Income and expense statement for the period of June - July',
                    
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),



////////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [

                      Container(
                        color: appOrange.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('Expenses',
                                style: TextStyle(
                                  fontSize: 16,
                                  
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('S/N')),
                            DataColumn(label: Text('Title')),
                            DataColumn(label: Text(
                              'Amount' + ' (${Currency(context).currencySymbol})'
                            )),
                            DataColumn(label: Text('Income')),
                            DataColumn(label: Text('Category')),
                            DataColumn(label: Text('Date')),
                          ], 
                          
                          rows: List.generate(expenses.length, (index){
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text((index+1).toString())
                                ),
                      
                                DataCell(
                                  Text(expenses[index].title),
                                ),
                      
                                DataCell(
                                  Text(expenses[index].amount.toString())
                                ),
                      
                                DataCell(
                                  Text(expenses[index].income!.name!)
                                ),
                      
                                DataCell(
                                  Text(expenses[index].category!.name)
                                ),
                      
                                DataCell(
                                  Text(
                                    DateFormat.yMMMd().format(expenses[index].date)
                                  )
                                )
                              ]
                            );
                          })
                          
                        ),
                      ),

                      Container(
                        color: appOrange.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('Incomes',
                                style: TextStyle(
                                  fontSize: 16,
                                  
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('S/N')),
                            DataColumn(label: Text('Title')),
                            DataColumn(label: Text(
                              'Amount' + ' (${Currency(context).currencySymbol})'
                            )),
                            DataColumn(label: Text('Source')),
                            DataColumn(label: Text('Vault')),
                            DataColumn(label: Text('Date')),
                          ], 
                          
                          rows: List.generate(incomes.length, (index){
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text((index+1).toString())
                                ),
                      
                                DataCell(
                                  Text(incomes[index].name!),
                                ),
                      
                                DataCell(
                                  Text(incomes[index].amount.toString())
                                ),
                      
                                DataCell(
                                  Text(incomes[index].source!)
                                ),
                      
                                DataCell(
                                  Text(incomes[index].incomeVault!.name)
                                ),
                      
                                DataCell(
                                  Text(
                                    DateFormat.yMMMd().format(incomes[index].date)
                                  )
                                )
                              ]
                            );
                          })
                          
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 60,
                child: Container(
                  color: appOrange,
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}