
import 'package:expense/utils/currency/currency.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../dbs/plan_exp_db.dart';
import '../../models/plan_exp.dart';
import '../../utils/constants/colors.dart';


class PlanCard extends StatefulWidget {

  final int? index;
  final BuildContext ctx;
  final PlanExpModel plannerExp;

  const PlanCard({
    this.index,
    required this.plannerExp,
    required this.ctx,
    super.key});

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {

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

            leading: Text(
              widget.index!.toString(),
            
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: appOrange
              ),
            ),
    
            title: Text(
              widget.plannerExp.name,
            
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                //color: appOrange
              ),
            ),
    
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Price: ',
                
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black
                      //color: appOrange
                    ),

                    children: [
                      TextSpan(
                        text: Currency(context).wrapCurrencySymbol(widget.plannerExp.price.toString()),
                    
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black
                          //color: appOrange
                        ),
                      ),
                    ]
                  ),
                ),

                const SizedBox(height: 5,),

                RichText(
                  text: TextSpan(
                    text: 'Scale of Preference: ',
                
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black
                      //color: appOrange
                    ),

                    children: [
                      TextSpan(
                        text: widget.plannerExp.scaleOfPref.toString(),
                    
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                          //color: appOrange
                        ),
                      ),
                    ]
                  ),
                ),

                const SizedBox(height: 5,),

                RichText(
                  text: TextSpan(
                    text: 'Estimated Satisfaction: ',
                
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black
                      //color: appOrange
                    ),

                    children: [
                      TextSpan(
                        text: widget.plannerExp.satisfaction.toString(),
                    
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                          //color: appOrange
                        ),
                      ),
                    ]
                  ),
                ),
              ],
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
                    onTap: ()async{

                      PlannerExpDb plannerExpDb = PlannerExpDb();

                      await plannerExpDb.deleteData(widget.plannerExp);
                      
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