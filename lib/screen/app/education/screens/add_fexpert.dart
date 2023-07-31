// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:expense/firebase/db/fexpert/fexpert.dart';
import 'package:expense/models/fexpert_like.dart';
import 'package:expense/models/fexpertmodel.dart';
import 'package:expense/models/user_model.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:expense/widgets/default_button.dart';
import 'package:expense/widgets/snack_bar.dart';
import 'package:expense/widgets/text_field.dart';
import 'package:expense/widgets/upload/selector.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../firebase/db/fexpert/likes.dart';
import '../../../../widgets/loading.dart';


class AddFexpert extends StatefulWidget {
  final LightUser user;
  final FexpertModel? fexpertModel;
  const AddFexpert({
    required this.user,
    this.fexpertModel,
    super.key});

  @override
  State<AddFexpert> createState() => _AddFexpertState();
}

class _AddFexpertState extends State<AddFexpert> {


  final imagePicker = ImagePickerCropper();
  File? image;

  String fexpertId = DateTime.now().millisecondsSinceEpoch.toString();

  FirebaseFexpertDb firebaseFexpertDb = FirebaseFexpertDb();



  final topicController = TextEditingController();
  final bodyController = TextEditingController();
  Map<String, bool> tags = {'budgeting':false, 'debt':false, 'investment':false, 'business':false, 'crytocurrencies':false, 'foreign exchange':false, 'financial news':false, 'goal settings':false, 'others':false};

  Future addFex({String? downlink})async{
    List<String> selectTags = [];

    FexpertLikesDb fexpertLikesDb=FexpertLikesDb(fexpertId);
    
    for (var element in tags.keys) {
      if (tags[element]==true) {
        selectTags.add(element.toString());
      }
    }


    
    if (topicController.text.isNotEmpty && bodyController.text.isNotEmpty && selectTags.isNotEmpty) {

      if (widget.fexpertModel != null) {
        final upFex = widget.fexpertModel!.copyWith(
          body: bodyController.text,
          topic: topicController.text,
           tags: selectTags.join(', '),
          tagSearch: selectTags,
          search: topicController.text.toLowerCase().split(' '),
        );

        await firebaseFexpertDb.update(upFex);

          Navigator.pop(context);
      } else {
        await firebaseFexpertDb.addFexpert(
        FexpertModel(
          id: fexpertId, 
          poster: widget.user, 
          topic: topicController.text, 
          date: DateTime.now(), 
          body: bodyController.text, 
          tags: selectTags.join(', '),
          tagSearch: selectTags,
          search: topicController.text.toLowerCase().split(' '),
          image: downlink
        )
      );

      await fexpertLikesDb.create(
        FLike(
          fexpertId: fexpertId,
          likes: []
        )
      );

      }

      

      topicController.text= '';
      bodyController.text = '';
      tags.map((key, value) => MapEntry(key, !value));

      setState(() {
        
      });

      return 'Succesful, add another fexpert';
      
    } else {
      if (topicController.text.isEmpty){
        return 'The subject field is required';
      }else if (bodyController.text.isEmpty){
        return 'The body field is required';
      }else if (selectTags.isEmpty){
        return 'Select at least one tag';
      }
    }
  }


  bool _load = false;


  @override
  void initState() {
    if (widget.fexpertModel != null) {
      topicController.text = widget.fexpertModel!.topic;
      bodyController.text = widget.fexpertModel!.body;

      for (var tag in widget.fexpertModel!.tagSearch!) {
        tags[tag] = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,

        title: Text(
                widget.fexpertModel != null ? 'Edit Fexpert':'Add Fexpert'
              ),
      ),

      body: LoadingIndicator(
        loading: _load,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const Divider(height: 2,),
      
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30,),
                        
                  MyTextField(
                    '',
                    headerText: 'Subject',
                    controller: topicController,
                  ),
                
                
                  const SizedBox(height: 10,),
                        
                  MyTextField(
                    '',
                    headerText: 'Body',
                    controller: bodyController,
                    minLines: 5,
                    maxLines: 10,
                  ),
            
      
                  
                  const SizedBox(height: 20,),
      
      
                  GestureDetector(
                    onTap:widget.fexpertModel != null ?null: () async{
                      image = await imagePicker.imgFromGallery(crop: false);
      
                      setState(() {
                        
                      });
                    },
                    child: Column(
                      children: [
                        if(image != null)...
                         [
                          Image.file(image!)
                         ],
      
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(width: .4,),
                            borderRadius: BorderRadius.circular(6)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MdiIcons.imageOutline,
                                color: appSuccess,
                              ),
                              const Text(
                                '  Attach image to post'
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      
                  const SizedBox(height: 20,),
                
                
                  Row(
                    children: const [
                      Text(
                        'Choose Tags:',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                    ],
                  ),
                
                  const SizedBox(height: 10,),
                
                
                  Wrap(
                    spacing: 7,
                    children: List.generate(tags.length, 
                      (index) => ChoiceChip(
                        label: Text(
                          tags.keys.elementAt(index)
                        ), 
                        selected: tags.values.elementAt(index),
                
                        onSelected: (v){
                          tags[tags.keys.elementAt(index)] = v;
                          setState(() {
                            
                          });
                        },
                      ))
                      
                    ),
                
                
                    const SizedBox(height: 30,),
                
                    DefaultButton(
                      text: widget.fexpertModel != null? 'Update': 'Post',
                     
                      onTap: () async{

                        _load = true;
                        setState(() {
                          
                        });

                        if (image != null) {
                          String dl = await imagePicker.uploadFile(fexpertId, dest: 'fexperts/');
                        
                          String res = await addFex(downlink: dl);
        
                          ScaffoldMessenger.of(context).showSnackBar(
                            financeSnackBar(res)
                          );

                          _load = false;

                          setState(() {
                            
                          });
                        } else {
                           
                            String res = await addFex();
          
                            ScaffoldMessenger.of(context).showSnackBar(
                              financeSnackBar(res)
                            );

                            _load = false;

                            setState(() {
                              
                            });
                        }

                        
                      },
                    ),
      
      
                    const SizedBox(height: 30,),
                
                    ],
                  ),
                ),
              )
            ]),
        ),
      ),
    );
  }
}