import 'package:expense/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

import '../../../../dbs/fexpert.dart';
import '../../../../models/fexpertmodel.dart';
import '../widgets/fexpert_card.dart';

class InvestmentFexpert extends StatefulWidget {
  final LightUser user;
  const InvestmentFexpert({required this.user, super.key});

  @override
  State<InvestmentFexpert> createState() => _InvestmentFexpertState();
}

class _InvestmentFexpertState extends State<InvestmentFexpert> {
  FexpertDb fexpertDb = FexpertDb();
  List<FexpertModel> fexperts = [];

  void gFexperts()async{
    fexperts = await fexpertDb.retrieveBasedOn(
      Filter.custom((record){
        final d = record.value as Map<String, dynamic>;
        final fex = FexpertModel.fromMap(d);

        for (var i in fex.tags.split(',')) {
          if (i.trim() == 'investment') {
            return true;
          }
        }
        return false;

      })
    );

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