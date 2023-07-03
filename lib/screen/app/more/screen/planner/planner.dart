import 'package:expense/widgets/cards/planner_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/currency/currency.dart';
import '../../../../../widgets/default_button.dart';
import '../../../../../widgets/text_field.dart';

class BudgetPlanner extends StatefulWidget {
  const BudgetPlanner({super.key});

  @override
  State<BudgetPlanner> createState() => _BudgetPlannerState();
}

class _BudgetPlannerState extends State<BudgetPlanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: const Text('All Plans'),
            actions: [
              IconButton(onPressed: ()async{
                // showDialog(context: context, builder: (context){
                //   return SizedBox(
                //     width: 100,
                //     height: 300,

                //     child: Container(
                //       color: Colors.white,
                //     ),
                //   );
                // }
                // );
              }, icon: Icon(MdiIcons.helpCircleOutline))
            ],
        
          ),
        ],
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(10, (index) => PlannerCard(index: index+1,)),
        ),
      ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          await showModalBottomSheet(
                    context: context, 
                    builder: (context){
                      return SizedBox(
                        height: MediaQuery.of(context).size.height-200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                                        Text('Add a Planner',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),


                                        IconButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          } , icon: Icon(MdiIcons.closeCircleOutline))
                                      ],
                                    ),
                                  ),
                            
                                  Divider(height: 30,),

                                  MyTextField(
                                    'planner name',
                                    headerText: 'Title',
                                  ),
                            
                                  SizedBox(
                                    height: 15,
                                  ),
                            
                                  MyTextField(
                                    '',
                                    headerText: 'Choose a budget',
                                    makeButton: true,
                                  ),

                                  SizedBox(
                                    height: 15,
                                  ),
                            
                                  MyTextField(
                                    '',
                                    headerText: 'Description',
                                  ),
                            
                                  SizedBox(height: 25,),
                            
                                  DefaultButton(
                                    
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
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