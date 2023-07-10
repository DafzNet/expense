// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/plan_model.dart';


class FirebasePlannerDb{
  dynamic uid;

  FirebasePlannerDb({this.uid});

  final CollectionReference plannerCollection = FirebaseFirestore.instance.collection('planner');

  ///Takee a list of incomes and aadd them to firestore 
  Future addPlanners(List<PlannerModel> planners)async{
    for (var planner in planners){
      await addPlanner(planner);
    }
  }

  ///Takee an expense and aadd them to firestore 
  Future addPlanner(PlannerModel planner)async{
      await plannerCollection.doc(uid).collection(uid).doc(planner.id.toString()).set(planner.toMap()).onError((error, stackTrace) => null);
  }


  Future<List<PlannerModel>> getPlanners()async{
    QuerySnapshot<Map<String, dynamic>> planners = await plannerCollection.doc(uid).collection(uid).get();
    List<PlannerModel> plannerDocs = planners.docs.map((e){
      Map<String, dynamic> _data = e.data();
      return PlannerModel.fromMap(_data);
    }).toList();

    return plannerDocs;
  }

  ///retturns the corresponding expense
  Future update(PlannerModel planner)async{
    await plannerCollection.doc(uid).collection(uid).doc(planner.id.toString()).update(planner.toMap());
  }

  Future delete(PlannerModel planner)async{
    await plannerCollection.doc(uid).collection(uid).doc(planner.id.toString()).delete();
  }
}