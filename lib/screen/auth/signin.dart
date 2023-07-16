// ignore_for_file: use_build_context_synchronously

import 'package:expense/screen/auth/signup.dart';
import 'package:expense/screen/base_nav.dart';
import 'package:expense/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../dbs/versions.dart';
import '../../firebase/auth/auth.dart';
import '../../models/version.dart';
import '../../widgets/text_field.dart';



class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: GestureDetector(

        onTap: () => FocusScope.of(context).unfocus(),

        child: LoadingIndicator(
          loading: _loading,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      const SizedBox(height: 180,),
                              
                      Row(
                        children: const [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                              
                              
                      Row(
                        children: const [
                          Text(
                            'Sign In to continue',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.4,
                              wordSpacing: 1.4
                            ),
                          )
                        ],
                      ),
                              
                      const SizedBox(height: 20,),
                              
                      MyTextField(
                        '',
                        headerText: 'Email',
                        controller: emailController,
                      ),
                              
                      const SizedBox(height: 20,),
                              
                      MyTextField(
                        '',
                        headerText: 'Password',
                        password: true,
                        controller: passwordController,
                      ),
                              
                      const SizedBox(height: 10,),
                              
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async{
                        
                              final fireAuth = FireAuth();
                        
                              if(
                                  emailController.text.isEmpty
                                ){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('please enter email'))
                                  );
                                }else if(
                                  passwordController.text.isEmpty
                                ){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('please enter password'))
                                  );
                                }else{
                
                                  _loading = true;
                
                                  setState(() {
                                    
                                  });
                
                                  User user = await fireAuth.signinUserWithEmail(
                                    email: emailController.text, 
                                    password: passwordController.text, 
                                   );

                                  //////////////////////
                                  ///Create user local db versioning
                                  ///first timers
                                  await VersionDb().addData(
                                    VersionModel(
                                      id: DateTime.now().millisecondsSinceEpoch
                                    )
                                  );

                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      child: AppBaseNavigation(user: user), 
                                      type: PageTransitionType.fade
                                    )
                                  );

                                   _loading = false;
                
                                   setState(() {
                                     
                                   });
                                }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: Row(
                                children: const [
                                  Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),
                                  ),
                                
                                  SizedBox(width: 10,),
                                
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                          
                          
                      const SizedBox(height: 80,)
                    ],
                  ),
                ),
              
                Positioned(
                  bottom: 30,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child:  Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
              
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: const SignUpScreen(),
                                type: PageTransitionType.rightToLeft
                              )
                            );
                          },
                          child: const Text(' Sign up',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.orangeAccent
                            ),
                          ),
                        ),
                        ],
                      )))
                )
              
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}