// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/images.dart';
import '../../widgets/loading.dart';


class PinScreen extends StatefulWidget {
  final String? header;
  final String? subHeader;

  final  Function(String, BuildContext)? onCompleted;

  const PinScreen({
    this.header,
    this.subHeader,
    this.onCompleted,
    super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {

  final rand = Random();

  //final otpDb = OtpDb();

  //lock screen images
  List<String> images = [v1, v2, d1, d2, c1, c2];
  String lockImage = v1;

  void getLock(){
    int i = rand.nextInt(6);
    lockImage = images[i];
    setState(() {
      
    });
  }

  bool _load = false;


  final otpController = TextEditingController(text: '');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),

      body: LoadingIndicator(
        loading: _load,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: .45,
                child: Image.asset(
                  lockImage,
                          
                  fit: BoxFit.cover,
                  color: Colors.black38,
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                SizedBox(
                  height: (MediaQuery.of(context).size.height/2),
                  child: Column(
                    children: [
                      SizedBox(height: 40,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text(
                              widget.header??'Security Pin',

                              style: TextStyle(
                                 fontSize: 20,
                                  fontWeight: FontWeight.w700
                              ),
                             
                            ),
                          ],
                        ),
                      ),

                      Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Text(
                        widget.subHeader??'',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                ),


                const SizedBox(height: 150,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: otpController.text.length>=1?appOrange.shade700:Colors.white,
                        border: Border.all(
                          color: appOrange.shade700,
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(100)
                      ),
                    ),

                    const SizedBox(width: 15,),

                    Container(
                      
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: otpController.text.length>=2?appOrange.shade700:Colors.white,
                        border: Border.all(
                          color: appOrange.shade700,
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(100)
                      ),
                    ),

                    const SizedBox(width: 15,),


                    Container(
                      
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: otpController.text.length>=3?appOrange.shade700:Colors.white,
                        border: Border.all(
                          color: appOrange.shade700,
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(100)
                      ),
                    ),

                    const SizedBox(width: 15,),


                    Container(
                      
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: otpController.text.length>=4?appOrange.shade700:Colors.white,
                        border: Border.all(
                          color: appOrange.shade700,
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(100)
                      ),
                    )
                  ],
                ),
      
                    ],
                  ),
                ),


