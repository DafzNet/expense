import 'package:cached_network_image/cached_network_image.dart';
import 'package:expense/models/fexpertmodel.dart';
import 'package:expense/models/user_model.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../dbs/fxlikes.dart';
import '../../../../firebase/db/fexpert/likes.dart';
import '../../../../utils/constants/images.dart';
import '../screens/fexpert_det.dart';

class FexpertCard extends StatefulWidget {
  final FexpertModel fexpert;
  final LightUser currentUser;
  const FexpertCard({
    required this.currentUser,
    required this.fexpert,
    super.key});

  @override
  State<FexpertCard> createState() => _FexpertCardState();
}

class _FexpertCardState extends State<FexpertCard> {
  bool liked = false;
  int likes = 0;

  void likeUnlike()async{
    final likesDb = FexpertLikesDb(widget.fexpert.id);
    //final likesDb = LikeDb(widget.fexpert.id);
    final like = await likesDb.fetch();
    liked = like.liked(widget.currentUser);
    likes = like.numberOfLikes;

    setState(() {
      
    });
  }

  @override
  void initState() {
    likeUnlike();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(height: 20,),
              SizedBox(
                height: 30,
                width: 30,

                child: ClipOval(
                  child: widget.fexpert.poster.dp != null && widget.fexpert.poster.dp!.isNotEmpty?
                       CachedNetworkImage(
                        imageUrl: widget.fexpert.poster.dp!):
                       Container(
                        color: appOrange,
                        child: Icon(
                          MdiIcons.account,
                          color: Colors.white,
                        ),
                      ),),
              ),
            ],
          ),

          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: FexpertDetailScreen(fexpert: widget.fexpert, user: widget.currentUser,),
                    type: PageTransitionType.rightToLeft
                  ));
              },
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 5, bottom: 5, top: 5),
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
                            tag: widget.fexpert.id,
                            child: Text(
                              widget.fexpert.topic,
                                                    
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                                                    
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
            
            
                        Text(
                             DateTime.now().difference(widget.fexpert.date).inDays<1?
                            DateTime.now().difference(widget.fexpert.date).inHours<1?
                            ' ${DateTime.now().difference(widget.fexpert.date).inMinutes}m':
                            ' ${DateTime.now().difference(widget.fexpert.date).inHours}h':
                              DateTime.now().difference(widget.fexpert.date).inDays<30?
                                ' ${DateTime.now().difference(widget.fexpert.date).inDays}d':
                                    DateFormat.yMMM().format(widget.fexpert.date),
                        
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                        
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                      ],
                    ),
            
                    Text(
                      '${widget.fexpert.poster.firstName!} ${widget.fexpert.poster.lastName!}',
            
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),
                    ),
            
                    Text(
                      widget.fexpert.body,
            
                      maxLines: 5,
            
                      style: const TextStyle(
                        fontSize: 13
                      ),
                    ),
            
            
                    Padding(
                      padding: const EdgeInsets.only(top: 7, bottom: 3),
                      child: Row(
                        children: [
                          const Text(
                            'Tags: ',
                    
                            maxLines: 5,
                    
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                            ),
                          ),
            
                          Expanded(
                            child: Text(
                              widget.fexpert.tags,
                                              
                              maxLines: 5,
                                              
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if(widget.fexpert.image != null)...
                     [
                      
                        const SizedBox(height: 5,),

                        Hero(
                        tag: '${widget.fexpert.id}img', 
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: widget.fexpert.image!,
                          ),
                        )
                        ),
              
                     ],

                    const SizedBox(height: 10,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all()
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                      liked? MdiIcons.heart : MdiIcons.heartOutline,
                                      size: 18,
                                      color: liked? Colors.redAccent : Colors.black,
                                    ),
                            
                                  const SizedBox(width: 5,), 
                            
                                  Text(
                                    likes.toString(),
                            
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // const SizedBox(width: 10,),


                          // Container(
                          //   padding: const EdgeInsets.symmetric(horizontal: 5),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(5),
                          //     border: Border.all()
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       const Icon(
                          //         MdiIcons.chatOutline,
                          //         size: 18,
                          //       ),
                          
                          //       const SizedBox(width: 5,), 
                          
                          //       Text(
                          //         (3).toString(),
                          
                          //         style: const TextStyle(
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.bold
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                         
                      ],
                    ),

                    const Icon(
                      MdiIcons.share,
                      size: 20,
                    ),
                  ],
                ),

                SizedBox(height: 10,),

                Divider(
                  height: 12,
                  thickness: 6,
                  color: Color.fromARGB(255, 243, 243, 243),
                )

                ]
                
              ),
            ),
          ),

          )
        ],
      ),
    );
  }
}