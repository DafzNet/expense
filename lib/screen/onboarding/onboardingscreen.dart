


// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:expense/screen/auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants/images.dart';
import '../auth/signup.dart';
import 'components/onboarder.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final pageController = PageController();


  void next() async{
    await pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
  }

  void onDot(int page){
    pageController.jumpToPage(page.toInt());
  }


  void getStarted(BuildContext context)async{
    
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('boarded', true);

     Navigator.pushReplacement(
       context,
       PageTransition(
        child: SignUpScreen(), type: PageTransitionType.fade)
       );

    }


    void getStarted2(BuildContext context)async{

     
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool('boarded', true);

     Navigator.pushReplacement(
       context,
       PageTransition(
        child: SignInScreen(), type: PageTransitionType.fade)
       );

    }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          OnboarderTemplate(
            onTap: next,
            onDotTap: onDot,

            img: boardTwo,

            dotPosition: 0,
            topic:  'Welcome',
            body: 'Welcome to LiFi. Take control of your finances, achieve your goals, and stay accountable every step of the way.\nLet\'s embark on your journey towards financial success together!',
          ),


          OnboarderTemplate(
            onTap: next,
            onDotTap: onDot,

            img: boardOne,

            dotPosition: 1,
            topic:  'Keep Track',
            body: 'Track your cashflow effortlessly. Record and categorize your purchases on the go. Understanding your spending habits is the key to financial empowerment and responsible money management.',
          ),


          OnboarderTemplate(
            onTap: next,
            onDotTap: onDot,

            img: 'assets/icons/anim/target.gif',

            dotPosition: 2,
            topic:  'Goal-Oriented Savings',
            body: 'Set savings goals and make them a reality. Define targets for your dream vacation, a new car, or any other milestone. LiFi will help you stay focused and motivated along the way.',
          ),


          OnboarderTemplate(
            onTap: (){
              getStarted(context);
            },

            onTap2: () {
              getStarted2(context);
            },

            onDotTap: onDot,

            img: boardThree,

            dotPosition: 3,
            topic:  'Budgets and Planners',
            buttonText: 'Create Account',
            button2text: 'Sign in to account',
            body: 'Create budgets that suit your lifestyle. Allocate spending limits and gain control over your finances. Stay on track and make informed spending decisions with our Planners to achieve your financial goals.',
          ),
        ],
      )
    );
  }
}