                TextButton(
                  onPressed: (){}, 
                  child: Text(
                    'Forgot Pin?'
                  )
                ),
      
                
                Container(
                  padding: const EdgeInsets.all(15),
                  height: (MediaQuery.of(context).size.height/2)-50,
                  //color: Color.fromARGB(70, 240, 241, 241),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: TextButton(
                              onPressed: ()async{
                                if (otpController.text.length<4) {
                                  otpController.text += '1';
                          
                                  if (otpController.text.length==4) {
                                
                                    _load = true;
                                    
                                    Future.delayed(
                                      Duration(milliseconds: 400),
                                      widget.onCompleted!(otpController.text, context)
                                    );
                                    
                                    
                                    _load = false;
                                  }
                          
                                  setState(() {
                                    
                                  });
                                }
                              },
                          
                              child: Text(
                                '1',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800
                                ),
                              )),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: TextButton(
                              onPressed: ()async{
                                if (otpController.text.length<4) {
                                  otpController.text += '2';
                                  print(otpController.text);
                          
                                  if (otpController.text.length==4) {
                                
                                    _load = true;
                                    
                                    Future.delayed(
                                      Duration(milliseconds: 400),
                                      widget.onCompleted!(otpController.text, context)
                                    );
                                    
                                    
                                    _load = false;
                                  }
                                  setState(() {
                                    
                                  });
                                }                              
                              }, 
                              child: Text(
                                '2',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800
                                ),
                              )),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: TextButton(
                              onPressed: ()async{
                                if (otpController.text.length<4) {
                                  otpController.text += '3';
                                  print(otpController.text);
                          
                                  if (otpController.text.length==4) {
                                
                                    _load = true;
                                    
                                    Future.delayed(
                                      Duration(milliseconds: 400),
                                      widget.onCompleted!(otpController.text, context)
                                    );
                                    
                                    
                                    _load = false;
                                  }
                                  setState(() {
                                    
                                  });
                                }
                              }, 
                              child: Text(
                                '3',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800
                                ),
                              )),
                          )
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: TextButton(
                              onPressed: ()async{
                                if (otpController.text.length<4) {
                                  otpController.text += '4';
                                  print(otpController.text);
                          
                                  if (otpController.text.length==4) {
                                
                                    _load = true;
                                    
                                    Future.delayed(
                                      Duration(milliseconds: 400),
                                      widget.onCompleted!(otpController.text, context)
                                    );
                                    
                                    
                                    _load = false;
                                  }
                                  setState(() {
                                    
                                  });
                                }
                              }, 
                              child: Text(
                                '4',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800
                                ),
                              )),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: TextButton(
                              onPressed: ()async{
                                if (otpController.text.length<4) {
                                  otpController.text += '5';
                                  print(otpController.text);
                          
                                  if (otpController.text.length==4) {
                                
                                    _load = true;
                                    
                                    Future.delayed(
                                      Duration(milliseconds: 400),
                                      widget.onCompleted!(otpController.text, context)
                                    );
                                    
                                    
                                    _load = false;
                                  }
                                  setState(() {
                                    
                                  });
                                }
                              }, 
                              child: Text(
                                '5',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800
                                ),
                              )),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: TextButton(
                              onPressed: ()async{
                                if (otpController.text.length<4) {
                                  otpController.text += '6';
                                  print(otpController.text);
                          
                                  if (otpController.text.length==4) {
                                
                                    _load = true;
                                    
                                    Future.delayed(
                                      Duration(milliseconds: 400),
                                      widget.onCompleted!(otpController.text, context)
                                    );
                                    
                                    
                                    _load = false;
                                  }
                                  setState(() {
                                    
                                  });
                                }
                              }, 
                              child: Text(
                                '6',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800
                                ),
                              )),
                          )
                        ],
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: TextButton(
                              onPressed: ()async{
                                if (otpController.text.length<4) {
                                  otpController.text += '7';
                                  print(otpController.text);
                          
                                  if (otpController.text.length==4) {
                                
                                    _load = true;
                                    
                                    Future.delayed(
                                      Duration(milliseconds: 400),
                                      widget.onCompleted!(otpController.text, context)
                                    );
                                    
                                    
                                    _load = false;
                                  }
                                  setState(() {
                                    
                                  });
                                }
                              }, 
                              child: Text(
                                '7',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800
                                ),
                              )),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: TextButton(
                              onPressed: ()async{
                                if (otpController.text.length<4) {
                                  otpController.text += '8';
                                  print(otpController.text);
                          
                                  if (otpController.text.length==4) {
                                
                                    _load = true;
                                    
                                    Future.delayed(
                                      Duration(milliseconds: 400),
                                      widget.onCompleted!(otpController.text, context)
                                    );
                                    
                                    
                                    _load = false;
                                  }
                                  setState(() {
                                    
                                  });
                                }
                              }, 
                              child: Text(
                                '8',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800
                                ),
                              )),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: TextButton(
                              onPressed: ()async{
                                if (otpController.text.length<4) {
                                  otpController.text += '9';
                                  print(otpController.text);
                          
                                  if (otpController.text.length==4) {
                                
                                    _load = true;
                                    
                                    Future.delayed(
                                      Duration(milliseconds: 400),
                                      widget.onCompleted!(otpController.text, context)
                                    );
                                    
                                    
                                    _load = false;
                                  }
                                  setState(() {
                                    
                                  });
                                }
                              }, 
                              child: Text(
                                '9',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800
                                ),
                              )),
                          )
                        ],
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: null, 
                            icon: Icon(
                              MdiIcons.fingerprint,
                              size: 30,
                              color: Color.fromARGB(0, 58, 29, 245),
                            )),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: TextButton(
                              onPressed: ()async{
                                if (otpController.text.length<4) {
                                  otpController.text += '0';
                          
                                  print(otpController.text);
                          
                                  if (otpController.text.length==4) {
                                
                                    _load = true;
                                    
                                    Future.delayed(
                                      Duration(milliseconds: 400),
                                      widget.onCompleted!(otpController.text, context)
                                    );
                                    
                                    
                                    _load = false;
                                  }
                                  setState(() {
                                    
                                  });
                                }
                              }, 
                              child: Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800
                                ),
                              )),
                          ),

                          IconButton(
                            onPressed: (){
                              if (otpController.text.isNotEmpty) {
                                otpController.text = otpController.text.substring(0, otpController.text.length-1);
                                setState(() {
                                  
                                });
                              }
                            }, 
                            icon: Icon(
                              MdiIcons.backspaceOutline,
 //                            size: 30,
                              color: Colors.red,
                            ))
                        ],
                      ),

                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}