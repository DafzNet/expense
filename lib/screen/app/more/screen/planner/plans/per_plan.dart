// ignore_for_file: use_build_context_synchronously

import 'package:expense/dbs/planner_db.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:expense/widgets/default_button.dart';
import 'package:expense/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';

import '../../../../../../dbs/budget_db.dart';
import '../../../../../../dbs/plan_exp_db.dart';
import '../../../../../../models/budget.dart';
import '../../../../../../models/plan_exp.dart';
import '../../../../../../models/plan_model.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/month.dart';
import '../../../../../../utils/rank.dart';
import '../../../../../../widgets/cards/plan_exp_card.dart';

class PlannerDetail extends StatefulWidget {

  final PlannerModel plannerModel;

  const PlannerDetail(
    this.plannerModel,
    {super.key});

  @override
  State<PlannerDetail> createState() => _PlannerDetailState();
}

class _PlannerDetailState extends State<PlannerDetail> {

  BudgetModel? budget;
  BudgetDb budgetDb = BudgetDb();
  PlannerDb plannerDb = PlannerDb();

  BudgetModel? _budget;

  plannerBudget()async{
    if (widget.plannerModel.budget != null) {
      final myBudget = await budgetDb.retrieveBasedOn(
        Filter.equals('id', widget.plannerModel.budget!.id)
      );

      _budget = myBudget.first;

    }

    setState(() {
      
    });
  }




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




  int? rankValue;
  String rankText = 'Rank By';


  Set<PlanExpModel> plans = {};


  final plannerExpDb = PlannerExpDb();
  Database? db;

  double total = 0;


  getTotal()async{
    final plans = await plannerExpDb.retrieveBasedOn(
      Filter.custom((record){
          final data = record.value as Map<String, dynamic>;
          final plan = PlanExpModel.fromMap(data);
          return plan.planner == widget.plannerModel;
        })
    );

    for (var element in plans) {
      total += element.price;
    }

    setState(() {
      
    });
  }

  getNewTotal(double t){
    total += t;

    setState(() {
      
    });
  }


  subNewTotal(double t){
    total -= t;

    setState(() {
      
    });
  }


  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final prefController = TextEditingController();
  final satisfactionController = TextEditingController();

  void getPlannerExps()async{
    db = await plannerExpDb.openDb();
    setState(() {
      
    });
  }

  bool saving = false;

