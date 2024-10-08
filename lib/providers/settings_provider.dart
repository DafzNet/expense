
import 'package:expense/dbs/settings.dart';
import 'package:expense/utils/settings/settings.dart';
import 'package:flutter/foundation.dart';


class SettingsProvider with ChangeNotifier{

  SettingsProvider(){
    getSet();
  }

  SettingsObj mySettings = SettingsObj(id: 123456);

  void getSet()async{
    final setting = SettingsDb();
    final myset = await setting.retrieveData();
    mySettings = myset.last;
  }

  void changeSettings(SettingsObj setting)async{
    mySettings = setting;

    notifyListeners();
  }

}