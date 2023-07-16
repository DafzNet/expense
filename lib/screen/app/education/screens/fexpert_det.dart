import 'package:expense/models/user_model.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../dbs/fexpert.dart';
import '../../../../models/fexpertmodel.dart';

class FexpertDetailScreen extends StatefulWidget {
  final FexpertModel fexpert;
  final LightUser user;
  const FexpertDetailScreen({
    required this.user,
    required this.fexpert,
    super.key});

  @override
  State<FexpertDetailScreen> createState() => _FexpertDetailScreenState();
}

class _FexpertDetailScreenState extends State<FexpertDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leadingWidth: 40,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              if(widget.fexpert.image != null)...
                [
                  Hero(
                  tag: widget.fexpert.id, 
                  child: Image.asset(widget.fexpert.image!) 
                  ),
                ]else...[
                  Hero(
                  tag: widget.fexpert.id, 
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width-20,
                      width: MediaQuery.of(context).size.width-20,
                      child: Expanded(
                        child: Icon(
                          MdiIcons.imageAlbum,
                          color: appSuccess,
                          size: MediaQuery.of(context).size.width-20,
                        ),
                      ),
                    ),
                  ) 
                  ),
                ],

              Center(
                child: Hero(
                  tag: widget.fexpert.id, 
                  child: Text(
                    widget.fexpert.topic,
              
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  )),
              ),
        
                ListTile(
                  contentPadding: EdgeInsets.only(left: 0, top: 2),
                  minLeadingWidth: 30,
                  title: Text(
                    '${widget.fexpert.poster.firstName} ${widget.fexpert.poster.lastName}'
                  ),
                  leading: ClipOval(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                  
                      child: Container(
                        color: appOrange,
                      ),
                    ),
                  ),
                ),
        
                //SizedBox(height: 10,),
        
                Text(
                    widget.fexpert.body,
              
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4
                    ),
                  ),

                  SizedBox(height: 5,),

                  Row(
                    children: [
                      Text(
                        'Tags: ',

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.4
                        ),
                      ),

                     
                      Wrap(
                        children: widget.fexpert.tags.split(',').map((e) => 
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: .4
                            ),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text(e)) 
                      ).toList(),
                      )
                    ],
                  ),

                  Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [


                      Row(
                        children: [
                          Icon(
                            MdiIcons.circle,
                            size: 8,
                          ),
                          Text(
                            DateTime.now().difference(widget.fexpert.date).inDays<1?
                              DateTime.now().difference(widget.fexpert.date).inHours<1?
                              ' ${DateTime.now().difference(widget.fexpert.date).inMinutes}m':
                              ' ${DateTime.now().difference(widget.fexpert.date).inHours}h':
                                DateTime.now().difference(widget.fexpert.date).inDays<30?
                                  ' ${DateTime.now().difference(widget.fexpert.date).inDays}d':
                                      DateFormat.yMMMd().format(widget.fexpert.date),
                    
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                    
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold
                            ),
                          ),


                          SizedBox(width: 30,),

                          Icon(
                            MdiIcons.heartOutline,
                            size: 20,
                          ), 

                          Text(
                            ' 00',

                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),


                      Row(
                        children: [
                          Icon(
                            MdiIcons.share,
                            size: 24,
                          ),

                          if(widget.fexpert.poster == widget.user)...
                           [
                            SizedBox(width: 5,),
                             GestureDetector(
                              onTap: () async{
                                await FexpertDb().deleteData(widget.fexpert);
                                Navigator.pop(context);
                              },
                               child: Icon(
                                MdiIcons.deleteOutline,
                                size: 20,
                                color: appDanger,
                                                         ),
                             ),

                            SizedBox(width: 7,),

                            Icon(
                              MdiIcons.bookEditOutline,
                              size: 18,
                              color: appSuccess,
                            ),
                           ],
                          
                        ],
                      )
                      
                    ],
                  ),


                  SizedBox(height: 50,)
            ],
          ),
        ),
      ),

    );
  }
}