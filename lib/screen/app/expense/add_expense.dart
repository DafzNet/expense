
// ignore_for_file: use_build_context_synchronously

import 'package:expense/dbs/category_db.dart';
import 'package:expense/dbs/expense.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/utils/month.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import '../../../dbs/income_db.dart';
import '../../../models/category_model.dart';
import '../../../models/income_model.dart';
import '../../../providers/expense_provider.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/selection_sheet.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/text_field.dart';
import '../more/screen/income/add_income.dart';

class AddExpenseScreen extends StatefulWidget {

  final ExpenseModel? expenseModel;
  final bool edit;

  const AddExpenseScreen({
    this.expenseModel,
    this.edit = false,
    super.key
    });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {


  final expenseDb = ExpenseDb();
  final incomeDb = IncomeDb();
  final categoryDb = CategoryDb();

  List<IncomeModel> monthlyIncomes =[];
  List<CategoryModel> categories =[];

  void getmonthlyIncomes()async{
    final Filter filter = Filter.and([Filter.equals('month', Month().currentMonthNumber), Filter.equals('year', DateTime.now().year)]);
    monthlyIncomes = await incomeDb.retrieveBasedOn(filter);

    setState(() {
      
    });
  }

  void getCategories()async{
    categories = await categoryDb.retrieveData();

    setState(() {
      
    });
  }

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final dateeController = TextEditingController();
  final categoryController = TextEditingController();
  final incomeController = TextEditingController();
  final noteController = TextEditingController();


  CategoryModel? category;
  IncomeModel? income;
  


  DateTime? _date = DateTime.now();



  void getCat(cat){
    
    categoryController.text = cat.name;
    category = cat;

    setState(() {
      
    });
  }


  void getIncome(inc){
    
    incomeController.text = inc.name;
    income = inc;

    setState(() {
      
    });
  }



  bool loading = false;


  @override
  void initState() {
    getCategories();
    getmonthlyIncomes();
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
          'Add Expense',
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
                                    headerText: 'Espense title',
                                    controller: titleController,
                                  ),
                                                      
                                  const SizedBox(height: 30,),
                                  
                                  MyTextField(
                                    '',
                                    headerText: 'Amount',
                                    keyboardType: TextInputType.number,
                                    controller: amountController,
                                  ),
                                                      
                                                      
                                  const SizedBox(height: 30,),
                                  
                                  MyTextField(
                                    DateFormat.yMMMEd().format(DateTime.now()),
                                    headerText: 'Expense Date',
                                    makeButton: true,
                                    controller: dateeController,

                                    onTap: ()async{
                                      var d = await showDatePicker(
                                        context: context, 
                                        initialDate: DateTime.now(), 
                                        firstDate: DateTime.now().subtract(const Duration(days: 366)), 
                                        lastDate: DateTime.now().add(const Duration(days: 366)))??DateTime.now();

                                      _date = DateTime(d.year, d.month, d.day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);

                                      dateeController.text = DateFormat.yMMMEd().format(d);
                                      setState((){});
                                    },
                                  ),


                                  const SizedBox(height: 30,),
                                  
                                  MyTextField(
                                    'Select category',
                                    headerText: 'Category',
                                    makeButton: true,
                                    controller: categoryController,

                                    onTap: ()async{
                                      await optionWidget(
                                        
                                        context,
                                        heading: 'Select category',
                                        options: categories.isNotEmpty? categories : [CategoryModel(id: 1, name: 'No category added yet', description: '')],

                                        onTap: getCat//categories.isNotEmpty? getCat : null,
                                      );
                                    },
                                  ),
                                                      
                                                      
                                  const SizedBox(height: 30,),
                                  
                                  MyTextField(
                                    'choose income spent for this expense',
                                    makeButton: true,
                                    headerText: 'Income Spent',
                                    controller: incomeController,

                                    onTap: ()async{
                                      await optionWidget(
                                        context,
                                        heading: 'Select Income',
                                        options: monthlyIncomes.isNotEmpty? monthlyIncomes:[IncomeModel(id: 1, name: 'No Income yet. add an income to continue', amount: 000, balance: 00, date: DateTime.now())],

                                        onTap: monthlyIncomes.isNotEmpty? getIncome:(a){
                                          Navigator.pop(context);
                                          
                                        },
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
                                    text: 'Submit',


                                    onTap: ()async{
                                      if(
                                        titleController.text.isEmpty
                                      ){
                                        ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            financeSnackBar('please enter title')
                                          );
                                      }
                                      else if(
                                        amountController.text.isEmpty
                                      ){
                                        ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            financeSnackBar('please enter the amount')
                                          );
                                      }
                                      else if(
                                        categoryController.text.isEmpty
                                      ){
                                        ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            financeSnackBar('select a category')
                                          );
                                      }
                                      else if(
                                        incomeController.text.isEmpty
                                      ){
                                        ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            financeSnackBar('select the income spent')
                                          );
                                      }
                                      else{
                                        setState(() {
                                          loading = true;
                                        });

                                        if(income!.balance < double.parse(amountController.text)){
                                          ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                              financeSnackBar('Insufficient funds in \'${income!.name}\' for this expense')
                                            );

                                            setState(() {
                                          loading = false;
                                        });
                                        }
                                        else{

                                          IncomeDb incomeDb = IncomeDb();
                                          double bal = income!.balance - double.parse(amountController.text);
                                          income = income!.copyWith(
                                            balance: bal
                                          );

                                          ExpenseModel expense = ExpenseModel(
                                          id: DateTime.now().millisecondsSinceEpoch, 
                                          title: titleController.text, 
                                          date: _date!,
                                          amount: double.parse(amountController.text),
                                          note: noteController.text,
                                          month: _date!.month,
                                          day: _date!.day,
                                          year: _date!.year,
                                          income: income,
                                          category: category
                                        );

                                        Provider.of<ExpenseProvider>(context, listen: false).add(double.parse(amountController.text));

                                        
                                        await expenseDb.addData(
                                          expense
                                        );

                                        await incomeDb.updateData(income!);

                                        setState(() {
                                          loading = false;
                                        });

                                        Navigator.pop(context);

                                      }

                                      }
                                    }
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