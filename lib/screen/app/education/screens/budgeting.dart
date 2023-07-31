import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

import '../../../../dbs/fexpert.dart';
import '../../../../firebase/db/fexpert/fexpert.dart';
import '../../../../models/fexpertmodel.dart';
import '../../../../models/user_model.dart';
import '../widgets/fexpert_card.dart';

class BudgetFexpert extends StatefulWidget {
  final LightUser user;
  const BudgetFexpert({required this.user, super.key});

  @override
  State<BudgetFexpert> createState() => _BudgetFexpertState();
}

class _BudgetFexpertState extends State<BudgetFexpert> {
  FexpertDb fexpertDb = FexpertDb();
  List<FexpertModel> fexperts = [];

  FirebaseFexpertDb firebaseFexpertDb = FirebaseFexpertDb();

  void gFexperts()async{
    fexperts = await firebaseFexpertDb.fetch(by: ['budgeting']);
    fexperts.addAll(await fexpertDb.retrieveBasedOn(
      Filter.custom((record){
        final d = record.value as Map<String, dynamic>;
        final fex = FexpertModel.fromMap(d);

        for (var i in fex.tags.split(',')) {
          if (i.trim() == 'budgeting') {
            return true;
          }
        }
        return false;

      })
    ));

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
      body: fexperts.isEmpty? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('No Fexperts yet')),
        ],
      ): ListView.builder(
        itemCount: fexperts.length,
        itemBuilder: (context, index){
          return FexpertCard(currentUser: widget.user, fexpert: fexperts[index]);
        }
      )
    );
  }
}