// ignore_for_file: use_build_context_synchronously

import 'package:expense/dbs/budget_db.dart';
import 'package:expense/models/plan_model.dart';
import 'package:expense/widgets/cards/planner_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sembast/sembast.dart';

import '../../../../../dbs/planner_db.dart';
import '../../../../../models/budget.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/month.dart';
import '../../../../../widgets/default_button.dart';
import '../../../../../widgets/snack_bar.dart';
import '../../../../../widgets/text_field.dart';

class BudgetPlanner extends StatefulWidget {
  final bool create;
  final BudgetModel? budget;
  const BudgetPlanner({
    this.create = false,
    this.budget,
    super.key});

  @override
  State<BudgetPlanner> createState() => _BudgetPlannerState();
}

class _BudgetPlannerState extends State<BudgetPlanner> {

  BudgetDb budgetDb = BudgetDb();
  List<BudgetModel> budgets = [];

  void getBudgets()async{
    budgets = await budgetDb.retrieveBasedOn(
            Filter.custom((record){
              final budg = record.value as Map<String, dynamic>;
              final myBudg = BudgetModel.fromMap(budg);

              if (myBudg.startDate == myBudg.endDate) {
                return myBudg.month == Month().currentMonthNumber && myBudg.year == DateTime.now().year;
              }else{
                return DateTime.now().isAfter(myBudg.startDate!) && DateTime.now().isBefore(myBudg.endDate!);
              }
          }
        )
    );

    setState(() {
      
    });
  }

  //int selectedBud = 0;

  final plannerDb = PlannerDb();
  Database? db;


  TextEditingController titleController = TextEditingController();
  final desController = TextEditingController();
  final budgetController = TextEditingController();

  void getPlanners()async{
    db = await plannerDb.openDb();
    setState(() {
      
    });
  }

  bool saving = false;
  bool? _create;

  void createPlanner()async{
      await Future.delayed(const Duration(milliseconds: 200),
      ()async{
        return await addPlanner(context);
      }
    );
  }


  BudgetModel? budget;




  @override
  void initState() {
    _create = widget.create;
    getBudgets();

    if(widget.budget!=null){
      budget = widget.budget;
      budgetController.text = widget.budget!.name;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    getPlanners();

    if (_create == true) {
      if(widget.budget!=null){
        budget = widget.budget;
        budgetController.text = widget.budget!.name;
      }
      createPlanner();
      _create = false;
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: const Text('Planners'),
            actions: [
              IconButton(onPressed: ()async{
                showMenu(
                  context: context, 
                  position: const RelativeRect.fromLTRB(200, 70, 30, 0), items: [
                    const PopupMenuItem(
                      child: Text('A Planner holds a list of items you intend to get (a service or a good).This helps a user avoid impulse purchases. Planners have integrated financial algorithms that suggests what to go for based on your preferences in a situation of limited finances')
                    )
                  ]);
              }, icon: const Icon(MdiIcons.helpCircleOutline))
            ],
        
          ),
        ],
      body: db != null ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: StreamBuilder<List<PlannerModel>>(
            initialData: const [],
            stream: plannerDb.onPlanners(db!),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Column();
              }
              
              final planners = snapshot.data;
              
              planners?.sort((a,b){
                return b.date.compareTo(a.date);
              });



              return planners!.isNotEmpty ?  ListView.builder(
                itemCount: planners.length,

                itemBuilder: (context, index){
                  return PlannerCard(
                    index: index+1,
                    planner: planners[index],
                    ctx: context
                  );
                }
              )
              :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text('No Planner added yet'),
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
        onPressed: ()async{
          await addPlanner(context);
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

  Future<dynamic> addPlanner(BuildContext context) {
    return showModalBottomSheet(
                  context: context, 
                  builder: (ctx){
                    return SizedBox(
                      height: 500,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                        child: Container(
                          color: Colors.white,

                          padding: const EdgeInsets.symmetric(horizontal: 12),

                          child: saving ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Center(child: CircularProgressIndicator())
                            ],
                          ) : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 12, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Add a Planner',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),


                                      IconButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        } , icon: const Icon(MdiIcons.closeCircleOutline))
                                    ],
                                  ),
                                ),
                          
                                const Divider(height: 30,),

                                MyTextField(
                                  'planner name',
                                  headerText: 'Title',
                                  controller: titleController,
                                ),
                          

                                if(budgets.isNotEmpty || widget.budget!=null)...
                                [const SizedBox(
                                  height: 15,
                                ),

                                 

                                MyTextField(
                                  '',
                                  headerText: 'Choose Budget',
                                  controller: budgetController,
                                  makeButton: true,
                                ),

                                const SizedBox(
                                  height: 5,
                                ),

                                SizedBox(
                                  height: 80,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                
                                    children: List.generate(budgets.length, (index){
                                      return GestureDetector(
                                        onTap: (){
                                          budgetController.text = budgets[index].name;
                                          budget = budgets[index];
                                          setState(() {
                                            
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 4),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            width: 100,
                                            decoration: BoxDecoration(
                                            
                                              border: Border.all(color: appOrange, width: .5),
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text(
                                                budgets[index].name,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              )
                                              )
                                            
                                            ),
                                        ),
                                      );

                                    }),
                                  ),
                                ),
                                
                                
                                
                                ],


                                const SizedBox(
                                  height: 15,
                                ),
                          
                                MyTextField(
                                  '',
                                  headerText: 'Description',
                                  controller: desController,
                                ),
                          
                                const SizedBox(height: 25,),
                          
                                DefaultButton(
                                  onTap: () async{

                                    if (titleController.text.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        financeSnackBar('Title field cannot be empty')
                                      );
                                    }
                                     else {

                                    final planner = PlannerModel(
                                      id: DateTime.now().millisecondsSinceEpoch,
                                      date: DateTime.now(),
                                      name: titleController.text,
                                      budget: budget,
                                      description: desController.text
                                    );


                                    await plannerDb.addData(planner);

                                    Navigator.pop(context);

                                    }

                                  },
                                ),

                                const SizedBox(height: 250,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                );
  }
}