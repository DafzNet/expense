import 'package:expense/models/fexpertmodel.dart';
import 'package:expense/models/user_model.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:expense/widgets/default_button.dart';
import 'package:expense/widgets/snack_bar.dart';
import 'package:expense/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../dbs/fexpert.dart';

class AddFexpert extends StatefulWidget {
  final LightUser user;
  const AddFexpert({
    required this.user,
    super.key});

  @override
  State<AddFexpert> createState() => _AddFexpertState();
}

class _AddFexpertState extends State<AddFexpert> {

  final topicController = TextEditingController();
  final bodyController = TextEditingController();
  Map<String, bool> tags = {FexpertTag.budgeting.name:false, FexpertTag.debt.name:false, FexpertTag.investment.name:false, FexpertTag.others.name:false};

  Future addFex()async{
    List<String> selectTags = [];
    
    for (var element in tags.keys) {
      if (tags[element]==true) {
        selectTags.add(element.toString());
      }
    }


    
    if (topicController.text.isNotEmpty && bodyController.text.isNotEmpty && selectTags.isNotEmpty) {
      FexpertDb fexpertDb = FexpertDb();

      await fexpertDb.addData(
        FexpertModel(
          id: DateTime.now().millisecondsSinceEpoch, 
          poster: widget.user, 
          topic: topicController.text, 
          date: DateTime.now(), 
          body: bodyController.text, 
          tags: selectTags.join(', '),
        )
      );

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,

        

        title: Text(
                'Add Fexpert'
              ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Divider(height: 2,),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                      
                MyTextField(
                  '',
                  headerText: 'Subject',
                  controller: topicController,
                ),
              
              
                SizedBox(height: 10,),
                      
                MyTextField(
                  '',
                  headerText: 'Body',
                  controller: bodyController,
                  minLines: 5,
                  maxLines: 10,
                ),
          

                
                SizedBox(height: 20,),


                GestureDetector(
                  onTap: () {
                    
                  },
                  child: Container(
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
                        Text(
                          '  Attach image to post'
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20,),
              
              
                Row(
                  children: [
                    Text(
                      'Choose Tags:',
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
              
                SizedBox(height: 10,),
              
              
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
              
              
                  SizedBox(height: 30,),
              
                  DefaultButton(
                    text: 'Post',
                   
                    onTap: () async{
                      String res = await addFex();

                      ScaffoldMessenger.of(context).showSnackBar(
                        financeSnackBar(res)
                      );
                    },
                  ),


                  SizedBox(height: 30,),
              
                  ],
                ),
              ),
            )
            

            
          ]),
      ),
    );
  }
}