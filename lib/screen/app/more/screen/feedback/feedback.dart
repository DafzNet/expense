import 'package:expense/widgets/default_button.dart';
import 'package:expense/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../../../models/user_model.dart';

class FeedbackScreen extends StatefulWidget {
  final LightUser user;
  const FeedbackScreen({
    required this.user,
    super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {

  final subjectContriller = TextEditingController();
  final bodyContriller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),

        actions: [

        ],
      ),
      body: Column(
        children: [
          Divider(height: 2,),

          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [

                      const SizedBox(height: 25,),
          
                      MyTextField(
                        '',
                        headerText: 'Subject',
                        controller: subjectContriller,
                      ),
          
          
                      const SizedBox(height: 15,),
          
                      MyTextField(
                        '',
                        headerText: 'Body',
                        controller: bodyContriller,
                        minLines: 8,
                        maxLines: 12,
          
                      ),
          
          
                      const SizedBox(height: 30,),
          
          
                      DefaultButton(
                        text: 'Send',
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),


    );
  }
}