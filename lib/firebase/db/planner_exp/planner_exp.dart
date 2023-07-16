// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/plan_exp.dart';
import '../../../models/version.dart';


class FirebasePlannerExpDb{
  dynamic uid;

  FirebasePlannerExpDb({this.uid});

  final CollectionReference plannerExpCollection = FirebaseFirestore.instance.collection('planners_exp');

  ///Takee a list of incomes and aadd them to firestore 
  Future addPlannerExps(List<PlanExpModel> planExps)async{
    for (var plan in planExps){
      await addPlannerExp(plan);
    }
  }

  ///Takee an expense and aadd them to firestore 
  Future addPlannerExp(PlanExpModel plan)async{
      await plannerExpCollection.doc(uid).collection(uid).doc(plan.id.toString())
        .get().then((value)async{
          if (!value.exists){
            await plannerExpCollection.doc(uid).collection(uid).doc(plan.id.toString()).set(plan.toMap()).onError((error, stackTrace) => null);
          }
        });
      await updateFirebaseDbVersion(uid, plannerExpDbVersion: 1);
  }


  Future<List<PlanExpModel>> getPlannerExps()async{
    QuerySnapshot<Map<String, dynamic>> planExps = await plannerExpCollection.doc(uid).collection(uid).get();
    List<PlanExpModel> planDocs = planExps.docs.map((e){
      Map<String, dynamic> _data = e.data();
      return PlanExpModel.fromMap(_data);
    }).toList();

    return planDocs;
  }

  ///retturns the corresponding expense
  Future update(PlanExpModel plan)async{
    await plannerExpCollection.doc(uid).collection(uid).doc(plan.id.toString()).update(plan.toMap());
  }

  Future delete(PlanExpModel plan)async{
    await plannerExpCollection.doc(uid).collection(uid).doc(plan.id.toString()).delete();
    await updateFirebaseDbVersion(uid, plannerExpDbVersion: 1);
  }
}