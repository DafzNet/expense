
import 'package:expense/dbs/budget_db.dart';
import 'package:expense/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../widgets/cards/budget_card.dart';
import 'add_budget.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {

  final BudgetDb budgetDb = BudgetDb();
  Database? db;

  void getBudgetDB()async{
    db = await budgetDb.openDb();
    setState(() {
      
    });
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getBudgetDB();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: const Text('Budgets'),
        
          ),
        ],

/////////////////////////////
////////////////////////////
        body: db != null ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: StreamBuilder<List<BudgetModel>>(
            initialData:[],
            stream: budgetDb.onBudgets(db!),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Column();
              }
              
              final budgetForMonth = snapshot.data;
              budgetForMonth?.sort((a,b){
                return b.startDate!.compareTo(a.startDate!);
              });

              return budgetForMonth!.isNotEmpty ?  ListView.builder(
                itemCount: budgetForMonth.length,

                itemBuilder: (context, index){
                  return BudgetCard(budget: budgetForMonth[index], ctx: context,);
                }
              )
              :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text('No Budgets added yet'),
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
              child: const AddBudgetScreen(),
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
