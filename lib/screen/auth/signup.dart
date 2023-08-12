// ignore_for_file: use_build_context_synchronously

import 'package:expense/screen/auth/signin.dart';
import 'package:expense/screen/base_nav.dart';
import 'package:expense/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../dbs/versions.dart';
import '../../firebase/auth/auth.dart';
import '../../models/version.dart';
import '../../widgets/text_field.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


  bool _loading = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: GestureDetector(

        onTap: () => FocusScope.of(context).unfocus(),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: LoadingIndicator(
            loading: _loading,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  
                      const SizedBox(height: 80,),

                      Row(
                        children: const [
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                  
                  
                      Row(
                        children: const [
                          Text(
                            'Sign up to enable saving your data online',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              wordSpacing: 1.2
                            ),
                          )
                        ],
                      ),
                          
                          
                      const SizedBox(height: 20,),
                  
                      MyTextField(
                        '',
                        headerText: 'Full Name',
                        controller: userNameController,
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
                        controller: passwordController,
                        password: true,
                      ),
                          
                      const SizedBox(height: 20,),
                  
                      MyTextField(
                        '',
                        headerText: 'Confirm password',
                        controller: confirmPasswordController,
                        password: true,
                      ),
                  
                      const SizedBox(height: 10,),
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async{
                              final fireAuth = FireAuth();
                
                              if (
                                emailController.text.isEmpty
                              ) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Email cannot be empty'))
                                );
                              }else if(
                                userNameController.text.isEmpty || userNameController.text.trim().split(' ').length < 2
                              ){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Full name required, separate names with space'))
                                );
                              }else if(
                                passwordController.text.isEmpty
                              ){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('password cannot be empty'))
                                );
                              }else if(
                                confirmPasswordController.text.isEmpty
                              ){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Confirm password expected'))
                                );
                              }else if(
                                passwordController.text != confirmPasswordController.text
                              ){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('passwords do not match'))
                                );
                              }else{
                
                                _loading = true;
                
                                  setState(() {
                                    
                                  });

                                  try{
                
                                  User user =await fireAuth.createUserWithEmail(
                                    email: emailController.text.trim(), 
                                    password: passwordController.text.trim(), 
                                    name: userNameController.text.trim()
                                  );

                                  await VersionDb().addData(
                                    VersionModel(
                                      id: DateTime.now().millisecondsSinceEpoch
                                    )
                                  );

                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      child: AppBaseNavigation(user: user), 
                                      type: PageTransitionType.fade)
                                  );
                                  
                                  
                                  }
                                  catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Something went wrong, check your email and try again'))
                                );
                                  }

                                   //////////////////////
                                  ///Create user local db versioning
                                  ///first timers
                                  
                                    
                  
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
                                    'Sign up',
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
                          const Text('Already have an account?',
                          style: TextStyle(
                            fontSize: 14
                          ),
                        ),
                
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: const SignInScreen(),
                                type: PageTransitionType.rightToLeft
                              )
                            );
                          },
                          child: const Text(' Sign In',
                            style: TextStyle(
                              fontSize: 14,
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