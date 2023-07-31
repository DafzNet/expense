// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expense/firebase/db/fexpert/likes.dart';
import 'package:expense/models/fexpert_like.dart';
import 'package:expense/models/user_model.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../dbs/fexpert.dart';
import '../../../../dbs/fxlikes.dart';
import '../../../../firebase/db/fexpert/fexpert.dart';
import '../../../../models/fexpertmodel.dart';
import 'add_fexpert.dart';

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

  bool liked = false;
  int likes = 0;

  void likeUnlike()async{
    final likesDb = FexpertLikesDb(widget.fexpert.id);
    //final likesDb = LikeDb(widget.fexpert.id);
    final like = await likesDb.fetch();
    liked = like.liked(widget.user);
    likes = like.numberOfLikes;

    setState(() {
      
    });
  }

  Future like()async{
    final likesDb = FexpertLikesDb(widget.fexpert.id);
    //final likesDb = LikeDb(widget.fexpert.id);
    FLike like = await likesDb.fetch();
    like.like(widget.user);
    await likesDb.update(like);

    liked = like.liked(widget.user);
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
                  tag: '${widget.fexpert.id}img',
                  child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: widget.fexpert.image!,
                          ),
                        )),
                        
                    SizedBox(height: 5,),
                ],

              Center(
                child: Hero(
                  tag: widget.fexpert.id, 
                  child: SelectableText(
                    widget.fexpert.topic,
              
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  )),
              ),
        
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 0, top: 2),
                  minLeadingWidth: 30,
                  title: Text(
                    '${widget.fexpert.poster.firstName} ${widget.fexpert.poster.lastName}'
                  ),
                  leading: ClipOval(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                  
                      child: widget.fexpert.poster.dp != null && widget.fexpert.poster.dp!.isNotEmpty?
                       CachedNetworkImage(
                        imageUrl: widget.fexpert.poster.dp!):
                       Container(
                        color: appOrange,
                        child: Icon(
                          MdiIcons.account,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
        
                //SizedBox(height: 10,),
        
                SelectableText(
                    widget.fexpert.body,
              
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4
                    ),
                  ),

                  const SizedBox(height: 5,),

                  Row(
                    children: [
                      const Text(
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
                          margin: const EdgeInsets.only(right: 5),
                          padding: const EdgeInsets.all(3),
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

                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [


                      Row(
                        children: [
                          const Icon(
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
                    
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold
                            ),
                          ),


                          const SizedBox(width: 30,),

                          GestureDetector(
                            onTap: () async{
                              await like();
                            },

                            child: Icon(
                              liked? MdiIcons.heart : MdiIcons.heartOutline,
                              size: 17,
                              color: liked? Colors.redAccent : Colors.black,
                            ),
                          ),

                          SizedBox(width: 7,), 

                          Text(
                            likes.toString(),

                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),


                      Row(
                        children: [
                          const Icon(
                            MdiIcons.share,
                            size: 24,
                          ),

                          if(widget.fexpert.poster == widget.user)...
                           [
                            const SizedBox(width: 5,),
                             GestureDetector(
                              onTap: () async{
                                try {
                                  await FexpertDb().deleteData(widget.fexpert);
                                } catch (e) {
                                  await FirebaseFexpertDb().delete(widget.fexpert);
                                }
                                Navigator.pop(context);
                                
                              },
                               child: Icon(
                                MdiIcons.deleteOutline,
                                size: 20,
                                color: appDanger,
                                                         ),
                             ),

                            const SizedBox(width: 7,),

                            GestureDetector(
                              onTap: () {
                                 Navigator.push(
                                  context,
                                  PageTransition(
                                    child: AddFexpert(
                                      user: widget.user,
                                      fexpertModel: widget.fexpert,
                                    ),

                                    type: PageTransitionType.bottomToTop
                                  )
                                );
                              },
                              child: Icon(
                                MdiIcons.bookEditOutline,
                                size: 18,
                                color: appSuccess,
                              ),
                            ),
                           ],
                          
                        ],
                      )
                      
                    ],
                  ),


                  const SizedBox(height: 50,)
            ],
          ),
        ),
      ),

    );
  }
}