
// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:expense/dbs/category_db.dart';
import 'package:expense/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sembast/sembast.dart';

import '../../../../../dbs/budget_db.dart';
import '../../../../../dbs/expense.dart';
import '../../../../../models/budget.dart';
import '../../../../../models/category_model.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/currency/currency.dart';
import '../../../../../utils/month.dart';
import '../../../../../widgets/default_button.dart';
import '../../../../../widgets/loading.dart';
import '../../../../../widgets/selection_sheet.dart';
import '../../../../../widgets/snack_bar.dart';
import '../../../../../widgets/text_field.dart';


class AddBudgetScreen extends StatefulWidget {

  const AddBudgetScreen({
    super.key
    });

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {

  final categoryDb = CategoryDb();
   final budgetDb = BudgetDb();


  List<CategoryModel> categories =[];

  void getCategories()async{
    categories = await categoryDb.retrieveData();
    setState(() {
      
    });
  }

  final categoryController = TextEditingController();
  final amountController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final noteController = TextEditingController();
  final titleController = TextEditingController();


  CategoryModel? category;
  BudgetModel? budget;
  


  DateTime? _starDate = DateTime.now();
  DateTime? _endDate = DateTime.now().add(const Duration(days: 30));



  void getCat(cat){
    
    categoryController.text = cat.name;
    category = cat;

    setState(() {
      
    });
  }


  bool loading = false;
  bool useCurrentMonth = true;

  @override
  void initState() {
    getCategories();
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
          'Add Budget',
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
                                    'Give this budget a name',
                                    headerText: 'Title',
                                    maxLines: 3,
                                    controller: titleController,
                                  ),
                                  
                                  const SizedBox(height: 30,),

                                  MyTextField(
                                    'Select category',
                                    headerText: 'Category',
                                    makeButton: true,
                                    controller: categoryController,
                                    bottomHint: 'category links a budget with the respective expenses',

                                    onTap: ()async{
                                      await optionWidget(
                                        
                                        context,
                                        heading: 'Select category',
                                        options: categories.isNotEmpty? categories : [CategoryModel(id: 1, name: 'No category added yet', description: '')],

                                        onTap: categories.isNotEmpty? getCat : null,
                                      );
                                    },
                                  ),
                                                      
                                                                          
                                  const SizedBox(height: 30,),
                                  
                                  MyTextField(
                                    Currency().currencySymbol,
                                    headerText: 'Budgeted Amount',
                                    keyboardType: TextInputType.number,
                                    controller: amountController,
                                  ),

                                if(!useCurrentMonth)...
                                  [
                                    const SizedBox(height: 30,),
                                    
                                    MyTextField(
                                      DateFormat.yMMMEd().format(_starDate!),
                                      headerText: 'Start Date',
                                      makeButton: true,
                                      controller: startDateController,

                                      onTap: ()async{
                                        var d = await showDatePicker(
                                          context: context, 
                                          initialDate: DateTime.now(), 
                                          firstDate: DateTime.now().subtract(const Duration(days: 366)), 
                                          lastDate: DateTime.now().add(const Duration(days: 366)))??DateTime.now();

                                        _starDate = DateTime(d.year, d.month, d.day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);

                                        startDateController.text = DateFormat.yMMMEd().format(d);
                                        setState((){});
                                      },
                                    ),
                                                        
                                                        
                                    const SizedBox(height: 30,),
                                    
                                    MyTextField(
                                      'choose end date',
                                      headerText: 'End Date',
                                      makeButton: true,
                                      controller: endDateController,

                                      onTap: ()async{
                                        var d = await showDatePicker(
                                          context: context, 
                                          initialDate: DateTime.now(), 
                                          firstDate: _starDate!.add(const Duration(days: 2)), 
                                          lastDate: DateTime.now().add(const Duration(days: 366)))??DateTime.now();

                                        _endDate = DateTime(d.year, d.month, d.day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);

                                        endDateController.text = DateFormat.yMMMEd().format(d);
                                        setState((){});
                                      },
                                    ),
                                  ],

                                  const SizedBox(height: 30,),
                                  
                                  
                                  MyTextField(
                                    'optional',
                                    headerText: 'Note',
                                    maxLines: 3,
                                    controller: noteController,
                                  ),

                                  const SizedBox(height: 20,),

                                  CheckboxListTile(
                                    value: useCurrentMonth,
                                    activeColor: appOrange,
                                    title: const Text('Use current month as duration'),
                                    contentPadding: const EdgeInsets.all(0),
                                    onChanged: (month){
                                      useCurrentMonth = month!;

                                      setState(() {
                                        
                                      });
                                    }),
                                                      
                                                      
                                                      
                                  const SizedBox(height: 50,),
                                                      
                                                      
                                   DefaultButton(
                                    text: 'Add Budget',


                                    onTap: ()async{
                                      if (titleController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            financeSnackBar('please enter title')
                                          );
                                      } else if(categoryController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            financeSnackBar('choose a category')
                                          );
                                      } else if(amountController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            financeSnackBar('Enter the amount for this budget')
                                        );
                                      } else if(!useCurrentMonth && endDateController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            financeSnackBar('choose end date or use current month as duration')
                                          );
                                      }else if(!useCurrentMonth && _endDate!.isBefore(_starDate!)) {
                                        ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            financeSnackBar('start date should be before end date')
                                          );
                                      }else{
                                        loading = true;

                                        setState(() {
                                          
                                        });

                                        if(useCurrentMonth) {
                                          _endDate = _starDate; 
                                        }


                                        //Before adding budget check to see if expenses with same category
                                        //already exists and subtract respectively

                                        //filter by category
                                        Filter filter = Filter.custom((record){
                                          final data = record.value as Map<String, dynamic>;
                                          CategoryModel myCat = CategoryModel.fromMap(data['category']);

                                          return myCat == category;
                                        });

                                        final expenseDb = ExpenseDb();

                                        List<ExpenseModel> expenses = await expenseDb.retrieveBasedOn(
                                          Filter.and(
                                            [
                                              filter,
                                              Filter.or(
                                                [
                                                  Filter.and(
                                                    [
                                                      Filter.equals('month', Month().currentMonthNumber),
                                                      Filter.equals('year', DateTime.now().year),
                                                    ]
                                                  ),

                                                  Filter.and(
                                                    [
                                                      Filter.greaterThanOrEquals('date', _starDate!.millisecondsSinceEpoch),
                                                      Filter.lessThanOrEquals('date', _endDate!.millisecondsSinceEpoch)
                                                    ]
                                                  )
                                                ]
                                              )
                                            ]
                                          )
                                        );

                                        double _catBal = double.parse(amountController.text);

                                        ///subtract each expense amount from this categoey
                                        for (var exp in expenses) {
                                          _catBal = _catBal - exp.amount;
                                        }


                                        BudgetModel _budget = BudgetModel(
                                          id: DateTime.now().millisecondsSinceEpoch, 
                                          name: titleController.text, 
                                          amount: double.parse(amountController.text), 
                                          balance: _catBal,
                                          category: category,
                                          startDate: _starDate,
                                          endDate: _endDate,
                                          day: _endDate!.day,
                                          month: Month().currentMonthNumber, 
                                          year: _endDate!.year
                                        );


                                        await budgetDb.addData(_budget);

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