

// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:expense/dbs/pin.dart';
import 'package:expense/dbs/settings.dart';
import 'package:expense/providers/settings_provider.dart';
import 'package:expense/screen/auth/pinscreen.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:expense/utils/settings/settings.dart';
import 'package:expense/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../dbs/category_db.dart';
import '../../../../../models/pin_model.dart';

//com.light.cashflowpad

// Future<void> _handleMethod(MethodCall call) async {
//   if (call.method == 'start') {
//     // Start the background service and execute your background task
//     onStart();
//   }
// }


// Future<void> onStart() async {
//   final service = FlutterBackgroundService();

//   final _time = TimeOfDay.now();

//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'lifi_id',
//     'LiFi',
//     channelDescription: 'Your Channel Description',
//     importance: Importance.high,
//     priority: Priority.max,
//   );

//   const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     DateTime.now().millisecondsSinceEpoch,
//     'LiFi',
//     'Update your daily transactions',
//     tz.TZDateTime.from(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, _time.hour, _time.minute), tz.local),
//     platformChannelSpecifics,
//     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     matchDateTimeComponents: DateTimeComponents.time,
//   );


// }






class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  final settingsDb = SettingsDb();
  SettingsObj? setting;
  
  String currencySymbol = '\$';
  String currencyCode = '';

  String currencySymbolPos = '';


  void getSettings()async{
    final settings = await settingsDb.retrieveData();
    setting = settings.last;

    currencySymbol = setting!.currencySymbol;
    currencyCode = setting!.currencyCode;
    currencySymbolPos = setting!.currencySymbolPosition;

    setState(() {
      
    });
  }
  
  @override
  void initState() {
  
    getSettings();
  
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark
        ),

        title: const Text(
          'Settings'
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
        
              Divider(height: 30,),
        
              Row(
                
                children: const [
                  Text(
                    'Currency Settings',
            
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ],
              ),
        
              ListTile(

                onTap: () {
                  showModalBottomSheet(
                    context: context, 
                    builder: (context){
                      return ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        child: Container(
                          height: (MediaQuery.of(context).size.height/3)*2,
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                      
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(Currency(context).currencies.length, (index){
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      currencySymbol = Currency(context).currencies.values.elementAt(index);
                                      currencyCode = Currency(context).currencies.keys.elementAt(index);
                                      setState(() {
                                        
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          width: .4
                                        )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            Currency(context).currencies.keys.elementAt(index),
                                            style: TextStyle(
                                              fontSize: 18
                                            ),
                                          ),
                                                            
                                                            
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: Color.fromARGB(255, 235, 233, 233)
                                            ),
                                            child: Text(
                                              Currency(context).currencies.values.elementAt(index),
                                              style: TextStyle(
                                                fontSize: 18
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              )
                            ),
                          ),
                        ),
                      );
                    }
                  );
                },

                title: const Text(
                  'Currency Symbol '
                ),
        
                subtitle: const Text(
                  'select currency symool'
                ),
        
                trailing: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: SizedBox(
                    width: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currencySymbol,
                  
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                  
                        Icon(MdiIcons.chevronRight)
                      ],
                    ),
                  ),
                ),
              ),
        
        
              ListTile(

                onTap: () async{
                    await showMenu(
                      context: context, 
                      position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width/2, 250, 10, 0), 
                      items: [
                        PopupMenuItem(
                          child: Text('Left'),

                          onTap: () {
                            currencySymbolPos='Left';
                            setState(() {
                              
                            });
                          },
                        ),

                        PopupMenuItem(
                          child: Text('Right'),

                          onTap: () {
                            currencySymbolPos='Right';
                            setState(() {
                              
                            });
                          },
                        )
                      ]
                    );            
                },

                title: const Text(
                  'Currency Symbol Position'
                ),
        
                subtitle: const Text(
                  'where to place the symbol'
                ),
        
                trailing: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: SizedBox(
                    width: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currencySymbolPos,
                  
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                  
                        Icon(MdiIcons.chevronRight)
                      ],
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: ()async{

                      final newSetting = SettingsObj(
                        id: DateTime.now().millisecondsSinceEpoch, 
                        currencySymbol: currencySymbol,
                        currencyCode: currencyCode,
                        currencySymbolPosition: currencySymbolPos
                      );

                      Provider.of<SettingsProvider>(context, listen: false).changeSettings(newSetting);
                        await settingsDb.addData(newSetting);
                      },

                      style: TextButton.styleFrom(
                        backgroundColor: appOrange,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                        
                      ),
                    child: Text('Save',
                      style: TextStyle(fontSize: 18),
                    )
                  ),
                ],
              ),
        
              // Divider(
              //   height: 30,
              // ),
        
              // Row(
                
              //   children: [
              //     Text(
              //       'Accountability Settings',
            
              //       style: TextStyle(
              //         fontSize: 16
              //       ),
              //     ),
        
              //     Icon(
              //       MdiIcons.star,
              //       size: 18,
              //       color: appOrange,
              //     )
              //   ],
              // ),
        
              // Row(
                
              //   children: const [
              //     Text(
              //       'What to include in financial statement when generating pdf',
            
              //       style: TextStyle(
              //         fontSize: 12
              //       ),
              //     ),
              //   ],
              // ),
        
        
              // Row(
              //   children: [
              //     Expanded(
              //       child: CheckboxListTile(
              //         title: Text('Income'),
              //         value: true, 
              //         onChanged: (e){})),
        
              //     Expanded(
              //       child: CheckboxListTile(
              //         title: Text('Expenses'),
              //         value: true, onChanged: (e){})),
              //   ],
              // ),
        
              // Row(
              //   children: [
              //     Expanded(
              //       child: CheckboxListTile(
              //         title: Text('Budget'),
              //         value: true, 
              //         onChanged: (e){})),
        
              //     Expanded(
              //       child: CheckboxListTile(
              //         title: Text('Savings'),
              //         value: true, onChanged: (e){})),
              //   ],
              // ),
        
              // Row(
              //   children: [
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width/2-12,
              //       child: CheckboxListTile(
              //         title: Text('Reports'),
              //         value: true, 
              //         onChanged: (e){}),
              //     ),
        
                 
              //   ],
              // ),


              //  Divider(
              //   height: 30,
              // ),
        
              // Row(
                
              //   children: [
              //     Text(
              //       'Planners',
            
              //       style: TextStyle(
              //         fontSize: 16
              //       ),
              //     ),
        
              //     Icon(
              //       MdiIcons.star,
              //       size: 18,
              //       color: appOrange,
              //     )
              //   ],
              // ),
        
              // Row(
                
              //   children: const [
              //     Text(
              //       'Choose default planner model',
            
              //       style: TextStyle(
              //         fontSize: 12
              //       ),
              //     ),
              //   ],
              // ),


              // Padding(
              //   padding: const EdgeInsets.all(4.0),
              //   child: Row(
              //     children: [
              //       Radio(
              //         value: 9, 
              //         groupValue: 9, 
              //         onChanged: (h){}),

              //       Text(
              //         'Weighted Averages',
                          
              //         style: TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.bold
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.all(4.0),
              //   child: Row(
              //     children: [
              //       Radio(
              //         value: 9, 
              //         groupValue: 9, 
              //         onChanged: (h){}),

              //       Text(
              //         'Weighted Averages',
                          
              //         style: TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.bold
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.all(4.0),
              //   child: Row(
              //     children: [
              //       Radio(
              //         value: 9, 
              //         groupValue: 9, 
              //         onChanged: (h){}),

              //       Text(
              //         'Weighted Averages',
                          
              //         style: TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.bold
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
        
        
              Divider(
                height: 30,
              ),
        
              Row(
                
                children: const [
                  Text(
                    'Others',
            
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
        
                ],
              ),
        
              ListTile(
                title: const Text(
                  'Unhide hidden categories'
                ),
        
                subtitle: const Text(
                  'hidden categories will be visible'
                ),
        
                trailing: GestureDetector(
                  onTap: () async{
                    CategoryDb catDb = CategoryDb();
                    final cats = await catDb.retrieveData();

                    for (var cat in cats) {
                      cat = cat.copyWith(
                        hidden: false
                      );

                      await catDb.updateData(cat);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      financeSnackBar('Categories unhidden')
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: SizedBox(
                      width: 65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Unhide',
                    
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                    
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        
        


              ListTile(
              onTap: () async{
                TimeOfDay? _time = await showTimePicker (
                  context: context,
                  initialTime: TimeOfDay.now(),
                  helpText: 'Reminder'
                );

                

                if (_time != null) {
                  
                  // await setReminder(millisecondsSinceEpoch);
                  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
                          FlutterLocalNotificationsPlugin();

                  final NotificationDetails notificationDetails = NotificationDetails(
                      android: AndroidNotificationDetails(
                        'lifi_id',
                        'LiFi',
                        channelDescription: 'Your Channel Description',
                        importance: Importance.high,
                        priority: Priority.max
                      ),
                    );

                     await flutterLocalNotificationsPlugin.zonedSchedule(
                        1000,
                        'LiFi',
                        'Update your daily transactions',
                        tz.TZDateTime.from(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, _time.hour, _time.minute), tz.local),
                        notificationDetails,
                        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
                        matchDateTimeComponents: DateTimeComponents.time,
                      );

                  

                  ScaffoldMessenger.of(context).showSnackBar(
                    financeSnackBar('Reminder at ${_time.hour}:${_time.minute}${_time.period==DayPeriod.am?'AM':'PM'}')
                  );

                  

                  
                }


              },
              title: const Text(
                'Reminder'
              ),

              subtitle: const Text(
                'Set a reminder to record your daily financial flow'
              ),
            ),

            ListTile(
              onTap: () async{
                Navigator.push(
                  context,
                  PageTransition(
                    child: PinScreen(
                      header: 'Set Your Security Pin',

                      onCompleted: (pin, ctx) async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        await pref.setString('pin', pin);

                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            child: PinScreen(
                              header: 'Confirm Pin',

                              onCompleted: (p, ctx) async{
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                String? _pin = await pref.getString('pin');

                                if (_pin == p) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    financeSnackBar('Pin successfully set')
                                  );

                                  PinDb pinDb = PinDb();
                                  SettingsDb settingsDb = SettingsDb();
                                  Pin pin = Pin(p);

                                  await pinDb.commit(pin);


                                  final settings = await settingsDb.retrieveData();
                                  SettingsObj? setting;

                                  if (settings.isNotEmpty) {
                                    setting = settings.last;
                                  } else {
                                    
                                  }

                                  if(settings.isNotEmpty){

                                    final nSet = setting!.copyWith(
                                      pin: true
                                    );

                                    Provider.of<SettingsProvider>(context, listen: false).changeSettings(nSet);
                                    await settingsDb.updateData(nSet);

                                  }else{
                                    
                                    final id = DateTime.now().millisecondsSinceEpoch;

                                    final nSet = SettingsObj(
                                      pin: true,
                                      id: id,
                                    );

                                    Provider.of<SettingsProvider>(context, listen: false).changeSettings(nSet);
                                    await settingsDb.addData(nSet);
                                  }


                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    financeSnackBar('Pin does not match, try again')
                                  );
                                }
                                
                              },
                            ),
                            type: PageTransitionType.fade
                          )
                        );
                      },
                    ),
                    type: PageTransitionType.fade
                  )
                );

              },
              title: const Text(
                'Security'
              ),

              subtitle: const Text(
                'Request a pin before access - turn on'
              ),

              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: Provider.of<SettingsProvider>(context, listen: false).mySettings.pin?Colors.green:Colors.grey,
                child: Text(
                  Provider.of<SettingsProvider>(context, listen: false).mySettings.pin?'ON':'OFF',
              
                  style: TextStyle(
                    fontSize: 20,
                    color: Provider.of<SettingsProvider>(context, listen: false).mySettings.pin?Colors.white:Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              
            ),

            

            SizedBox(height: 30,)
        
            ],
          ),
        ),
      ),
    );
  }
}