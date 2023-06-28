

// ignore_for_file: prefer_const_constructors

import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
                      children: const [
                        Text(
                          'N',
                  
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
                    width: 65,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'front',
                  
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
                'Remider'
              ),

              subtitle: const Text(
                'Set a reminder to record your daily financial flow'
              ),

              
            ),
        
              
        
            ],
          ),
        ),
      ),
    );
  }
}