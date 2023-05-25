import 'package:expense/screen/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../widgets/text_field.dart';
import '../base_nav.dart';



class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: GestureDetector(

        onTap: () => FocusScope.of(context).unfocus(),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
      
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
      
                  const MyTextField(
                    '',
                    headerText: 'Email',
                  ),
      
                  const SizedBox(height: 20,),
      
                  const MyTextField(
                    '',
                    headerText: 'Password',
                  ),
      
                  const SizedBox(height: 10,),
      
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          PageTransition(
                            child: const AppBaseNavigation(), 
                            type: PageTransitionType.fade
                          )
                        ),
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
                ],
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
    );
  }
}