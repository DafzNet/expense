
import 'package:flutter/foundation.dart';


class SubscriptionProvider with ChangeNotifier{

 SubscriptionProvider();

  bool premiumUser = false;

  void getSubscriptionStatus(){
    premiumUser = !premiumUser;
    
    notifyListeners();
  }

}