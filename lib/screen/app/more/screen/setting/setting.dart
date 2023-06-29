

// ignore_for_file: prefer_const_constructors

import 'package:expense/dbs/settings.dart';
import 'package:expense/providers/settings_provider.dart';
import 'package:expense/utils/constants/colors.dart';
import 'package:expense/utils/currency/currency.dart';
import 'package:expense/utils/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  final settingsDb = SettingsDb();
  SettingsObj? setting;
  

  void getSettings()async{
    final settings = await settingsDb.retrieveData();
    setting = settings.first;

    setState(() {
      
    });
  }

  
  String _currencySymbol = '\$';
  String _currencyCode = '';

  String _currencySymbolPos = 'Left';
  
  
  @override
  void initState() {
    if (setting != null) {
      _currencySymbol = setting!.currencySymbol;
      _currencyCode = setting!.currencyCode;
      _currencySymbolPos = setting!.currencySymbolPosition;
    }
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
                                      _currencySymbol = Currency(context).currencies.values.elementAt(index);
                                      _currencyCode = Currency(context).currencies.keys.elementAt(index);
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
                          _currencySymbol,
                  
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
                            _currencySymbolPos='Left';
                            setState(() {
                              
                            });
                          },
                        ),

                        PopupMenuItem(
                          child: Text('Right'),

                          onTap: () {
                            _currencySymbolPos='Right';
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
                          _currencySymbolPos,
                  
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
        
              Divider(
                height: 30,
              ),
        
              Row(
                
                children: [
                  Text(
                    'Accountability Settings',
            
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
        
                  Icon(
                    MdiIcons.star,
                    size: 18,
                    color: appOrange,
                  )
                ],
              ),
        
              Row(
                
                children: [
                  Text(
                    'What to include in financial statement when generating pdf',
            
                    style: TextStyle(
                      fontSize: 12
                    ),
                  ),
                ],
              ),
        
        
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: Text('Income'),
                      value: true, 
                      onChanged: (e){})),
        
                  Expanded(
                    child: CheckboxListTile(
                      title: Text('Expenses'),
                      value: true, onChanged: (e){})),
                ],
              ),
        
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: Text('Budget'),
                      value: true, 
                      onChanged: (e){})),
        
                  Expanded(
                    child: CheckboxListTile(
                      title: Text('Savings'),
                      value: true, onChanged: (e){})),
                ],
              ),
        
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2-12,
                    child: CheckboxListTile(
                      title: Text('Reports'),
                      value: true, 
                      onChanged: (e){}),
                  ),
        
                 
                ],
              ),
        
        
              Divider(
                height: 30,
              ),
        
              Row(
                
                children: [
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
        
                trailing: Container(
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
        
        
              ListTile(
                title: const Text(
                  'Unhide hidden Vaults'
                ),
        
                subtitle: const Text(
                  'all hidden vaults will be visible'
                ),
        
                trailing: Container(
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


              ListTile(
              title: const Text(
                'Reminder'
              ),

              subtitle: const Text(
                'Set a reminder to record your daily financial flow'
              ),

              
            ),

            SizedBox(height: 10,),

            TextButton(
              onPressed: ()async{

                final newSetting = SettingsObj(
                  id: DateTime.now().millisecondsSinceEpoch, 
                  currencySymbol: _currencySymbol,
                  currencyCode: _currencyCode,
                  currencySymbolPosition: _currencySymbolPos
                );

                Provider.of<SettingsProvider>(context, listen: false).changeSettings(newSetting);
                await settingsDb.addData(newSetting);

                print('saved');

              },

              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40),
                side: BorderSide(
                  
                )
              ),
              child: Text('Save',
                style: TextStyle(fontSize: 18),
              )
            ),

            SizedBox(height: 30,)
        
            ],
          ),
        ),
      ),
    );
  }
}