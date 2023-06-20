
// ignore_for_file: use_build_context_synchronously

import 'package:expense/dbs/category_db.dart';
import 'package:expense/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../widgets/default_button.dart';
import '../../../../../widgets/loading.dart';
import '../../../../../widgets/text_field.dart';


class AddCategoryScreen extends StatefulWidget {

  const AddCategoryScreen({
    super.key
    });

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {

  final categoryDb = CategoryDb();

  final iconController = TextEditingController();
  final noteController = TextEditingController();
  final titleController = TextEditingController();


  bool loading = false;


  @override
  Widget build(BuildContext context) {

    //_edit();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        automaticallyImplyLeading: false,

        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(
            MdiIcons.arrowLeft,
            color: Colors.white
          )),

        title: const Text(
          'Add Category',
          style: TextStyle(
            color: Colors.white
          ),
        ),

        backgroundColor: Colors.black,
        //toolbarHeight: 50,

        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light
        ),
      ),

      body: Column(
        children: [
           


            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                child: Container(
                  color: Colors.white,

                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25,),
                          child: SingleChildScrollView(
                            child: LoadingIndicator(
                              loading: loading,
                              child: Column(
                                children: [
                                  const SizedBox(height: 30,),
                                  
                                  
                                  MyTextField(
                                    'provide category name',
                                    headerText: 'Title',
                                    maxLines: 3,
                                    controller: titleController,
                                  ),
                                  
                                  const SizedBox(height: 30,),

                                  MyTextField(
                                    'optional',
                                    headerText: 'Description',
                                    maxLines: 3,
                                    controller: noteController,
                                  ),
                            
                                                      
                                  const SizedBox(height: 50,),
                                                      
                                                      
                                   DefaultButton(
                                    text: 'Add Category',


                                    onTap: ()async{
                                      if (titleController.text.isEmpty) {
                                        
                                      } else {
                                        loading = true;
                                        setState(() {
                                          
                                        });

                                        CategoryModel category = CategoryModel(
                                          id: DateTime.now().millisecondsSinceEpoch, 
                                          name: titleController.text,
                                          hidden: false,
                                          description: noteController.text,

                                        );


                                        await categoryDb.addData(category);

                                        loading = false;

                                        setState(() {
                                          
                                        });

                                        Navigator.pop(context);

                                      }
                                    }
                                   ),

                                   SizedBox(height: 20,)
                                ],
                              ),
                            ),
                          ),
                        )
                      )
                    ],
                  ),
                ),
              )
            )

        ],
      )
    );
  }
}