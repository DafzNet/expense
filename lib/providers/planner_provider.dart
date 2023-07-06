
import 'package:flutter/foundation.dart';


class PlannerProvider with ChangeNotifier{

 PlannerProvider();

  double hight = 0;

  void setHeight(double h){
    if (hight == 0.0) {
      hight = h;
    } else {
      hight = 0;
    }
    notifyListeners();
  }

}