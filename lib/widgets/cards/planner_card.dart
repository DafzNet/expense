import 'package:expense/dbs/plan_exp_db.dart';
import 'package:expense/dbs/planner_db.dart';
import 'package:expense/screen/app/more/screen/planner/plans/per_plan.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';

import '../../models/plan_exp.dart';
import '../../models/plan_model.dart';
import '../../utils/capitalize.dart';
import '../../utils/constants/colors.dart';


class PlannerCard extends StatefulWidget {

  final PlannerModel planner;
  final int? index;
  final BuildContext ctx;

  const PlannerCard({
    this.index,
    required this.planner,
    required this.ctx,
    super.key});

  @override
  State<PlannerCard> createState() => _PlannerCardState();
}

class _PlannerCardState extends State<PlannerCard> {

  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 0.2,
              color: Colors.black26
            )
          ),
    
          child: ListTile(
            minLeadingWidth: 25,
            
            onTap: (){
              Navigator.push(
                context,
                PageTransition(
                  child: PlannerDetail(
                    widget.planner
                  ), 
                  type: PageTransitionType.rightToLeft)
              );
            },

            leading: Text(
              widget.index!.toString(),
            
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: appOrange
              ),
            ),
    
            title: Text(
              widget.planner.name!,
            
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                //color: appOrange
              ),
            ),
    
            subtitle: Text(
              widget.planner.description??'',
            
              style: const TextStyle(
                fontSize: 14,
                //color: appOrange
              ),
            ),
    
            trailing: deleting? const SizedBox(
              width: 20,
              height: 20,

              child: CircularProgressIndicator(),
            ) : SizedBox(
              width: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                
    
                  GestureDetector(
                    onTap: (){
                      showDialog(
                        context: widget.ctx,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            //backgroundColor: appOrange,
                            title: Text('Delete ${capitalize(widget.planner.name!)}?'),
                            content:  SingleChildScrollView(
                              child: ListBody(
                                children: const <Widget>[
                                  Text('Deleting this planner will remove all plans under it'),
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
                                  
                                  Navigator.pop(context);

                                  setState(() {
                                    deleting = true;
                                  });

                                  Filter filterPlannerExp = Filter.custom((record){
                                    final d = record.value as Map<String, dynamic>;
                                    final expPlan = PlanExpModel.fromMap(d);

                                    return expPlan.planner == widget.planner;
                                  });


                                  PlannerDb plannerDb = PlannerDb();
                                  PlannerExpDb plannerExpDb =PlannerExpDb();

                                  final plans = await plannerExpDb.retrieveBasedOn(filterPlannerExp);

                                  for (var p in plans) {
                                    await plannerExpDb.deleteData(p);
                                  }

                                  await plannerDb.deleteData(widget.planner);

                                },
                              ),
                            ],
                          );}
                       );
                    },
                    child: Icon(
                      MdiIcons.deleteOutline,
                      size: 22,
                      color: appDanger,
                    ),
                  )
                ],
              ),
            ),
          ),
    
        
      ),
    );
  }
}