  @override
  void initState() {
    plannerBudget();

    getTotal();
    getBudgets();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    getPlannerExps();

    return Scaffold(

      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
        title: Text(
          widget.plannerModel.name!),
            actions: [
              DropdownButton(
                hint: Text(
                  rankText,

                  style: const TextStyle(
                        fontSize: 12
                      ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Price',
                    child: Text(
                      'Price',

                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ),

                  DropdownMenuItem(
                    value: 'Satisfaction',
                    child: Text(
                      'Satisfaction',

                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ),


                  DropdownMenuItem(
                    value: 'Preference',
                    child: Text(
                      'Preference',

                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ),

                  DropdownMenuItem(
                    value: 'Cost-Benefit',
                    child: Text(
                      'Cost-Benefit',

                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ),

                  DropdownMenuItem(
                    value: 'Weighted Averages',
                    child: Text(
                      'Weighted Averages',

                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ),

                  DropdownMenuItem(
                    value: 'TOPSIS',
                    child: Text(
                      'TOPSIS',

                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ),


                  DropdownMenuItem(
                    value: 'AHP',
                    child: Text(
                      'AHP',

                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ),
                ], 
                onChanged: (n){
                  rankText = n!;
                  setState(() {
                    
                  });
                }),

              IconButton(
                onPressed: ()async{
                  await showModalBottomSheet(
                    context: context, 
                    builder: (context){
                      return SizedBox(
                        height: MediaQuery.of(context).size.height-200,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                          child: Container(
                            color: Colors.white,

                            padding: const EdgeInsets.symmetric(horizontal: 12),

                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Add Likely Expense to Plan',
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
                                    'What do you plan on spending',
                                    headerText: 'Title',
                                    controller: titleController,
                                  ),
                            
                                  const SizedBox(
                                    height: 15,
                                  ),
                            
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: MyTextField(
                                          Currency(context).currencySymbol,
                                          headerText: 'Price',
                                          keyboardType: TextInputType.number,
                                          controller: priceController,
                                        ),
                                      ),
                            
                                      const SizedBox(width: 10,),
                            
                                      SizedBox(
                                        width: 170,
                                        child: MyTextField(
                                          '1 - 10',
                                          headerText: 'Scale of Preference',
                                          keyboardType: TextInputType.number,
                                          controller: prefController,
                                        ),
                                      )
                                    ],
                                  ),
                            
                                  const SizedBox(height: 15,),
                            
                                  MyTextField(
                                    '1 - 10',
                                    headerText: 'Estimated Level of Satisfaction',
                                    keyboardType: TextInputType.number,
                                    controller: satisfactionController,
                                  ),
                            
                                  const SizedBox(height: 25,),
                            
                                  DefaultButton(
                                    text: 'Add',

                                    onTap: () async{

                                      if (titleController.text.isNotEmpty && priceController.text.isNotEmpty
                                          && prefController.text.isNotEmpty && satisfactionController.text.isNotEmpty &&
                                          int.parse(prefController.text)>=1 && int.parse(prefController.text)<=10 &&
                                          int.parse(satisfactionController.text)>=1 && int.parse(satisfactionController.text)<=10
                                      ) {
                                        final plan = PlanExpModel(
                                        id: DateTime.now().millisecondsSinceEpoch, 
                                        planner: widget.plannerModel, 
                                        name: titleController.text, 
                                        price: double.parse(priceController.text), 
                                        scaleOfPref: int.parse(prefController.text), 
                                        satisfaction: int.parse(satisfactionController.text)
                                      );


                                      await plannerExpDb.addData(plan);

                                      getNewTotal(double.parse(priceController.text));

                                      Navigator.pop(context);
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 200,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  );
              }, icon: const Icon(MdiIcons.plusCircleOutline))
            ],
      ),

      body: db != null ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [

              SizedBox(
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: appSuccess.shade500,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Planned Total:',
                          
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                    ),
                                  ],
                                ),
                          
                                Row(
                                  children: [
                                    Text(
                                      Currency(context).wrapCurrencySymbol(double.parse(total.toString()).toStringAsFixed(0)),
                          
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: double.parse(total.toString()).toStringAsFixed(0).length<=8?20:16,
                                      fontWeight: FontWeight.bold
                                    ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                          SizedBox(width: 10,),

                          SizedBox(
                            height: 100,
                            width: 1,

                            child: Container(
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(width: 10,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if(widget.plannerModel.budget != null)...
                                [
                                  const Text(
                                    'Budget:',

                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12
                                    ),
                                  ),

                                  Text(
                                    widget.plannerModel.budget!.name,

                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),

                                  const Text(
                                    'Budget Balance:',

                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12
                                    ),
                                  ),

                                  Text(
                                    Currency(context).wrapCurrencySymbol(_budget!.balance.toString()),

                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),


                                  Text(
                                    'plan is ' +double.parse(((total/_budget!.balance)*100).toString()).toStringAsFixed(0)+'% of budget balance',

                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                    ),
                                  ),
                                ]else...[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: TextButton.icon(
                                          onPressed: ()async{
                                            await showModalBottomSheet(
                                              context: context, 
                                              builder: (context){
                                                return SizedBox(
                                                  height: 699,
                                                  child: ClipRRect(
                                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                                    child: Container(
                                                      color: Colors.white,

                                                      padding: const EdgeInsets.symmetric(horizontal: 12),

                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(10),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                const Text('Choose Budget',
                                                                    style: TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.bold
                                                                    ),
                                                                  ),


                                                                  IconButton(
                                                                    onPressed: (){
                                                                      Navigator.pop(context);
                                                                    }, 
                                                                    icon: Icon(
                                                                      MdiIcons.closeCircleOutline,
                                                                      color: appDanger,
                                                                    )
                                                                  )

                                                              
                                                                ],
                                                            ),
                                                          ),

                                                          Expanded(
                                                            child: ListView.builder(
                                                              itemCount: budgets.length,
                                                              itemBuilder: (context, index){
                                                                return ListTile(
                                                                  onTap: () async{

                                                                    final updated = widget.plannerModel.copyWith(
                                                                      budget: budgets[index]
                                                                    );

                                                                    await plannerDb.updateData(updated);

                                                                    Navigator.pop(context);

                                                                    Navigator.pushReplacement(
                                                                      context,
                                                                      PageTransition(
                                                                      child: PlannerDetail(
                                                                        updated
                                                                      ), 
                                                                      type: PageTransitionType.rightToLeft)
                                                                    );

                                                                     
                                                                  },
                                                                  title: Text(
                                                                    budgets[index].name
                                                                  ),
                                                                );
                                                              }
                                                            )
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            );                                      
                                          }, 
                                          icon: Icon(
                                            MdiIcons.plusCircleOutline,
                                            color: Colors.white,
                                          ), 
                                          label: Text(
                                            'Attach a budget',
                                            style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                          ),
                                            )),
                                      ),
                                    ],
                                  )                                  
                                ]
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),


              Expanded(
                child: StreamBuilder<List<PlanExpModel>>(
                  initialData: [],
                  stream: plannerExpDb.onPlanners(db!, plannerModel: widget.plannerModel),
                  builder: (context, snapshot){
                    if(snapshot.hasError){
                      return Column();
                    }
                    
                    List<PlanExpModel>? planners = snapshot.data;

                    if (rankText == 'Weighted Averages') {
                      planners = Ranker(planners!).weightedAverages;

                      
                    }else if (rankText == 'Preference') {
                      planners = Ranker(planners!).preferences;
                    }else if (rankText == 'Cost-Benefit') {
                      planners = Ranker(planners!).costBenefit;
                    }else if (rankText == 'Price') {
                      planners = Ranker(planners!).price;
                    }else if (rankText == 'Satisfaction') {
                      planners = Ranker(planners!).satisfaction;
                    }
                    else{
                      planners?.sort((a,b){
                      return b.date!.compareTo(a.date!);
                    });
                    }
                    
                    

                    plans.addAll(planners!);
              
                    return planners.isNotEmpty ?  ListView.builder(
                      itemCount: planners.length,
              
                      itemBuilder: (context, index){
                        return PlanCard(
                          index: index+1,
                          plannerExp: planners![index],
                          ctx: context,
                          onDel: (){
                            subNewTotal(planners![index].price);
                          },
                        );
                      }
                    )
                    :
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text('No items added to ${widget.plannerModel.name} yet'),
                        )
                      ],
                    );
                  }
                ),
              ),
            ],
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
  
    );
  }
}