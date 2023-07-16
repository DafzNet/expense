import 'package:expense/dbs/fexpert.dart';
import 'package:expense/models/fexpertmodel.dart';
import 'package:expense/models/user_model.dart';
import 'package:expense/screen/app/education/widgets/fexpert_card.dart';
import 'package:flutter/material.dart';

class GeneralFexpert extends StatefulWidget {

  final LightUser user;

  const GeneralFexpert({
    required this.user,
    super.key});

  @override
  State<GeneralFexpert> createState() => _GeneralFexpertState();
}

class _GeneralFexpertState extends State<GeneralFexpert> {

  FexpertDb fexpertDb = FexpertDb();
  List<FexpertModel> fexperts = [];

  void gFexperts()async{
    fexperts = await fexpertDb.retrieveData();

    fexperts.sort(
      (a,b){
        return b.date.compareTo(a.date);
      }
    );

    setState(() {
      
    });
  }

  @override
  void initState() {
    gFexperts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: fexperts.length,
        itemBuilder: (context, index){
          return FexpertCard(currentUser: widget.user, fexpert: fexperts[index]);
        }
      )
    );
  }
}