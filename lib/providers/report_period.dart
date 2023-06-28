
import 'package:flutter/foundation.dart';


class ReportProvider with ChangeNotifier{

  var currentPeriodDate;
  String currentDateString = '';


  void changePeriod(String p, value)async{
    currentPeriodDate = value;
    currentDateString = p;

    notifyListeners();
  }

}