import 'package:expense/utils/currency/currency.dart';
import 'package:expense/widgets/cards/planner_card.dart';
import 'package:expense/widgets/default_button.dart';
import 'package:expense/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../widgets/cards/plan_exp_card.dart';

class PlannerDetail extends StatefulWidget {
  const PlannerDetail({super.key});

  @override
  State<PlannerDetail> createState() => _PlannerDetailState();
}

class _PlannerDetailState extends State<PlannerDetail> {
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
            
            title: const Text('Plan Name'),
            actions: [
              IconButton(
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
                                        Text('Add Likely Expense to Plan',
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
                                    'What do you plan on spending',
                                    headerText: 'Title',
                                  ),
                            
                                  SizedBox(
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
                                        ),
                                      ),
                            
                                      SizedBox(width: 10,),
                            
                                      SizedBox(
                                        width: 170,
                                        child: MyTextField(
                                          '1 - 10',
                                          headerText: 'Scale of Preference',
                                          keyboardType: TextInputType.number,
                                        ),
                                      )
                                    ],
                                  ),
                            
                                  SizedBox(height: 15,),
                            
                                  MyTextField(
                                    '1 - 10',
                                    headerText: 'Estimated Level of Satisfaction',
                                    keyboardType: TextInputType.number,
                                  ),
                            
                                  SizedBox(height: 25,),
                            
                                  DefaultButton(
                                    text: 'Add',
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  );
              }, icon: Icon(MdiIcons.plusCircleOutline))
            ],
        
          ),
        ],
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(4, (index) => PlanCard(index: index+1,)),
        ),
      ),
      ),
  
    );
  }
}