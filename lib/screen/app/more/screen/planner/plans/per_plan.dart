// ignore_for_file: use_build_context_synchronously

import 'package:expense/utils/currency/currency.dart';
import 'package:expense/widgets/default_button.dart';
import 'package:expense/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sembast/sembast.dart';

import '../../../../../../dbs/plan_exp_db.dart';
import '../../../../../../models/plan_exp.dart';
import '../../../../../../models/plan_model.dart';
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

  int? rankValue;
  String rankText = 'Rank By';


  final plannerExpDb = PlannerExpDb();
  Database? db;


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
  Widget build(BuildContext context) {

    getPlannerExps();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: Text(widget.plannerModel.name!),
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
                    value: 'Weighted Averages',
                    child: Text(
                      'Weighted Average',

                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ),

                  DropdownMenuItem(
                    value: 'Marginal Utility',
                    child: Text(
                      'Marginal Utility',

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

                                      

                                      final plan = PlanExpModel(
                                        id: DateTime.now().millisecondsSinceEpoch, 
                                        planner: widget.plannerModel, 
                                        name: titleController.text, 
                                        price: double.parse(priceController.text), 
                                        scaleOfPref: int.parse(prefController.text), 
                                        satisfaction: int.parse(satisfactionController.text)
                                      );


                                      await plannerExpDb.addData(plan);

                                      Navigator.pop(context);
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
        ],
      body: db != null ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<PlanExpModel>>(
                  initialData: const [],
                  stream: plannerExpDb.onPlanners(db!, plannerModel: widget.plannerModel),
                  builder: (context, snapshot){
                    if(snapshot.hasError){
                      return Column();
                    }
                    
                    final planners = snapshot.data;
                    planners?.sort((a,b){
                      return b.date!.compareTo(a.date!);
                    });
              
                    return planners!.isNotEmpty ?  ListView.builder(
                      itemCount: planners.length,
              
                      itemBuilder: (context, index){
                        return PlanCard(
                          index: index+1,
                          plannerExp: planners[index],
                          ctx: context
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
      ),
  
    );
  }
}