
import 'package:expense/dbs/income_db.dart';
import 'package:expense/models/income_model.dart';
import 'package:expense/screen/app/more/screen/income/add_income.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';
import '../../../../../procedures/income/income_procedure.dart';
import '../../../../../utils/capitalize.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../widgets/income_card.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});
  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {

  final IncomeDb incomeDb = IncomeDb();
  Database? db;

  void getIncomDB()async{
    db = await incomeDb.openDb();
    setState(() {
      
    });
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    getIncomDB();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: const Text('Income'),
        
          ),
        ],

/////////////////////////////
////////////////////////////
        body: db != null ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: StreamBuilder<List<IncomeModel>>(
            initialData: [],
            stream: incomeDb.onIncome(db!),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Column();
              }
              
              final incomesForMonth = snapshot.data;

              return incomesForMonth!.isNotEmpty ?  ListView.builder(
                itemCount: incomesForMonth.length,

                itemBuilder: (context, index){
                  return IncomeCard(
                    onDelete: (){
                      showDialog(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            //backgroundColor: appOrange,
                            title: Text('Delete ${capitalize(incomesForMonth[index].name!)}'),
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
                                  
                                  await deleteIncomeProcedure(incomesForMonth[index], context);//expenseDb.deleteData(widget.expenseModel);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );}
                        );
                    },


                    income: incomesForMonth[index]
                  );
                }
              )
              :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text('No Income added yet'),
                  )
                ],
              );
            }
          )
        ) 
        
        :

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        )
        
        ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            PageTransition(
              child: AddIncomeScreen(),
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
