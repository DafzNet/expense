import 'dart:math';

import 'package:expense/models/plan_exp.dart';

class Ranker{
  List<PlanExpModel> items;

  Ranker(this.items);

  double _weight = 0.33;

  List<double> get minMaxPrice{
    double max = 0;
    double min = 50000000000000000000000000000000.0;

    for (var plan in items) {
      if (plan.price>max) {
        max = plan.price;
      }
      if (plan.price<min) {
        min = plan.price;
      }
    }

    return [min, max];
  }


  double priceNormalizer(PlanExpModel plan){
    return (plan.price - minMaxPrice[0])/(minMaxPrice[1]-minMaxPrice[0]);
  }

  double prefNormalizer(PlanExpModel plan){
    return (plan.scaleOfPref - 1)/(10-1);
  }

  double satisfactionNormalizer(PlanExpModel plan){
    return (plan.satisfaction - 1)/(10-1);
  }


  List<PlanExpModel> get weightedAverages {
    List<PlanExpModel> newItems = [];

    for (var plan in items) {
      double score = (_weight*priceNormalizer(plan))+(_weight*prefNormalizer(plan))+(_weight*satisfactionNormalizer(plan));
      newItems.add(
        plan.copyWith(
          price: score
        )
      );
    }

    newItems.sort(
      (a, b){
        return b.price.compareTo(a.price);
      }
    );

    for (var e in items) {
      for (var i = 0; i<newItems.length; i++) {
        if (e == newItems[i]) {
          final a = newItems[i].copyWith(
            price: e.price
          );

         newItems.replaceRange(i, i+1, [a]);
        }
      }
    }

    return newItems;

  }


////////////////////////////////
  List<PlanExpModel> get costBenefit {
    List<PlanExpModel> newItems = [];

    for (var plan in items) {
      double score = plan.satisfaction/plan.price;
      newItems.add(
        plan.copyWith(
          price: score
        )
      );
    }

    newItems.sort(
      (a, b){
        return b.price.compareTo(a.price);
      }
    );

    for (var e in items) {
      for (var i = 0; i<newItems.length; i++) {
        if (e == newItems[i]) {
          final a = newItems[i].copyWith(
            price: e.price
          );

         newItems.replaceRange(i, i+1, [a]);
        }
      }
    }

    return newItems;

  }

//////////////////////////////////
  List<PlanExpModel> get topsis{
    List<PlanExpModel> newItems = [];
    int pis = 1;
    int nis = 0;

    for (var plan in items) {
      double di_positive = sqrt((pow((priceNormalizer(plan)-pis), 2)+pow((prefNormalizer(plan)-pis), 2)+pow((satisfactionNormalizer(plan)-pis), 2)));
      double di_negative = sqrt((pow((priceNormalizer(plan)-nis), 2)+pow((prefNormalizer(plan)-nis), 2)+pow((satisfactionNormalizer(plan)-nis), 2)));

      double ci = di_negative / (di_positive+di_negative);
      newItems.add(
        plan.copyWith(
          price: ci
        )
      );
    }

    newItems.sort(
      (a, b){
        return b.price.compareTo(a.price);
      }
    );

    for (var e in items) {
      for (var i = 0; i<newItems.length; i++) {
        if (e == newItems[i]) {
          final a = newItems[i].copyWith(
            price: e.price
          );

         newItems.replaceRange(i, i+1, [a]);
        }
      }
    }

    return newItems;

  }


////////////////////////////////
  List<PlanExpModel> get preferences{
    
    items.sort(
      (a, b){
        return b.scaleOfPref.compareTo(a.scaleOfPref);
      }
    );

    return items;

  } 

//////////////////////////////
  List<PlanExpModel> get price{
    
    items.sort(
      (a, b){
        return a.price.compareTo(b.price);
      }
    );

    return items;
  }  


////////////////////////
  List<PlanExpModel> get satisfaction{
    
    items.sort(
      (a, b){
        return b.satisfaction.compareTo(a.satisfaction);
      }
    );

    return items;

  }


  //////////////////////////////////////////////////////
   

}
