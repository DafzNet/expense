import 'package:expense/models/fexpertmodel.dart';
import 'package:expense/models/user_model.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../utils/constants/images.dart';
import '../screens/fexpert_det.dart';

class FexpertCard extends StatelessWidget {
  final FexpertModel fexpert;
  final LightUser currentUser;
  const FexpertCard({
    required this.currentUser,
    required this.fexpert,
    super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        //height: 200,
        
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(height: 20,),
                SizedBox(
                  height: 30,
                  width: 30,

                  child: ClipOval(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          width: 1,
                          color: appOrange
                        )
                      ),
                      child: Image.asset(lifiIcon),
                    )),
                ),
              ],
            ),

            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: FexpertDetailScreen(fexpert: fexpert, user: currentUser,),
                      type: PageTransitionType.rightToLeft
                    ));
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 5, bottom: 5, top: 5),
                  // decoration: BoxDecoration(
                  //   border: Border.all()
                  // ),
              
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Hero(
                              tag: fexpert.id,
                              child: Text(
                                fexpert.topic,
                                                      
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                                      
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
              
              
                          Text(
                               DateTime.now().difference(fexpert.date).inDays<1?
                              DateTime.now().difference(fexpert.date).inHours<1?
                              ' ${DateTime.now().difference(fexpert.date).inMinutes}m':
                              ' ${DateTime.now().difference(fexpert.date).inHours}h':
                                DateTime.now().difference(fexpert.date).inDays<30?
                                  ' ${DateTime.now().difference(fexpert.date).inDays}d':
                                      DateFormat.yMMM().format(fexpert.date),
                          
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                          
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                        ],
                      ),
              
                      Text(
                        '${fexpert.poster.firstName!} ${fexpert.poster.lastName!}',
              
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                        ),
                      ),
              
                      Text(
                        fexpert.body,
              
                        maxLines: 5,
              
                        style: TextStyle(
                          fontSize: 13
                        ),
                      ),
              
              
                      Padding(
                        padding: const EdgeInsets.only(top: 7, bottom: 3),
                        child: Row(
                          children: [
                            Text(
                              'Tags: ',
                      
                              maxLines: 5,
                      
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold
                              ),
                            ),
              
                            Expanded(
                              child: Text(
                                fexpert.tags,
                                                
                                maxLines: 5,
                                                
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                      if(fexpert.image != null)...
                       [
                        
                       ]



                    ],
                  ),
                ),
              ),
            ),

            
          ],
        ),
      ),
    );
  }
}