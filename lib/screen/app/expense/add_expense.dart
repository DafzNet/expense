
import 'package:expense/dbs/expense.dart';
import 'package:expense/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../providers/expense_provider.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/text_field.dart';

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

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final dateeController = TextEditingController();
  final sourceController = TextEditingController();
  final noteController = TextEditingController();


  DateTime? _date = DateTime.now();


  void _edit(){
    if (widget.expenseModel != null) {
       titleController.text = widget.expenseModel != null? widget.expenseModel!.title:'';
        amountController.text = widget.expenseModel != null? widget.expenseModel!.amount.toString():'';
        dateeController.text = widget.expenseModel != null? DateFormat.yMMMEd().format(widget.expenseModel!.date):DateFormat.yMMMEd().format(DateTime.now());
        sourceController.text = widget.expenseModel != null? widget.expenseModel!.fundSource!:'';
        noteController.text = widget.expenseModel != null? widget.expenseModel!.note!:'';

        _date = widget.expenseModel!.date;
    }

    setState(() {
      
    });
  }




  bool loading = false;


  @override
  void initState() {
    _edit();
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
                                    '',
                                    headerText: 'Source of Fund',
                                    controller: sourceController,
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
                                        titleController.text.isNotEmpty&&
                                        amountController.text.isNotEmpty&&
                                        sourceController.text.isNotEmpty
                                      ){
                                        setState(() {
                                          loading = true;
                                        });


                                        ExpenseModel expense = ExpenseModel(
                                          id: DateTime.now().millisecondsSinceEpoch, 
                                          title: titleController.text, 
                                          date: _date!,
                                          amount: double.parse(amountController.text),
                                          note: noteController.text,
                                          fundSource: sourceController.text
                                        );

                                        if (!widget.edit) {
                                          await expenseDb.addData(
                                            expense.toMap()
                                          );

                                          Provider.of<ExpenseProvider>(context, listen: false).add(double.parse(amountController.text));
                                        }else{
                                          await expenseDb.updateData(expense.toMap(), widget.expenseModel!.id);
                                          Provider.of<ExpenseProvider>(context, listen: false).subtract(widget.expenseModel!.amount);
                                          Provider.of<ExpenseProvider>(context, listen: false).add(double.parse(amountController.text));
                                        }

                                        

                                        setState(() {
                                          loading = false;
                                        });

                                        Navigator.pop(context);

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