import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../models/user_model.dart';
import '../../../utils/constants/colors.dart';

class MoreScreen extends StatefulWidget {

  final User user;
  
  const MoreScreen({
    required this.user,
    super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 30,

        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
          ),
      ),


      body: Column(
        children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          color: appOrange,

                          child: Center(
                            child: Text(
                              '${widget.user.firstName.substring(0,1).toUpperCase()}${widget.user.lastName.substring(0,1).toUpperCase()}',
                                              
                              style: const TextStyle(
                                fontSize: 50,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10,
                                    offset: Offset(1, 1)
                                  )
                                ]
                              ),
                            ),
                          ),
                        )
                      ),
                    ),
              
                    const SizedBox(
                      height: 10,
                    ),
              
                    Text(
                      '${widget.user.firstName} ${widget.user.lastName}',
              
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600
                      ),
                    ),
            
                    const SizedBox(
                      height: 20,
                    ),
            
            
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: (){},
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Income', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                Icon(MdiIcons.chevronRight)
                              ],)
                          ),

                          const Divider(),
                    
                          TextButton(
                            onPressed: (){},
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Budget', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                Icon(MdiIcons.chevronRight)
                              ],)
                          ),
                    
                          
                          const Divider(),
                    
                          TextButton(
                            onPressed: (){},
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Visualization', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                Icon(MdiIcons.chevronRight)
                              ],)
                          ),


                          const Divider(),
                    
                          TextButton(
                            onPressed: (){},
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                Icon(MdiIcons.chevronRight)
                              ],)
                          ),


                          const Divider(),
                    
                          TextButton(
                            onPressed: (){},
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Archive', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                Icon(MdiIcons.chevronRight)
                              ],)
                          ),

                          const Divider(),
                    
                          TextButton(
                            onPressed: (){},
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Subscribe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                Icon(MdiIcons.chevronRight)
                              ],)
                          ),
                    
                          const Divider(),
                    
                          TextButton(
                            onPressed: (){},
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                Icon(MdiIcons.chevronRight)
                              ],)
                          ),
                    
                          const Divider(),
                    
                          TextButton(
                            onPressed: (){},
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                Icon(MdiIcons.chevronRight)
                              ],)
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: appOrange,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextButton.icon(
                              onPressed: (){}, 
                              icon: const Icon(
                                MdiIcons.logout,
                                color: Colors.white,
                              ),
                                              
                              label: Text('Log Out', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),)
                            ),
                          ),
                        ],
                      ),
                    )
              
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}